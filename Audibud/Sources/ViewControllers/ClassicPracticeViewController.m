//
//  ClassicPracticeViewController.m
//  AudiBud
//
//  Created by 이승주 on 16/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import "ClassicPracticeViewController.h"
#import "DefinedHeader.h"
#import "PracticeItemTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

//https://developer.apple.com/documentation/avfoundation/avqueueplayer

@interface ClassicPracticeViewController () <UITableViewDelegate, UITableViewDataSource, STKAudioPlayerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *vPlayBar;
@property (weak, nonatomic) IBOutlet UIButton *btnLang;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnSwitch;


@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *dataC;
@property (strong, nonatomic) STKAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSString *audio_file_name;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSInteger currentIdx;
@property (assign, nonatomic) CGFloat currentStartTime;
@property (assign, nonatomic) CGFloat currentEndTime;
@property (assign, nonatomic) NSInteger language_type_idx;
@property (assign, nonatomic) NSInteger repeat_count;
@property (assign, nonatomic) NSInteger repeat_buffer;
@property (assign, nonatomic) NSInteger random_yn;
@property (assign, nonatomic) NSInteger gap_sec;

@end

@implementation ClassicPracticeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self end];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.data  = [[NSMutableArray alloc] init];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - APP_DEL.tab_height - self.vPlayBar.frame.size.height);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PracticeItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"PracticeItemTableViewCell"];
    
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer1.width = 10.0f;
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [btnLeft setImage:[UIImage imageNamed:@"title_btn_back.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(leftMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemLeft  = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItems = @[spacer1, itemLeft];
    
    [self.vPlayBar sizeToWidth:SCREEN_WIDTH];
    [self.vPlayBar moveToY:SCREEN_HEIGHT - APP_DEL.tab_height - self.vPlayBar.frame.size.height];
    [self.btnLang moveToX:SCREEN_WIDTH - 40 - self.btnLang.frame.size.width];
    [self.btnPlay moveToX:(SCREEN_WIDTH - self.btnPlay.frame.size.width)/2];
    [self.btnBack moveToX:self.btnPlay.frame.origin.x - self.btnBack.frame.size.width - 40];
    [self.btnNext moveToX:(self.btnPlay.frame.origin.x + self.btnPlay.frame.size.width) + 40];
//    [self.btnLang moveToX:SCREEN_WIDTH - (self.btnLang.frame.size.width)*2];
    [self.btnLang moveToX:SCREEN_WIDTH - (self.btnLang.frame.size.width)];
    [self.btnSwitch moveToX:0];
    
    self.language_type_idx  = [GCGet(@"language_type_idx") intValue]; // 0 한글 1 영어 2 한/영  3 무
    [self langButton:self.language_type_idx];
    self.repeat_count       = [GCGet(@"repeat_count") intValue];
    self.repeat_buffer      = 0;
    self.random_yn          = [GCGet(@"random_yn") intValue];
    self.gap_sec            = [GCGet(@"gap_sec") intValue];
    [self switchButton:self.random_yn];
    
    NSDictionary *fileInfo = [SQLITE fileDataByFileIdx:self.f_idx];
    
    NSLog(@"fileInfo : %@", fileInfo);
    
    if(!fileInfo)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.audio_file_name = fileInfo[@"f_a"];
    
    NSString *currentIdxKey = [NSString stringWithFormat:@"f_idx_%lu_currentIdx", (unsigned long)self.f_idx];
    if(GCIsNull(currentIdxKey))
        GCSet(currentIdxKey, @"-1");
    
    self.currentIdx = [[GCache stringForKey:currentIdxKey] intValue];
    
    [self viewCount];
    [self loadData];
    [self initPlayer];
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    commandCenter.playCommand.enabled = YES;
    [commandCenter.playCommand addTarget:self action:@selector(playAndResume)];
    commandCenter.stopCommand.enabled = YES;
    [commandCenter.stopCommand addTarget:self action:@selector(playAndResume)];
    commandCenter.pauseCommand.enabled = YES;
    [commandCenter.pauseCommand addTarget:self action:@selector(playAndResume)];
    commandCenter.nextTrackCommand.enabled = YES;
    [commandCenter.nextTrackCommand addTarget:self action:@selector(RemotePlayNext)];
    commandCenter.previousTrackCommand.enabled = YES;
    [commandCenter.previousTrackCommand addTarget:self action:@selector(RemotePlayBack)];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
//    http://lukagabric.com/ios-audio-player-with-lock-screen-controls/
//    https://stackoverflow.com/questions/17103148/avoid-headset-plugout-stops-avaudioplayer-in-ios
//    https://stackoverflow.com/questions/45247098/locked-screen-audio-controls-ios
//    https://stackoverflow.com/questions/29271417/mpremotecommandcenter-does-nothing-with-mpmusicplayercontroller
//    https://stackoverflow.com/questions/45247098/locked-screen-audio-controls-ios
//    https://stackoverflow.com/questions/29271417/mpremotecommandcenter-does-nothing-with-mpmusicplayercontroller
//    https://stackoverflow.com/questions/20591156/is-there-a-public-way-to-force-mpnowplayinginfocenter-to-show-podcast-controls/24818340#24818340
//    https://developer.apple.com/documentation/avfoundation/media_assets_playback_and_editing/creating_a_basic_video_player_ios_and_tvos/controlling_background_audio?language=objc
}

- (UIImage *)resizeImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}

- (void)viewCount
{
    NSString *URLString = [NSString stringWithFormat:@"http://lang.nicejames.com/api/Lang/GetViewCount?f_idx=%lu", (unsigned long)self.f_idx];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString
       parameters:nil
         progress:nil
          success:^(NSURLSessionTask *task, id responseObject) {
              self.dataC = responseObject[@"response_data"];
              [self.tableView reloadData];
              
              if(self.currentIdx > 0)
              {
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIdx inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                  });
              }
              
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)initPlayer
{
    self.audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    self.audioPlayer.meteringEnabled    = YES;
    self.audioPlayer.volume             = 1.0;
    self.audioPlayer.delegate           = self;
    
    NSLog(@"self.audio_file_name : %@", self.audio_file_name);
    
    NSArray *fArray = [self.audio_file_name componentsSeparatedByString: @"."];
    NSString *fName = fArray[0];
    NSString *fExt  = fArray[1];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fName ofType:fExt];
    self.url = [NSURL fileURLWithPath:path];
}

- (void)play:(NSUInteger)idx
{
    //    세팅전 0
    //    재생시작 5
    //    재생중 3
    //    일시정지 9
    //    중지 16
    
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.currentIdx = idx;
    NSString *k = [NSString stringWithFormat:@"f_idx_%lu_currentIdx", (unsigned long)self.f_idx];
    GCSet(k, @(self.currentIdx).stringValue);
    [self.tableView reloadData];
    
    NSDictionary *dic       = self.data[self.currentIdx];
    self.currentStartTime   = [dic[@"start_time"] floatValue];
    self.currentEndTime     = [dic[@"end_time"] floatValue];
    
    NSLog(@"::::::::::::::::::: dic =============> %@", dic);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSMutableDictionary *songInfo   = [NSMutableDictionary dictionary];
//        MPMediaItemArtwork *artworkImage = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(600, 600)
//                                                                           requestHandler:^UIImage * _Nonnull(CGSize size) {
//                                                                               UIImage *lockScreenArtworkApp = [UIImage imageNamed:@"down"];
//                                                                               return [self resizeImageWithImage:lockScreenArtworkApp scaledToSize:size];
//                                                                           }];
        
//        [songInfo setValue:artworkImage forKey:MPMediaItemPropertyArtwork];
//        [songInfo setValue:artworkImage forKey:MPMediaItemPropertyArtwork];
        
//        if(self.language_type_idx == 0)
//        {
//            [songInfo setValue:dic[@"txt_kor"] forKey:MPMediaItemPropertyTitle];
//            [songInfo setValue:@"" forKey:MPMediaItemPropertyArtist];
//        }
//        else if(self.language_type_idx == 1)
//        {
//            [songInfo setValue:dic[@"txt_eng"] forKey:MPMediaItemPropertyTitle];
//            [songInfo setValue:@"" forKey:MPMediaItemPropertyArtist];
//            [self.btnLang setTitle:@"영어" forState:UIControlStateNormal];
//        }
//        else if(self.language_type_idx == 2)
//        {
            [songInfo setValue:dic[@"txt_eng"] forKey:MPMediaItemPropertyTitle];
            [songInfo setValue:dic[@"txt_kor"] forKey:MPMediaItemPropertyArtist];
//            [self.btnLang setTitle:@"한/영" forState:UIControlStateNormal];
//        }
//        else if(self.language_type_idx == 3)
//        {
//            [songInfo setValue:@"" forKey:MPMediaItemPropertyTitle];
//            [songInfo setValue:@"" forKey:MPMediaItemPropertyArtist];
//            [self.btnLang setTitle:@"무" forState:UIControlStateNormal];
//        }
        
        
        
        
//        [songInfo setValue:[NSNumber numberWithInt:self.audioPlayer.duration] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
//        [songInfo setValue:[NSNumber numberWithInt:self.audioPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        [songInfo setValue:[NSNumber numberWithInt:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = songInfo;
    });
    
    [self setupTimer:dic];
    
    NSLog(@"currentIdx : %ld, start_time : %f, end_time : %f", (long)self.currentIdx, self.currentStartTime, self.currentEndTime);
    CGFloat delay_time = 0;
    if (self.audioPlayer.state == 0 ||
        self.audioPlayer.state == 9 ||
        self.audioPlayer.state == 16)
    {
        if(self.audioPlayer.state == 9)
        {
            NSLog(@"==================> resume");
            delay_time = 0.001;
            [self.audioPlayer resume];
        }
        else
        {
            NSLog(@"==================> play");
            delay_time = 0.01;
            [self.audioPlayer playURL:self.url];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"==================> jump");
        [self.audioPlayer seekToTime:self.currentStartTime];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIdx inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        [SQLITE addUesrLog:@{@"p_idx":dic[@"p_idx"]}];
        
        NSString *URLString = @"http://lang.nicejames.com/api/Lang/AddUserLog";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:URLString
           parameters:@{@"p_idx":dic[@"p_idx"]}
             progress:nil
              success:^(NSURLSessionTask *task, id responseObject) {
              } failure:^(NSURLSessionTask *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    });
}

- (void)loadData
{
    if(self.random_yn == 0)
        self.data = [SQLITE practiceFileIdx:self.f_idx];
    else
        self.data = [SQLITE practiceFileIdx:self.f_idx withRandomYN:@"Y"];
        
    [self.tableView reloadData];
    
    if(self.currentIdx > 0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIdx inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PracticeItemTableViewCell";
    PracticeItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.index              = indexPath.row;
    cell.curindex           = self.currentIdx;
    cell.language_type_idx  = self.language_type_idx;
    cell.viewArray          = self.dataC;
    [cell setData:self.data[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.repeat_buffer = 0;
    [self play:indexPath.row];
    [self uiSetting];
}

- (void)playBack
{
    NSLog(@"onTouch_btnBack");
    if(self.currentIdx == 0)
    {
        [self.audioPlayer pause];
        [self uiSetting];
        return;
    }
    
    self.currentIdx--;
    [self play:self.currentIdx];
    [self uiSetting];
}

- (void)RemotePlayBack
{
    self.repeat_buffer = 0;
    [self playBack];
}

- (void)RemotePlayNext
{
    self.repeat_buffer = 0;
    [self playNext];
}

- (IBAction)onTouch_btnBack:(id)sender
{
    self.repeat_buffer = 0;
    [self playBack];
}

- (void)playAndResume
{
    self.repeat_buffer = 0;
    NSLog(@"onTouch_btnPlay");
    if (self.audioPlayer.state == 3 || self.audioPlayer.state == 5)
    {
        NSLog(@"pause");
        [self.audioPlayer pause];
    }
    else if (self.audioPlayer.state == 9)
    {
        NSLog(@"resume");
        [self.audioPlayer resume];
    }
    else if (self.audioPlayer.state == 16)
    {
        if(self.currentIdx < 0)
            self.currentIdx = 0;
        
        NSLog(@"play");
        [self play:self.currentIdx];
    }
    [self uiSetting];
}

- (IBAction)onTouch_btnPlay:(id)sender
{
    [self playAndResume];
}

- (void)playNext
{
    NSLog(@"onTouch_btnNext");
    if(self.currentIdx >= self.data.count - 1)
    {
        [self.audioPlayer pause];
        [self uiSetting];
        return;
    }
    
    self.currentIdx++;
    [self play:self.currentIdx];
    [self uiSetting];
}

- (IBAction)onTouch_btnNext:(id)sender
{
    self.repeat_buffer = 0;
    [self playNext];
}

- (IBAction)onTouch_btnLangChange:(id)sender
{
    self.language_type_idx++;
    self.language_type_idx = self.language_type_idx % 2;
    [GCache setString:@(self.language_type_idx).stringValue forKey:@"language_type_idx"];
    [self langButton:self.language_type_idx];
    [self.tableView reloadData];
}

- (void)langButton:(NSUInteger)language_type_idx
{
    if(language_type_idx == 0)
    {
        [self.btnLang setTitle:@"한글" forState:UIControlStateNormal];
    }
    else if(language_type_idx == 1)
    {
        [self.btnLang setTitle:@"영어" forState:UIControlStateNormal];
    }
    else if(language_type_idx == 2)
    {
        [self.btnLang setTitle:@"한/영" forState:UIControlStateNormal];
    }
    else if(language_type_idx == 3)
    {
        [self.btnLang setTitle:@"무" forState:UIControlStateNormal];
    }
    else
    {
        [self.btnLang setTitle:@"XX" forState:UIControlStateNormal];
    }
}

- (IBAction)onTouch_btnSwitch:(id)sender
{
    self.random_yn++;
    self.random_yn = self.random_yn % 2;
    GCSet(@"random_yn", @(self.random_yn).stringValue);
    [self switchButton:self.random_yn];
}

- (void)switchButton:(NSUInteger)random_yn
{
    if(random_yn == 0)
    {
        [self.btnSwitch setTitle:@"순서" forState:UIControlStateNormal];
    }
    else if(random_yn == 1)
    {
        [self.btnSwitch setTitle:@"램덤" forState:UIControlStateNormal];
    }
    
    [self loadData];
}

- (void)setupTimer:(NSDictionary *)dic
{
    self.timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(tick:) userInfo:dic repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)tick:(NSTimer *)timer
{
//    세팅전 0
//    재생시작 5
//    재생중 3
//    일시정지 9
//    중지 16
    
    NSDictionary *dic = [timer userInfo];
//
//    if([idxStr intValue] != self.currentIdx)
//    {
//        [timer invalidate];
//        timer = nil;
//    }
    
    if (self.audioPlayer.state == 3 || self.audioPlayer.state == 5)
    {
        if(self.audioPlayer.progress >= self.currentEndTime)
        {
            self.repeat_buffer++;
            if(self.repeat_buffer < self.repeat_count)
            {
                [self.audioPlayer pause];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.gap_sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.audioPlayer resume];
                    [self.audioPlayer seekToTime:self.currentStartTime];
                    
                    NSString *URLString = @"http://lang.nicejames.com/api/Lang/AddUserLog";
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    [manager POST:URLString
                       parameters:@{@"p_idx":dic[@"p_idx"]}
                         progress:nil
                          success:^(NSURLSessionTask *task, id responseObject) {
                          } failure:^(NSURLSessionTask *operation, NSError *error) {
                              NSLog(@"Error: %@", error);
                          }];
                });
            }
            else
            {
                [timer invalidate];
                timer = nil;
                
                [self.audioPlayer pause];
                self.repeat_buffer = 0;
                
                if(self.currentIdx < self.data.count - 1)
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.gap_sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.currentIdx++;
                        [self play:self.currentIdx];
                    });
                }
                else
                {
//                    // 처음 부터 다시 시작
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.gap_sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        self.currentIdx = 0;
//                        [self play:self.currentIdx];
//                    });
                    
                    NSString *tempKey = [NSString stringWithFormat:@"f_idx_%lu_currentIdx", (unsigned long)self.f_idx];
                    GCSet(tempKey, @"0");
                    
                    // 다음 파일 검색
                    NSDictionary *fileD = [SQLITE fileDataByFileIdx:self.f_idx];

                    if(fileD)
                    {
                        NSUInteger f_type_idx = [fileD[@"f_type_idx"] intValue];
                        NSMutableArray *files = [SQLITE fileDataByFileTypeIdx:f_type_idx];
                        
                        NSLog(@"files : %@", files);

                        for (int i = 0; i < [files count]; i++)
                        {
                            NSDictionary *filesD = files[i];

                            if([filesD[@"f_idx"] intValue] == self.f_idx)
                            {
                                NSDictionary *renewD = nil;

                                if(i + 1 >= [files count] - 1)
                                {
                                    renewD = files[0];
                                }
                                else
                                {
                                    renewD = files[i + 1];
                                }

                                self.f_idx = [renewD[@"f_idx"] intValue];
                                
                                NSDictionary *fileInfo = [SQLITE fileDataByFileIdx:self.f_idx];
                                self.audio_file_name = fileInfo[@"f_a"];
                                
                                NSString *currentIdxKey = [NSString stringWithFormat:@"f_idx_%lu_currentIdx", (unsigned long)self.f_idx];
                                if(GCIsNull(currentIdxKey))
                                    GCSet(currentIdxKey, @"0");
                                
                                self.currentIdx = [[GCache stringForKey:currentIdxKey] intValue];
                                
                                [self viewCount];
                                [self loadData];
                                [self initPlayer];
                                [self.tableView reloadData];

                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.gap_sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self play:self.currentIdx];
                                });
                                
                                break;
                            }
                        }

                        
                    }
                    

//                        NSString *URLString = [NSString stringWithFormat:@"http://lang.nicejames.com/api/Lang/GetFileItems?f_type_idx=%lu", (unsigned long)f_type_idx];
                    
//                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//                        [manager POST:URLString
//                           parameters:nil
//                             progress:nil
//                              success:^(NSURLSessionTask *task, id responseObject) {
//                                  NSMutableArray *files = responseObject[@"response_data"];
//                                  NSLog(@"JSON: %@", files);
//
//                                  for (int i = 0; i < [files count]; i++)
//                                  {
//                                      NSDictionary *filesD =  files[i];
//
//                                      if([filesD[@"f_idx"] intValue] == self.f_idx)
//                                      {
//                                          NSDictionary *renewD = nil;
//
//                                          if(i + 1 >= [files count] - 1)
//                                          {
//                                              renewD = files[0];
//                                          }
//                                          else
//                                          {
//                                              renewD = files[i + 1];
//                                          }
//
//                                          self.f_idx = [renewD[@"f_idx"] intValue];
//                                          [self loadData];
//
//                                          if([self.data count] > 0)
//                                          {
//                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.gap_sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                                  self.currentIdx = 0;
//                                                  [self play:self.currentIdx];
//                                              });
//                                          }
//                                          else
//                                          {
//                                              self.currentIdx = -1;
//                                          }
//                                      }
//                                  }
//
//                                  [self.tableView reloadData];
//
//                              } failure:^(NSURLSessionTask *operation, NSError *error) {
//                                  NSLog(@"Error: %@", error);
//                              }];
                        
//                    }
                  
//                }
                    
                }
            }
        }
    }
}


- (void)uiSetting
{
    if(self.audioPlayer.state == STKAudioPlayerStateReady ||
       self.audioPlayer.state == STKAudioPlayerStateDisposed ||
       self.audioPlayer.state == STKAudioPlayerStateError ||
       self.audioPlayer.state == STKAudioPlayerStateStopped ||
       self.audioPlayer.state == STKAudioPlayerStatePaused)
    {
        [self.btnPlay setTitle:@"►" forState:UIControlStateNormal];
    }
    else
    {
        [self.btnPlay setTitle:@"||" forState:UIControlStateNormal];
    }
}

- (void)end
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if(self.audioPlayer.state == STKAudioPlayerStateReady ||
       self.audioPlayer.state == STKAudioPlayerStateDisposed ||
       self.audioPlayer.state == STKAudioPlayerStateError ||
       self.audioPlayer.state == STKAudioPlayerStateStopped ||
       self.audioPlayer.state == STKAudioPlayerStatePaused)
    {
        
    }
    else
    {
        [self.audioPlayer stop];
    }
    
    self.audioPlayer = nil;
}

- (void)leftMenuPressed:(UIButton *)sender
{
    [self end];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId
{
    NSLog(@"StartPlaying : %@", queueItemId);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId
{
    NSLog(@"inishBufferingSource : %@", queueItemId);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    NSLog(@"state chaged : %ld -> %ld", previousState, state);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    NSLog(@"FinishPlaying : %@, reason : %ld, progress : %f, duration : %f ", queueItemId, stopReason, progress, duration );
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    NSLog(@"unexpectedError : %ld", errorCode);
}

@end
