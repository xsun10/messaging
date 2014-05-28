//
//  MessagingAppDelegate.m
//  Messaging
//
//  Created by Turbo on 5/14/14.
//  Copyright (c) 2014 Turbo. All rights reserved.
//

#import "MessagingAppDelegate.h"
#import "ChatTVC.h";

@implementation MessagingAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Register sound and alert for the push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    if (launchOptions != nil) {
        //NSDictionary *dirctionary = [launchOptions];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];//delete the space in token
    
    /*UINavigationController *navigationController = (UINavigationController *)_window.rootViewController;
    ChatTVC *chatTVC = (ChatTVC *)[navigationController.viewControllers objectAtIndex:2];
    MessagingModel * dataModel = chatTVC.dataModel;*/
    
    NSLog(@"My Token:%@", newToken);
    
    [self postUpadteRequest];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#warning NO FAIL OPERATIONS, ASK JAMES
    NSLog(@"Register Remote Notification failed:%@", error);
}

- (void)postUpadteRequest
{
    NSLog(@"test git!");
}

@end
