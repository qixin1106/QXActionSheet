QXActionSheet
=============

类似淘宝app的选择商品SKU切换效果

演示效果:

![image](https://raw.githubusercontent.com/qixin1106/QXActionSheet/master/sheeteffect.gif)


### init
    
    self.as = [[QXActionSheet alloc] initWithHeight:420
                                  isNeedPerspective:YES];
    self.as.delegate = self;
    [self.view addSubview:self.as];


### addSubView

    [self.as.contentView addSubview:showView];


### delegate
  
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
