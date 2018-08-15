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

@interface T1ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *dataP;

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
    self.dataP = [[NSMutableArray alloc] init];

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
              [self.tableView reloadData];
              
              for (NSDictionary *dic in self.data)
              {
                  [SQLITE addFileData:dic];
              }
              
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
    [cell setData:self.data[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *URLString = @"http://lang.nicejames.com/api/Lang/GetPractice";
    NSUInteger f_idx = [self.data[indexPath.row][@"f_idx"] intValue];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString
       parameters:@{@"f_idx":@(f_idx).stringValue}
         progress:nil
          success:^(NSURLSessionTask *task, id responseObject) {
              self.dataP = responseObject[@"response_data"];
              NSLog(@"JSON: %@", self.dataP);
              //[self.tableView reloadData];
              
              [SQLITE removePracticeByFileIdx:f_idx];
              for (NSDictionary *dic in self.dataP)
                  [SQLITE addPractice:dic];
              [SQLITE updateFileDataAtDownloadYN:f_idx];
              
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
