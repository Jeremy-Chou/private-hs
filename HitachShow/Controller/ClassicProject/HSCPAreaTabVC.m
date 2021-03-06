//
//  HSCPAreaTabVC.m
//  HitachShow
//
//  Created by Jeremy on 2016年.
//  Copyright (c) 2016年 hitach. All rights reserved.
//

#import "HSCPAreaTabVC.h"
#import "HSCPAreaTabBar.h"
#import "HSCPAreaPartVC.h"
#import "HSCommonInfo.h"

@interface HSCPAreaTabVC ()

@property(nonatomic,strong) NSArray *areas;
@property(nonatomic,strong) NSDictionary *dic;

@end

@implementation HSCPAreaTabVC

- (void)viewDidLoad {
    _areas = [NSArray arrayWithObjects:@"East Asia",@"Southeast Asia",@"Southern Asia",@"West Asia / Middle Asia", nil];
    _dic = @{@"East Asia":@"cp_area_part_bg_3_1_0.jpg",
             @"Southeast Asia":@"cp_area_part_bg_3_2_0.jpg",
             @"Southern Asia":@"cp_area_part_bg_3_3_0.jpg",
             @"West Asia / Middle Asia":@"cp_area_part_bg_3_4_0.jpg"};

    [super viewDidLoad];
    
    HSCPAreaTabBar *tabBar = [[HSCPAreaTabBar alloc] initWithFrame:self.tabBar.frame];
    tabBar.titles = _areas;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    [self setChildVC];
}

- (void)setChildVC {
//    NSDictionary *categories = @{@"East Asia":@"ci-cp-1-1",
//                                 @"Southeast Asia":@"ci-cp-1-2",
//                                 @"Southern Asia":@"ci-cp-1-3",
//                                 @"West Asia\nMiddle Asia":@"ci-cp-1-4"};
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for (int i=0; i<_areas.count; i++) {
        NSString *area =  _areas[i];
        HSCPAreaPartVC *vc = [[HSCPAreaPartVC alloc] init];
        vc.areaName = area;
        vc.background = [UIImage imageNamed:_dic[area]];
        vc.projects = [[HSCommonInfo shared] findByArea:area];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [vcs addObject:nav];
    }
    self.viewControllers = vcs;
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
