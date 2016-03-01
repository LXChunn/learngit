//
//  UIResponder+Router.h
//  RespondChain
//
//  Created by xinpinghuang on 3/1/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief  聊天界面各种点击事件
 */
typedef NS_OPTIONS(NSInteger, EventChatCellType)
{
    /**
     *  删除事件
     */
    EventChatCellRemoveEvent,
    
    /**
     *  @brief  图片点击事件
     */
    EventChatCellImageTapedEvent,
    
    /**
     *  @brief  头像点击事件
     */
    EventChatCellHeadTapedEvent,
    
    /**
     *  @brief  头像长按事件
     */
    EventChatCellHeadLongPressEvent,
    
    /**
     *  @brief  输入框点击发送消息事件
     */
    EventChatCellTypeSendMsgEvent,
    
    
    /**
     *  @brief 输入界面，更多界面，选择图片
     */
    EventChatMoreViewPickerImage,
};

@interface UIResponder (Router)

- (void)routerEventWithType:(EventChatCellType)eventType userInfo:(NSDictionary *)userInfo;

@end
