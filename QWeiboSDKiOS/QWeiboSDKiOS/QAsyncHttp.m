//
//  QAsyncHttp.m
//  QWeiboSDK4iOS
//
//  Created on 11-1-18.
//  
//

#import "QAsyncHttp.h"
#import "QMutableURLRequest.h"


@implementation QAsyncHttp

- (NSURLConnection *)httpGet:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [QMutableURLRequest requestGet:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare]; 
	
}

- (NSURLConnection *)httpPost:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [QMutableURLRequest requestPost:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}

- (NSURLConnection *)httpPostWithData:(NSArray *)dataList url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [QMutableURLRequest requestPostWithData:dataList url:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}

@end
