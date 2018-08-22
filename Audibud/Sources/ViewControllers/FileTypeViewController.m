//
//  T1ViewController.m
//  A1
//
//  Created by 이승주 on 15/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import "FileTypeViewController.h"
#import "DefinedHeader.h"
#import "BasicTableViewCell.h"
#import "ClassicPracticeViewController.h"
#import "T1ViewController.h"

@interface FileTypeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSDictionary *dicLatest;
@property (weak, nonatomic) IBOutlet UIButton *btnLatest;

@end


@implementation FileTypeViewController

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
    
    self.btnLatest.layer.cornerRadius = 8;
    self.btnLatest.clipsToBounds = YES;
    self.btnLatest.layer.borderWidth = 0.5;
    self.btnLatest.layer.borderColor = [UIColor grayColor].CGColor;
    self.btnLatest.backgroundColor = [UIColor colorWithHexString:@"#f7f1db"];
    
    self.data  = [[NSMutableArray alloc] init];

    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - APP_DEL.tab_height);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BasicTableViewCell" bundle:nil] forCellReuseIdentifier:@"BasicTableViewCell"];
    
    
    [self.btnLatest sizeToWidth:SCREEN_WIDTH - 60 height:40];
    [self.btnLatest moveToY:SCREEN_HEIGHT - APP_DEL.tab_height - 40 - 20];
    
    self.dicLatest = [SQLITE latestInfo];
    
    if(self.dicLatest)
    {
        [self.btnLatest setTitle:[NSString stringWithFormat:@"최근 %@", self.dicLatest[@"view_date"]] forState:UIControlStateNormal];
    }
    else
    {
        self.btnLatest.hidden = YES;
    }
    
    [self loadData];
}

- (void)loadData
{
    NSString *URLString = @"http://lang.nicejames.com/api/Code/GetList?code_group_idx=1";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString
       parameters:nil
         progress:nil
          success:^(NSURLSessionTask *task, id responseObject) {
              self.data = responseObject[@"response_data"];              
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
    static NSString *CellIdentifier = @"BasicTableViewCell";
    BasicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setData:self.data[indexPath.row][@"code_name"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    T1ViewController *viewController = [[T1ViewController alloc] initWithNibName:@"T1ViewController" bundle:nil];
    viewController.title = @"Learning Items List";
    viewController.f_type_idx = [self.data[indexPath.row][@"code_value"] intValue];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)onTouch_btnLatest:(id)sender {
    T1ViewController *viewController = [[T1ViewController alloc] initWithNibName:@"T1ViewController" bundle:nil];
    viewController.title = @"Learning Items List";
    viewController.f_type_idx = [self.dicLatest[@"f_type_idx"] intValue];
    viewController.dicLatest = self.dicLatest;
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
