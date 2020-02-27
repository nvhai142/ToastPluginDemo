//
//  LivePersonManager.m
//  MobileConciergeUSDemo
//
//  Created by s3 on 5/24/19.
//  Copyright © 2019 Sunrise Software Solutions Corporation. All rights reserved.
//

#import "LivePersonComponent.h"


@interface LivePersonComponent ()<LPMessagingSDKdelegate>

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
        [self setUserDetails];
    }
    return self;
}

#pragma mark - Chat Stuffs
-(void) initializeChatSDK
{
    [self setupBranding];
    
    [[LPMessagingSDK instance] subscribeLogEvents:LogLevelInfo logEvent:^(LPLog *log) {
        NSLog(@"LPMessaging Log: %@", log.text);
    }];
    
    NSString *account = CHAT_ACCOUNT_ID;

    NSError *error = nil;
    
    [[LPMessagingSDK instance] initialize:account monitoringInitParams:nil error:&error];
    
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
-(void) setupBranding {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LivePerson" ofType:@"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    LPConfig *configurations = [LPConfig defaultConfiguration];

    configurations.remoteUserBubbleBackgroundColor = [dict colorForKey:@"remoteUserBubbleBackgroundColor"];
    configurations.remoteUserBubbleBorderColor = [dict colorForKey:@"remoteUserBubbleBorderColor"];
    configurations.remoteUserBubbleLinkColor = [dict colorForKey:@"remoteUserBubbleLinkColor"];
    configurations.remoteUserBubbleTextColor =  [dict colorForKey:@"remoteUserBubbleTextColor"];
    
    configurations.remoteUserBubbleBorderWidth = [dict doubleForKey:@"remoteUserBubbleBorderWidth"];
    configurations.remoteUserBubbleTimestampColor = [dict colorForKey:@"remoteUserBubbleTimestampColor"];
    configurations.remoteUserTypingTintColor = [UIColor grayColor];//[dict colorForKey:@"remoteUserTypingTintColor"];
    configurations.remoteUserBubbleLongPressOverlayColor = [dict colorForKey:@"remoteUserBubbleLongPressOverlayColor"];
    configurations.remoteUserBubbleLongPressOverlayAlpha = [dict floatForKey:@"remoteUserBubbleLongPressOverlayAlpha"];
    configurations.remoteUserBubbleTopLeftCornerRadius = [dict floatForKey:@"remoteUserBubbleTopLeftCornerRadius"];
    configurations.remoteUserBubbleTopRightCornerRadius = [dict floatForKey:@"remoteUserBubbleTopRightCornerRadius"];
    configurations.remoteUserBubbleBottomLeftCornerRadius = [dict floatForKey:@"remoteUserBubbleBottomLeftCornerRadius"];
    configurations.remoteUserBubbleBottomRightCornerRadius = [dict floatForKey:@"remoteUserBubbleBottomRightCornerRadius"];
    
    configurations.userBubbleBackgroundColor = [dict colorForKey:@"userBubbleBackgroundColor"];
    configurations.userBubbleBorderColor = [dict colorForKey:@"userBubbleBorderColor"];
    configurations.userBubbleLinkColor = [dict colorForKey:@"userBubbleLinkColor"];
    configurations.userBubbleTextColor = [dict colorForKey:@"userBubbleTextColor"];
    configurations.userBubbleBorderWidth = [dict doubleForKey:@"userBubbleBorderWidth"];
    configurations.userBubbleTimestampColor =  [dict colorForKey:@"userBubbleTimestampColor"];
    configurations.userBubbleSendStatusTextColor = [dict colorForKey:@"userBubbleSendStatusTextColor"];
    configurations.userBubbleErrorTextColor = [dict colorForKey:@"userBubbleErrorTextColor"];
    configurations.userBubbleErrorBorderColor = [dict colorForKey:@"userBubbleErrorBorderColor"];
    configurations.userBubbleLongPressOverlayColor = [dict colorForKey:@"userBubbleLongPressOverlayColor"];
    configurations.userBubbleLongPressOverlayAlpha = [dict floatForKey:@"userBubbleLongPressOverlayAlpha"];
    configurations.userBubbleTopLeftCornerRadius = [dict floatForKey:@"userBubbleTopLeftCornerRadius"];
    configurations.userBubbleTopRightCornerRadius = [dict floatForKey:@"userBubbleTopRightCornerRadius"];
    configurations.userBubbleBottomLeftCornerRadius = [dict floatForKey:@"userBubbleBottomLeftCornerRadius"];
    configurations.userBubbleBottomRightCornerRadius = [dict floatForKey:@"userBubbleBottomRightCornerRadius"];
    configurations.bubbleEmailLinksRegex = nil;
    configurations.bubbleUrlLinksRegex = nil;
    configurations.bubblePhoneLinksRegex = nil;
    configurations.bubbleTopPadding = [dict floatForKey:@"bubbleTopPadding"];
    configurations.bubbleBottomPadding = [dict floatForKey:@"bubbleBottomPadding"];
    configurations.bubbleLeadingPadding = [dict floatForKey:@"bubbleLeadingPadding"];
    configurations.bubbleTrailingPadding = [dict floatForKey:@"bubbleTrailingPadding"];
    configurations.bubbleTimestampTopPadding = [dict floatForKey:@"bubbleTimestampTopPadding"];
    configurations.bubbleTimestampBottomPadding = [dict floatForKey:@"bubbleTimestampBottomPadding"];
    configurations.enableLinkPreview = [dict boolForKey:@"enableLinkPreview"];
    
    configurations.linkPreviewBackgroundColor = [dict colorForKey:@"linkPreviewBackgroundColor"];
    configurations.linkPreviewTitleTextColor = [dict colorForKey:@"linkPreviewTitleTextColor"];
    configurations.linkPreviewDescriptionTextColor = [dict colorForKey:@"linkPreviewDescriptionTextColor"];
    configurations.linkPreviewSiteNameTextColor = [dict colorForKey:@"linkPreviewSiteNameTextColor"];
    configurations.linkPreviewBorderWidth = [dict doubleForKey:@"linkPreviewBorderWidth"];
    configurations.urlRealTimePreviewBackgroundColor = [dict colorForKey:@"urlRealTimePreviewBackgroundColor"];
    configurations.urlRealTimePreviewBorderColor = [dict colorForKey:@"urlRealTimePreviewBorderColor"];
    configurations.urlRealTimePreviewBorderWidth = [dict floatForKey:@"urlRealTimePreviewBorderWidth"];
    configurations.urlRealTimePreviewTitleTextColor = [dict colorForKey:@"urlRealTimePreviewTitleTextColor"];
    configurations.urlRealTimePreviewDescriptionTextColor = [dict colorForKey:@"urlRealTimePreviewDescriptionTextColor"];
    configurations.useNonOGTagsForLinkPreview = [dict boolForKey:@"useNonOGTagsForLinkPreview"];
//    configurations.enablePhotoSharing = [dict boolForKey:@"enablePhotoSharing"];
    configurations.maxNumberOfSavedFilesOnDisk = [dict integerForKey:@"maxNumberOfSavedFilesOnDisk"];
    
    configurations.photosharingMenuBackgroundColor = [dict colorForKey:@"photosharingMenuBackgroundColor"];
    configurations.photosharingMenuButtonsBackgroundColor = [UIColor grayColor];
    configurations.photosharingMenuButtonsTintColor = [dict colorForKey:@"photosharingMenuButtonsTintColor"];
    configurations.photosharingMenuButtonsTextColor = [dict colorForKey:@"photosharingMenuButtonsTextColor"];
    configurations.cameraButtonEnabledColor = [dict colorForKey:@"cameraButtonEnabledColor"];
    configurations.cameraButtonDisabledColor = [dict colorForKey:@"cameraButtonDisabledColor"];
     configurations.fileCellLoaderFillColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    configurations.fileCellLoaderRingProgressColor = [dict colorForKey:@"fileCellLoaderRingProgressColor"];
    configurations.fileCellLoaderRingBackgroundColor = [dict colorForKey:@"fileCellLoaderRingBackgroundColor"];
    
    configurations.sendButtonDisabledColor = [dict colorForKey:@"sendButtonDisabledColor"];
    configurations.sendButtonEnabledColor = [dict colorForKey:@"sendButtonEnabledColor"];
    configurations.isSendMessageButtonInTextMode = TRUE;
    configurations.systemBubbleTextColor = [dict colorForKey:@"systemBubbleTextColor"];
    // configurations.customButtonIconName = nil;
    configurations.checkmarkVisibility = CheckmarksStateAll;
    configurations.checkmarkSentColor = [dict colorForKey:@"checkmarkSentColor"];
    configurations.checkmarkDistributedColor = [dict colorForKey:@"checkmarkDistributedColor"];
    configurations.checkmarkReadColor = [dict colorForKey:@"checkmarkReadColor"];
    configurations.isReadReceiptTextMode = [dict boolForKey:@"isReadReceiptTextMode"];
    configurations.csatSubmitButtonCornerRadius = [dict doubleForKey:@"csatSubmitButtonCornerRadius"];
    configurations.csatSubmitButtonBackgroundColor = [dict colorForKey:@"csatSubmitButtonBackgroundColor"];
    configurations.csatSubmitButtonTextColor = [dict colorForKey:@"csatSubmitButtonTextColor"];
    configurations.csatRatingButtonSelectedColor = [dict colorForKey:@"csatRatingButtonSelectedColor"];
    //configurations.csatResolutionButtonSelectedColor = [dict colorForKey:@""](@"#D20A3B");
    
    configurations.csatAllTitlesTextColor = [UIColor blackColor];
    configurations.csatResolutionHidden = [dict boolForKey:@"csatResolutionHidden"];
    configurations.csatAgentViewHidden = [dict boolForKey:@"csatAgentViewHidden"];
    configurations.csatThankYouScreenHidden = [dict boolForKey:@"csatThankYouScreenHidden"];
    configurations.csatNavigationBackgroundColor = [dict colorForKey:@"csatNavigationBackgroundColor"];
    configurations.csatNavigationTitleColor = [dict colorForKey:@"csatNavigationTitleColor"];
    configurations.csatSkipButtonColor = [UIColor blackColor];
//    configurations.csatUIStatusBarStyleLightContent = [dict boolForKey:@"csatUIStatusBarStyleLightContent"];
    configurations.csatShowSurveyView = [dict boolForKey:@"csatShowSurveyView"];
    configurations.csatSurveyExpirationInMinutes = [dict integerForKey:@"csatSurveyExpirationInMinutes"];
    configurations.maxPreviousConversationToPresent = [dict integerForKey:@"maxPreviousConversationToPresent"];
    configurations.deleteClosedConversationOlderThanMonths = [dict integerForKey:@"deleteClosedConversationOlderThanMonths"];
    configurations.sendingMessageTimeoutInMinutes = [dict integerForKey:@"sendingMessageTimeoutInMinutes"];
    configurations.enableConversationSeparatorTextMessage = [dict boolForKey:@"enableConversationSeparatorTextMessage"];
    configurations.enableConversationSeparatorTextMessage = [dict boolForKey:@"enableConversationSeparatorTextMessage"];
    configurations.enableConversationSeparatorLine = [dict boolForKey:@"enableConversationSeparatorLine"];
    configurations.conversationSeparatorTextColor = [dict colorForKey:@"conversationSeparatorTextColor"];
    configurations.conversationSeparatorFontSize = UIFontTextStyleCaption1;
    configurations.conversationSeparatorTopPadding = [dict floatForKey:@"conversationSeparatorTopPadding"];
    configurations.conversationSeparatorBottomPadding = [dict floatForKey:@"conversationSeparatorTopPadding"];
    configurations.enableVibrationOnMessageFromRemoteUser = [dict boolForKey:@"enableVibrationOnMessageFromRemoteUser"];
    //configurations.scrollToBottomButtonBackgroundColor = UIColor.white
    //configurations.scrollToBottomButtonMessagePreviewTextColor = UIColor.white
    //configurations.scrollToBottomButtonBadgeBackgroundColor = UIColor.white
    //configurations.scrollToBottomButtonBadgeTextColor = UIColor.white
    //configurations.scrollToBottomButtonArrowColor = UIColor.white
    //configurations.unreadMessagesDividerBackgroundColor = UIColor.white
    //configurations.unreadMessagesDividerTextColor = UIColor.white
    configurations.scrollToBottomButtonEnabled = [dict boolForKey:@"scrollToBottomButtonEnabled"];
    configurations.scrollToBottomButtonMessagePreviewEnabled = [dict boolForKey:@"scrollToBottomButtonMessagePreviewEnabled"];
    configurations.unreadMessagesDividerEnabled = [dict boolForKey:@"unreadMessagesDividerEnabled"];
    //configurations.unreadMessagesCornersRadius = 1.1;
    //configurations.scrollToBottomButtonCornerRadius = 1.1;
    // configurations.scrollToBottomButtonBadgeCornerRadius = 1.1;
    
    configurations.country = nil;
    configurations.language = LPLanguageDevice;
    configurations.brandName = @"CHAT";
    configurations.conversationBackgroundColor = [dict colorForKey:@"conversationBackgroundColor"];
//    configurations.customFontNameConversationFeed = FONT_MarkForMC_REGULAR;
//    configurations.customFontNameNonConversationFeed = FONT_MarkForMC_REGULAR;
    configurations.customRefreshControllerImagesArray = nil;
    configurations.customRefreshControllerAnimationSpeed = [dict floatForKey:@"customRefreshControllerAnimationSpeed"];
    configurations.dateSeparatorTitleBackgroundColor = [dict colorForKey:@"dateSeparatorTitleBackgroundColor"];
    configurations.dateSeparatorTextColor =  [dict colorForKey:@"dateSeparatorTextColor"];
    configurations.dateSeparatorLineBackgroundColor = [dict colorForKey:@"dateSeparatorLineBackgroundColor"];
    configurations.dateSeparatorBackgroundColor = [dict colorForKey:@"dateSeparatorBackgroundColor"];
    configurations.dateSeparatorFontSize = UIFontTextStyleFootnote;
//    configurations.customFontNameDateSeparator = FONT_MarkForMC_REGULAR;
    configurations.dateSeparatorTopPadding = [dict floatForKey:@"dateSeparatorTopPadding"];
    configurations.dateSeparatorBottomPadding = [dict floatForKey:@"dateSeparatorBottomPadding"];
    configurations.inputTextViewContainerBackgroundColor = [dict colorForKey:@"inputTextViewContainerBackgroundColor"];
    configurations.inputTextViewTopBorderColor = [dict colorForKey:@"inputTextViewTopBorderColor"];
    configurations.retrieveAssignedAgentFromLastClosedConversation = [dict boolForKey:@"retrieveAssignedAgentFromLastClosedConversation"];
    configurations.notificationShowDurationInSeconds = [dict doubleForKey:@"notificationShowDurationInSeconds"];
    configurations.ttrShowShiftBanner = [dict boolForKey:@"ttrShowShiftBanner"];
    configurations.ttrFirstTimeDelay = [dict doubleForKey:@"ttrFirstTimeDelay"];
    configurations.ttrShouldShowTimestamp = [dict boolForKey:@"ttrShouldShowTimestamp"];
    configurations.ttrShowFrequencyInSeconds = [dict integerForKey:@"ttrShowFrequencyInSeconds"];

    configurations.showOffHoursBanner = [dict boolForKey:@"showOffHoursBanner"];
    configurations.ttrBannerBackgroundColor =  [dict colorForKey:@"ttrBannerBackgroundColor"];
    configurations.ttrBannerTextColor = [dict colorForKey:@"ttrBannerTextColor"];
//    configurations.ttrBannerOpacityAlpha = [dict floatForKey:@"ttrBannerOpacityAlpha"];
    configurations.offHoursTimeZoneName = @" ";
    configurations.lpDateFormat = nil;
    configurations.lpTimeFormat = nil;
    configurations.lpDateTimeFormat = nil;
    configurations.toastNotificationsEnabled = [dict boolForKey:@"toastNotificationsEnabled"];
    
    //configurations.csdsDomain = [NSString stringWithFormat:@"https://adminlogin.liveperson.net/csdr/account/%@/service/baseURL.json?version=1.0", CHAT_ACCOUNT_ID];
    configurations.remoteUserAvatarBackgroundColor = [dict colorForKey:@"remoteUserAvatarBackgroundColor"];
    configurations.remoteUserAvatarLeadingPadding = [dict floatForKey:@"remoteUserAvatarLeadingPadding"];
    configurations.remoteUserAvatarTrailingPadding = [dict floatForKey:@"remoteUserAvatarTrailingPadding"];
    configurations.remoteUserAvatarIconColor  = [dict colorForKey:@"remoteUserAvatarIconColor"];
    configurations.remoteUserDefaultAvatarImage  = nil;
    configurations.brandAvatarImage = nil;
    configurations.csatAgentAvatarBackgroundColor = [dict colorForKey:@"csatAgentAvatarBackgroundColor"];
    configurations.csatAgentAvatarIconColor = [dict colorForKey:@"csatAgentAvatarIconColor"];
    configurations.enableClientOnlyMasking = [dict boolForKey:@"enableClientOnlyMasking"];
    configurations.enableRealTimeMasking = [dict boolForKey:@"enableRealTimeMasking"];
    configurations.clientOnlyMaskingRegex = @" ";
    configurations.realTimeMaskingRegex = @" ";
    
    configurations.conversationNavigationBackgroundColor = [dict colorForKey:@"conversationNavigationBackgroundColor"];
    configurations.conversationNavigationTitleColor = [dict colorForKey:@"conversationNavigationTitleColor"];
    configurations.conversationStatusBarStyle = UIStatusBarStyleLightContent;
    configurations.secureFormBackButtonColor = [dict colorForKey:@"secureFormBackButtonColor"];
//    configurations.secureFormUIStatusBarStyleLightContent = [dict boolForKey:@"secureFormUIStatusBarStyleLightContent"];
    configurations.secureFormNavigationBackgroundColor = [dict colorForKey:@"secureFormNavigationBackgroundColor"];
    configurations.secureFormNavigationTitleColor = [dict colorForKey:@"secureFormNavigationTitleColor"];
    configurations.secureFormBubbleBackgroundColor = [UIColor whiteColor];
    configurations.secureFormBubbleBorderColor = [dict colorForKey:@"secureFormBubbleBorderColor"];
    configurations.secureFormBubbleBorderWidth = [dict doubleForKey:@"secureFormBubbleBorderWidth"];
    configurations.secureFormBubbleTitleColor = [dict colorForKey:@"secureFormBubbleTitleColor"];
    configurations.secureFormBubbleDescriptionColor = [dict colorForKey:@"secureFormBubbleDescriptionColor"];
    configurations.secureFormBubbleFillFormButtonTextColor = [dict colorForKey:@"secureFormBubbleFillFormButtonTextColor"];
    configurations.secureFormBubbleFillFormButtonBackgroundColor = [dict colorForKey:@"secureFormBubbleFillFormButtonBackgroundColor"];
    configurations.secureFormBubbleFormImageTintColor = [dict colorForKey:@"secureFormBubbleFormImageTintColor"];
//    configurations.secureFormCustomFontName = FONT_MarkForMC_REGULAR;
    configurations.secureFormHideLogo = [dict boolForKey:@"secureFormHideLogo"];
    configurations.secureFormBubbleLoadingIndicatorColor = [dict colorForKey:@"secureFormBubbleLoadingIndicatorColor"];
//    configurations.enableStrucutredContent = [dict boolForKey:@"enableStrucutredContent"];
    configurations.structuredContentBubbleBorderWidth = [dict floatForKey:@"structuredContentBubbleBorderWidth"];
    configurations.structuredContentBubbleBorderColor = [UIColor clearColor];
    configurations.structuredContentMapLatitudeDeltaDeltaSpan = [dict doubleForKey:@"structuredContentMapLatitudeDeltaDeltaSpan"];
    configurations.structuredContentMapLongitudeDeltaSpan = [dict doubleForKey:@"structuredContentMapLongitudeDeltaSpan"];
    configurations.connectionStatusConnectingBackgroundColor = [dict colorForKey:@"connectionStatusConnectingBackgroundColor"];
    configurations.connectionStatusConnectingTextColor = [dict colorForKey:@"connectionStatusConnectingTextColor"];
    configurations.connectionStatusFailedToConnectBackgroundColor = [dict colorForKey:@"connectionStatusFailedToConnectBackgroundColor"];
    configurations.connectionStatusFailedToConnectTextColor = [dict colorForKey:@"connectionStatusFailedToConnectTextColor"];
    configurations.controllerBubbleTextColor = [dict colorForKey:@"controllerBubbleTextColor"];
    configurations.announceAgentTyping = [dict boolForKey:@"announceAgentTyping"];
    configurations.conversationEmptyStateTextColor = [UIColor whiteColor];

    [LPConfig printAllConfigurations];
    //UIImage *customButtonImage = [UIImage imageNamed:@"phone_icon"];
    //[LPConfig defaultConfiguration].customButtonImage = customButtonImage;
}

/**
 This method sets the user details such as first name, last name, profile image and phone number.
 */
- (void)setUserDetails {
    UserObject* userObject = (UserObject*)[[User current] convertToUserObjectWithClassName:NSStringFromClass([UserObject class]) andPreferencesClassName:NSStringFromClass([PreferenceObject class])];
    NSString* account = @"";
    
    NSString* firstName = @"Hai";
    NSString* lastName = @"Nguyen";
    NSString* email = @"hai.nguyenv@s3corp.com.vn";
    NSString* phone = @"84973116911";
    
    LPUser *user = [[LPUser alloc] initWithFirstName:firstName lastName:lastName nickName:@"" uid:nil profileImageURL:@"" phoneNumber:[NSString stringWithFormat:@"%@|%@",phone,email] employeeID:nil];
    [[LPMessagingSDK instance] setUserProfile:user brandID:account];
    
}



#pragma mark - LPMessagingSDKDelegate

/**
 This delegate method is required.
 It is called when authentication process fails
 */
- (void)LPMessagingSDKAuthenticationFailed:(NSError *)error {
    NSLog(@"Error: %@",error);
}

/**
 This delegate method is required.
 It is called when the SDK version you're using is obselete and needs an update.
 */
- (void)LPMessagingSDKObseleteVersion:(NSError *)error {
    NSLog(@"Error: %@",error);
}

/**
 This delegate method is optional.
 It is called each time the SDK receives info about the agent on the other side.
 
 Example:
 You can use this data to show the agent details on your navigation bar (in view controller mode)
 */

/**
 This delegate method is optional.
 It is called each time the SDK menu is opened/closed.
 */
- (void)LPMessagingSDKActionsMenuToggled:(BOOL)toggled {
    
}

/**
 This delegate method is optional.
 It is called each time the agent typing state changes.
 */
- (void)LPMessagingSDKAgentIsTypingStateChanged:(BOOL)isTyping {
    
}

/**
 This delegate method is optional.
 It is called after the customer satisfaction page is submitted with a score.
 */
- (void)LPMessagingSDKCSATScoreSubmissionDidFinish:(NSString *)accountID rating:(NSInteger)rating {
    
}

/**
 This delegate method is optional.
 If you set a custom button, this method will be called when the custom button is clicked.
 */
- (void)LPMessagingSDKCustomButtonTapped {
    
}

/**
 This delegate method is optional.
 It is called whenever an event log is received.
 */
- (void)LPMessagingSDKDidReceiveEventLog:(NSString *)eventLog {
    
}

/**
 This delegate method is optional.
 It is called when the SDK has connections issues.
 */
- (void)LPMessagingSDKHasConnectionError:(NSString *)error {
    
}

/**
 This delegate method is required.
 It is called when the token which used for authentication is expired
 */
- (void)LPMessagingSDKTokenExpired:(NSString *)brandID {
    
}

/**
 This delegate method is required.
 It lets you know if there is an error with the SDK and what the error is
 */
- (void)LPMessagingSDKError:(NSError *)error {
    
}

/**
 This delegate method is optional.
 It is called when a new conversation has started, from the agent or from the consumer side.
 */
- (void)LPMessagingSDKConversationStarted:(NSString *)conversationID {
    
}

/**
 This delegate method is optional.
 It is called when a conversation has ended, from the agent or from the consumer side.
 */
- (void)LPMessagingSDKConversationEnded:(NSString *)conversationID {
//    [self.conversationViewController dismissAlert];
}

/**
 This delegate method is optional.
 It is called each time connection state changed for a brand with a flag whenever connection is ready.
 Ready means that all conversations and messages were synced with the server.
 */
- (void)LPMessagingSDKConnectionStateChanged:(BOOL)isReady brandID:(NSString *)brandID {
    
}

/**
 This delegate method is optional.
 It is called when the customer satisfaction survey is dismissed after the user has submitted the survey/
 */
- (void)LPMessagingSDKConversationCSATDismissedOnSubmittion:(NSString *)conversationID {
    
}

/**
 This delegate method is optional.
 It is called when the conversation view controller removed from its container view controller or window.
 */
- (void)LPMessagingSDKConversationViewControllerDidDismiss {
    
}

/**
 This delegate method is optional.
 It is called when the user tapped on the agent’s avatar in the conversation and also in the navigation bar within window mode.
 */
- (void)LPMessagingSDKAgentAvatarTapped:(LPUser *)agent {
    
}

/**
 This delegate method is optional.
 It is called when the Conversation CSAT did load
 */
- (void)LPMessagingSDKConversationCSATDidLoad:(NSString *)conversationID {
    NSLog(@"CSAT: %@",conversationID);
}

/**
 This delegate method is optional.
 It is called when the Conversation CSAT skipped by the consumer
 */
- (void)LPMessagingSDKConversationCSATSkipped:(NSString *)conversationID {
    
}

/**
 This delegate method is optional.
 It is called when the user is opening photo sharing gallery/camera and the persmissions denied
 */
- (void)LPMessagingSDKUserDeniedPermission:(enum LPPermissionTypes)permissionType {
    
}

@end
