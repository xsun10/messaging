//
//  ChatTVC.m
//  Messaging
//
//  Created by Turbo on 5/19/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import "ChatTVC.h"
#import "MessagingModel.h"
#import "Thread.h"
#import "MessageTVCell.h"
#import "MessagingBubbleView.h"
#import "config.h"
#import "AFHTTPSessionManager.h"
#import "NSString+URLEncoding.h" //Encode the URL string

@interface ChatTVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendBtn;
// Gey the player id using segue
@property (weak, nonatomic) NSString * player_id;
@property (strong, nonatomic) NSString * user_id;
@end

@implementation ChatTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user_id = self.player_id;
    self.textField.keyboardType = UIKeyboardTypeDefault;
    self.textField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.textField.delegate = self;
    
    self.toolBarView.backgroundColor = [UIColor blackColor];
    // Listen the keyboard operation
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    // Register notification when the keyboard will be showed
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillChangeFrame:)
                          name:UIKeyboardWillChangeFrameNotification
                        object:nil];
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard:)];
    gesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gesture];
}

/* Move the toolbar if the keyboard change the frame */
- (void) keyboardWillChangeFrame:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardRect;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    CGFloat y = self.toolBarView.frame.origin.y-keyboardRect.size.height;
    if (y < 0) {
        y = self.toolBarView.frame.origin.y+keyboardRect.size.height;
    }
    [self.toolBarView setFrame:CGRectMake(self.toolBarView.frame.origin.x,
                                          y,
                                          self.toolBarView.frame.size.width,
                                          self.toolBarView.frame.size.height)];
    [UIView commitAnimations];
}

/* Close the keyboard when tap the screen */
- (void)closeKeyBoard:(UITapGestureRecognizer *)aTapGesture
{
    [self.view endEditing:YES];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dataModel = [[MessagingModel alloc] init];
        [_dataModel loadMessages];
    }
    return self;
}

/* Return key definition function */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

/* Send new message to the server */
- (IBAction)sendNewMessage:(UIBarButtonItem *)sender {
    NSString * message = self.textField.text;
    NSString * encodeMsg = [message urlEncodingUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", encodeMsg);
#warning target player id for test
    NSString * target_id = @"2";
    NSURL *url_localhost = [NSURL URLWithString:LOCALHOST_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url_localhost];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    /* Prepare for the data will be sent to the server */
#warning send static player_id for test purpose;
    NSDictionary *data = @{@"cmd":@"message",
                           @"player_id":self.user_id,
                           @"target_id":target_id,
                           @"message":encodeMsg};
    
    /* Communicate with server via POST */
    [manager POST:LOCALHOST_SEND_MSG parameters:data success:
     ^(NSURLSessionDataTask *task, id responseObject) {
         NSLog(@"success: %@", (NSString *)responseObject);
     }failure:^(NSURLSessionDataTask *task, NSError *error) {
#warning failed operation not implement! ask James!
         NSLog(@"Failed:%@", [error localizedDescription]);
     }];
    // Clear the text field
    self.textField.text = @"";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*if (![_dataModel joinedChat]) {
     //
     }*/
}

/*- (void)scrollToNewestMessage
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:(self.dataModel.messages.count-1) inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![_dataModel joinedChat]) {
        //
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = [_dataModel secretCode];
    [self scrollToNewestMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataModel.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTVCell *cell = [tableView dequeueReusableCellWithIdentifier: @"message" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[MessageTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"message"];
    }
    
    Thread* message = (self.dataModel.messages)[indexPath.row];
    [cell setMessage:message];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Thread* thread = (self.dataModel.messages)[indexPath.row];
    thread.bubbleSize = [MessagingBubbleView bubbleSizeForText:thread.message];
    return thread.bubbleSize.height + 16;
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
