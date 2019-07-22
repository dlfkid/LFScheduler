//
//  Provider_PopAlert.m
//  LFSchedulerDemo
//
//  Created by LeonDeng on 2019/7/11.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import "Provider_PopAlert.h"

#import <UIKit/UIKit.h>

NSString * const kProvider_PopAlert = @"Provider_PopAlert";
NSString * const KAction_popAlertControllerWithParams = @"popAlertControllerWithParams";

@implementation Provider_PopAlert

- (id)popAlertControllerWithParams:(NSDictionary *)params {
    NSString *leftTitle = params[@"LBT"];
    dispatch_block_t leftHandler = params[@"LBH"];
    NSString *rightTitle = params[@"RBT"];
    dispatch_block_t rightHandler = params[@"RBH"];
    NSString *message = params[@"Msg"];
    NSString *title = params[@"Title"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !leftHandler ?: leftHandler();
    }];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !rightHandler ?: rightHandler();
    }];
    
    [alertController addAction:leftAction];
    [alertController addAction:rightAction];
    
    return alertController;
}

@end
