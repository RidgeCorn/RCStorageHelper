//
//  City.h
//  RCStorageHelper
//
//  Created by Looping on 14-4-9.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Weather;

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *weather;
@end

@interface City (CoreDataGeneratedAccessors)

- (void)addWeatherObject:(Weather *)value;
- (void)removeWeatherObject:(Weather *)value;
- (void)addWeather:(NSSet *)values;
- (void)removeWeather:(NSSet *)values;

@end
