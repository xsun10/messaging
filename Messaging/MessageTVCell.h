//
//  MessageTVC.h
//  Messaging
//
//  Created by Turbo on 5/23/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Thread;

@interface MessageTVCell : UITableViewCell

- (void)setMessage:(Thread *)thread;

@end
