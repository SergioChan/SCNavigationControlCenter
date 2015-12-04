//
//  SCNavigationController.m
//  SCNavigationController
//
//  Created by 叔 陈 on 15/11/30.
//  Copyright © 2015年 叔 陈. All rights reserved.
//

#import "SCNavigationController.h"
#import "SCNavigationControlCenter.h"

@interface SCNavigationController ()

@end

@implementation SCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SCNavigationControlCenter sharedInstance] setNavigationController:self];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressed:)];
    [self.navigationBar addGestureRecognizer:longPress];
    // Do any additional setup after loading the view.
}

- (void)longPressed:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        [[SCNavigationControlCenter sharedInstance] showWithNavigationController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
