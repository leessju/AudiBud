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
@property (strong, nonatomic) NSString *audio_file_name;
@property (strong, nonatomic) STKAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSTimer *timer;

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
    
    [self loadData];
}

- (void)initPlayer
{
    self.audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    self.audioPlayer.meteringEnabled    = YES;
    self.audioPlayer.volume             = 1.0;
    self.audioPlayer.delegate           = self;
}

- (void)playSetting
{
    NSArray *fArray = [self.audio_file_name componentsSeparatedByString: @"."];
    NSString *fName = fArray[0];
    NSString *fExt  = fArray[1];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fName ofType:fExt];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSLog(@"url : %@", url);
    
    CGFloat delay_time = 2.0;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"____ delay execute ");
    });
    
//  [audioPlayer play:@"http://www.abstractpath.com/files/audiosamples/sample.mp3"];
//  [self.audioPlayer playURL:url];
}

- (void)play:(NSUInteger)idx
{
    if (self.audioPlayer.state == STKAudioPlayerStatePaused)
    {
        
    }
    else if (self.audioPlayer.state & STKAudioPlayerStatePlaying)
    {
        
    }
    else
    {
        
    }
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
    //cell.delegate = self;
    [cell setData:self.data[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.data[indexPath.row];
    NSLog(@"dic : %@", dic);
}

- (void)leftMenuPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    if (!self.audioPlayer)
    {
        // 초기화
        return;
    }
    
    if (self.audioPlayer.currentlyPlayingQueueItemId == nil)
    {
        // 초기화
        return;
    }
    
    // 로컬파일 경우
    if (self.audioPlayer.duration != 0)
    {
//        slider.minimumValue = 0;
//        slider.maximumValue = audioPlayer.duration;
//        slider.value        = audioPlayer.progress;
//        label.text          = [NSString stringWithFormat:@"%@ - %@", [self formatTimeFromSeconds:audioPlayer.progress], [self formatTimeFromSeconds:audioPlayer.duration]];
    }
    else
    {
        // 스트리밍 일때
//        slider.value        = 0;
//        slider.minimumValue = 0;
//        slider.maximumValue = 0;
//        label.text          = [NSString stringWithFormat:@"Live stream %@", [self formatTimeFromSeconds:audioPlayer.progress]];
    }
    
    NSString *bufferingYN   = self.audioPlayer.state == STKAudioPlayerStateBuffering ? @"buffering" : @"";
    NSLog(@"bufferingYN : %@", bufferingYN);
}

- (void)updateControls
{
    if (self.audioPlayer == nil)
    {
        //[playButton setTitle:@"" forState:UIControlStateNormal];
    }
    else if (self.audioPlayer.state == STKAudioPlayerStatePaused)
    {
        //[playButton setTitle:@"Resume" forState:UIControlStateNormal];
    }
    else if (self.audioPlayer.state & STKAudioPlayerStatePlaying)
    {
        //[playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
    else
    {
        //[playButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    [self tick];
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
