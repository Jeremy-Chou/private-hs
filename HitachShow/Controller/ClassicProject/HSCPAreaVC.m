//
//  HSCPAreaVC.m
//  HitachShow
//
//  Created by Jeremy on 2016年.
//  Copyright (c) 2016年 hitach. All rights reserved.
//

#import "HSCPAreaVC.h"
#import "HSImageButton.h"
#import "HSCPAreaTabVC.h"

@interface HSCPAreaVC ()

@end

@implementation HSCPAreaVC

- (void)viewDidLoad {
    self.mainTitle = @"Project Gallery";
    [super viewDidLoad];
    [self addSubviews];
}

-(void) addSubviews {
    NSDictionary *areas = @{@"East Asia":@"cp_area_btn_3_1_1_East.jpg",
                            @"Southeast Asia":@"cp_area_btn_3_1_2_The southeast.jpg",
                            @"Southern Asia":@"cp_area_btn_3_1_3_Southern.jpg",
                            @"West Asia\nMiddle Asia":@"cp_area_btn_3_1_4_West Asia.jpg"};
    NSArray *keys = [[NSArray alloc] initWithObjects:@"East Asia",@"Southeast Asia",
                     @"Southern Asia",@"West Asia\nMiddle Asia",nil];
    
    NSInteger count = areas.count;
    
    CGFloat width = 321;
    CGFloat height = 165;
    for (int i=0; i<count;i++) {
        HSImageButton *btn = [[HSImageButton alloc] init];
        btn.leftTitle = [keys objectAtIndex:i];
        [self.view addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(width);
            make.height.equalTo(height);
            make.top.equalTo(self.view.top).offset(255 + height * (i/2));
            make.left.equalTo(self.view.left).offset(100 + width/2 * (i/2) + width * (i%2));
        }];
        btn.rightImage = areas[btn.leftTitle];
        // Updated at 2017.2
        btn.rightImgV.tag = i;
        btn.leftBtn.tag = i;
        [btn.rightImgV addTarget:self action:@selector(tab:) forControlEvents:UIControlEventTouchDown];
        [btn.leftBtn addTarget:self action:@selector(tab:) forControlEvents:UIControlEventTouchDown];
    }
}

-(void) tab:(UIButton *) sender {
    HSCPAreaTabVC *tabVC = [[HSCPAreaTabVC alloc] init];
    tabVC.selectedIndex = sender.tag;
    [self presentViewController:tabVC animated:YES completion:nil];
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
