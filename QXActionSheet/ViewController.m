//
//  ViewController.m
//  QXActionSheet
//
//  Created by Qixin on 14/12/16.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import "ViewController.h"
#import "QXActionSheet.h"


@interface ViewController () <QXActionSheetDelegate>
@property (strong, nonatomic) QXActionSheet *as;
@end

@implementation ViewController

- (void)closeSheet:(UIButton*)sender
{
    [self.as close];
}

- (IBAction)onClick:(UIButton *)sender
{
    //DEMO: 模拟sheet的视图,实际应用则替换为自己的自定义视图
    UIImageView *showView = [[UIImageView alloc] init];
    showView.userInteractionEnabled = YES;
    showView.image = [UIImage imageNamed:@"sheet.jpg"];
    showView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 420);
    
    //DEMO: 模拟返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(self.view.bounds.size.width-40, 22, 30, 30);
    backButton.backgroundColor = [UIColor redColor];
    backButton.alpha = 0.3;
    [backButton addTarget:self
                   action:@selector(closeSheet:)
         forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:backButton];

    
    
    //INIT: 初始化
    self.as = [[QXActionSheet alloc] initWithHeight:420
                                    isNeedPerspective:YES];
    self.as.delegate = self;
    [self.view addSubview:self.as];

    [self.as.contentView addSubview:showView];

    self.navigationController.navigationBarHidden = YES;
}




#pragma mark - QXActionSheetDelegate
- (void)actionSheetWillClose:(QXActionSheet*)actionSheet
{
    NSLog(@"actionSheetWillClose");
}
- (void)actionSheetDidClose:(QXActionSheet*)actionSheet
{
    NSLog(@"actionSheetDidClose");
    self.navigationController.navigationBarHidden = NO;
    self.as = nil;
}

@end
