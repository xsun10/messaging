//
//  Thread.m
//  Messaging
//
//  Created by Turbo on 5/14/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import "Thread.h"

@implementation Thread

@dynamic userId;
@dynamic message;
@dynamic date;

- (BOOL)isSendByUser {
    return YES;
}

#pragma - mark  NSCoding delegate implementation
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

@end
