//
//  GMActionSheet.m
//  TestActionSheet
//
//  Created by Qixin on 14-4-9.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import "QXActionSheet.h"
#import <QuartzCore/QuartzCore.h>


@interface QXActionSheet ()
@property (strong, nonatomic) UIControl *closeControl;
@property (strong, nonatomic) UIImageView *maskImageView;
@property (assign, nonatomic) BOOL isNeedPerspective;
@end

@implementation QXActionSheet

+ (UIImage*)cutImageWithWindow
{
    @autoreleasepool
    {
        UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, YES, 1);
        [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return uiImage;
    }
}


#pragma mark - 打开动画
- (void)open
{
    if (self.isNeedPerspective)
    {
        CATransform3D t = CATransform3DIdentity;
        t.m34 = -0.004;
        [self.maskImageView.layer setTransform:t];
        self.maskImageView.layer.zPosition = -10000;

        self.maskImageView.image = [QXActionSheet cutImageWithWindow];
        self.closeControl.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.5f animations:^{
            self.maskImageView.alpha = 0.5;
            self.contentView.frame = CGRectMake(0,
                                                self.bounds.size.height-self.contentView.bounds.size.height,
                                                self.bounds.size.width,
                                                self.bounds.size.height);
        }];

        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.layer.transform = CATransform3DRotate(t, 7/90.0*M_PI_2, 1, 0, 0);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -50, -50);
            }];
        }];

        /*
         //反弹效果
        CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        CATransform3D r0 = CATransform3DRotate(self.maskImageView.layer.transform, 0/90.0*M_PI_2, 1, 0, 0);
        CATransform3D r1 = CATransform3DRotate(self.maskImageView.layer.transform, 7/90.0*M_PI_2, 1, 0, 0);
        CATransform3D s0 = CATransform3DScale(self.maskImageView.layer.transform, 1, 1, 1);
        CATransform3D s1 = CATransform3DScale(self.maskImageView.layer.transform, 0.8, 0.8, 0.8);

        [bounce setValues:[NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:r0],
                           [NSValue valueWithCATransform3D:s0],
                           [NSValue valueWithCATransform3D:r1],
                           [NSValue valueWithCATransform3D:s1],
                           [NSValue valueWithCATransform3D:r0],nil]];
        [bounce setDuration:0.8f];
        bounce.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.maskImageView.layer addAnimation:bounce forKey:@"bounceAnimation"];
         */
        
    }
    else
    {
        self.maskImageView.image = [QXActionSheet cutImageWithWindow];
        self.closeControl.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.alpha = 0.25;
            self.contentView.frame = CGRectMake(0,
                                                self.bounds.size.height-self.contentView.bounds.size.height,
                                                self.bounds.size.width,
                                                self.bounds.size.height);
        }];
    }
}



#pragma mark - 关闭动画
- (void)close
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetWillClose:)])
    {
        [self.delegate actionSheetWillClose:self];
    }
    if (self.isNeedPerspective)
    {
            CATransform3D t = CATransform3DIdentity;
            t.m34 = -0.004;
            [self.maskImageView.layer setTransform:t];
            
            self.closeControl.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.5f animations:^{
                self.maskImageView.alpha = 1;
                self.contentView.frame = CGRectMake(0,
                                                    self.frame.size.height,
                                                    self.bounds.size.width,
                                                    self.bounds.size.height);
            } completion:^(BOOL finished) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetDidClose:)])
                {
                    [self.delegate actionSheetDidClose:self];
                }
                [self performSelector:@selector(removeFromSuperview)];
            }];
            
            
            [UIView animateWithDuration:0.25f animations:^{
                self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -50, -50);
                self.maskImageView.layer.transform = CATransform3DRotate(t, 7/90.0*M_PI_2, 1, 0, 0);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25f animations:^{
                    self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, 0, 0);
                }];
            }];
    }
    else
    {
        self.closeControl.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.alpha = 1;
            self.contentView.frame = CGRectMake(0,
                                                self.frame.size.height,
                                                self.bounds.size.width,
                                                self.bounds.size.height);
        } completion:^(BOOL finished) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetDidClose:)])
            {
                [self.delegate actionSheetDidClose:self];
            }
            [self performSelector:@selector(removeFromSuperview)];
        }];
    }
}


#pragma mark - 设置contentView高度
- (void)contentViewHeight:(float)height
{
    //保护高度不能超标准
    if (height>[UIScreen mainScreen].bounds.size.height)
    {
        height = [UIScreen mainScreen].bounds.size.height;
    }
    self.contentView.frame = CGRectMake(0,
                                        self.frame.size.height,
                                        self.frame.size.width,
                                        height);
}



#pragma mark - 初始化
- (id)initWithHeight:(CGFloat)height
   isNeedPerspective:(BOOL)isNeedPerspective
{
    self = [super init];
    if (self)
    {
        self.isNeedPerspective = isNeedPerspective;
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor blackColor];

        self.maskImageView = [[UIImageView alloc] init];
        self.maskImageView.frame = CGRectMake(0,
                                              0,
                                              self.frame.size.width,
                                              self.frame.size.height);
        [self addSubview:self.maskImageView];

        self.closeControl = [[UIControl alloc] initWithFrame:self.bounds];
        self.closeControl.userInteractionEnabled = NO;
        self.closeControl.backgroundColor = [UIColor clearColor];
        [self.closeControl addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeControl];


        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    self.frame.size.height,
                                                                    self.frame.size.width,
                                                                    self.frame.size.height)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];

        //设置高度
        [self contentViewHeight:height];
        [self open];
    }
    return self;
}


- (void)dealloc
{
    self.delegate = nil;
}



@end
