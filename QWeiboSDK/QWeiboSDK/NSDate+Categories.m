//
//  NSDate+Categories.m
//  DDCoupon
//
//  Created by Ryan Wang on 11-3-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Categories.h"

@implementation NSDate(Categories)

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
	[formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    [formatter release];
   
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
	[formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:date];
    [formatter release];
    
	return dateString;
}

- (NSString *)normalizeDateString
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *dayComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    NSDate *today = [gregorian dateFromComponents:dayComponents];
    [dayComponents setDay:(dayComponents.day - 1)];
    NSDate *yestoday = [gregorian dateFromComponents:dayComponents];
    
    if ([self timeIntervalSinceDate:yestoday] < 0) {
        return [NSDate stringFromDate:self format:@"MM月d日 HH:mm"];
    } else if ([self timeIntervalSinceDate:yestoday] > 0 && [self timeIntervalSinceDate:today] < 0) {
        return [NSDate stringFromDate:self format:@"昨天 HH:mm"];
    } else {
        return [NSDate stringFromDate:self format:@"今天 HH:mm"];
    }
}

@end
