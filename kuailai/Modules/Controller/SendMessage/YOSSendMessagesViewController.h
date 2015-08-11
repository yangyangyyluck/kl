//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//


// Import all the things
#import "JSQMessages.h"

#import "YOSModelData.h"
#import "NSUserDefaults+DemoSettings.h"


@class YOSSendMessagesViewController, YOSUserInfoModel;

@protocol YOSSendMessagesViewControllerDelegate <NSObject>

- (void)didDismissYOSSendMessagesViewController:(YOSSendMessagesViewController *)vc;

@end




@interface YOSSendMessagesViewController : JSQMessagesViewController <UIActionSheetDelegate>

@property (nonatomic, strong) YOSUserInfoModel *otherUserInfoModel;

@property (weak, nonatomic) id<YOSSendMessagesViewControllerDelegate> delegateModal;

@property (strong, nonatomic) YOSModelData *demoData;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

@end
