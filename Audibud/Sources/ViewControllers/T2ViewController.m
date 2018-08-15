//
//  T2ViewController.m
//  A1
//
//  Created by 이승주 on 15/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import "T2ViewController.h"
#import "DefinedHeader.h"

@interface T2ViewController ()

@property (strong, nonatomic) STKAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *btnTest;

@end

//https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-3.0-Migration-Guide
@implementation T2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    self.audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    self.audioPlayer.meteringEnabled = YES;
    self.audioPlayer.volume = 0.1;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Unit_31_40" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //[audioPlayer play:@"http://www.abstractpath.com/files/audiosamples/sample.mp3"];
    [self.audioPlayer playURL:url];
    
    CGFloat time1 = 3.49;
    CGFloat time2 = 8.13;
    
    // Delay 2 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat newTime = time1 + time2;
        NSLog(@"New time: %f", newTime);
        
        [self.audioPlayer seekToTime:100.0];
    });
    
    
    NSString *URLString = @"http://lang.nicejames.com/api/Lang/GetFileItems";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString
       parameters:nil
         progress:nil
          success:^(NSURLSessionTask *task, id responseObject) {
              NSLog(@"JSON: %@", responseObject[@"response_code"]);
              
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    
//    NSMutableArray *a = [[SQLiteData sharedSQLiteData] testData];
//    NSLog(@"aaaaaaa : %@", a);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
