//
//  LivePersonManager.m
//  MobileConciergeUSDemo
//
//  Created by s3 on 5/24/19.
//  Copyright © 2019 Sunrise Software Solutions Corporation. All rights reserved.
//

#import "LivePersonComponent.h"


@interface LivePersonComponent ()

@end

@implementation LivePersonComponent

+ (LivePersonComponent *)shared {
    static LivePersonComponent *sharedLivePerson = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLivePerson = [[self alloc] init];
    });
    
//    [sharedLivePerson initConversation];
    
    return sharedLivePerson;
}

+ (void)start {
    [LivePersonComponent shared];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeChatSDK];
       // [self setUserDetails];
    }
    return self;
}

#pragma mark - Chat Stuffs
-(void) initializeChatSDK
{
    //[self setupBranding];
    
    // [[LPMessagingSDK instance] subscribeLogEvents:LogLevelInfo logEvent:^(LPLog *log) {
    //     NSLog(@"LPMessaging Log: %@", log.text);
    // }];
    
    NSString *account = @"2022139";

    NSError *error = nil;
    
   // [[LPMessagingSDK instance] initialize:account monitoringInitParams:nil error:&error];
    
    if (error) {
        NSLog(@"LPMessagingSDK Initialize Error: %@",error);
        return;
    }
    
}

/**
 This method sets the SDK configurations.
 For example:
 Change background color of remote user (such as Agent)
 Change background color of user (such as Consumer)
 */


/**
 This method sets the user details such as first name, last name, profile image and phone number.
 */





@end
