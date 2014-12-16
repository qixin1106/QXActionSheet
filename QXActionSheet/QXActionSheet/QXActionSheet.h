//
//  GMActionSheet.h
//  TestActionSheet
//
//  Created by Qixin on 14-4-9.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

/*
 //用法
 1.初始化QXActionSheet
 self.as = [[QXActionSheet alloc] initWithHeight:420
                               isNeedPerspective:YES];
 self.as.delegate = self;
 [self.view addSubview:self.as];

 2.将自定义的控件添加到contentView上
 [self.as.contentView addSubview:showView];
 */

#import <UIKit/UIKit.h>

@protocol QXActionSheetDelegate;
@interface QXActionSheet : UIView
@property (weak, nonatomic) id<QXActionSheetDelegate> delegate;
@property (strong, nonatomic) UIView *contentView;//所有控件必须加载到此View上

- (id)initWithHeight:(CGFloat)height
     isNeedPerspective:(BOOL)isNeedPerspective;//是否需要后面背景缩小,NO为不缩小
- (void)close;//关闭
@end



@protocol QXActionSheetDelegate <NSObject>
@optional
/*
actionsheet关闭的时候回调,如自定义button关闭调close方法,则可以在此回调中实现其他操作.
 */
- (void)actionSheetWillClose:(QXActionSheet*)actionSheet;
- (void)actionSheetDidClose:(QXActionSheet*)actionSheet;
@end