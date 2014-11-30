//
//  MTUtils.m
//  TMeter
//
//  Created by Mykola Vyshynskyi on 30.11.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "MTUtils.h"

#import <sys/types.h>
#import <sys/sysctl.h>

#define MTCurrentMetricKey @"CurrentMetric"

#define C2FMultiplier 1.8f
#define C2FAddition 32.0f

static NSDateFormatter *_dateFormatter = nil;
static NSNumberFormatter *_numberFormatter = nil;

@implementation MTUtils

+ (MTMetric)currentMetric {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:MTCurrentMetricKey] unsignedIntegerValue];
}

+ (void)setCurrentMetric:(MTMetric)metric {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@(metric) forKey:MTCurrentMetricKey];
    [defaults synchronize];
}

+ (NSString *)dayStringFromDate:(NSDate *)date {
    if (!date)
        return nil;
    
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:@"d"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)monthStringFromDate:(NSDate *)date {
    if (!date)
        return nil;
    
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:@"LLL"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)temperatureFromNumber:(NSNumber *)number {
    if (!number || ![number integerValue])
        return nil;
    
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setMaximumFractionDigits:2];
    if ([self currentMetric] == MTMetricFahrenheit) {
        number = @([self celsiusToFahrenheit:[number floatValue]]);
        [numberFormatter setPositiveSuffix:@"°F"];
    } else
        [numberFormatter setPositiveSuffix:@"°C"];
    
    return [numberFormatter stringFromNumber:number];
}

+ (NSString *)shortTemperatureFromNumber:(NSNumber *)number {
    if (!number || ![number integerValue])
        return nil;
    
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    if ([self currentMetric] == MTMetricFahrenheit) {
        number = @([self celsiusToFahrenheit:[number floatValue]]);
        [numberFormatter setPositiveSuffix:@" °F"];
    } else
        [numberFormatter setPositiveSuffix:@" °C"];
    
    return [numberFormatter stringFromNumber:number];
}

+ (NSNumber *)temperatureFromString:(NSString *)string {
    if (!string)
        return nil;
    
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    if ([self currentMetric] == MTMetricFahrenheit)
        [numberFormatter setPositiveSuffix:@"°F"];
    else
        [numberFormatter setPositiveSuffix:@"°C"];
    
    NSNumber *temperature = [numberFormatter numberFromString:string];
    
    if ([self currentMetric] == MTMetricFahrenheit)
        temperature = @([self fahrenheitToCelsius:[temperature floatValue]]);

    return temperature;
}

+ (float)celsiusToFahrenheit:(float)temperature {
    return temperature*C2FMultiplier + C2FAddition;
}

+ (float)fahrenheitToCelsius:(float)temperature {
    return (temperature - C2FAddition)/C2FMultiplier;
}

+ (NSDateFormatter *)dateFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
    });
    
//    [_dateFormatter setLocale:[BPLanguageManager sharedManager].currentLocale];

    return _dateFormatter;
}

+ (NSNumberFormatter *)numberFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _numberFormatter = [[NSNumberFormatter alloc] init];
//        [_numberFormatter setRoundingMode:NSNumberFormatterRoundCeiling];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    });
    
//    [_numberFormatter setLocale:[BPLanguageManager sharedManager].currentLocale];
    [_numberFormatter setMultiplier:@1];
    [_numberFormatter setMinimumFractionDigits:0];
    [_numberFormatter setMaximumFractionDigits:0];
    [_numberFormatter setPositiveSuffix:nil];

    return _numberFormatter;
}

+ (NSString *)deviceModelName {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    //    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    //    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    //    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    //    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    //    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (CDMA)";
    //    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    //    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    //    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    //    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    //    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    //    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    //    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    //    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    //    if ([platform isEqualToString:@"x86_64"])         return @"Simulator";
    
    return platform;
}

@end
