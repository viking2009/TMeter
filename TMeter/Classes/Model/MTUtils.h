//
//  MTUtils.h
//  TMeter
//
//  Created by Mykola Vyshynskyi on 13.11.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MTMetric) {
    MTMetricFahrenheit,
    MTMetricCelsius
};

@interface MTUtils : NSObject

+ (MTMetric)currentMetric;
+ (void)setCurrentMetric:(MTMetric)metric;

+ (NSString *)dayStringFromDate:(NSDate *)date;
+ (NSString *)monthStringFromDate:(NSDate *)date;

+ (NSString *)temperatureFromNumber:(NSNumber *)number;
+ (NSString *)shortTemperatureFromNumber:(NSNumber *)number;

+ (NSNumber *)temperatureFromString:(NSString *)string;

+ (float)fahrenheitToCelsius:(float)temperature;
+ (float)celsiusToFahrenheit:(float)temperature;

+ (NSDateFormatter *)dateFormatter;
+ (NSNumberFormatter *)numberFormatter;

/**
 * @return device full model name in human readable strings
 */
+ (NSString*)deviceModelName;

@end
