//
//  QWConstants.h
//  QWeiboClient
//
//  Created by  on 11-9-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#define RGBCOLOR(R,G,B)                                     [NSColor colorWithDeviceRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#define LINK_COLOR                                          RGBCOLOR(0,64,128)

#define REQUEST_TOKEN_KEY                                   @"REQUEST_TOKEN_KEY"
#define REQUEST_TOKEN_SECRET_KEY                            @"REQUEST_TOKEN_SECRET_KEY"
#define ACCESS_TOKEN_KEY                                    @"ACCESS_TOKEN_KEY"
#define ACCESS_TOKEN_SECRET_KEY                             @"ACCESS_TOKEN_SECRET_KEY"

#define LISTVIEW_RESIZED_NOTIFICATION                       @"LISTVIEW_RESIZED_NOTIFICATION"
#define GET_TIMELINE_NOTIFICATION                           @"GET_TIMELINE_NOTIFICATION"
#define GET_METHIONS_NOTIFICATION                           @"GET_METHIONS_NOTIFICATION"
#define GET_MESSAGES_NOTIFICATION                           @"GET_MESSAGES_NOTIFICATION"
#define GET_FAVORITES_NOTIFICATION                          @"GET_FAVORITES_NOTIFICATION"
#define GET_USER_INFO_NOTIFICATION                          @"GET_USER_INFO_NOTIFICATION"
#define PUBLISH_MESSAGE_NOTIFICATION                        @"PUBLISH_MESSAGE_NOTIFICATION"
#define LOGOUT_NOTIFICATION                                 @"LOGOUT_NOTIFICATION"
#define GET_UPDATE_COUNT_NOTIFICATION                       @"GET_UPDATE_COUNT_NOTIFICATION"

#define VERIFY_URL                                          @"http://open.t.qq.com/cgi-bin/authorize?oauth_token="
#define GET_TIMELINE_URL                                    @"http://open.t.qq.com/api/statuses/home_timeline"
#define GET_METHIONS_URL                                    @"http://open.t.qq.com/api/statuses/mentions_timeline"
#define GET_MESSAGES_URL                                    @"http://open.t.qq.com/api/private/recv"
#define GET_FAVORITES_URL                                   @"http://open.t.qq.com/api/fav/list_t"
#define GET_USER_INFO_URL                                   @"http://open.t.qq.com/api/user/info"
#define PUBLISH_MESSAGE_URL                                 @"http://open.t.qq.com/api/t/add"
#define PUBLISH_IMAGE_URL                                   @"http://open.t.qq.com/api/t/add_pic"
#define RETWEET_URL                                         @"http://open.t.qq.com/api/t/re_add"
#define GET_UPDATE_COUNT_URL                                @"http://open.t.qq.com/api/info/update"
#define GET_MY_BROADCAST_URL                                @"http://open.t.qq.com/api/statuses/broadcast_timeline"
#define GET_USER_BROADCAST_URL                              @"http://open.t.qq.com/api/statuses/user_timeline"
#define GET_PUBLIC_TIMELINE_URL                             @"http://open.t.qq.com/api/statuses/public_timeline"
#define ADD_FAVORITE_URL                                    @"http://open.t.qq.com/api/fav/addt"
#define DELETE_FAVORITE_URL                                 @"http://open.t.qq.com/api/fav/delt"

#define UPDATE_INTERVAL_TIMELINE                            30
#define UPDATE_INTERVAL_MENTHIONS                           60
#define UPDATE_INTERVAL_MESSAGES                            300

