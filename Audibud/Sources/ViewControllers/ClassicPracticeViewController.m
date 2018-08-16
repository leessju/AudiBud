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

@interface ClassicPracticeViewController () <UITableViewDelegate, UITableViewDataSource, STKAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *vPlayBar;
@property (weak, nonatomic) IBOutlet UIButton *btnLang;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;


@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) STKAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSString *audio_file_name;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSInteger currentIdx;
@property (assign, nonatomic) CGFloat currentStartTime;
@property (assign, nonatomic) CGFloat currentEndTime;

@end

@implementation ClassicPracticeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self.btnNext moveToX:(self.btnPlay.frame.origin.x + self.btnPlay.frame.size.width) + self.btnNext.frame.size.width + 40];
    
    NSDictionary *fileInfo = [SQLITE fileDataByFileIdx:self.f_idx];
    
    if(!fileInfo)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.audio_file_name = fileInfo[@"f_a"];
    self.currentIdx = -1;
    
    [self loadData];
    [self initPlayer];
}

- (void)initPlayer
{
    self.audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    self.audioPlayer.meteringEnabled    = YES;
    self.audioPlayer.volume             = 1.0;
    self.audioPlayer.delegate           = self;
    
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
    [self.tableView reloadData];
    
    NSDictionary *dic       = self.data[self.currentIdx];
    self.currentStartTime   = [dic[@"start_time"] floatValue];
    self.currentEndTime     = [dic[@"end_time"] floatValue];
    
    [self setupTimer:self.currentIdx];
    
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
    });
}

- (void)loadData
{
    self.data = [SQLITE practiceFileIdx:self.f_idx];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PracticeItemTableViewCell";
    PracticeItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.index = indexPath.row;
    cell.curindex = self.currentIdx;
    [cell setData:self.data[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self play:indexPath.row];
    [self uiSetting];
}

- (IBAction)onTouch_btnBack:(id)sender
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

- (IBAction)onTouch_btnPlay:(id)sender
{
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

- (IBAction)onTouch_btnNext:(id)sender
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

- (IBAction)onTouch_btnLangChange:(id)sender
{
    
}

- (void)setupTimer:(NSInteger)idx
{
    self.timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(tick:) userInfo:@(idx).stringValue repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)tick:(NSTimer *)timer
{
//    세팅전 0
//    재생시작 5
//    재생중 3
//    일시정지 9
//    중지 16
    
    NSString *idxStr = [timer userInfo];
    
    if([idxStr intValue] != self.currentIdx)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if (self.audioPlayer.state == 3 || self.audioPlayer.state == 5)
    {
        if(self.audioPlayer.progress >= self.currentEndTime)
        {
            [timer invalidate];
            timer = nil;
            
            [self.audioPlayer pause];
            
            if(self.currentIdx < self.data.count - 1)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.currentIdx++;
                    [self play:self.currentIdx];
                });
            }
            
        }
    }
}


- (void)uiSetting
{
//    STKAudioPlayerStateReady,
//    STKAudioPlayerStateRunning = 1,
//    STKAudioPlayerStatePlaying = (1 << 1) | STKAudioPlayerStateRunning,
//    STKAudioPlayerStateBuffering = (1 << 2) | STKAudioPlayerStateRunning,
//    STKAudioPlayerStatePaused = (1 << 3) | STKAudioPlayerStateRunning,
//    STKAudioPlayerStateStopped = (1 << 4),
//    STKAudioPlayerStateError = (1 << 5),
//    STKAudioPlayerStateDisposed = (1 << 6)
    
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

- (void)leftMenuPressed:(UIButton *)sender
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
        [self.audioPlayer stop];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    NSLog(@"StartPlaying : %@", queueItemId);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    NSLog(@"inishBufferingSource : %@", queueItemId);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    NSLog(@"state chaged : %ld -> %ld", previousState, state);
}

- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    NSLog(@"FinishPlaying : %@, reason : %ld, progress : %f, duration : %f ", queueItemId, stopReason, progress, duration );
}

- (void)audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    NSLog(@"unexpectedError : %ld", errorCode);
}

@end
