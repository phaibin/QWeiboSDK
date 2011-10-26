//
//  QWeiboAsyncApi.h
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-18.
//   
//

#import <Foundation/Foundation.h>
#import "JSONURLConnection.h"
#import "QWMessage.h"

enum {
    JSONURLConnectionTagGetLastTweets = 0,
    JSONURLConnectionTagGetOlderTweets,
    JSONURLConnectionTagGetNewerTweets,
	JSONURLConnectionTagGetUserInfo,
	JSONURLConnectionTagPublishMessage,
    JSONURLConnectionTagGetUpdateCount,
    JSONURLConnectionTagAddFavorite,
    JSONURLConnectionTagGetPublicTimeline,
    JSONURLConnectionTagDeleteFavorite,
};

typedef enum {
    TweetTypeNone = 0,
    TweetTypeTimeline = 5,
    TweetTypeMethions,
    TweetTypeMessages,
    TweetTypeFavorites,
    TweetTypeMyBroadcast,
    TweetTypeUserBroadcast,
    TweetTypeSearch,
} TweetType;

typedef enum {
    UpdateTypeAll = 0,
    UpdateTypeTimeline = 5,
    UpdateTypeMentions,
    UpdateTypeMessages,
} UpdateType;

typedef enum {
    PageFlagLast = 0,
    PageFlagOlder,
    PageFlagNewer,
} PageFlag;

@protocol QWeiboAsyncApiDelegate <NSObject>

- (void)receivedLastTweets:(NSArray *)tweets info:(NSDictionary *)info;
- (void)receivedOlderTweets:(NSArray *)tweets info:(NSDictionary *)info;
- (void)receivedNewerTweets:(NSArray *)tweets;
- (void)addedFavorite;
- (void)deletedFavorite;

@end

@interface QWeiboAsyncApi : NSObject<JSONURLConnectionDelegate> {
    NSMutableArray *connectionList;
    NSTimer *timer;
}

@property(copy) NSString *appKey;
@property(copy) NSString *appSecret;
@property(assign) id<QWeiboAsyncApiDelegate> delegate;

- (id)initWithAppKey:(NSString *)appKey AppSecret:(NSString *)appSecret;
- (NSString *)getRequestToken;
- (NSString *)getAccessTokenWithRequestTokenKey:(NSString *)aRequestTokenKey requestTokenSecret:(NSString *)aRequestTokenSecret verify:(NSString *)aVerify;
- (void)getLastTweetsWithTweetType:(TweetType)tweetType pageSize:(int)pageSize userName:(NSString *)userName;
- (void)getOlderTweetsWithTweetType:(TweetType)tweetType pageSize:(int)pageSize pageTime:(double)pageTime userName:(NSString *)userName;
- (void)getNewerTweetsWithTweetType:(TweetType)tweetType pageSize:(int)pageSize pageTime:(double)pageTime userName:(NSString *)userName;
- (void)getPublicTimelineWithPos:(int)pos pageSize:(int)pageSize;
- (void)getUserInfo;
- (void)publishMessage:(NSString *)message;
- (void)publishMessage:(NSString *)message withPicture:(NSString *)filePath;
- (void)retweet:(QWMessage *)tweet content:(NSString *)message;
- (void)beginUpdating;
- (void)stopUpdating;
- (void)addFavorite:(NSString *)tweetId;
- (void)deleteFavorite:(NSString *)tweetId;

@end
