//
//  T2ViewController.m
//  A1
//
//  Created by 이승주 on 15/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import "T2ViewController.h"
#import "DefinedHeader.h"

@interface T2ViewController () <STKAudioPlayerDelegate>

@property (strong, nonatomic) STKAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *btnTest;
@property (strong, nonatomic) NSTimer *timer;

@end

//https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-3.0-Migration-Guide
@implementation T2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    self.audioPlayer.meteringEnabled = YES;
    self.audioPlayer.volume = 0.1;
    self.audioPlayer.delegate = self;
    
    //[self setupTimer];
}

- (IBAction)play:(UIButton *)sender
{
    //NSLog(@"play");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Unit_31_40" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //[audioPlayer play:@"http://www.abstractpath.com/files/audiosamples/sample.mp3"];
    [self.audioPlayer playURL:url];
}

- (IBAction)stop:(UIButton *)sender
{
    //NSLog(@"stop");
    [self.audioPlayer stop];
}

- (IBAction)pause:(UIButton *)sender
{
    //NSLog(@"pause");
    [self.audioPlayer pause];
}

- (IBAction)seek:(UIButton *)sender
{
    //NSLog(@"seek");
    
    //    세팅전 0
    //    재생시작 5
    //    재생중 3
    //    일시정지 9
    //    중지 16
    
    if (self.audioPlayer.state == 3 || self.audioPlayer.state == 5)
    {
        NSLog(@"seek without play");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.audioPlayer seekToTime:100.0];
        });
    }
    else if (self.audioPlayer.state == 9 || self.audioPlayer.state == 16)
    {
        NSLog(@"seek with play");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Unit_31_40" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
        [self.audioPlayer playURL:url];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.audioPlayer seekToTime:100.0];
        });
    }
}

- (IBAction)queue:(UIButton *)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Unit_41_50" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    [self.audioPlayer queueURL:url];
}

- (void)setupTimer
{
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)tick
{
    NSLog(@"tick ===================> status : %ld", (long)self.audioPlayer.state);
    
//    if (!self.audioPlayer)
//    {
//        NSLog(@"tick ===================> !self.audioPlayer, XXXXX");
//
//        return;
//    }
//
//    if (self.audioPlayer.currentlyPlayingQueueItemId == nil)
//    {
//        NSLog(@"tick ===================>self.audioPlayer.currentlyPlayingQueueItemId == nil, XXXXX");
//        return;
//    }
//
//    // 로컬파일 경우
//    if (self.audioPlayer.duration != 0)
//    {
//        NSLog(@"tick ===================>local 파일, status : %ld", (long)self.audioPlayer.state);
//
//        //        slider.minimumValue = 0;
//        //        slider.maximumValue = audioPlayer.duration;
//        //        slider.value        = audioPlayer.progress;
//        //        label.text          = [NSString stringWithFormat:@"%@ - %@", [self formatTimeFromSeconds:audioPlayer.progress], [self formatTimeFromSeconds:audioPlayer.duration]];
//    }
//    else
//    {
//        NSLog(@"tick ===================>streaming 파일 ");
//
//        // 스트리밍 일때
//        //        slider.value        = 0;
//        //        slider.minimumValue = 0;
//        //        slider.maximumValue = 0;
//        //        label.text          = [NSString stringWithFormat:@"Live stream %@", [self formatTimeFromSeconds:audioPlayer.progress]];
//    }
    
//    NSString *bufferingYN   = self.audioPlayer.state == STKAudioPlayerStateBuffering ? @"buffering" : @"";
//    NSLog(@"bufferingYN : %@", bufferingYN);
    
//    CGFloat time1 = 3.49;
//    CGFloat time2 = 8.13;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGFloat newTime = time1 + time2;
//        NSLog(@"New time: %f", newTime);
//
//
//    });

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
