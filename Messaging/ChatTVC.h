//
//  ChatTVC.h
//  Messaging
//
//  Created by Turbo on 5/19/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessagingModel;

@interface ChatTVC : UIViewController

@property (nonatomic, strong, readonly) MessagingModel *dataModel;

@end
