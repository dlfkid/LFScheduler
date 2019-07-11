//
//  ViewController.m
//  LFSchedulerDemo
//
//  Created by LeonDeng on 2019/7/11.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "ViewController.h"

#import "UIViewController+PopAlert.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIAlertController *alertController = [self popAlertControllerWithTitle:@"AlertTitle" Message:@"Alert Message" LeftButtonTitle:@"Cancel" LeftButtonHandler:nil RightButtonTitle:@"OK" RightButtonHandler:^{
        NSLog(@"OK Button Pressed");
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
