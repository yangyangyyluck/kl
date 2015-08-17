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

#import "YOSSendMessagesViewController.h"

#import "YOSUserInfoModel.h"

#import "YOSEaseMobManager.h"

#import <AGEmojiKeyboard/AGEmojiKeyboardView.h>
#import "ZWEmoji.h"
#import "IQKeyboardManager.h"
#import "YOSWidget.h"
#import "EMMessage+YOSAdditions.h"

const static NSUInteger kCountOfLoadMessages = 20;

@interface YOSSendMessagesViewController()<AGEmojiKeyboardViewDelegate, AGEmojiKeyboardViewDataSource>

/** 最近的messageId，用于加载更多 */
@property (nonatomic, copy) NSString *lastMessageId;

/** 用weak是因为存在YOSEaseMobManager里 */
@property (nonatomic, weak) EMConversation *conversation;

@property (nonatomic, strong) YOSUserInfoModel *meUserInfoModel;

/** 隐藏在VC视图后面，专门用来带出emoji键盘 */
@property (nonatomic, strong) UITextView *emojiTextView;

@property (nonatomic, assign) NSRange currentTextViewSelectedRange;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIButton *emojiBtn;

@end


@implementation YOSSendMessagesViewController

#pragma mark - View lifecycle

/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    self.meUserInfoModel = [YOSWidget getCurrentUserInfoModel];
    
    // 创建一个会话
    
    self.title = self.otherUserInfoModel.nickname;
    
    self.conversation = [[YOSEaseMobManager sharedManager] conversationForChatter:self.otherUserInfoModel.hx_user];
    
    BOOL st = [self.conversation markAllMessagesAsRead:YES];
    
    NSLog(@"sttt is %zi",st);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationResetUnReadMessage object:nil userInfo:@{@"userInfoModel":self.otherUserInfoModel}];
    
    /**
     *  You MUST set your senderId and display name
     */
    
    self.senderId = self.meUserInfoModel.hx_user;
    self.senderDisplayName = self.meUserInfoModel.nickname;
    
    /**
     *  Load up our fake data for the demo
     */
    
    // 默认加载20条聊天信息
    
    NSArray *messages = [self.conversation loadNumbersOfMessages:kCountOfLoadMessages before:[NSDate date].timeIntervalSince1970 * 1000];
    
    NSLog(@"messages is %@", messages);
    
    if (!messages) {
        messages = [NSArray new];
    }
    
    if (messages.count) {
        self.lastMessageId = ((EMMessage *)messages[0]).messageId;
    }
    
    self.demoData = [[YOSModelData alloc] initWithMeUserInfoModel:self.meUserInfoModel otherUserInfoModel:self.otherUserInfoModel messages:messages];
    
    
    /**
     *  You can set custom avatar sizes
     */

    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(30, 30);

    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(30, 30);
    
    
    self.showLoadEarlierMessagesHeader = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(receiveMessagePressed:)];

    /**
     *  Register custom menu actions for cells.
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    [UIMenuController sharedMenuController].menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];

    // setup left right buttons
    self.emojiBtn = [UIButton new];
    [self.emojiBtn setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
    [self.emojiBtn sizeToFit];
    self.inputToolbar.contentView.rightBarButtonItem = self.emojiBtn;
    
    self.moreBtn = [UIButton new];
    [self.moreBtn setImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [self.emojiBtn sizeToFit];
    self.inputToolbar.contentView.leftBarButtonItem = self.moreBtn;
    self.inputToolbar.maximumHeight = 150;
    
    // setup emoji keyboard
    self.emojiTextView = [UITextView new];
    [self.view addSubview:self.emojiTextView];
    self.emojiTextView.inputView = self.inputToolbar;
    
    AGEmojiKeyboardView *emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216) dataSource:self];
    emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    emojiKeyboardView.delegate = self;
    self.emojiTextView.inputView = emojiKeyboardView;
    emojiKeyboardView.segmentsBar.hidden = YES;
    emojiKeyboardView.backgroundColor = YOSRGB(248, 248, 248);
    emojiKeyboardView.pageControl.pageIndicatorTintColor = YOSRGB(210, 210, 210);
    emojiKeyboardView.pageControl.currentPageIndicatorTintColor = YOSColorMainRed;
    
    self.inputToolbar.contentView.textView.returnKeyType = UIReturnKeySend;
    self.inputToolbar.contentView.textView.enablesReturnKeyAutomatically = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:YOSNotificationReceiveMessage object:nil];
    
    /**
     *  Customize your toolbar buttons
     *
     *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
     *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
     */

    /**
     *  Set a maximum height for the input toolbar
     *
     *  self.inputToolbar.maximumHeight = 150;
     */
    
}

- (void)dealloc {
    NSLog(@"\r\n\r\n%@ dealloc\r\n\r\n", NSStringFromClass([self class]));
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.delegateModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                              target:self
                                                                                              action:@selector(closePressed:)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
//    self.collectionView.collectionViewLayout.springinessEnabled = [NSUserDefaults springinessSetting];
    
//    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}



#pragma mark - Testing

- (void)pushMainViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nc = [sb instantiateInitialViewController];
    [self.navigationController pushViewController:nc.topViewController animated:YES];
}


#pragma mark - Actions

- (void)receiveMessagePressed:(UIBarButtonItem *)sender
{
    /**
     *  DEMO ONLY
     *
     *  The following is simply to simulate received messages for the demo.
     *  Do not actually do this.
     */
    
    
    /**
     *  Show the typing indicator to be shown
     */
    self.showTypingIndicator = !self.showTypingIndicator;
    
    /**
     *  Scroll to actually view the indicator
     */
    [self scrollToBottomAnimated:YES];
    
    /**
     *  Copy last sent message, this will be the new "received" message
     */
    JSQMessage *copyMessage = [[self.demoData.messages lastObject] copy];
    
    if (!copyMessage) {
        copyMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdJobs
                                          displayName:kJSQDemoAvatarDisplayNameJobs
                                                 text:@"First received!"];
    }
    
    /**
     *  Allow typing indicator to show
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableArray *userIds = [[self.demoData.users allKeys] mutableCopy];
        [userIds removeObject:self.senderId];
        NSString *randomUserId = userIds[arc4random_uniform((int)[userIds count])];
        
        JSQMessage *newMessage = nil;
        id<JSQMessageMediaData> newMediaData = nil;
        id newMediaAttachmentCopy = nil;
        
        if (copyMessage.isMediaMessage) {
            /**
             *  Last message was a media message
             */
            id<JSQMessageMediaData> copyMediaData = copyMessage.media;
            
            if ([copyMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
                JSQPhotoMediaItem *photoItemCopy = [((JSQPhotoMediaItem *)copyMediaData) copy];
                photoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [UIImage imageWithCGImage:photoItemCopy.image.CGImage];
                
                /**
                 *  Set image to nil to simulate "downloading" the image
                 *  and show the placeholder view
                 */
                photoItemCopy.image = nil;
                
                newMediaData = photoItemCopy;
            }
            else if ([copyMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
                JSQLocationMediaItem *locationItemCopy = [((JSQLocationMediaItem *)copyMediaData) copy];
                locationItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [locationItemCopy.location copy];
                
                /**
                 *  Set location to nil to simulate "downloading" the location data
                 */
                locationItemCopy.location = nil;
                
                newMediaData = locationItemCopy;
            }
            else if ([copyMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
                JSQVideoMediaItem *videoItemCopy = [((JSQVideoMediaItem *)copyMediaData) copy];
                videoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [videoItemCopy.fileURL copy];
                
                /**
                 *  Reset video item to simulate "downloading" the video
                 */
                videoItemCopy.fileURL = nil;
                videoItemCopy.isReadyToPlay = NO;
                
                newMediaData = videoItemCopy;
            }
            else {
                NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
            }
            
            newMessage = [JSQMessage messageWithSenderId:randomUserId
                                             displayName:self.demoData.users[randomUserId]
                                                   media:newMediaData];
        }
        else {
            /**
             *  Last message was a text message
             */
            newMessage = [JSQMessage messageWithSenderId:randomUserId
                                             displayName:self.demoData.users[randomUserId]
                                                    text:copyMessage.text];
        }
        
        /**
         *  Upon receiving a message, you should:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishReceivingMessage`
         */
        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
        [self.demoData.messages addObject:newMessage];
        [self finishReceivingMessageAnimated:YES];
        
        
        if (newMessage.isMediaMessage) {
            /**
             *  Simulate "downloading" media
             */
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /**
                 *  Media is "finished downloading", re-display visible cells
                 *
                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
                 *
                 *  Reload the specific item, or simply call `reloadData`
                 */
                
                if ([newMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
                    ((JSQPhotoMediaItem *)newMediaData).image = newMediaAttachmentCopy;
                    [self.collectionView reloadData];
                }
                else if ([newMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
                    [((JSQLocationMediaItem *)newMediaData)setLocation:newMediaAttachmentCopy withCompletionHandler:^{
                        [self.collectionView reloadData];
                    }];
                }
                else if ([newMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
                    ((JSQVideoMediaItem *)newMediaData).fileURL = newMediaAttachmentCopy;
                    ((JSQVideoMediaItem *)newMediaData).isReadyToPlay = YES;
                    [self.collectionView reloadData];
                }
                else {
                    NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
                }
                
            });
        }
        
    });
}

- (void)closePressed:(UIBarButtonItem *)sender
{
    [self.delegateModal didDismissYOSSendMessagesViewController:self];
}




#pragma mark - JSQMessagesViewController method overrides
#pragma mark - ###### 发送消息 ######
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    
    [[YOSEaseMobManager sharedManager] sendMessageToUser:self.otherUserInfoModel.hx_user message:text];
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [self.demoData.messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];
}

#pragma mark - 点击 more emoji 按钮

- (void)didPressAccessoryButton:(UIButton *)sender
{
    NSLog(@"%s", __func__);
    // tapped left button
    if (sender == self.moreBtn) {
        NSLog(@"tapped more btn");
    } else {    // tapped right button
        
         NSLog(@"tapped emoji btn");
        
        if ([self.emojiTextView isFirstResponder]) {
            [self.inputToolbar.contentView.textView becomeFirstResponder];
        } else {
            // 记录selectedRange
            self.currentTextViewSelectedRange = self.inputToolbar.contentView.textView.selectedRange;
            
            [self.emojiTextView becomeFirstResponder];
        }
        
    }
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
//                                                       delegate:self
//                                              cancelButtonTitle:@"Cancel"
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
//    
//    [sheet showFromToolbar:self.inputToolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            [self.demoData addPhotoMediaMessage];
            break;
            
        case 1:
        {
            __weak UICollectionView *weakView = self.collectionView;
            
            [self.demoData addLocationMediaMessageCompletion:^{
                [weakView reloadData];
            }];
        }
            break;
            
        case 2:
            [self.demoData addVideoMediaMessage];
            break;
    }
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self finishSendingMessageAnimated:YES];
}



#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.demoData.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.demoData.outgoingBubbleImageData;
    }
    
    return self.demoData.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
//        if (![NSUserDefaults outgoingAvatarSetting]) {
//            return nil;
//        }
    }
    else {
//        if (![NSUserDefaults incomingAvatarSetting]) {
//            return nil;
//        }
    }
    
    
    return [self.demoData.avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.demoData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}



#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }

    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }

    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);

    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
                               message:nil
                              delegate:nil
                     cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.demoData.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
    NSArray *moreMessages = [self.conversation loadNumbersOfMessages:kCountOfLoadMessages withMessageId:self.lastMessageId];
    
    if (!moreMessages || !moreMessages.count) {
        return;
    }
    
    NSMutableArray *jsqMessages = [NSMutableArray array];
    [moreMessages enumerateObjectsUsingBlock:^(EMMessage *obj, NSUInteger idx, BOOL *stop) {
        [jsqMessages addObject:[obj transferToJSQMessageWithMeUserInfo:self.meUserInfoModel otherUserInfo:self.otherUserInfoModel]];
    }];
    
    self.lastMessageId = ((EMMessage *)moreMessages[0]).messageId;
    
    NSUInteger newMessageCount = jsqMessages.count;
    
    [jsqMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.demoData.messages insertObject:obj atIndex:0];
    }];
    
    [self.collectionView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:newMessageCount inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:newMessageCount inSection:0];
//        
//        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
//    });
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
    
    NSLog(@"row: %zi len: %zi", indexPath.row, indexPath.section);
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
    
    [self.view endEditing:YES];
}

#pragma mark - AGEmojiKeyboardViewDataSource

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    
    return [UIImage imageNamed:@"chatBar_face"];
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {

    return [UIImage imageNamed:@"chatBar_more"];
}

- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
  
    return [UIImage imageNamed:@"faceDelete"];
}

- (AGEmojiKeyboardViewCategoryImage)defaultCategoryForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView {
    return AGEmojiKeyboardViewCategoryImageFace;
}

#pragma mark - AGEmojiKeyboardViewDelegate

- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
    UITextView *textView = self.inputToolbar.contentView.textView;
    
    NSMutableString *mStr = [textView.text mutableCopy];
    
    NSLog(@"range is %@", NSStringFromRange(self.currentTextViewSelectedRange));
    
    if (self.currentTextViewSelectedRange.length) {
        [mStr replaceCharactersInRange:self.currentTextViewSelectedRange withString:emoji];
    } else {
        [mStr insertString:emoji atIndex:self.currentTextViewSelectedRange.location];
    }
    
    self.currentTextViewSelectedRange = NSMakeRange(self.currentTextViewSelectedRange.location + emoji.length, 0);
    
    textView.text = mStr;
    
}

- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView {
    NSLog(@"%s", __func__);
    
    UITextView *textView = self.inputToolbar.contentView.textView;
    
    NSLog(@"-- range %@", NSStringFromRange(textView.selectedRange));
    
    NSMutableString *chatText = [textView.text mutableCopy];
    
    NSRange range = self.currentTextViewSelectedRange;
    NSMutableString *mStr = [textView.text mutableCopy];
    NSRange resultRange;
    
    if (range.location == 0) {
        return;
    }
    
    if (range.length) {
        [mStr replaceCharactersInRange:range withString:@""];
        textView.text = mStr;
        resultRange = NSMakeRange(range.location, 0);
    } else {
        
        if (range.location >= 2) {
            NSString *subStr = [chatText substringWithRange:NSMakeRange(range.location - 2, 2)];
            
            if ([subStr zw_isEmoji]) {
                [mStr replaceCharactersInRange:NSMakeRange(range.location - 2, 2) withString:@""];
                resultRange = NSMakeRange(range.location - 2, 0);
            } else {
                [mStr replaceCharactersInRange:NSMakeRange(range.location - 1, 1) withString:@""];
                resultRange = NSMakeRange(range.location - 1, 0);
            }
            
            textView.text = mStr;
            
        } else if (range.location > 0) {
            [mStr replaceCharactersInRange:NSMakeRange(range.location - 1, 1) withString:@""];
            textView.text = mStr;
            resultRange = NSMakeRange(range.location - 1, 0);
        }
    }
    
    textView.selectedRange = resultRange;
    self.currentTextViewSelectedRange = resultRange;
    
}

#pragma mark - deal notification[receive message]

- (void)receiveMessage:(NSNotification *)noti {
    NSLog(@"%s", __func__);
    
    EMMessage *receiveMessage = noti.userInfo[@"message"];
    YOSUserInfoModel *currentUserInfo = [YOSWidget getCurrentUserInfoModel];
    
    YOSLog(@"\r\n\r\n\r\n message from %@ to %@", receiveMessage.from, receiveMessage.to);
    
    BOOL status0 = [receiveMessage.from isEqualToString:self.otherUserInfoModel.hx_user];
    BOOL status1 = [receiveMessage.to isEqualToString:currentUserInfo.hx_user];
    if (status0 && status1) {
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        
        BOOL st = [self.conversation markAllMessagesAsRead:YES];
        
        NSLog(@"sttt is %zi",st);
        
        JSQMessage *message = [receiveMessage transferToJSQMessageWithUserInfo:self.otherUserInfoModel];
        
        [self.demoData.messages addObject:message];
        
        [self finishSendingMessageAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:YOSNotificationResetUnReadMessage object:nil userInfo:@{@"userInfoModel":self.otherUserInfoModel}];
        });
    }
    
}

@end
