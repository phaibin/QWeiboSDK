
//
//  QWeiboAsyncApi.m
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-18.
//   
//

#import "QWeiboAsyncApi.h"
#import "QOauthKey.h"
#import "QweiboRequest.h"
#import "QWPerson.h"
#import <YAJL/YAJL.h>

@interface QWeiboAsyncApi()

- (int)getUpdateCount:(BOOL)reset;
- (NSString *)getDataSyncWithURL:(NSString *)url Parameters:(NSMutableDictionary *)parameters;
- (void)getDataWithURL:(NSString *)url Parameters:(NSMutableDictionary *)parameters delegate:(id)aDelegate tag:(JSONURLConnectionTag)tag;
- (void)postDataWithURL:(NSString *)url Parameters:(NSMutableDictionary *)parameters Files:(NSDictionary *)files delegate:(id)aDelegate tag:(JSONURLConnectionTag)tag;
- (void)getTweetsWithPageFlag:(PageFlag)pageFlag pageSize:(int)pageSize pageTime:(double)pageTime userName:(NSString *)userName tag:(JSONURLConnectionTag)tag;

@end

@implementation QWeiboAsyncApi

@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize tweetType = _tweetType;
@synthesize delegate = _delegate;

- (id)initWithAppKey:(NSString *)appKey AppSecret:(NSString *)appSecret
{
    if ((self = [super init])) {
        connectionList = [[NSMutableArray alloc] init];
        self.appKey = appKey;
        self.appSecret = appSecret;
    }
    return self;
}

- (NSString *)getRequestToken
{
	
	NSString *url = @"https://open.t.qq.com/cgi-bin/request_token";//for example
	
	QOauthKey *oauthKey = [[QOauthKey alloc] init];
	oauthKey.consumerKey = self.appKey;
	oauthKey.consumerSecret = self.appSecret;
	oauthKey.callbackUrl = @"http://www.qq.com";//for example
	
	QWeiboRequest *request = [[QWeiboRequest alloc] init];
	NSString *retString = [request syncRequestWithUrl:url httpMethod:@"GET" oauthKey:oauthKey parameters:nil files:nil];
	
	[request release];
	[oauthKey release];
	return retString;
}

- (NSString *)getAccessTokenWithRequestTokenKey:(NSString *)aRequestTokenKey requestTokenSecret:(NSString *)aRequestTokenSecret verify:(NSString *)aVerify 
{
	
	NSString *url = @"https://open.t.qq.com/cgi-bin/access_token";
	
	QOauthKey *oauthKey = [[QOauthKey alloc] init];
	oauthKey.consumerKey = self.appKey;
	oauthKey.consumerSecret = self.appSecret;
	oauthKey.tokenKey = aRequestTokenKey;
	oauthKey.tokenSecret= aRequestTokenSecret;
	oauthKey.verify = aVerify;
	
	QWeiboRequest *request = [[QWeiboRequest alloc] init];
	NSString *retString = [request syncRequestWithUrl:url httpMethod:@"GET" oauthKey:oauthKey parameters:nil files:nil];
	
	[request release];
	[oauthKey release];
	return retString;
}

- (void)getLastTweetsWithPageSize:(int)pageSize userName:(NSString *)userName
{
    [self getTweetsWithPageFlag:PageFlagLast pageSize:pageSize pageTime:0 userName:userName tag:JSONURLConnectionTagGetLastTweets];
}

- (void)getOlderTweetsWithPageSize:(int)pageSize pageTime:(double)pageTime userName:(NSString *)userName
{
    if (pageTime == 0)
        [self getTweetsWithPageFlag:PageFlagLast pageSize:pageSize pageTime:0 userName:userName tag:JSONURLConnectionTagGetOlderTweets];
    else
        [self getTweetsWithPageFlag:PageFlagOlder pageSize:pageSize pageTime:pageTime userName:userName tag:JSONURLConnectionTagGetOlderTweets];
}

- (void)getNewerTweetsWithPageSize:(int)pageSize pageTime:(double)pageTime userName:(NSString *)userName
{
    if (pageTime == 0)
        [self getTweetsWithPageFlag:PageFlagLast pageSize:pageSize pageTime:0 userName:userName tag:JSONURLConnectionTagGetNewerTweets];
    else
        [self getTweetsWithPageFlag:PageFlagNewer pageSize:pageSize pageTime:pageTime userName:userName tag:JSONURLConnectionTagGetNewerTweets];
}

- (void)getPublicTimelineWithPos:(int)pos pageSize:(int)pageSize
{
    NSString *url = GET_PUBLIC_TIMELINE_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[NSString stringWithFormat:@"%d", pos] forKey:@"pos"];
	[parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"reqnum"];
    JSONURLConnectionTag tag;
    if (pos == 0)
        tag = JSONURLConnectionTagGetLastTweets;
    else
        tag = JSONURLConnectionTagGetOlderTweets;
    [self getDataWithURL:url Parameters:parameters delegate:self tag:tag];
}

- (void)getTweetsWithPageFlag:(PageFlag)pageFlag pageSize:(int)pageSize pageTime:(double)pageTime userName:(NSString *)userName tag:(JSONURLConnectionTag)tag
{
    NSString *url;
    switch (self.tweetType) {
        case TweetTypeTimeline: {
            url = GET_TIMELINE_URL;
            break;
        }
        case TweetTypeMethions: {
            url = GET_METHIONS_URL;
            break;
        }
        case TweetTypeMessages: {
            url = GET_MESSAGES_URL;
            break;
        }
        case TweetTypeFavorites: {
            url = GET_FAVORITES_URL;
            break;
        }
        case TweetTypeMyBroadcast: {
            url = GET_MY_BROADCAST_URL;
            break;
        }
        case TweetTypeUserBroadcast: {
            url = GET_USER_BROADCAST_URL;
            break;
        }
        default:
            break;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:[NSString stringWithFormat:@"%d", pageFlag] forKey:@"pageflag"];
	[parameters setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"reqnum"];
    [parameters setObject:[NSString stringWithFormat:@"%.f", pageTime] forKey:@"pagetime"];
    if (userName && ![userName isEqualToString:@""])
        [parameters setObject:userName forKey:@"name"];
    [self getDataWithURL:url Parameters:parameters delegate:self tag:tag];
}

- (void)getUserInfo
{
    NSString *url = GET_USER_INFO_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [self getDataWithURL:url Parameters:parameters delegate:self tag:JSONURLConnectionTagGetUserInfo];
}

- (int)getUpdateCount:(BOOL)reset
{
    int updateCount;
    NSString *url = GET_UPDATE_COUNT_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"op"];
    [parameters setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"type"];
    NSDictionary *result = [[self getDataSyncWithURL:url Parameters:parameters] yajl_JSON];
    switch (self.tweetType) {
        case TweetTypeTimeline:
            updateCount = [[result valueForKeyPath:@"data.home"] intValue];
            break;
        case TweetTypeMethions:
            updateCount = [[result valueForKeyPath:@"data.mentions"] intValue];
            break;
        case TweetTypeMessages:
            updateCount = [[result valueForKeyPath:@"data.private"] intValue];
            break;
        default:
            updateCount = 0;
            break;
    }
    
    if (reset) {
        parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"op"];
        [parameters setObject:[NSString stringWithFormat:@"%d", self.tweetType] forKey:@"type"];
        [self getDataSyncWithURL:url Parameters:parameters];
    }
    
    return updateCount;
}

- (void)publishMessage:(NSString *)message
{
    NSString *url = PUBLISH_MESSAGE_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:message forKey:@"content"];
    [self postDataWithURL:url Parameters:parameters Files:nil delegate:self tag:JSONURLConnectionTagPublishMessage];
}

- (void)publishMessage:(NSString *)message withPicture:(NSString *)filePath
{
    NSString *url = PUBLISH_IMAGE_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:message forKey:@"content"];
    [self postDataWithURL:url Parameters:parameters Files:[NSDictionary dictionaryWithObjectsAndKeys:filePath, [[filePath lastPathComponent] stringByDeletingPathExtension], nil] delegate:self tag:JSONURLConnectionTagPublishMessage];
}

- (void)retweet:(QWMessage *)tweet content:(NSString *)message
{
    NSString *content;
    if (tweet.source) {
        content = [NSString stringWithFormat:@"%@ || @%@: %@", message, tweet.name, tweet.origText];
    } else {
        content = message;
    }
    NSString *url = RETWEET_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:content forKey:@"content"];
    [parameters setObject:@"127.0.0.1" forKey:@"clientip"];
    [parameters setObject:tweet.tweetId forKey:@"reid"];
    [self postDataWithURL:url Parameters:parameters Files:nil delegate:self tag:JSONURLConnectionTagPublishMessage];
}

- (void)addFavorite:(NSString *)tweetId
{
    NSString *url = ADD_FAVORITE_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:tweetId forKey:@"id"];
    [self postDataWithURL:url Parameters:parameters Files:nil delegate:self tag:JSONURLConnectionTagAddFavorite];
}

- (void)deleteFavorite:(NSString *)tweetId
{
    NSString *url = DELETE_FAVORITE_URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:tweetId forKey:@"id"];
    [self postDataWithURL:url Parameters:parameters Files:nil delegate:self tag:JSONURLConnectionTagDeleteFavorite];
}

- (NSString *)getDataSyncWithURL:(NSString *)url Parameters:(NSMutableDictionary *)parameters
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:ACCESS_TOKEN_KEY];
    NSString *accessTokenSecret = [[NSUserDefaults standardUserDefaults] stringForKey:ACCESS_TOKEN_SECRET_KEY];
	QOauthKey *oauthKey = [[QOauthKey alloc] init];
	oauthKey.consumerKey = self.appKey;
	oauthKey.consumerSecret = self.appSecret;
	oauthKey.tokenKey = accessToken;
	oauthKey.tokenSecret= accessTokenSecret;
	
	[parameters setObject:@"json" forKey:@"format"];

	QWeiboRequest *request = [[QWeiboRequest alloc] init];
	NSString *result = [request syncRequestWithUrl:url httpMethod:@"GET" oauthKey:oauthKey parameters:parameters files:nil];
	[request release];
	[oauthKey release];
    return result;
}

- (void)getDataWithURL:(NSString *)url Parameters:(NSMutableDictionary *)parameters delegate:(id)aDelegate tag:(JSONURLConnectionTag)tag
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:ACCESS_TOKEN_KEY];
    NSString *accessTokenSecret = [[NSUserDefaults standardUserDefaults] stringForKey:ACCESS_TOKEN_SECRET_KEY];
	QOauthKey *oauthKey = [[QOauthKey alloc] init];
	oauthKey.consumerKey = self.appKey;
	oauthKey.consumerSecret = self.appSecret;
	oauthKey.tokenKey = accessToken;
	oauthKey.tokenSecret= accessTokenSecret;
	
	[parameters setObject:@"json" forKey:@"format"];
    
    JSONURLConnection *jsonConnection = [[JSONURLConnection alloc] initWithDelegate:self connectionTag:tag];
    [connectionList addObject:jsonConnection];
	QWeiboRequest *request = [[QWeiboRequest alloc] init];
	NSURLConnection *connection = [request asyncRequestWithUrl:url httpMethod:@"GET" oauthKey:oauthKey parameters:parameters files:nil delegate:jsonConnection];
    jsonConnection.innerConnection = connection;
	[connection start];
	[request release];
	[oauthKey release];
}

- (void)postDataWithURL:(NSString *)url Parameters:(NSMutableDictionary *)parameters Files:(NSDictionary *)files delegate:(id)aDelegate tag:(JSONURLConnectionTag)tag
{	
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:ACCESS_TOKEN_KEY];
    NSString *accessTokenSecret = [[NSUserDefaults standardUserDefaults] stringForKey:ACCESS_TOKEN_SECRET_KEY];
	QOauthKey *oauthKey = [[QOauthKey alloc] init];
	oauthKey.consumerKey = self.appKey;
	oauthKey.consumerSecret = self.appSecret;
	oauthKey.tokenKey = accessToken;
	oauthKey.tokenSecret= accessTokenSecret;
	
	[parameters setObject:@"json" forKey:@"format"];
    [parameters setObject:@"127.0.0.1" forKey:@"clientip"];
	
    JSONURLConnection *jsonConnection = [[JSONURLConnection alloc] initWithDelegate:self connectionTag:tag];
    [connectionList addObject:jsonConnection];
    [jsonConnection release];
	QWeiboRequest *request = [[QWeiboRequest alloc] init];
	NSURLConnection *connection = [request asyncRequestWithUrl:url httpMethod:@"POST" oauthKey:oauthKey parameters:parameters files:files delegate:jsonConnection];
	[connection start];
	[request release];
	[oauthKey release];
}

#pragma mark - JSONURLConnectionDelegate

- (void)dURLConnection:(JSONURLConnection *)connection didFinishLoadingJSONValue:(NSDictionary *)json
{
    switch (connection.connectionTag) {
        case JSONURLConnectionTagGetLastTweets:
        {
            int updateCount = [self getUpdateCount:YES];
            NSMutableArray *messages = [[NSMutableArray alloc] init];
            NSDictionary *userInfo = nil;
            if ([json valueForKeyPath:@"data"] != [NSNull null]) {
                for (NSDictionary *dict in [json valueForKeyPath:@"data.info"]) {
                    QWMessage *message = [[QWMessage alloc] initWithJSON:dict];
                    if (updateCount > 0)
                        message.isNew = YES;
                    updateCount--;
                    [messages addObject:message];
                    [message release];
                }
                userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[json valueForKeyPath:@"data.hasnext"], @"hasNext", [json valueForKeyPath:@"data.pos"], @"pos", nil];
            } else {
                userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"hasNext", nil];
            }
            if ([self.delegate respondsToSelector:@selector(receivedLastTweets:info:)]) {
                [self.delegate receivedLastTweets:messages info:userInfo];
            }
            [messages release];
            [userInfo release];
            break;
        }
        case JSONURLConnectionTagGetOlderTweets:
        {
            NSMutableArray *messages = [[NSMutableArray alloc] init];
            NSDictionary *userInfo = nil;
            if ([json valueForKeyPath:@"data"] != [NSNull null]) {
                for (NSDictionary *dict in [json valueForKeyPath:@"data.info"]) {
                    QWMessage *message = [[QWMessage alloc] initWithJSON:dict];
                    [messages addObject:message];
                    [message release];
                }
                userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[json valueForKeyPath:@"data.hasnext"], @"hasNext", [json valueForKeyPath:@"data.pos"], @"pos", nil];
            } else {
                userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"hasNext", nil];
            }
            if ([self.delegate respondsToSelector:@selector(receivedLastTweets:info:)]) {
                [self.delegate receivedOlderTweets:messages info:userInfo];
            }
            [messages release];
            [userInfo release];
            break;        
        } 
        case JSONURLConnectionTagGetNewerTweets:
        {
            NSMutableArray *messages = [[NSMutableArray alloc] init];
            if ([json valueForKeyPath:@"data"] != [NSNull null]) {
                for (NSDictionary *dict in [json valueForKeyPath:@"data.info"]) {
                    QWMessage *message = [[QWMessage alloc] initWithJSON:dict];
                    message.isNew = YES;
                    [messages addObject:message];
                    [message release];
                }
            }
            if ([self.delegate respondsToSelector:@selector(receivedNewerTweets:)]) {
                [self.delegate receivedNewerTweets:messages];
            }
            [messages release];
            break;
        }   
        case JSONURLConnectionTagGetUserInfo:
        {
            QWPerson *person = [[QWPerson alloc] initWithJSON:[json valueForKeyPath:@"data"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:GET_USER_INFO_NOTIFICATION object:person];
            [person release];
            break;
        }
        case JSONURLConnectionTagPublishMessage:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:PUBLISH_MESSAGE_NOTIFICATION object:[json objectForKey:@"msg"]];
            break;
        }
        case JSONURLConnectionTagGetUpdateCount:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:GET_UPDATE_COUNT_NOTIFICATION object:[json objectForKey:@"data"]];
            break;            
        }
        case JSONURLConnectionTagAddFavorite:
        {
            if ([self.delegate respondsToSelector:@selector(addFavorite)]) {
                [self.delegate addedFavorite];
            }
            break;            
        }
        case JSONURLConnectionTagDeleteFavorite:
        {
            if ([self.delegate respondsToSelector:@selector(deleteFavorite)]) {
                [self.delegate deletedFavorite];
            }
            break;            
        }
        default:
            break;
    }
    [connection release]; 
    connection = nil;
}

- (void)dURLConnection:(JSONURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection release]; 
    connection = nil;
}

- (void)dealloc
{
    [_appKey release];
    [_appSecret release];
    for (JSONURLConnection *conn in connectionList) {
        [conn cancelConnection];
    }
    [connectionList release]; connectionList = nil;
    [super dealloc];
}

@end
