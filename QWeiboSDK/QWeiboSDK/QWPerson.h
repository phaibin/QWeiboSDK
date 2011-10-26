//
//  QWPerson.h
//  QWeiboClient
//
//  Created by  on 11-9-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
//BOOL isMyBlack
//BOOL isMyFans
//BOOL isMyIdol
//NSDate birth
//NSString cityCode
//NSString countryCode
//NSString edu
//NSString email
//int fansNum
//NSString head
//int idolNum
//NSString introduction
//BOOL isEnt
//BOOL isVIP
//NSString location
//NSString name
//NSString nick
//NSString openID
//NSString provinceCode
//BOOL sex
//NSString tag
//int tweetNum
//NSString verifyInfo
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QWPerson : NSObject {

}

@property (assign) BOOL isMyBlack;
@property (assign) BOOL isMyFans;
@property (assign) BOOL isMyIdol;
@property (retain) NSDate *birth;
@property (copy) NSString *cityCode;
@property (copy) NSString *countryCode;
@property (copy) NSString *edu;
@property (copy) NSString *email;
@property (assign) int fansNum;
@property (copy) NSString *head;
@property (assign) int idolNum;
@property (copy) NSString *introduction;
@property (assign) BOOL isEnt;
@property (assign) BOOL isVIP;
@property (copy) NSString *location;
@property (copy) NSString *name;
@property (copy) NSString *nick;
@property (copy) NSString *openID;
@property (copy) NSString *provinceCode;
@property (assign) BOOL sex;
@property (copy) NSString *tag;
@property (assign) int tweetNum;
@property (copy) NSString *verifyInfo;

- (id)initWithIsmyblack:(BOOL)aIsmyblack isMyFans:(BOOL)aIsmyfans isMyIdol:(BOOL)aIsmyidol birth:(NSDate *)aBirth cityCode:(NSString *)aCitycode countryCode:(NSString *)aCountrycode edu:(NSString *)aEdu email:(NSString *)aEmail fansNum:(int)aFansnum head:(NSString *)aHead idolNum:(int)aIdolnum introduction:(NSString *)aIntroduction isEnt:(BOOL)aIsent isVIP:(BOOL)aIsvip location:(NSString *)aLocation name:(NSString *)aName nick:(NSString *)aNick openID:(NSString *)aOpenid provinceCode:(NSString *)aProvincecode sex:(BOOL)aSex tag:(NSString *)aTag tweetNum:(int)aTweetnum verifyInfo:(NSString *)aVerifyinfo;
- (id)initWithJSON:(NSDictionary *)dict;

@end
