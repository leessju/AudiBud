//
//  T1ViewController.m
//  A1
//
//  Created by 이승주 on 15/08/2018.
//  Copyright © 2018 nicejames. All rights reserved.
//

#import "T1ViewController.h"
#import "DefinedHeader.h"

@interface T1ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end


@implementation T1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
