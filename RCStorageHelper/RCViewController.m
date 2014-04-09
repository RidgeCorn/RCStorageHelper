//
//  RCViewController.m
//  RCStorageHelper
//
//  Created by Looping on 14-4-8.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "RCViewController.h"
#import "RCTableViewController.h"
#import <objc/runtime.h>
#import "Weather.h"
#import "NSManagedObject+RCStorageHelper.h"

#define StoreURL [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:kRCDBFileName]];

static NSString * const kRCDBFileName = @"Model.sqlite";
static NSString * const kRCDBWeatherEntityName = @"Weather";

@interface RCViewController ()
@property (weak, nonatomic) IBOutlet UIButton *update;
@property (weak, nonatomic) IBOutlet UILabel *weatherInfoLabel;

@property (nonatomic) UIAlertView *updateAlert;

@property(nonatomic) NSManagedObjectModel *managedObjectModel;
@property(nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation RCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self launchCoreData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)updatePressed:(UIButton *)sender {
    if ( !_updateAlert) {
        _updateAlert = [[UIAlertView alloc] initWithTitle:@"更新中" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    }
    
    [_updateAlert show];
    
    NSThread *fetchDataThread = [[NSThread alloc] initWithTarget:self selector:@selector(fetchData) object:nil];
    [fetchDataThread start];
}

- (IBAction)checkOutPressed:(UIButton *)sender {
    RCTableViewController *weatherDisplayViewController = [RCTableViewController new];
    [weatherDisplayViewController displayWithData:[self queryWeatherWithSortKeyPath:@"date"]];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:weatherDisplayViewController] animated:YES completion:nil];
}

- (void)fetchData {
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.weather.com.cn/data/sk/101210101.html"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.f];
    
    NSError *error = nil;
    
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&error];
    
    if (error || !receivedData) {
        NSLog(@"Error (or Received data is nil): \n%@", error.description);
    } else {
        [self saveWeatherWithData:receivedData];
    }
    
    [self performSelectorOnMainThread:@selector(dismissAlertView) withObject:nil waitUntilDone:NO];
}

- (void)dismissAlertView {
    if (_updateAlert) {
        [_updateAlert dismissWithClickedButtonIndex:0 animated:YES];
    }
}

#pragma mark - CoreData
- (void)launchCoreData {
    [self managedObjectModel];
    [self persistentStoreCoordinator];
    [self managedObjectContext];
}

- (NSManagedObjectModel *)managedObjectModel {
    if ( !_managedObjectModel) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if ( !_persistentStoreCoordinator) {
        NSURL *storeUrl = StoreURL;
        NSError *error = nil;
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
            NSLog(@"Error: %@,%@", error, [error userInfo]);
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if ( !_managedObjectContext) {
        NSPersistentStoreCoordinator *coordinator =[self persistentStoreCoordinator];
        
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc]init];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
 
    return _managedObjectContext;
}

#pragma mark Storage
- (void)saveWeatherWithData:(NSData *)data {
    Weather *weather = (Weather *)[NSEntityDescription insertNewObjectForEntityForName:kRCDBWeatherEntityName inManagedObjectContext:_managedObjectContext];

    NSDictionary *mapping = @{
                              @"city": @"weatherinfo.city",
                              @"cityId": @"weatherinfo.cityid",
                              @"temperature": @"weatherinfo.temp",
                              @"windDirection": @"weatherinfo.WD",
                              @"windSpeed": @"weatherinfo.WS",
                              @"humidity": @"weatherinfo.SD",
                              @"updateTime": @"weatherinfo.time"
                              };
    
    [weather updateFromData:data withMapping:mapping];
    
    weather.date = [NSDate date];
    
    [_weatherInfoLabel setText:[NSString stringWithFormat:@"更新时间: %@ \n城市: %@ \n温度: %@℃ \n风速: %@ \n风向: %@ \n湿度: %@", weather.updateTime, weather.city, weather.temperature, weather.windSpeed, weather.windDirection, weather.humidity]];
}

#pragma mark Query
- (NSArray *)queryWeatherWithSortKeyPath:(NSString *)sortkeyPath {
    return [self queryInEntity:kRCDBWeatherEntityName WithSortKeyPath:sortkeyPath];
}

- (NSArray *)queryInEntity:(NSString *)entity WithSortKeyPath:(NSString *)sortkeyPath {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:_managedObjectContext]];
    
    if (sortkeyPath) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortkeyPath ascending:NO];
        NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptions];
    }
    
    NSError *error = nil;
    
    NSArray *fetchResult = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if (fetchResult == nil) {
        NSLog(@"Error: %@,%@", error, [error userInfo]);
    }
    
    NSLog(@"The count of %@: %i",entity ,[fetchResult count]);
    
    return fetchResult;
}

@end
