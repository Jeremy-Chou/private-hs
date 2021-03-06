//
//  HSTabBarController.m
//  HitachShow
//
//  Created by Jeremy on 2016.
//  Copyright (c) 2016年 hitach. All rights reserved.
//

#import "HSMainTabController.h"
#import "HSBaseVC.h"

@implementation HSMainTabController

- (void)viewDidLoad {
    self.titles = [NSArray arrayWithObjects:@"Company\nIntroduction",
                   @"Project\nGallery",@"Product\nIntroduction",
                   @"Maintenance",nil ];
    [super viewDidLoad];
    
    [self setChildVC];
}

- (void)setChildVC {
    NSDictionary *map = @{@"Company\nIntroduction":@"HSCIMainVC",
                          @"Project\nGallery":@"HSCPMainVC",
                          @"Product\nIntroduction":@"HSPITabVC",
                          @"Maintenance":@"HSMaintenanceVC"};
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for (NSString *key in self.titles) {
        NSString *vcName = map[key];
        HSBaseVC *vc = [[NSClassFromString(vcName) alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [vcs addObject:nav];
    }
    
    self.viewControllers = vcs;
}

@end
