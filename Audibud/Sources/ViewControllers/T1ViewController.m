//
//  T1ViewController.m
//  A1
//
//  Created by 이승주 on 15/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import "T1ViewController.h"
#import "DefinedHeader.h"
#import "FileItemTableViewCell.h"
#import "ClassicPracticeViewController.h"

@interface T1ViewController () <UITableViewDelegate, UITableViewDataSource, FileItemTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;

@end


@implementation T1ViewController

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FileItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"FileItemTableViewCell"];
    
    [self loadData];
}

- (void)loadData
{
    NSString *URLString = @"http://lang.nicejames.com/api/Lang/GetFileItems";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString
       parameters:nil
         progress:nil
          success:^(NSURLSessionTask *task, id responseObject) {
              self.data = responseObject[@"response_data"];
              NSLog(@"JSON: %@", self.data);
              
              for (NSDictionary *dic in self.data)
              {
                  [SQLITE addFileData:dic];
              }
              
              [self.tableView reloadData];
              
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FileItemTableViewCell";
    FileItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.delegate = self;
    [cell setData:self.data[indexPath.row]];

    return cell;
}

- (void)didDownload:(NSUInteger)f_idx
{
    NSDictionary *d = [SQLITE fileDataByFileIdx:f_idx];
    
    if(d)
        if([d[@"download_yn"] isEqualToString:@"Y"])
            return;
    
    NSString *URLString = @"http://lang.nicejames.com/api/Lang/GetPractice";

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString
       parameters:@{@"f_idx":@(f_idx).stringValue}
         progress:nil
          success:^(NSURLSessionTask *task, id responseObject) {
              
              [SQLITE removePracticeByFileIdx:f_idx];
              for (NSDictionary *dic in responseObject[@"response_data"])
                  [SQLITE addPractice:dic];
              [SQLITE updateFileDataAtDownloadYN:f_idx];
              [self.tableView reloadData];

          } failure:^(NSURLSessionTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)didView:(NSUInteger)f_idx
{
    NSLog(@"view : f_idx : %lu", (unsigned long)f_idx);
    NSLog(@"practice : %@", [SQLITE practiceFileIdx:f_idx] );

    NSDictionary *d = [SQLITE fileDataByFileIdx:f_idx];
    
    if(d)
    {
        if([d[@"download_yn"] isEqualToString:@"Y"])
        {
            ClassicPracticeViewController *viewController = [[ClassicPracticeViewController alloc] initWithNibName:@"ClassicPracticeViewController" bundle:nil];
            viewController.f_idx = f_idx;
            viewController.title = @"Course";
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
