//
//  Weather.h
//  RCStorageHelper
//
//  Created by Looping on 14-4-8.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weather : NSManagedObject

@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSString * windDirection;
@property (nonatomic, retain) NSString * windSpeed;
@property (nonatomic, retain) NSString * humidity;
@property (nonatomic, retain) NSString * updateTime;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * cityId;

@end
