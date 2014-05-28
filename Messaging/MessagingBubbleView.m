//
//  MessagingBubbleView.m
//  Messaging
//
//  Created by Turbo on 5/23/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import "MessagingBubbleView.h"

static UIFont *font;
static UIImage *leftBubbleImg;
static UIImage *rightBubbleImg;

const CGFloat maxWidthForText = 200;

const CGFloat topMargin = 10;
const CGFloat bottomMargin = 11;
const CGFloat leftMargin = 17;
const CGFloat rightMargin = 15;

const CGFloat minBubbleWidth = 50;
const CGFloat minBubbleHeight = 40;

const CGFloat verticalPadding = 4;
const CGFloat horizontalPadding = 4;

@interface MessagingBubbleView()
@property (nonatomic) BubbleType bubbleType;
@property (nonatomic, strong) NSString *text;
@end

@implementation MessagingBubbleView

+ (void) initialize
{
    if (self == [MessagingBubbleView class]) {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        leftBubbleImg = [[UIImage imageNamed:@"left_bubble_test"] stretchableImageWithLeftCapWidth:20 topCapHeight:19];
        rightBubbleImg = [[UIImage imageNamed:@"right_bubble_test"] stretchableImageWithLeftCapWidth:20 topCapHeight:19];
    }
}

+ (CGSize)bubbleSizeForText:(NSString *)text
{
    /* Get the size for text */
    CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(maxWidthForText, 9999)
                           lineBreakMode:NSLineBreakByWordWrapping];
    
    /* Fit the bubble size to the text */
    CGSize bubbleSize;
    bubbleSize.height = textSize.height + topMargin + bottomMargin;
    bubbleSize.width = textSize.width + leftMargin + rightMargin;
    if (bubbleSize.width < minBubbleWidth) {
        bubbleSize.width = minBubbleWidth;
    }
    if (bubbleSize.height < minBubbleHeight) {
        bubbleSize.height = minBubbleHeight;
    }
    
    return bubbleSize;
}

- (void)drawRect:(CGRect)rect
{
    [self.backgroundColor setFill];
    UIRectFill(rect);
    
    CGRect bubbleRect = CGRectInset(self.bounds, verticalPadding, horizontalPadding);
    
    CGRect textRect;
    textRect.origin.y = bubbleRect.origin.y + topMargin;
    textRect.size.width = bubbleRect.size.width - leftMargin - rightMargin;
    textRect.size.height = bubbleRect.size.height - topMargin - bottomMargin;
    
    if (self.bubbleType == BubbleTypeLefthand) {
        [leftBubbleImg drawInRect:bubbleRect];
        textRect.origin.x = bubbleRect.origin.x + leftMargin;
    } else {
        [rightBubbleImg drawInRect:bubbleRect];
        textRect.origin.y = bubbleRect.origin.y + rightMargin;
    }
    
    [[UIColor blackColor] set];
    [self.text drawInRect:textRect withFont:font lineBreakMode:NSLineBreakByWordWrapping];
}

- (void)setText:(NSString *)newText bubbleType:(BubbleType)newButtleType
{
    self.text = [newText copy];
    self.bubbleType = newButtleType;
    [self setNeedsDisplay];
}

@end
