//
//  QWPerson.m
//  QWeiboClient
//
//  Created by  on 11-9-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "QWPerson.h"
#import "NSObject+Universal.h"

@implementation QWPerson

@synthesize isMyBlack = _isMyBlack;
@synthesize isMyFans = _isMyFans;
@synthesize isMyIdol = _isMyIdol;
@synthesize birth = _birth;
@synthesize cityCode = _cityCode;
@synthesize countryCode = _countryCode;
@synthesize edu = _edu;
@synthesize email = _email;
@synthesize fansNum = _fansNum;
@synthesize head = _head;
@synthesize idolNum = _idolNum;
@synthesize introduction = _introduction;
@synthesize isEnt = _isEnt;
@synthesize isVIP = _isVIP;
@synthesize location = _location;
@synthesize name = _name;
@synthesize nick = _nick;
@synthesize openID = _openID;
@synthesize provinceCode = _provinceCode;
@synthesize sex = _sex;
@synthesize tag = _tag;
@synthesize tweetNum = _tweetNum;
@synthesize verifyInfo = _verifyInfo;

- (id)init
{
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithIsmyblack:(BOOL)aIsmyblack isMyFans:(BOOL)aIsmyfans isMyIdol:(BOOL)aIsmyidol birth:(NSDate *)aBirth cityCode:(NSString *)aCitycode countryCode:(NSString *)aCountrycode edu:(NSString *)aEdu email:(NSString *)aEmail fansNum:(int)aFansnum head:(NSString *)aHead idolNum:(int)aIdolnum introduction:(NSString *)aIntroduction isEnt:(BOOL)aIsent isVIP:(BOOL)aIsvip location:(NSString *)aLocation name:(NSString *)aName nick:(NSString *)aNick openID:(NSString *)aOpenid provinceCode:(NSString *)aProvincecode sex:(BOOL)aSex tag:(NSString *)aTag tweetNum:(int)aTweetnum verifyInfo:(NSString *)aVerifyinfo
{
    if ((self = [super init])) {
        self.isMyBlack = aIsmyblack;
        self.isMyFans = aIsmyfans;
        self.isMyIdol = aIsmyidol;
        self.birth = aBirth;
        self.cityCode = aCitycode;
        self.countryCode = aCountrycode;
        self.edu = aEdu;
        self.email = aEmail;
        self.fansNum = aFansnum;
        self.head = aHead;
        self.idolNum = aIdolnum;
        self.introduction = aIntroduction;
        self.isEnt = aIsent;
        self.isVIP = aIsvip;
        self.location = aLocation;
        self.name = aName;
        self.nick = aNick;
        self.openID = aOpenid;
        self.provinceCode = aProvincecode;
        self.sex = aSex;
        self.tag = aTag;
        self.tweetNum = aTweetnum;
        self.verifyInfo = aVerifyinfo;
        
    }
    return self;
}

- (id)initWithJSON:(NSDictionary *)dict
{
    BOOL isMyBlack = [[dict objectForKey:@"Ismyblack"] boolValue];
    BOOL isMyFans = [[dict objectForKey:@"Ismyfans"] boolValue];
    BOOL isMyIdol = [[dict objectForKey:@"Ismyidol"] boolValue];
    NSDate *birth = [dict objectForKey:@"nick"];
    NSString *cityCode = EmptyString([dict objectForKey:@"city_code"]);
    NSString *countryCode = EmptyString([dict objectForKey:@"country_code"]);
    NSString *edu = EmptyString([dict objectForKey:@"edu"]);
    NSString *email = EmptyString([dict objectForKey:@"email"]);
    int fansNum = [[dict objectForKey:@"fansnum"] intValue];
    NSString *head = EmptyString([dict objectForKey:@"head"]);
    if (![head isEqualToString:@""])
        head = [head stringByAppendingPathComponent:@"50"];
    int idolNum = [[dict objectForKey:@"idolnum"] intValue];
    NSString *introduction = EmptyString([dict objectForKey:@"introduction"]);
    BOOL isEnt = [[dict objectForKey:@"isent"] boolValue];
    BOOL isVIP = [[dict objectForKey:@"isvip"] boolValue];
    NSString *location = EmptyString([dict objectForKey:@"location"]);
    NSString *name = EmptyString([dict objectForKey:@"name"]);
    NSString *nick = EmptyString([dict objectForKey:@"nick"]);
    NSString *openID = EmptyString([dict objectForKey:@"openid"]);
    NSString *provinceCode = EmptyString([dict objectForKey:@"province_code"]);
    BOOL sex = [[dict objectForKey:@"sex"] boolValue];
    NSString *tag = EmptyString([dict objectForKey:@"tag"]);
    int tweetNum = [[dict objectForKey:@"tweetnum"] intValue];
    NSString *verifyInfo = EmptyString([dict objectForKey:@"verifyinfo"]);
    return [self initWithIsmyblack:isMyBlack isMyFans:isMyFans isMyIdol:isMyIdol birth:birth cityCode:cityCode countryCode:countryCode edu:edu email:email fansNum:fansNum head:head idolNum:idolNum introduction:introduction isEnt:isEnt isVIP:isVIP location:location name:name nick:nick openID:openID provinceCode:provinceCode sex:sex tag:tag tweetNum:tweetNum verifyInfo:verifyInfo];
}

- (void)dealloc
{
    [_birth release];
    [_cityCode release];
    [_countryCode release];
    [_edu release];
    [_email release];
    [_head release];
    [_introduction release];
    [_location release];
    [_name release];
    [_nick release];
    [_openID release];
    [_provinceCode release];
    [_tag release];
    [_verifyInfo release];
    
    [super dealloc];
}

@end
