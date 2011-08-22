//
//  UIApplication+UDAdditions.h
//
//  Created by Rolandas Razma on 1/8/11.
//  Copyright 2011 UD7. All rights reserved.
//

#import <Foundation/Foundation.h>


NSString *const UIApplicationStatusBarDidTouchNotification;


@interface UIApplication (UDAdditions)

- (void)registerForStatusBarTouchNotifications;
- (void)unRegisterForStatusBarTouchNotifications;

@end
