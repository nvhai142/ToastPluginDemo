
#import <UIKit/UIKit.h>
#import <LPMessagingSDK/LPMessagingSDK.h>
//#import "AppData.h"
//#import "AppColor.h"
//#import "AppSize.h"
#import "LivePersonComponent.h"

@interface ConversationViewController : UIViewController <LPMessagingSDKdelegate>

@property (nonatomic, strong) id <ConversationParamProtocol> conversationQuery;
@property (nonatomic, weak) NSString *account;

- (void) dismissAlert;
- (void)setTitleAgentChat:(NSString *)nameAgent;

@end
