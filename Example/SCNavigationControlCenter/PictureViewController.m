//
//  PictureViewController.m
//  SCNavigationController
//
//  Created by 叔 陈 on 15/12/3.
//  Copyright © 2015年 叔 陈. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    int value = (arc4random() % 7) + 1;
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",value]];
    [self.view addSubview:imageView];
    
    self.title = @"VC's title";
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc]initWithTitle:@"new VC" style:UIBarButtonItemStylePlain target:self action:@selector(fuck:)];
    self.navigationItem.rightBarButtonItem = next;
    
    // Do any additional setup after loading the view.
}

- (void)fuck:(id)sender
{
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
