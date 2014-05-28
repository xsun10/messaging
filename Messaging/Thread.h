//
//  Thread.h
//  Messaging
//
//  Created by Turbo on 5/14/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Thread : NSObject <NSCoding>

@property (nonatomic) NSInteger userId;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSDate *date;

@property (nonatomic, assign) CGSize bubbleSize;

- (BOOL)isSendByUser;

@end
