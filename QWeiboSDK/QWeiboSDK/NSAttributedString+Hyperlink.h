#import <Cocoa/Cocoa.h>

@interface NSAttributedString (Hyperlink)

+ (id)hyperlinkFromString:(NSString *)inString withURL:(NSString *)aURL;

@end