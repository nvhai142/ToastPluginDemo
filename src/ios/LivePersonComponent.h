//
//  LivePersonManager.h
//  MobileConciergeUSDemo
//
//  Created by s3 on 5/24/19.
//  Copyright © 2019 Sunrise Software Solutions Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LPMessagingSDK/LPMessagingSDK.h>
#import <LPInfra/LPInfra.h>
#import <LPAMS/LPAMS.h>

//#import "constant.h"
//#import "Common.h"
//#import "SWRevealViewController.h"
//#import "AppData.h"

@interface LivePersonComponent : NSObject

+ (LivePersonComponent *)shared;

+ (void)start;

@end

