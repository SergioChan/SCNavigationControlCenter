//
//  TabAViewController.m
//  SCNavigationController
//
//  Created by 叔 陈 on 15/12/3.
//  Copyright © 2015年 叔 陈. All rights reserved.
//

#import "TabAViewController.h"
#import "PictureViewController.h"

@interface TabAViewController ()

@end

@implementation TabAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Navi A";
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"2.jpg"];
    [self.view addSubview:imageView];
    
    // Do any additional setup after loading the view.
}

- (IBAction)ButtonPressed:(id)sender {
    PictureViewController *vc = [[PictureViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
