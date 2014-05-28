//
//  InboxTVC.m
//  Messaging
//
//  Created by Turbo on 5/14/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import "InboxTVC.h"
#import "ChatTVC.h"
#import "config.h"
#import "AFHTTPSessionManager.h"
#import "AFURLResponseSerialization.h"

@interface InboxTVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *underline;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *noContactView;

@property (retain, strong) UIRefreshControl *refreshControl;

@property (nonatomic) BOOL isInbox;
@property (nonatomic) NSInteger player_id;

@property (nonatomic, strong) UIView *pop;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *secIndexKeys;
@property (nonatomic, strong) NSDictionary *retrieveData;
@property (weak, nonatomic) IBOutlet UIView *topButtonsView;
@end

@implementation InboxTVC
#pragma mark - view functions

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Player_id for test
    self.player_id = 1;
    
    // Init the isInbox flag
    self.isInbox = YES;
    self.secIndexKeys = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
    // Generate a pop view for section index
    [self popupViewCreate];
    // Init the config for tableview
    [self initTableView];
    // Config the image for no-contact
    self.noContactView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view bringSubviewToFront:self.topButtonsView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#warning retrieve the conversation information from the server when the screen shows up
    
}

/*- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

#pragma mark - self defined functions

/* Settings for tableView */
- (void) initTableView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:(CGFloat)250/255 green:(CGFloat)250/255 blue:(CGFloat)250/255 alpha:1.0];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithRed:(CGFloat)250/255 green:(CGFloat)250/255 blue:(CGFloat)250/255 alpha:1.0];
    [self setExtraseparatorLines:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

/* Change between inbox page and contacts page */
- (IBAction)topBtnisClicked:(UIButton *)sender
{
    // Animation for buttom line move
    if ([sender.restorationIdentifier isEqualToString:@"left_btn"]) { // Inbox
        self.isInbox = YES;
        if (self.underline.frame.origin.x > 0) {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 CGFloat xPostion = self.underline.frame.origin.x;
                                 self.underline.frame = CGRectMake(xPostion - 160,
                                                                   self.underline.frame.origin.y,
                                                                   self.underline.frame.size.width,
                                                                   self.underline.frame.size.height);
                                 
                             }
                             completion:nil];
        }
        
#warning reload for test
        [self.tableView reloadData];
        // Disable the separator for tableView
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self dropSubViewByTag:REFRESH_CONTROLLER_TAG];
        [self.view sendSubviewToBack:self.noContactView];
    } else if ([sender.restorationIdentifier isEqualToString:@"right_btn"]) { // Contacts
        self.isInbox = NO;
        if (self.underline.frame.origin.x < 160) {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 CGFloat xPostion = self.underline.frame.origin.x;
                                 self.underline.frame = CGRectMake(xPostion + 160,
                                                                   self.underline.frame.origin.y,
                                                                   self.underline.frame.size.width,
                                                                   self.underline.frame.size.height);
                                 
                             }
                             completion:nil];
            // Enable the separator for tableView
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
            // Enable the refresh control for tableView
            [self addRefreshControlForView:self.tableView];
            // Retrieve contacts from server
            [self retrieveContactFromServer];
        }
    }
}

- (void)addRefreshControlForView:(UIView *)view
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:(CGFloat)209/255 green:(CGFloat)167/255 blue:(CGFloat)86/255 alpha:0.7];
    self.refreshControl.tag = REFRESH_CONTROLLER_TAG;
    [self.refreshControl addTarget:self action:@selector(retrieveContactFromServer) forControlEvents:UIControlEventValueChanged];
    [view addSubview:self.refreshControl];
}

/* Retrieve contacts list from the server */
- (void)retrieveContactFromServer
{
    // Communicate with server in queue
    dispatch_queue_t q = dispatch_queue_create("contact_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(q,^{
        
        NSURL *url_localhost = [NSURL URLWithString:LOCALHOST_URL];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url_localhost];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        /* Prepare for the data will be sent to the server */
#warning send static player_id for test purpose;
        NSDictionary *data = @{@"player_id":[NSString stringWithFormat:@"%d",self.player_id]};
        
        /* Communicate with server via POST */
        [manager POST:LOCALHOST_CONTACTS_URL parameters:data success:
         ^(NSURLSessionDataTask *task, id responseObject) {
             NSLog(@"success!");
             self.retrieveData = (NSDictionary *)responseObject;
             //NSLog(@"%@",self.retrieveData);
             if ([self getNumberOfContacts] == 0) { // no rows in list
                 [self.view bringSubviewToFront:self.noContactView];
             }
             // Back to main thread to handle the UI
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.refreshControl endRefreshing];
                 [self.tableView reloadData];
             });
        }failure:^(NSURLSessionDataTask *task, NSError *error) {
#warning failed operation not implement! ask James!
            NSLog(@"Failed:%@", [error localizedDescription]);
        }];
    });
}

/* Get the total number of contacts in the list */
- (NSInteger)getNumberOfContacts
{
    return [self.retrieveData[@"total"] intValue];
}

/* Get information of a single contact with its attribute name */
- (NSString *)parseContactDic:(NSIndexPath *)indexPath attributesToRetrieve:(NSString *)attrName
{
    NSString *key = [self.secIndexKeys objectAtIndex:indexPath.section];
    NSArray *contacts = self.retrieveData[@"contacts"][key];
    NSDictionary *detail = [contacts objectAtIndex:indexPath.row];
    return detail[attrName];
}

/* Popup view for section index */
- (void) popupViewCreate
{
    CGRect rect = self.tableView.bounds;
    self.pop = [[UIView alloc] initWithFrame:CGRectMake(rect.size.width/2-25, rect.size.height/2-25, 50, 50)]; // Center of the talbeView
    self.pop.backgroundColor = [UIColor blackColor];
    self.pop.alpha = 0.5;
    self.pop.layer.cornerRadius = 7;
    self.pop.layer.masksToBounds = YES;
    // Text setting
    self.titleLabel = [[UILabel alloc] initWithFrame:self.pop.bounds];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    
    [self.pop addSubview:self.titleLabel];
    [self.view addSubview:self.pop];
    [self.view bringSubviewToFront:self.pop];
    self.pop.hidden = YES; // Hidden always
}

/* Dismiss the popup view with animation fade */
- (void)dismissPop
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 1.0;
    [self.pop.layer addAnimation:animation forKey:nil];
    self.pop.hidden = YES;
}

/* Drop subview based on its tag */
- (void)dropSubViewByTag:(NSInteger)tag
{
    for (UIView *subview in self.tableView.subviews) {
        if (subview.tag == tag) {
            [subview removeFromSuperview];
        }
    }
}

/* Hide the extra separator for tableViewCell */
- (void)setExtraseparatorLines:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.isInbox) {
#warning Inbox row not given, 1 for test
        return 1;
    } else {
        return 27;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in one section
    if (self.isInbox) {
#warning Inbox row not given, 10 for test
        return 10;
    } else {
        if (!self.retrieveData) {
            return 0;
        } else {
            NSString *key = [self.secIndexKeys objectAtIndex:section];
            NSArray *eachSec = [self.retrieveData[@"contacts"] objectForKey:key];
            return eachSec.count;
        }
    }
}


/* Draw cells for table view */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (self.isInbox == YES) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"msg_cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"msg_cell"];
        }
        
        // Set the background color
        cell.backgroundColor = [UIColor colorWithRed:(CGFloat)250/255 green:(CGFloat)250/255 blue:(CGFloat)250/255 alpha:1.0];
        cell.accessoryView.opaque = YES;
        // Label for user name
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:NAME_IN_TABLEVIEW_CELL_TAG];
        nameLabel.text = @"text_name";
        // Label for latest message
        UILabel *messagingLabel = (UILabel *)[cell.contentView viewWithTag:SUBTITLE_IN_TABLEVIEW_CELL_TAG];
        messagingLabel.text = @"test message to test the font and style!lalala~";
        // Label for time
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:TIME_LABEL_INBOX_TAG];
        timeLabel.text = @"14 min";
        // Image for inbox cell
        UIImageView *imageLabel = (UIImageView *)[cell.contentView viewWithTag:IMAGE_LABEL_INBOX_TAG];
#warning STATIC IMAGE HERE!
        [imageLabel setImage:[UIImage imageNamed:@"test2"]];
        imageLabel.layer.cornerRadius = 7;
        imageLabel.layer.masksToBounds = YES;
        imageLabel.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"contact_cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contact_cell"];
        }
        // Set the background color
        if (indexPath.row%2 == 0) {
            cell.backgroundColor = [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)255/255 blue:(CGFloat)255/255 alpha:1.0];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:(CGFloat)240/255 green:(CGFloat)240/255 blue:(CGFloat)240/255 alpha:1.0];
        }
        // Label for user name
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:NAME_IN_TABLEVIEW_CELL_TAG];
        nameLabel.text = [self parseContactDic:indexPath attributesToRetrieve:@"full_name"];
        // Label for latest message
        UILabel *fullNameLabel = (UILabel *)[cell.contentView viewWithTag:SUBTITLE_IN_TABLEVIEW_CELL_TAG];
        fullNameLabel.text = [self parseContactDic:indexPath attributesToRetrieve:@"user_name"];;
        // Image for inbox cell
        UIImageView *imageLabel = (UIImageView *)[cell.contentView viewWithTag:IMAGE_LABEL_CONTACTS_TAG];
#warning STATIC IMAGE HERE!
        [imageLabel setImage:[UIImage imageNamed:@"test2"]];
        imageLabel.layer.cornerRadius = 7;
        imageLabel.layer.masksToBounds = YES;
        imageLabel.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return cell;
}

/* Animation when table cell is clicked */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/* Group header for each section in tableView */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.isInbox) { // Only contact need group header for each section
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        NSArray * dataInSec = [self.retrieveData[@"contacts"] objectForKey:[self.secIndexKeys objectAtIndex:section]];
        if (dataInSec.count > 0) {
            UIView *buttomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 19, 320, 1)];
            buttomLine.backgroundColor = [UIColor lightGrayColor];
            [headerView addSubview:buttomLine];
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
            topLine.backgroundColor = [UIColor colorWithRed:(CGFloat)205/255 green:(CGFloat)205/255 blue:(CGFloat)205/255 alpha:1.0];
            [headerView addSubview:topLine];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 320, 20)];
            //NSArray *keys = self.retrieveData[@"key"];
            label.text = [self.secIndexKeys objectAtIndex:section];
            [headerView addSubview:label];
        } else {
            headerView = nil;
        }
        return headerView;
    } else {
        return nil;
    }
}

/* Height of the header in section, working with the viewForHeaderInSection() */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isInbox) {
        return 0;
    } else {
        NSArray * dataInSec = [self.retrieveData[@"contacts"] objectForKey:[self.secIndexKeys objectAtIndex:section]];
        if (dataInSec.count > 0) {
            return 20;
        } else {
            return 0;
        }
    }
    
}

/* Set index for sections */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.isInbox) {
        return self.secIndexKeys;
    } else {
        return nil;
    }
}

/* Operations when index is clicked  */
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    self.titleLabel.text = title;
    self.pop.hidden = NO;
    [self performSelector:@selector(dismissPop) withObject:self afterDelay:1];
    return index;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"chat_segue"]) {
        if ([segue.destinationViewController isKindOfClass:[ChatTVC class]]) {
            ChatTVC *target = segue.destinationViewController;
            [target setValue:[NSString stringWithFormat:@"%d", self.player_id]
                      forKey:@"player_id"];
            
        }
    }
}


@end
