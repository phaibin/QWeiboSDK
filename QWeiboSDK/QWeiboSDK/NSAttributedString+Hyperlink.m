#import "NSAttributedString+Hyperlink.h"

@implementation NSAttributedString (Hyperlink)

+(id)hyperlinkFromString:(NSString*)inString withURL:(NSString *)aURL
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);
    
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:aURL range:range];
    
    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:LINK_COLOR range:range];
    
    // font
    [attrString addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:12.0] range:range];
    
    // cursor
    [attrString addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:range];
    
    // shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = RGBCOLOR(88, 88, 88);
    shadow.shadowBlurRadius = 3;
    [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
    
    // next make the text appear with an underline
//    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
    
//    NSMutableParagraphStyle *truncateStyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
//	[truncateStyle setLineBreakMode:NSLineBreakByTruncatingTail];
//	[attrString addAttribute:NSParagraphStyleAttributeName value:truncateStyle range:range];

    [attrString endEditing];
    
    return [attrString autorelease];
}

@end
