//
//  UIViewController+PopAlert.h
//  LFSchedulerDemo
//
//  Created by LeonDeng on 2019/7/11.
//  Copyright © 2019 LeonDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (PopAlert)

- (UIAlertController *)popAlertControllerWithTitle:(NSString *)title Message:(NSString *)message LeftButtonTitle:(NSString *)leftTitle LeftButtonHandler:(dispatch_block_t _Nullable)leftHandler RightButtonTitle:(NSString *)rightTitle RightButtonHandler:(dispatch_block_t _Nullable)rightHandler;

@end

NS_ASSUME_NONNULL_END
