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

#import "YOSModelData.h"

#import "NSUserDefaults+DemoSettings.h"
#import "SDImageCache.h"
#import "EMMessage+YOSAdditions.h"
#import "EMTextMessageBody.h"

@interface YOSModelData ()

@property (nonatomic, strong) NSMutableArray *emmessages;

@end


/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

@implementation YOSModelData

- (instancetype)initWithMeUserInfoModel:(YOSUserInfoModel *)me otherUserInfoModel:(YOSUserInfoModel *)other messages:(NSArray *)messages {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _meUserInfoModel = me;
    _otherUserInfoModel = other;
    
    // setter setup history messages
    self.emmessages = [messages mutableCopy];
    
    [self setupData];
    
    return self;
}

- (void)setupData {
    JSQMessagesAvatarImage *meImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[self imageWithURLString:self.meUserInfoModel.avatar]
                                                                                   diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    JSQMessagesAvatarImage *otherImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[self imageWithURLString:self.otherUserInfoModel.avatar]
                                                                                 diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    self.avatars = @{
                     self.meUserInfoModel.hx_user : meImage,
                     self.otherUserInfoModel.hx_user : otherImage,
                     };
    
    
    self.users = @{
                   self.meUserInfoModel.hx_user : self.meUserInfoModel.nickname,
                   self.otherUserInfoModel.hx_user : self.otherUserInfoModel.nickname,
                   };
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
}

- (void)loadFakeMessages
{
    /**
     *  Load some fake messages for demo.
     *
     *  You should have a mutable array or orderedSet, or something.
     */
    
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                        senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                     date:[NSDate distantPast]
                                                     text:@"Welcome to JSQMessages: A messaging UI framework for iOS."],
                     
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdWoz
                                        senderDisplayName:kJSQDemoAvatarDisplayNameWoz
                                                     date:[NSDate distantPast]
                                                     text:@"It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy."],
                     
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                        senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                     date:[NSDate distantPast]
                                                     text:@"It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com."],
                     
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdJobs
                                        senderDisplayName:kJSQDemoAvatarDisplayNameJobs
                                                     date:[NSDate date]
                                                     text:@"JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better."],
                     
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdCook
                                        senderDisplayName:kJSQDemoAvatarDisplayNameCook
                                                     date:[NSDate date]
                                                     text:@"It is unit-tested, free, open-source, and documented."],
                     
                     [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                        senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                     date:[NSDate date]
                                                     text:@"Now with media messages!"],
                     nil];
    
    [self addPhotoMediaMessage];
    
    /**
     *  Setting to load extra messages for testing/demo
     */
    if ([NSUserDefaults extraMessagesSetting]) {
        NSArray *copyOfMessages = [self.messages copy];
        for (NSUInteger i = 0; i < 4; i++) {
            [self.messages addObjectsFromArray:copyOfMessages];
        }
    }
    
    
    /**
     *  Setting to load REALLY long message for testing/demo
     *  You should see "END" twice
     */
    if ([NSUserDefaults longMessageSetting]) {
        JSQMessage *reallyLongMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                            displayName:kJSQDemoAvatarDisplayNameSquires
                                                                   text:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END"];
        
        [self.messages addObject:reallyLongMessage];
    }
}

- (void)addPhotoMediaMessage
{
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"goldengate"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:photoItem];
    [self.messages addObject:photoMessage];
}

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMessage *locationMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                      displayName:kJSQDemoAvatarDisplayNameSquires
                                                            media:locationItem];
    [self.messages addObject:locationMessage];
}

- (void)addVideoMediaMessage
{
    // don't have a real video, just pretending
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:videoItem];
    [self.messages addObject:videoMessage];
}

- (UIImage *)imageWithURLString:(NSString *)urlString {
    UIImage *img = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlString];
    
    if (!img) {
        img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
    }
    
    if (!img) {
        img = [UIImage imageNamed:@"默认头像"];
    }
    
    return img;
}

#pragma mark - getter & setter 

- (void)setEmmessages:(NSMutableArray *)emmessages {
    _emmessages = emmessages;
    
    [emmessages enumerateObjectsUsingBlock:^(EMMessage *obj, NSUInteger idx, BOOL *stop) {
        [self.messages addObject:[obj transferToJSQMessageWithMeUserInfo:self.meUserInfoModel otherUserInfo:self.otherUserInfoModel]];
    }];
    
    /*
    [emmessages enumerateObjectsUsingBlock:^(EMMessage *obj, NSUInteger idx, BOOL *stop) {
        
        NSLog(@"from : %@, to : %@, message : %@", obj.from, obj.to, ((EMTextMessageBody *)obj.messageBodies[0]).text);
        
        // other -> me
        if ([obj.from isEqualToString:self.otherUserInfoModel.hx_user] && [obj.to isEqualToString:self.meUserInfoModel.hx_user]) {
            [self.messages addObject:[obj transferToJSQMessageWithUserInfo:self.otherUserInfoModel]];
        }
        
        // me -> other
        if ([obj.from isEqualToString:self.meUserInfoModel.hx_user] && [obj.to isEqualToString:self.otherUserInfoModel.hx_user]) {
            [self.messages addObject:[obj transferToJSQMessageWithUserInfo:self.meUserInfoModel]];
        }
     
    }];
     */
    
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    
    return _messages;
}

@end
