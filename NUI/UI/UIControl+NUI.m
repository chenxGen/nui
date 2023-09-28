//
//  UIControl+NUI.m
//  NUIDemo
//
//  Created by Alejandro Isaza on 13-01-30.
//  Copyright (c) 2013 Tom Benner. All rights reserved.
//

#import "UIControl+NUI.h"

@implementation UIControl (NUI)

- (void)initNUI
{
    if (!self.nuiClass) {
        self.nuiClass = @"Control";
    }
}

- (void)applyNUI
{
    // Styling shouldn't be applied to inherited classes, unless nuiClass is
    // explictly set
    if ([self isMemberOfClass:[UIControl class]] ||
        self.nuiClass) {
        [self initNUI];
        if (![self.nuiClass isEqualToString:kNUIClassNone]) {
            [NUIRenderer renderView:self withClass:self.nuiClass];
        }
    }
    self.nuiApplied = YES;
}

- (void)override_didMoveToWindow
{
    if (self.class != [UIControl class]) {
        Method currentMethod = class_getInstanceMethod(self.class, @selector(override_didMoveToWindow));
        Method expectedMethod = class_getInstanceMethod([UIControl class], @selector(override_didMoveToWindow));
        if (currentMethod && expectedMethod) {
            /// Both subclass and UIControl override method override_didMoveToWindow,
            /// In this case, just invoke method of UIControl(original implementation of `didMoveToWindow`).
            if (currentMethod != expectedMethod) {
                ((void (*)(id, Method))method_invoke)(self, expectedMethod);
                return;
            }
        }
    }

    if (!self.isNUIApplied) {
        [self applyNUI];
    }
    [self override_didMoveToWindow];
}

@end
