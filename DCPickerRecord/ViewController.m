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
    [[DCPickerRecorder shareRecorder] recordDataClass:NSClassFromString(@"CityPickers") didSelectedAction:^id(NSIndexPath *index,CityModel *city) {
        self.label.text = [NSString stringWithFormat:@"选择了 %@省 %@ 市",city.province,city.name];
        return nil;
    }];
    [self.pickerView reloadAllComponents];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
