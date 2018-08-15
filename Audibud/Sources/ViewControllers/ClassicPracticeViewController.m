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

@interface ClassicPracticeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;

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
    
    
    [self loadData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
