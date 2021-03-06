//
//  HSCPTypeTabBar.m
//  HitachShow
//
//  Created by Jeremy on 2016.
//  Copyright (c) 2016年 hitach. All rights reserved.
//

#import "HSCPTypeTabBar.h"
#import "HSViewUtil.h"
#import "HSCPTabVC.h"

@implementation HSCPTypeTabBar

- (void) addButtons {
    int i = 0;
    CGFloat x = 288;
    CGFloat width = (AppWidth - x - 7)/self.titles.count;
    for (UIView *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton removeFromSuperview];
            CGRect frame = CGRectMake(x, (self.bounds.size.height - 40)/2, width, 40);
            UIButton *tabBtn = [self customBtnWithTitle:self.titles[i] frame:frame];
            tabBtn.tag = i;
            [tabBtn addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:tabBtn];
            x+=width;
            i++;
        }
    }
    [self addAreaButton];
}

- (void) tabClick:(UIButton *)sender {
    [self setSelectedIndex:sender.tag];
    UIViewController *currentVC = [HSViewUtil findViewController:self];
    UITabBarController *tab = (UITabBarController *) currentVC;
    [tab setSelectedIndex:sender.tag];
    UINavigationController *nav = tab.selectedViewController;
    [nav popToRootViewControllerAnimated:YES];
}

- (void) addAreaButton {
    CGRect frame = CGRectMake(221, (self.bounds.size.height - 40)/2, 60, 40);
    UIButton *moduleTopBtn = [self customBtnWithTitle:@"Area" frame:frame];
    moduleTopBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:0.6];
    [self addSubview:moduleTopBtn];
    [moduleTopBtn addTarget:self action:@selector(areaClick) forControlEvents:UIControlEventTouchDown];
}

- (void) areaClick {
    UIViewController *currentVC = [HSViewUtil findViewController:self];
    HSCPTabVC *tabVC = [[HSCPTabVC alloc] init];
    tabVC.selectedIndex = 0;
    [currentVC presentViewController:tabVC animated:YES completion:nil];
}

@end
