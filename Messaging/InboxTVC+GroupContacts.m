//
//  InboxTVC+GroupContacts.m
//  Messaging
//
//  Created by Turbo on 5/21/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import "InboxTVC+GroupContacts.h"

@implementation InboxTVC (GroupContacts)

- (void)groupContracts
{
     NSArray *dic = [[self.contracts objectForKey:@"player"] objectForKey:@"contacts"] ;
}

@end
