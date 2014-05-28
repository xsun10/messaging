//
//  MessagingModel.m
//  Messaging
//
//  Created by Turbo on 5/23/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import "MessagingModel.h"

static NSString * const NicknameKey = @"Nickname";
static NSString * const SecretCodeKey = @"SecretCode";
static NSString * const JoinedChatkey = @"JoinedChat";

@interface MessagingModel ()
@property (nonatomic, strong) NSString *deviceToken;
@end


@implementation MessagingModel

@synthesize messages;

+ (void)initialize
{
    if (self == [MessagingModel class]) {
        // Default setting
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{NicknameKey: @"",
                                                                 SecretCodeKey: @"",
                                                                  JoinedChatkey:@0}];
    }
}

// Return path to Message.plist file in directory
- (NSString*)messagesPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = paths[0];
    return [documentsDirectory stringByAppendingString:@"Messages.plist"];
}

- (void)loadMessages
{
    NSString *path = [self messagesPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.messages = [unarchiver decodeObjectForKey:@"Messages"];
        [unarchiver finishDecoding];
    } else {
        self.messages = [NSMutableArray arrayWithCapacity:20];
    }
}

- (void)saveMessages
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.messages forKey:@"Messages"];
    [archiver finishEncoding];
    [data writeToFile:[self messagesPath] atomically:YES];
}

- (int)addMessage: (Thread *)thread
{
    [self.messages addObject:thread];
    [self saveMessages];
    return self.messages.count - 1;
}

- (NSString *)deviceToken
{
    return self.deviceToken;
}

- (NSString *)nickname
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:NicknameKey];
}

- (void)setNickname:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:NicknameKey];
}

- (NSString *)secretCode
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:SecretCodeKey];
}

- (void)setSecretCode:(NSString *)code
{
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:SecretCodeKey];
}

- (BOOL)joinedChat
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:JoinedChatkey];
}

- (void)setJoinedChat:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:JoinedChatkey];
}


@end
