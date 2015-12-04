//
//  SCNavigationControlCenter.h
//  SCNavigationController
//
//  Created by 叔 陈 on 15/12/3.
//  Copyright © 2015年 叔 陈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
#import "iCarousel.h"

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

#define SCLog(fmt, ...)    NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@interface SCNavigationControlCenter : UIView
<
iCarouselDelegate,
iCarouselDataSource,
UINavigationControllerDelegate
>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, assign) CGSize cardSize;

@property (nonatomic, strong) UIWindow *backgroundWindow;

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UIVisualEffectView *blurView;

@property (nonatomic) BOOL isShowing;

+ (SCNavigationControlCenter *) sharedInstance;
- (void)setNavigationController:(UINavigationController *)navigationController;

- (void)show;
- (void)showWithNavigationController:(UINavigationController *)controller;

- (void)hide;
- (void)hideWithCompletion:(void (^)(void))completion;

@end
