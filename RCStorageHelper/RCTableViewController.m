//
//  RCTableViewController.m
//  RCStorageHelper
//
//  Created by Looping on 14-4-8.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "RCTableViewController.h"
#import "Weather.h"

@interface RCTableViewController ()

@property (nonatomic) NSArray *data;

@end

@implementation RCTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)displayWithData:(NSArray *)data {
    _data = data;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_data) {
        [self setTitle:[NSString stringWithFormat:@"共 %d 条数据", [_data count]]];
    }
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 0;
    
    if (_data) {
        numberOfSections = 1;
    }
    
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"WeatherCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( !cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Weather *weather = (Weather *)[_data objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"更新时间: %@ \n城市: %@ \n温度: %@℃ \n风速: %@ \n风向: %@ \n湿度: %@", weather.updateTime, weather.city, weather.temperature, weather.windSpeed, weather.windDirection, weather.humidity]];
    [cell.textLabel setNumberOfLines:10];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - Dismiss
- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
