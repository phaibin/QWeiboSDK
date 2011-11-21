//
//  QWMessage.h
//  QWeiboClient
//
//  Created by Leon on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//NSString *nick
//NSString *head
//NSString *text
//double timestamp
//NSString *image
//QWMessage *source
//int type

typedef enum {
    QWMessageTypeOriginal=1,//原创
    QWMessageTypeRetweet=2,//转播
    QWMessageTypePrivateMessage=3,//私信
    QWMessageTypeDialog=4,//回复
    QWMessageTypeReply=7,//评论
} QWMessageType;

#define ATEntityPropertyNamedFullImage          @"fullImage"
#define ATEntityPropertyNamedThumbnailImage     @"thumbnailImage"

#import <Foundation/Foundation.h>

@interface QWMessage : NSObject

@property (copy) NSString *tweetId;
@property (copy) NSString *nick;
@property (copy) NSString *name;
@property (copy) NSString *head;
@property (copy) NSString *text;
@property (copy) NSString *origText;
@property (copy, readonly) NSString *time;
@property (copy) NSString *imageURL;
@property (readonly) NSString *thumbnailImageURL;
@property (readonly) NSString *fullImageURL;
@property (assign) double timestamp;
@property (retain) QWMessage *source;
@property (assign) QWMessageType type;
@property (assign) BOOL isNew;
@property (retain) NSMutableAttributedString *richText;
@property (retain) NSImage *thumbnailImage;
@property (retain) NSImage *fullImage;
@property (assign) BOOL imageLoading;

- (id)initWithTweetId:(NSString *)tweetId Nick:(NSString *)aNick Name:(NSString *)aName head:(NSString *)aHead text:(NSString *)aText origText:(NSString *)aOrigText timestamp:(double)aTimestamp image:(NSString *)aImage source:(QWMessage *)aSource type:(QWMessageType)aType;
- (id)initWithJSON:(NSDictionary *)dict;
+ (NSArray *)sharedFaceArray;

@end