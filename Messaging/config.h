//
//  config.h
//  Messaging
//
//  Created by Turbo on 5/22/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#ifndef Messaging_config_h
#define Messaging_config_h

#pragma mark - static parameters
static NSInteger const REFRESH_CONTROLLER_TAG = 0404 ;
static NSInteger const NAME_IN_TABLEVIEW_CELL_TAG = 1;
static NSInteger const SUBTITLE_IN_TABLEVIEW_CELL_TAG = 2;
static NSInteger const TIME_LABEL_INBOX_TAG = 3;
static NSInteger const IMAGE_LABEL_INBOX_TAG = 4;
static NSInteger const IMAGE_LABEL_CONTACTS_TAG = 3;


#pragma mark - Server configuration
static NSString * const LOCALHOST_URL = @"http://192.168.1.219:8888/ChatServerLocalhost/";
static NSString * const LOCALHOST_CONTACTS_URL = @"retrieve_data.php/query_all_followers";
static NSString * const LOCALHOST_SEND_MSG = @"chat_api.php";

#endif
