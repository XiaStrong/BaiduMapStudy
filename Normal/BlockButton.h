//
//  BlockButton.h
//  BlockUseDemo
//
//  Created by mac on 14-10-9.
//  Copyright (c) 2014年 zhang jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockButton : UIButton
//以前: 处理按钮的事件, 传入一个事件处理方法
//现在: 为了处理事件, 传入block语句块
// void btnClick(UIButton *button)
{
    void (^_action)(UIButton *button);
}
//注意: block类型property,修饰符一定是copy
@property (copy,nonatomic) void (^action)(UIButton *button);

@end

//为了调用的时候方便,添加类别
@interface UIButton (BlockButton)
//创建按钮的快捷方法
// void (^)(UIButton *button)
+(UIButton *)systemButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                            action:( void (^)(UIButton *button) )action;

@end

