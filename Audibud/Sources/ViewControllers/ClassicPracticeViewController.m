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
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) STKAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSString *audio_file_name;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *vPlayBar;
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
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - APP_DEL.tab_height);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PracticeItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"PracticeItemTableViewCell"];
    
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer1.width = 10.0f;
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [btnLeft setImage:[UIImage imageNamed:@"title_btn_back.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(leftMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemLeft  = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItems = @[spacer1, itemLeft];
    
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
    [self setupTimer];
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
    
    self.currentIdx         = idx;
    NSDictionary *dic       = self.data[self.currentIdx];
    self.currentStartTime   = [dic[@"start_time"] floatValue];
    self.currentEndTime     = [dic[@"end_time"] floatValue];
    
    NSLog(@"currentIdx : %ld, start_time : %f, end_time : %f", (long)self.currentIdx, self.currentStartTime, self.currentEndTime);
    
    if (self.audioPlayer.state == 0 || self.audioPlayer.state == 9 || self.audioPlayer.state == 16 )
    {
        NSLog(@"==================> play");
        [self.audioPlayer playURL:self.url];
    }
    
    CGFloat delay_time = 0.01;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"==================> jump");
        [self.audioPlayer seekToTime:self.currentStartTime];
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
    [cell setData:self.data[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row : %ld", indexPath.row);
    [self play:indexPath.row];
}

- (IBAction)onTouch_btnBack:(id)sender
{
    NSLog(@"back");
    
    if(self.currentIdx == 0)
    {
        [self.audioPlayer stop];
        return;
    }
    
    self.currentIdx--;
    [self play:self.currentIdx];
}

- (IBAction)onTouch_btnPlay:(id)sender
{
    if (self.audioPlayer.state == 3 || self.audioPlayer.state == 5)
    {
        NSLog(@"pause");
        [self.audioPlayer pause];
    }
    else if (self.audioPlayer.state == 9)
    {
        NSLog(@"play or pause");
        [self.audioPlayer resume];
    }
    else if (self.audioPlayer.state == 16)
    {
        if(self.currentIdx < 0)
            self.currentIdx = 0;
        
        [self play:self.currentIdx];
    }
}

- (IBAction)onTouch_btnNext:(id)sender
{
    NSLog(@"next");
    if(self.currentIdx == self.data.count - 1)
    {
        [self.audioPlayer stop];
        return;
    }
    
    self.currentIdx++;
    [self play:self.currentIdx];
}

- (void)setupTimer
{
    self.timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)tick
{
//    세팅전 0
//    재생시작 5
//    재생중 3
//    일시정지 9
//    중지 16
    
    if ((self.audioPlayer.state == 3 || self.audioPlayer.state == 5) && self.currentIdx >= 0)
    {
        if(self.audioPlayer.progress >= self.currentEndTime)
        {
            if(self.currentIdx == self.data.count - 1)
            {
                [self.audioPlayer pause];
                return;
            }
            
            self.currentIdx++;
            [self play:self.currentIdx];
        }
        // 재생 중에 만료 시간이 오면 다음 라인으로 이동한다.
    }
}















//- (void)autoPlay:(NSInteger)idx
//{
//    if (self.audioPlayer.state == 0 || self.audioPlayer.state == 5)
//    {
//        [self jump:idx];
//        NSLog(@"========> jump : %ld", idx);
//    }
//    else
//    {
//        [self play:idx];
//        NSLog(@"========> play : %ld", idx);
//    }
//}


//- (void)jump:(NSInteger)idx
//{
//    self.currentIdx         = idx;
//    NSDictionary *dic       = self.data[self.currentIdx];
//    self.currentStartTime   = [dic[@"start_time"] floatValue];
//    self.currentEndTime     = [dic[@"end_time"] floatValue];
//
//    NSLog(@"currentIdx : %ld, start_time : %f, end_time : %f", (long)self.currentIdx, self.currentStartTime, self.currentEndTime);
//
//    CGFloat delay_time = 0.3;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.audioPlayer seekToTime:self.currentStartTime];
//    });
//}











- (void)leftMenuPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}





/// Raised when an item has started playing
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    NSLog(@"StartPlaying : %@", queueItemId);
}

/// Raised when an item has finished buffering (may or may not be the currently playing item)
/// This event may be raised multiple times for the same item if seek is invoked on the player
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    NSLog(@"inishBufferingSource : %@", queueItemId);
}

/// Raised when the state of the player has changed
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    //    STKAudioPlayerStateReady,
    //    STKAudioPlayerStateRunning = 1,
    //    STKAudioPlayerStatePlaying = (1 << 1) | STKAudioPlayerStateRunning,
    //    STKAudioPlayerStateBuffering = (1 << 2) | STKAudioPlayerStateRunning,
    //    STKAudioPlayerStatePaused = (1 << 3) | STKAudioPlayerStateRunning,
    //    STKAudioPlayerStateStopped = (1 << 4),
    //    STKAudioPlayerStateError = (1 << 5),
    //    STKAudioPlayerStateDisposed = (1 << 6)
    
    NSLog(@"state chaged : %ld -> %ld", previousState, state);
}

/// Raised when an item has finished playing
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    //    STKAudioPlayerStopReasonNone = 0,
    //    STKAudioPlayerStopReasonEof,
    //    STKAudioPlayerStopReasonUserAction,
    //    STKAudioPlayerStopReasonPendingNext,
    //    STKAudioPlayerStopReasonDisposed,
    //    STKAudioPlayerStopReasonError = 0xffff
    
    NSLog(@"FinishPlaying : %@, reason : %ld, progress : %f, duration : %f ", queueItemId, stopReason, progress, duration );
}

/// Raised when an unexpected and possibly unrecoverable error has occured (usually best to recreate the STKAudioPlauyer)
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    //    STKAudioPlayerErrorNone = 0,
    //    STKAudioPlayerErrorDataSource,
    //    STKAudioPlayerErrorStreamParseBytesFailed,
    //    STKAudioPlayerErrorAudioSystemError,
    //    STKAudioPlayerErrorCodecError,
    //    STKAudioPlayerErrorDataNotFound,
    //    STKAudioPlayerErrorOther = 0xffff
    
    NSLog(@"unexpectedError : %ld", errorCode);
}

/// Optionally implemented to get logging information from the STKAudioPlayer (used internally for debugging)
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line
{
    NSLog(@"audio log : %@", line);
}

/// Raised when items queued items are cleared (usually because of a call to play, setDataSource or stop)
- (void)audioPlayer:(STKAudioPlayer*)audioPlayer didCancelQueuedItems:(NSArray *)queuedItems
{
    NSLog(@"queued items are cleard : %@", queuedItems);
}

/// Raised when datasource read stream metadata
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didReadStreamMetadata:(NSDictionary *)dictionary
{
    NSLog(@"read stream metadata : %@", dictionary);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
