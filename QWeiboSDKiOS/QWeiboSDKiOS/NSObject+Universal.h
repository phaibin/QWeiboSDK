//
//  NSObject+Universal.h
//  
//
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////////////

NSString * EmptyString(id anMaybeEmptyString);

////////////////////////////////////////////////////////////////////////////////////////

@interface NSUserDefaults (standardUserDefaults)

+ (NSString *)stringOfKeyInStandardDefaults:(NSString *)key;
+ (void)setStandardDefaultsObject:(id)object forKey:(NSString *)key;

@end
