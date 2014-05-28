//
//  MessagingModel.h
//  Messaging
//
//  Created by Turbo on 5/23/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Thread;

@interface MessagingModel : NSObject

@property (nonatomic, strong) NSMutableArray *messages;

- (void)loadMessages;

- (void)saveMessages;

- (int)addMessage: (Thread *)thread;

- (NSString *)nickname;

- (void)setNickname:(NSString *)name;

- (NSString *)secretCode;

- (void)setSecretCode:(NSString *)code;

- (BOOL)joinedChat;

- (void)setJoinedChat:(BOOL)value;

- (NSString *)deviceToken;

@end
