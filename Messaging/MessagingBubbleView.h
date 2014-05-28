//
//  MessagingBubbleView.h
//  Messaging
//
//  Created by Turbo on 5/23/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    BubbleTypeLefthand = 0,
    BubbleTypeRighthand,
}
BubbleType;

@interface MessagingBubbleView : UIView

// Calculate the bubble size for the text
+ (CGSize)bubbleSizeForText:(NSString *)text;

// Init the text and bubble
- (void)setText:(NSString *)newText bubbleType:(BubbleType)newButtleType;

@end
