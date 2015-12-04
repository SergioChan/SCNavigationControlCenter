//
//  SCNavigationControlCenter.m
//  SCNavigationController
//
//  Created by 叔 陈 on 15/12/3.
//  Copyright © 2015年 叔 陈. All rights reserved.
//

#import "SCNavigationControlCenter.h"

@interface SCNavigationControlCenter()
{
    NSMutableDictionary *_snapShots;
    UINavigationController *_navigationController;
    CGFloat _popAnimationDuration;
}

@end

@implementation SCNavigationControlCenter
@dynamic navigationController;

- (UINavigationController *)navigationController
{
    return _navigationController;
}

- (void)setNavigationController:(UINavigationController *)navigationController
{
    SCLog(@"success");
    // If transfering from one navigation to another, snapshots must be cleared in order to record the new navigation's view controllers.
    if(![_navigationController isEqual:navigationController])
    {
        [_snapShots removeAllObjects];
        SCLog(@"remove");
    }
    _navigationController = navigationController;
    
    // We need to get the delegate call back here in order to maintain the snap shots for each controllers.
    _navigationController.delegate = self;
}

+ (SCNavigationControlCenter *) sharedInstance
{
    static dispatch_once_t  onceToken;
    static SCNavigationControlCenter * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SCNavigationControlCenter alloc] initWithFrame:CGRectMake(0.0f,0.0f,ScreenWidth,ScreenHeight)];
    });
    return sharedInstance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _popAnimationDuration = 0.2f;
        _snapShots = [NSMutableDictionary dictionary];
        self.isShowing = NO;
        [self initSubViews];
    }
    return self;
}

/**
 *  初始化所有子视图
 */
- (void)initSubViews
{
    CGFloat cardWidth = [UIScreen mainScreen].bounds.size.width*5.0f/7.0f;
    self.cardSize = CGSizeMake(cardWidth, cardWidth*16.0f/9.0f);
    
    self.backgroundWindow = [[UIWindow alloc]initWithFrame:self.frame];
    _backgroundWindow.windowLevel = UIWindowLevelStatusBar;
    _backgroundWindow.backgroundColor = [UIColor clearColor];
    _backgroundWindow.alpha = 0.0f;
    
    self.blurView = [[UIVisualEffectView alloc]initWithFrame:self.frame];
    _blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    [_backgroundWindow addSubview:_blurView];
    
    self.userInteractionEnabled = YES;
    _backgroundWindow.userInteractionEnabled = YES;
    
    self.carousel = [[iCarousel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_backgroundWindow addSubview:self.carousel];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeCustom;
    self.carousel.bounceDistance = 0.2f;
    self.carousel.viewpointOffset = CGSizeMake(-cardWidth/5.0f, 0);
}

- (void)show
{
    if(_isShowing)
    {
        return;
    }
    _isShowing = YES;
    
    [_backgroundWindow makeKeyAndVisible];
    [self.carousel reloadData];
    [self.carousel scrollToItemAtIndex:self.navigationController.viewControllers.count-1 animated:NO];
    
    [UIView animateWithDuration:0.5f animations:^{
        _backgroundWindow.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- (void)showWithNavigationController:(UINavigationController *)controller
{
    self.navigationController = controller;
    [self show];
}

- (void)hide
{
    [self hideWithCompletion:nil];
}

- (void)hideWithCompletion:(void (^)(void))completion
{
    if(!_isShowing)
    {
        return;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        _backgroundWindow.alpha = 0.0f;
    } completion:^(BOOL finished) {
        _isShowing = NO;
        _backgroundWindow.hidden = YES;
        if(completion)
        {
            completion();
        }
    }];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if(self.navigationController)
    {
        return self.navigationController.viewControllers.count;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.cardSize.width;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionVisibleItems:
        {
            return 7;
        }
        default:
            break;
    }
    
    return value;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIView *cardView = view;
    
    if (!cardView)
    {
        cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cardSize.width, self.cardSize.height)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cardView.bounds];
        [cardView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.tag = [@"image" hash];
        
        cardView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0f].CGPath;
        cardView.layer.shadowRadius = 3.0f;
        cardView.layer.shadowColor = [UIColor blackColor].CGColor;
        cardView.layer.shadowOpacity = 0.5f;
        cardView.layer.shadowOffset = CGSizeMake(0, 0);
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = imageView.bounds;
        layer.path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:5.0f].CGPath;
        imageView.layer.mask = layer;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.0f, -20.0f, 100.0f, 15.0f)];
        titleLabel.font = [UIFont systemFontOfSize:12.0f];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.tag = [@"title" hash];
        [cardView addSubview:titleLabel];
    }
    
    UIViewController *tmp = [self.navigationController.viewControllers objectAtIndex:index];
    NSString *t_key= [NSString stringWithFormat:@"%@",tmp];
    
    UIImageView *imageView = (UIImageView*)[cardView viewWithTag:[@"image" hash]];
    imageView.image = [_snapShots objectForKey:t_key];
    
    UILabel *label = (UILabel *)[cardView viewWithTag:[@"title" hash]];
    label.text = tmp.title;
    
    return cardView;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    CGFloat scale = [self scaleByOffset:offset];
    CGFloat translation = [self translationByOffset:offset];
    
    return CATransform3DScale(CATransform3DTranslate(transform, translation * self.cardSize.width, 0, offset), scale, scale, 1.0f);
}

- (void)carouselDidScroll:(iCarousel *)carousel
{
    for ( UIView *view in carousel.visibleItemViews)
    {
        CGFloat offset = [carousel offsetForItemAtIndex:[carousel indexOfItemView:view]];
        
        if ( offset < -3.0 )
        {
            view.alpha = 0.0f;
        }
        else if ( offset < -2.0f)
        {
            view.alpha = offset + 3.0f;
        }
        else
        {
            view.alpha = 1.0f;
        }
    }
}

//形变是线性的就ok了
- (CGFloat)scaleByOffset:(CGFloat)offset
{
    return offset*0.04f + 1.0f;
}

//位移通过得到的公式来计算
- (CGFloat)translationByOffset:(CGFloat)offset
{
    CGFloat z = 5.0f/4.0f;
    CGFloat n = 5.0f/8.0f;
    
    //z/n是临界值 >=这个值时 我们就把itemView放到比较远的地方不让他显示在屏幕上就可以了
    if ( offset >= z/n )
    {
        return 2.0f;
    }
    
    return 1/(z-n*offset)-1/z;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if(!_isShowing)
    {
        return;
    }
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:NO];
    
    UIView *cardView = [self.carousel itemViewAtIndex:index];
    if([self.carousel itemViewAtIndex:index+1])
    {
        UIView *nextCardView = [self.carousel itemViewAtIndex:index+1];
        [nextCardView.layer addAnimation:[self moveoutAnimationForNextCardView:cardView] forKey:@"next_one_move_out"];
    }
    [cardView.layer addAnimation:[self popAnimationForCardView:cardView] forKey:@"chosen_one_pop_out"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _isShowing = NO;
    _backgroundWindow.hidden = YES;
    _backgroundWindow.alpha = 0.0f;
}

- (void)carouseldidTapInBlankArea:(iCarousel *)carousel
{
    [self hide];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSString *key= [NSString stringWithFormat:@"%@",viewController];
    if([_snapShots objectForKey:key] == nil)
    {
        // 不存在
        [_snapShots setObject:[self capture] forKey:key];
    }
    else
    {
        // 已经存在，则比对两者，去掉多余的
        // self.navigationController.viewControllers
        NSMutableDictionary *t_snapshots = [NSMutableDictionary dictionary];
        for(UIViewController *t_vc in self.navigationController.viewControllers)
        {
            NSString *t_key= [NSString stringWithFormat:@"%@",t_vc];
            if([_snapShots objectForKey:t_key])
            {
                [t_snapshots setObject:[_snapShots objectForKey:t_key] forKey:t_key];
            }
        }
        _snapShots = t_snapshots;
    }
}

- (UIImage *)capture
{
    CALayer *layer = [[UIApplication sharedApplication].windows firstObject].layer;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    return screenshot;
}

- (CAAnimationGroup *)popAnimationForCardView:(UIView *)cardView
{
    CABasicAnimation *scaleAnimation;
    scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(ScreenWidth/cardView.width, ScreenHeight/cardView.height, 1.0)];
    scaleAnimation.duration = _popAnimationDuration;
    scaleAnimation.cumulative = YES;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.removedOnCompletion= NO;
    scaleAnimation.fillMode=kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    scaleAnimation.speed = 1.0f;
    scaleAnimation.beginTime = 0.0f;
    
    CABasicAnimation *transitionAnimation;
    CGFloat translationX = cardView.center.x - ScreenWidth/2.0f;
    transitionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    transitionAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)];
    transitionAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(translationX, 0.0f)];
    transitionAnimation.duration = _popAnimationDuration;
    transitionAnimation.cumulative = YES;
    transitionAnimation.repeatCount = 1;
    transitionAnimation.removedOnCompletion= NO;
    transitionAnimation.fillMode=kCAFillModeForwards;
    transitionAnimation.autoreverses = NO;
    transitionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transitionAnimation.speed = 1.0f;
    transitionAnimation.beginTime = 0.0f;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = _popAnimationDuration;
    groupAnimation.repeatCount = 1;
    groupAnimation.removedOnCompletion= NO;
    groupAnimation.fillMode=kCAFillModeForwards;
    groupAnimation.autoreverses = NO;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    groupAnimation.delegate = self;
    
    groupAnimation.animations = [NSArray arrayWithObjects:scaleAnimation,transitionAnimation,nil];
    return groupAnimation;
}

- (CAAnimationGroup *)moveoutAnimationForNextCardView:(UIView *)cardView
{
    CABasicAnimation *transitionAnimation;
    CGFloat translationX = cardView.center.x - ScreenWidth/2.0f;
    CGFloat offset = 20.0f;
    transitionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    transitionAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)];
    transitionAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(-translationX + offset, 0.0f)];
    transitionAnimation.duration = _popAnimationDuration;
    transitionAnimation.cumulative = YES;
    transitionAnimation.repeatCount = 1;
    transitionAnimation.removedOnCompletion= NO;
    transitionAnimation.fillMode=kCAFillModeForwards;
    transitionAnimation.autoreverses = NO;
    transitionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transitionAnimation.speed = 1.0f;
    transitionAnimation.beginTime = 0.0f;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = _popAnimationDuration;
    groupAnimation.repeatCount = 1;
    groupAnimation.removedOnCompletion= NO;
    groupAnimation.fillMode=kCAFillModeForwards;
    groupAnimation.autoreverses = NO;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    groupAnimation.delegate = self;
    
    groupAnimation.animations = [NSArray arrayWithObjects:transitionAnimation,nil];
    return groupAnimation;
}
@end
