//
//  V2DataManager.h
//  v2ex-iOS
//
//  Created by Singro on 3/17/14.
//  Copyright (c) 2014 Singro. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AIRDataManager : NSObject

+ (instancetype)manager;

@property (nonatomic, assign) BOOL preferHttps;

#pragma mark - GET


//
//- (NSURLSessionDataTask *)getTopicListWithType:(V2HotNodesType)type
//                                       Success:(void (^)(V2TopicList *list))success
//                                       failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)getTopicWithTopicId:(NSString *)topicId
//                                      success:(void (^)(V2TopicModel *model))success
//                                      failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)getReplyListWithTopicId:(NSString *)topicId
//                                          success:(void (^)(V2ReplyList *list))success
//                                          failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)getMemberProfileWithUserId:(NSString *)userid
//                                            username:(NSString *)username
//                                             success:(void (^)(V2MemberModel *member))success
//                                             failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)getMemberTopicListWithType:(V2HotNodesType)type
//                                                page:(NSInteger)page
//                                       Success:(void (^)(V2TopicList *list))success
//                                       failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)getMemberTopicListWithMemberModel:(V2MemberModel *)model
//                                                       page:(NSInteger)page
//                                                    Success:(void (^)(V2TopicList *list))success
//                                                    failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)getMemberNodeListSuccess:(void (^)(NSArray *list))success
//                                           failure:(void (^)(NSError *error))failure;
//
//#pragma mark - Action
//
//- (NSURLSessionDataTask *)favNodeWithName:(NSString *)nodeName
//                                  success:(void (^)(NSString *message))success
//                                  failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)favTopicWithTopicId:(NSString *)topicId
//                                      success:(void (^)(NSString *message))success
//                                      failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)topicFavWithTopicId:(NSString *)topicId
//                                        token:(NSString *)token
//                                      success:(void (^)(NSString *message))success
//                                      failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)topicFavCancelWithTopicId:(NSString *)topicId
//                                        token:(NSString *)token
//                                      success:(void (^)(NSString *message))success
//                                      failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)topicThankWithTopicId:(NSString *)topicId
//                                        token:(NSString *)token
//                                      success:(void (^)(NSString *message))success
//                                      failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)topicIgnoreWithTopicId:(NSString *)topicId
//                                        success:(void (^)(NSString *message))success
//                                        failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)replyThankWithReplyId:(NSString *)replyId
//                                        token:(NSString *)token
//                                      success:(void (^)(NSString *message))success
//                                      failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)memberFollowWithMemberName:(NSString *)memberName
//                                      success:(void (^)(NSString *message))success
//                                      failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)memberBlockWithMemberName:(NSString *)memberName
//                                           success:(void (^)(NSString *message))success
//                                           failure:(void (^)(NSError *error))failure;
//
//
//#pragma mark - Token
//
//- (NSURLSessionDataTask *)getTopicTokenWithTopicId:(NSString *)topicId
//                                               success:(void (^)(NSString *token))success
//                                               failure:(void (^)(NSError *error))failure;
//
//
//#pragma mark - Create
//
//- (NSURLSessionDataTask *)replyCreateWithTopicId:(NSString *)topicId
//                                         content:(NSString *)content
//                                         success:(void (^)(V2ReplyModel *model))success
//                                         failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)topicCreateWithNodeName:(NSString *)nodeName
//                                            title:(NSString *)title
//                                          content:(NSString *)content
//                                          success:(void (^)(NSString *message))success
//                                          failure:(void (^)(NSError *error))failure;
//
//
//#pragma mark - Login & Profile
//
//- (NSURLSessionDataTask *)UserLoginWithUsername:(NSString *)username password:(NSString *)password
//                                        success:(void (^)(NSString *message))success
//                                        failure:(void (^)(NSError *error))failure;
//
//- (void)UserLogout;
//
//- (NSURLSessionDataTask *)getFeedURLSuccess:(void (^)(NSURL *feedURL))success
//                                    failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)getUserNotificationWithPage:(NSInteger)page
//                                              success:(void (^)(V2NotificationList *list))success
//                                              failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)getUserReplyWithUsername:(NSString *)username
//                                              page:(NSInteger)page
//                                           success:(void (^)(V2MemberReplyList *list))success
//                                           failure:(void (^)(NSError *error))failure;
//
//#pragma mark - Notifications
//
//- (NSURLSessionDataTask *)getCheckInURLSuccess:(void (^)(NSURL *URL))success
//                                       failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)checkInWithURL:(NSURL *)url
//                                 Success:(void (^)(NSInteger count))success
//                                   failure:(void (^)(NSError *error))failure;
//
//- (NSURLSessionDataTask *)getCheckInCountSuccess:(void (^)(NSInteger count))success
//                                 failure:(void (^)(NSError *error))failure;

@end
