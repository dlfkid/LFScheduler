//
//  UIViewController+PopAlert.m
//  LFSchedulerDemo
//
//  Created by LeonDeng on 2019/7/11.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "UIViewController+PopAlert.h"

#import "LFScheduler.h"

@implementation UIViewController (PopAlert)

- (UIAlertController *)popAlertControllerWithTitle:(NSString *)title Message:(NSString *)message LeftButtonTitle:(NSString *)leftTitle LeftButtonHandler:(dispatch_block_t)leftHandler RightButtonTitle:(NSString *)rightTitle RightButtonHandler:(dispatch_block_t)rightHandler {
    dispatch_block_t handlerLeft = leftHandler ? leftHandler : ^{};
    dispatch_block_t handlerRight = rightHandler ? rightHandler : ^{};
    NSDictionary *params = @{@"Title": title, @"Msg": message, @"LBT": leftTitle, @"LBH": handlerLeft, @"RBT": rightTitle, @"RBH": handlerRight};
    return [[LFScheduler sharedScheduler] invokeWithProviderClass:@"Provider_PopAlert" Action:@"popAlertControllerWithParams" Params:params CacheProvider:YES];
}

@end
