//
//  Conversation.h
//  Messaging
//
//  Created by Turbo on 5/14/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conversation : NSObject

@property (nonatomic, retain) NSNumber *conversationId;
@property (nonatomic, retain) NSMutableArray *threads;
@property (nonatomic, retain) NSMutableArray *participants;

@end
