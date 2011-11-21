//
//  QWMessage.m
//  QWeiboClient
//
//  Created by Leon on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QWMessage.h"
#import "NSAttributedString+Hyperlink.h"
#import "NSImage+Categories.h"
#import "NSDate+Categories.h"
#import "NSString+HTML.h"

@interface QWMessage ()

- (void)loadFullImage;
- (void)loadThumbnailImage;

@end

static NSOperationQueue *ATSharedOperationQueue() {
    static NSOperationQueue *_ATSharedOperationQueue = nil;
    if (_ATSharedOperationQueue == nil) {
        _ATSharedOperationQueue = [[NSOperationQueue alloc] init];
        // We limit the concurrency to see things easier for demo purposes. The default value NSOperationQueueDefaultMaxConcurrentOperationCount will yield better results, as it will create more threads, as appropriate for your processor
        [_ATSharedOperationQueue setMaxConcurrentOperationCount:2];
    }
    return _ATSharedOperationQueue;    
}

@implementation QWMessage

@synthesize tweetId = _tweetId;
@synthesize nick = _nick;
@synthesize name = _name;
@synthesize head = _head;
@synthesize text = _text;
@synthesize origText = _origText;
@synthesize timestamp = _timestamp;
@synthesize imageURL = _imageURL;
@synthesize source = _source;
@synthesize type = _type;
@synthesize isNew = _isNew;
@synthesize richText = _richText;
@synthesize fullImage = _fullImage;
@synthesize thumbnailImage = _thumbnailImage;
@synthesize imageLoading;

static NSArray *faces;

+ (NSArray *)sharedFaceArray
{
    if (!faces) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"face" ofType:@"plist"];
        faces = [[NSArray arrayWithContentsOfFile:path] retain];
    }
    return faces;
}

- (NSString *)time
{
    return [[NSDate dateWithTimeIntervalSince1970:self.timestamp] normalizeDateString];
}

- (NSString *)text
{
    return _text;
}

- (void)setText:(NSString *)text
{
    [_text autorelease];
    _text = [text copy];
    
    NSString *regexString = @"<a href=\"(.*?)\" target=\"_blank\">(.*?)</a>";   
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:NULL];
    NSArray *results = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    NSMutableArray *links = [NSMutableArray array];
    for(id result in results)
    {
        NSString *url = [text substringWithRange:[result rangeAtIndex:1]];
        NSString *linkString = [text substringWithRange:[result rangeAtIndex:2]];
        [links addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithRange:[result range]], @"range", url, @"url", linkString, @"linkString", nil]];
    }
   
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = NSMakeRange(0, attrString.length);
    [attrString addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:range];
    [attrString addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12.0] range:range];
    
    //replace hyper link
    for (NSInteger i=(links.count-1); i>-1; i--) {
        NSDictionary *dict = [links objectAtIndex:i];
        [attrString replaceCharactersInRange:[[dict objectForKey:@"range"] rangeValue] withAttributedString:[NSAttributedString hyperlinkFromString:[dict objectForKey:@"linkString"] withURL:[dict objectForKey:@"url"]]];
    }
    
    //replace face image
    [attrString beginEditing];
    NSArray *faceArray = [QWMessage sharedFaceArray];
    for (NSDictionary *dic in faceArray) {
        NSMutableString *innerString = [attrString mutableString];
        NSRegularExpression *regexForFace = [NSRegularExpression regularExpressionWithPattern:[dic objectForKey:@"text"] options:(NSRegularExpressionCaseInsensitive | NSRegularExpressionIgnoreMetacharacters) error:NULL];
        NSArray *resultsFace = [regexForFace matchesInString:innerString options:0 range:NSMakeRange(0, [innerString length])];
        for (id result in [resultsFace reverseObjectEnumerator]) {
            NSImage * pic = [NSImage imageNamed:[dic objectForKey:@"image"]];
            NSTextAttachmentCell *attachmentCell = [[NSTextAttachmentCell alloc] initImageCell:pic];
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            [attachment setAttachmentCell: attachmentCell ];
            NSAttributedString *imageString = [NSAttributedString  attributedStringWithAttachment: attachment];
            [attrString replaceCharactersInRange:[result range] withAttributedString:imageString];
        }
    }
    [attrString endEditing];
    
    self.richText = attrString;
    [attrString release];
}

- (NSString *)thumbnailImageURL
{
    if (self.imageURL && ![self.imageURL isEqualToString:@""]) {
        return [self.imageURL stringByAppendingPathComponent:@"160"];
    }
    return @"";
}

- (NSString *)fullImageURL
{
    if (self.imageURL && ![self.imageURL isEqualToString:@""]) {
        return [self.imageURL stringByAppendingPathComponent:@"2000"];
    }
    return @"";
}

- (NSImage *)fullImage {
    if (_fullImage == nil && !self.imageLoading) {
        // Load the image lazily
        [self loadFullImage];
    }        
    return _fullImage;
}

- (void)setFullImage:(NSImage *)fullImage
{
    [_fullImage autorelease];
    _fullImage = [fullImage retain];
}

- (NSImage *)thumbnailImage {
    if (_thumbnailImage == nil) {
        // Load the image lazily
        [self loadThumbnailImage];
    }        
    return _thumbnailImage;
}

- (void)setThumbnailImage:(NSImage *)thumbnailImage
{
    [_thumbnailImage autorelease];
    _thumbnailImage = [thumbnailImage retain];
}

- (id)init
{
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithTweetId:(NSString *)tweetId Nick:(NSString *)aNick Name:(NSString *)aName head:(NSString *)aHead text:(NSString *)aText origText:(NSString *)aOrigText timestamp:(double)aTimestamp image:(NSString *)aImage source:(QWMessage *)aSource type:(QWMessageType)aType
{
    if ((self = [super init])) {
        self.tweetId = tweetId;
        self.nick = aNick;
        self.name = aName;
        self.head = aHead;
        self.text = aText;
        self.origText = aOrigText;
        self.timestamp = aTimestamp;
        self.imageURL = aImage;
        self.source = aSource;
        self.type = aType;
    }
    return self;
}

- (id)initWithJSON:(NSDictionary *)dict
{
    NSString *tweetId = [dict objectForKey:@"id"];
    NSString *nick = [dict objectForKey:@"nick"];
    NSString *name = [dict objectForKey:@"name"];
    NSString *head = [dict objectForKey:@"head"];
    if (head && ![head isEqualToString:@""])
        head = [head stringByAppendingPathComponent:@"50"];
    NSString *text = [[[dict objectForKey:@"text"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByDecodingHTMLEntities];
    NSString *origText = [[text copy] autorelease];
    double timestamp = [[dict objectForKey:@"timestamp"] doubleValue];
    NSString *image = @"";
    if ([dict objectForKey:@"image"] && [dict objectForKey:@"image"] != [NSNull null])
        image = [[dict objectForKey:@"image"] objectAtIndex:0];
    QWMessage *source = nil;
    if ([dict objectForKey:@"source"] && [dict objectForKey:@"source"] != [NSNull null]) {
        source = [[[QWMessage alloc] initWithJSON:[dict objectForKey:@"source"]] autorelease];
        if ([text isEqualToString:@""])
            text = [NSString stringWithFormat:@"-------------------\n<a href=\"Dandelion://%@\" target=\"_blank\">@%@</a>:%@", source.name, source.nick, source.text];
        else 
            text = [NSString stringWithFormat:@"%@\n-------------------\n<a href=\"Dandelion://%@\" target=\"_blank\">@%@</a>:%@", text, source.name, source.nick, source.text];
        if (![source.imageURL isEqualToString:@""])
            image = source.imageURL;
    }
    QWMessageType type = (QWMessageType)[dict objectForKey:@"type"];
    return [self initWithTweetId:tweetId Nick:nick Name:name head:head text:text origText:origText timestamp:timestamp image:image source:source type:type];
}

- (void)loadFullImage
{
    @synchronized (self) {
        if (!self.imageLoading) {
            self.imageLoading = YES;
            // We would have to keep track of the block with an NSBlockOperation, if we wanted to later support cancelling operations that have scrolled offscreen and are no longer needed. That will be left as an exercise to the user.
            [ATSharedOperationQueue() addOperationWithBlock:^(void) {
//                NSLog(@"%@", self.fullImageURL);
                NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:self.fullImageURL]];
                if (image != nil) {
                    @synchronized (self) {
                        [image fixSize];
                        self.imageLoading = NO;
                        self.fullImage = image;
                    }
                    [image release];
                }
            }];
        }
    }
}

- (void)loadThumbnailImage
{
    @synchronized (self) {
        if (!self.imageLoading) {
            self.imageLoading = YES;
            // We would have to keep track of the block with an NSBlockOperation, if we wanted to later support cancelling operations that have scrolled offscreen and are no longer needed. That will be left as an exercise to the user.
            [ATSharedOperationQueue() addOperationWithBlock:^(void) {
//                usleep(25000000);
//                NSLog(@"%@", self.thumbnailImageURL);
                NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:self.thumbnailImageURL]];
                if (image != nil) {
                    @synchronized (self) {
                        [image fixSize];
                        self.imageLoading = NO;
                        self.thumbnailImage = image;
                    }
                    [image release];
                }
            }];
        }
    }
}

- (void)dealloc
{
    [_tweetId release];
    [_nick release];
    [_name release];
    [_head release];
    [_text release];
    [_origText release];
    [_imageURL release];
    [_source release];
    [_richText release];
    [_fullImage release];
    [_thumbnailImage release];
    
    [super dealloc];
}

@end
