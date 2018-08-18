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

@interface T1ViewController () <UITableViewDelegate, UITableViewDataSource, FileItemTableViewCellDelegate, UIGestureRecognizerDelegate>

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
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.data  = [[NSMutableArray alloc] init];

    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - APP_DEL.tab_height);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer1.width = 10.0f;
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [btnLeft setImage:[UIImage imageNamed:@"title_btn_back.png"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(leftMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemLeft  = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItems = @[spacer1, itemLeft];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FileItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"FileItemTableViewCell"];
    
    [self loadData];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}

- (void)loadData
{
    NSString *URLString = [NSString stringWithFormat:@"http://lang.nicejames.com/api/Lang/GetFileItems?f_type_idx=%lu", (unsigned long)self.f_type_idx];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString
       parameters:nil
         progress:nil
          success:^(NSURLSessionTask *task, id responseObject) {
              self.data = responseObject[@"response_data"];
              NSLog(@"JSON: %@", self.data);
              
//              for (NSDictionary *dic in self.data)
//              {
//                  [SQLITE addFileData:dic];
//              }
              
              [self.tableView reloadData];
              
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    [arr addObject:@"1"];
//    [arr addObject:@"2"];
//    [arr addObject:@"3"];
//    
//    [GCache setString:@"_______________" forKey:@"a"];
//    NSLog(@"______________cache : %@", [GCache stringForKey:@"a"]);
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

- (void)didDownload:(NSUInteger)f_idx with:(NSDictionary *)dic
{
    NSDictionary *d = [SQLITE fileDataByFileIdx:f_idx];
    
    if(d)
        if([d[@"download_yn"] isEqualToString:@"Y"])
            return;
    
    [SQLITE addFileData:dic];
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // time-consuming task
    dispatch_async(dispatch_get_main_queue(), ^{
        
            NSString *URLString = @"http://lang.nicejames.com/api/Lang/GetPractice";

            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:URLString
               parameters:@{@"f_idx":@(f_idx).stringValue}
                 progress:nil
                  success:^(NSURLSessionTask *task, id responseObject) {
                      
                      [SVProgressHUD showProgress:0];

                      [SQLITE removePracticeByFileIdx:f_idx];
                      int i = 0;
                      for (NSDictionary *dic in responseObject[@"response_data"])
                      {
                          [SQLITE addPractice:dic];
                          i++;
                          
                          //[SVProgressHUD showProgress: (float)i / (float)[responseObject[@"response_data_count"] intValue] * 100.0f ];
                          [SVProgressHUD showProgress: (float)i / (float)[responseObject[@"response_data_count"] intValue] ];
                      }
                      
                      [SQLITE updateFileDataAtDownloadYN:f_idx];
                      [self.tableView reloadData];
                      
                      [SVProgressHUD dismiss];
                      

                  } failure:^(NSURLSessionTask *operation, NSError *error) {
                      NSLog(@"Error: %@", error);
             }];

            
            
            
        });
    });
}

- (void)didView:(NSUInteger)f_idx
{
    NSLog(@"view : f_idx : %lu", (unsigned long)f_idx);
    //NSLog(@"practice : %@", [SQLITE practiceFileIdx:f_idx] );
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

- (void)leftMenuPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
