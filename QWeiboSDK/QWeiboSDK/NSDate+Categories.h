//
//  NSDate+Categories.h
//  DDCoupon
//
//  Created by Ryan Wang on 11-3-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Categories)

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format; 
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
- (NSString *)normalizeDateString;

@end
