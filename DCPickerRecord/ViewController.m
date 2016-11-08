//
//  ViewController.m
//  DCPickerSourceRecord
//
//  Created by dingchao on 15/8/23.
//  Copyright (c) 2015年 dingc. All rights reserved.
//

#import "ViewController.h"
#import "DCPickerRecorder.h"
#import "CityPickers.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[DCPickerRecorder shareRecorder] dc_pickerView:self.pickerView
//                                         recordData:@[@[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天"],@[@"上班",@"不上班"]]
//                                  didSelectedAction:^(NSIndexPath *index,NSString *data){
//                                      self.label.text = data;
//                                  }];
    
    [[DCPickerRecorder shareRecorder] dc_pickerView:self.pickerView
                                    recordDataClass:NSClassFromString(@"CityPickers")
                                  didSelectedAction:^void(NSIndexPath *index,CityModel *city) {
        self.label.text = [NSString stringWithFormat:@"选择了 %@省 %@ 市",city.province,city.name];
    }];
    //    [self.pickerView reloadAllComponents];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
