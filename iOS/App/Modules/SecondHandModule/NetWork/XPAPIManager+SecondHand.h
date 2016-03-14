//
//  XPAPIManager+SecondHand.h
//  XPApp
//
//  Created by jy on 15/12/29.
//  Copyright 2015年 ShareMerge. All rights reserved.
//

#import "XPAPIManager.h"

typedef enum : NSUInteger {
    CollectionTypeOfTopic = 1,
    CollcctionTypeOfSecondHand = 2,
    CollectionTypeOfHousekeeping = 5,
} CollectionType;

@interface XPAPIManager (SecondHand)

/**
 *  二手市场列表
 *
 *  @param type 类型：1-转让；2-求购；如此参数不填，则请求所有
 *
 *  @return 信号
 */

- (RACSignal *)secondHandListWithType:(NSString *)type lastSecondHandItemId:(NSString *)lastSecondHandItemId;

/**
 *  发布二手商品
 *
 *  @param title    二手标题
 *  @param content  描述
 *  @param pic_urls 图片数组
 *  @param price    加个
 *  @param type     交易类型：1-转让；2-求购
 *  @param mobile   发布人的联系电话，可以为空
 *
 *  @return 信号
 */
- (RACSignal *)postSecondHandWithTitle:(NSString *)title
                               content:(NSString *)content
                               picUrls:(NSArray *)picUrls
                                 price:(NSString *)price
                                  type:(NSString *)type
                                mobile:(NSString *)mobile;

/**
 *  二手商品详情
 *
 *  @param secondhand_item_id 二手商品ID
 *
 *  @return 信号
 */
- (RACSignal *)secondHandDetailWithSecondhandItemId:(NSString *)secondhandItemId;

/**
 *  二手发布取消
 *
 *  @param secondhand_item_id 二手商品ID
 *
 *  @return 信号
 */
- (RACSignal *)secondHandCancelWithSecondhandItemId:(NSString *)secondhandItemId;

/**
 *  关闭二手交易
 *
 *  @param secondhand_item_id 二手商品ID
 *
 *  @return 信号
 */
- (RACSignal *)secondHandCloseWithSecondhandItemId:(NSString *)secondhandItemId;

/**
 *  二手跟帖（评论/回复）
 *
 *  @param secondhand_item_id 二手商品ID
 *  @param content            跟贴内容
 *  @param reply_of           如果是回复某条评论，则此参数为被回复的评论的secondhand_comment_id
 *
 *  @return 信号
 */
- (RACSignal *)secondHandCreateCommentWithSecondhandItemId:(NSString *)secondhandItemId
                                                   content:(NSString *)content
                                                   replyOf:(NSString *)replyOf;

/**
 *   查询二手跟帖列表
 *
 *  @param secondhand_item_id    二手交易物品ID
 *  @param page_size             默认为20
 *  @param secondhand_comment_id 上一页跟帖最后一个跟帖的ID，首页不要传此参数
 
 *
 *  @return 信号
 */
- (RACSignal *)secondHandCommentListWithSecondhandItemId:(NSString *)secondhandItemId
                                                pageSize:(NSInteger)pageSize
                                     secondhandCommentId:(NSString *)secondhandCommentId;

/**
 *  收藏论坛帖子或者二手商品
 *
 *  @param favoriteId 如果是论坛类型，该参数为帖子的forum_topic_id;如果是二手类型，该参数为二手商品的secondhand_item_id
 *  @param type       收藏类型  类型：1-论坛；2-二手
 *
 *  @return 信号
 */
- (RACSignal *)collectionTopicOrSecondHandWithFavoriteId:(NSString *)favoriteId
                                                    type:(CollectionType)type;

/**
 *  取消收藏
 *
 *  @param favoriteId 如果是论坛类型，该参数为帖子的forum_topic_id;如果是二手类型，该参数为二手商品的secondhand_item_id
 *  @param type       收藏类型  类型：1-论坛；2-二手
 *
 *  @return 信号
 */
- (RACSignal *)cancelCollectionTopicOrSecondHandWithFavoriteId:(NSString *)favoriteId
                                                          type:(CollectionType)type;

/**
 *  编辑(修改)二手发布
 *
 *  @param secondhandItemId 被编辑的二手交易ID
 *  @param title            二手标题
 *  @param content          描述
 *  @param picUrls          图片URL数组
 *  @param price            价格，一般为正数，如果用户用户不填，则默认为-1（表示价格面议）
 *  @param type             交易类型：1-转让；2-求购
 *  @param mobile           发布人的联系电话，可以为空
 *
 *  @return 信号
 */
- (RACSignal *)updateSecondHandWithSecondhandItemId:(NSString *)secondhandItemId
                                              Title:(NSString *)title
                                            content:(NSString *)content
                                            picUrls:(NSArray *)picUrls
                                              price:(NSString *)price
                                               type:(NSString *)type
                                             mobile:(NSString *)mobile;
@end
