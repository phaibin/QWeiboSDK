

#import "JSONURLConnection.h"
#import <YAJL/YAJL.h>

@interface JSONURLConnection () 

@property (nonatomic, retain)  NSMutableData *buffer;

@end 


@implementation JSONURLConnection

@synthesize connectionTag = _connectionTag;
@synthesize buffer = _buffer;
@synthesize delegate = _delegate;
@synthesize innerConnection = _innerConnection;

- (id)initWithDelegate:(id <JSONURLConnectionDelegate>)delegate {
	return [self initWithDelegate:delegate connectionTag:JSONURLConnectionTagDefault];
}

- (id)initWithDelegate:(id<JSONURLConnectionDelegate>)delegate connectionTag:(JSONURLConnectionTag)tag {
	if (self = [super init]) {
		self.delegate = delegate;
		self.connectionTag = tag;
		NSAssert(_delegate,@"no delegate to get the responsed data");
	}
	return self;
}

- (id)initWithDelegate:(id<JSONURLConnectionDelegate>)delegate connectionTag:(JSONURLConnectionTag)tag connection:(NSURLConnection *)connection
{
    if (self = [self initWithDelegate:delegate connectionTag:tag]) {
		self.innerConnection = connection;
	}
	return self;
}

/////////////////////////////////////////////////////////////

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
	self.buffer = nil;
    self.innerConnection = nil;
	if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
		[_delegate dURLConnection:self didFailWithError:error];
	}
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)response {
	self.buffer = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
	[self.buffer appendData:data]; 
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    self.innerConnection = nil;
	NSDictionary *jsonValue = nil;
	
	@try {
		jsonValue = [self.buffer yajl_JSON];
	}
	@catch (NSException * e) {
		if (e) {
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"JSON Parser error"
																 forKey:NSLocalizedDescriptionKey];
			NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
															 code:1000
														 userInfo:userInfo];
			
			if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
				[_delegate dURLConnection:self didFailWithError:error];
			}			
		}
	}
	@finally {
		if (jsonValue) {
			if ([_delegate respondsToSelector:@selector(dURLConnection:didFinishLoadingJSONValue:)]) {
				[_delegate dURLConnection:self didFinishLoadingJSONValue:jsonValue];
			} 
			
			if ([_delegate respondsToSelector:@selector(dURLConnection:didFinishLoadingJSONValue:string:)]) {
				NSString *string = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
				[_delegate dURLConnection:self didFinishLoadingJSONValue:jsonValue string:string];
				[string release];
			}
		} else {
			if ([_delegate respondsToSelector:@selector(dURLConnection:didFinishLoadingJSONValue:string:)]) {
				NSString *string = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
				[_delegate dURLConnection:self didFinishLoadingJSONValue:nil string:string];
				[string release];
			}
		}

	}
}

- (void)cancelConnection 
{
	self.delegate = nil;
	[self.innerConnection cancel];
	self.innerConnection = nil;
	self.buffer = nil;
}

- (void)dealloc {
	[self cancelConnection];
	[super dealloc];
}

@end
