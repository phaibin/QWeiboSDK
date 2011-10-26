//
//  NSObject+Universal.m
//  
//
//

#import "NSObject+Universal.h"
#import <QuartzCore/QuartzCore.h>

////////////////////////////////////////////////////////////////////////////////////////

NSString* EmptyString(id anMaybeEmptyString) {
	if (!anMaybeEmptyString || anMaybeEmptyString == [NSNull null]) return @"";
	else return (NSString *)anMaybeEmptyString;
}

////////////////////////////////////////////////////////////////////////////////////////
@implementation NSUserDefaults (standardUserDefaults)

+ (NSString *)stringOfKeyInStandardDefaults:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults]stringForKey:key];
}

+ (void)setStandardDefaultsObject:(id)object forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
