//
//  UIApplication+UDAdditions.m
//
//  Created by Rolandas Razma on 1/8/11.
//  Copyright 2011 UD7. All rights reserved.
//

#import "UIApplication+UDAdditions.h"
#import <objc/runtime.h> 
#import <objc/message.h>


NSString *const UIApplicationStatusBarDidTouchNotification = @"UIApplicationStatusBarDidTouchNotification";

static BOOL isRegisterForStatusBarTouchNotifications = NO;


@implementation UIApplication (UDAdditions)


- (void)ud_sendEvent:(UIEvent *)event {

    if( [event type] == UIEventTypeTouches ){
        UITouch *touch = (UITouch *)[[event allTouches] anyObject];
        if( [touch phase] == UITouchPhaseBegan && CGRectContainsPoint([self statusBarFrame], [touch locationInView:nil]) ){
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:UIApplicationStatusBarDidTouchNotification object:self]];
        }
    }
           
    [self ud_sendEvent:event];
}


- (void)registerForStatusBarTouchNotifications {
    if( isRegisterForStatusBarTouchNotifications ) return;
       
    isRegisterForStatusBarTouchNotifications = YES;

    // swizzle
    Method origMethod = class_getInstanceMethod([self class], @selector(sendEvent:));
    Method newMethod = class_getInstanceMethod([self class], @selector(ud_sendEvent:));

    if( class_addMethod([self class], @selector(sendEvent:), method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) ) {
        class_replaceMethod([self class], @selector(ud_sendEvent:), method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, newMethod);
    }

}


- (void)unRegisterForStatusBarTouchNotifications {
    if( !isRegisterForStatusBarTouchNotifications ) {
        NSLog(@"-[UIApplication unRegisterForStatusBarTouchNotifications] called without matching -registerForStatusBarTouchNotifications. Ignoring.");
        return;
    }
    isRegisterForStatusBarTouchNotifications = NO;
    [self registerForStatusBarTouchNotifications];
    isRegisterForStatusBarTouchNotifications = NO;
}


@end
