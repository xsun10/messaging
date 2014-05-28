//
//  MessageTVC.m
//  Messaging
//
//  Created by Turbo on 5/23/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import "Thread.h"
#import "MessageTVCell.h"
#import "MessagingBubbleView.h"

static UIColor* color = nil; // TableView cell background color

@interface MessageTVCell ()
@property (nonatomic, strong) MessagingBubbleView * bubble;
@property (nonatomic, strong) UILabel *label;
@end

@implementation MessageTVCell

+ (void)initialize
{
    if (self == [MessageTVCell class]) {
        color = [UIColor colorWithRed:219/255 green:226/255 blue:237/255 alpha:1.0];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Create the bubble view for text
        self.bubble = [[MessagingBubbleView alloc] initWithFrame:CGRectZero];
        self.bubble.backgroundColor = color;
        self.opaque = YES;
        self.clearsContextBeforeDrawing = NO;
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = 0;
        [self.contentView addSubview:self.bubble];
        
        // Create the label for text
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.backgroundColor = color;
        self.label.opaque = YES;
        self.label.clearsContextBeforeDrawing = NO;
        self.label.contentMode = UIViewContentModeRedraw;
        self.label.autoresizingMask = 0;
        self.label.font = [UIFont systemFontOfSize:13];
        self.label.textColor = [UIColor colorWithRed:64/255 green:64/255 blue:64/255 alpha:1.0];
        [self.contentView addSubview:self.label];
    }
    return self;
}

/* Set the background color of a table view cell */
- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = color;
}

/* Set the message to the message bubble */
- (void)setMessage:(Thread *)thread
{
    CGPoint point = CGPointZero;
    
    // Set the user's message on the right-hand side, and received message on the other side
    NSInteger senderId;
    BubbleType bubbleType;
    if ([thread isSendByUser] == YES) {
        bubbleType = BubbleTypeRighthand;
        point.x = self.bounds.size.width - thread.bubbleSize.width;
        senderId = thread.userId;
        self.label.textAlignment = NSTextAlignmentRight;
    } else {
        bubbleType = BubbleTypeLefthand;
        senderId = thread.userId;
        self.label.textAlignment = NSTextAlignmentLeft;
    }
    
    // Resize the bubble view and display the message
    CGRect rect;
    rect.origin = point;
    rect.size = thread.bubbleSize;
    self.bubble.frame = rect;
    [self.bubble setText:thread.message bubbleType:bubbleType];
    
    // Format the message date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDoesRelativeDateFormatting:YES];
    NSString *dateString = [formatter stringFromDate:thread.date];
    
    // Display the date and sender in label
    self.label.text = [NSString stringWithFormat:@"%d, %@",senderId, dateString];
    [self.label sizeToFit];
    self.label.frame = CGRectMake(8, thread.bubbleSize.height, self.contentView.bounds.size.width - 16, 16);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
