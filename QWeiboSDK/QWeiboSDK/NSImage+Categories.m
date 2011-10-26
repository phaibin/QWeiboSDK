//
//  NSImage+NSImage_Categories.m
//  QWeiboClient
//
//  Created by Leon on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSImage+Categories.h"

@implementation NSImage (Categories)

// fix image size to pixel size
- (void)fixSize
{
    NSImageRep *imageRep = [[self representations] lastObject];
    [self setSize:NSMakeSize(imageRep.pixelsWide, imageRep.pixelsHigh)];
}

@end
