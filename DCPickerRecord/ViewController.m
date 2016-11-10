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
    NSArray *data = @[@[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天"],@[@"上班",@"不上班"]];
    
//      #case 1
//    [[DCPickerRecorder shareRecorder] dc_pickerView:self.pickerView
//                                         recordData:data
//                                  didSelectedAction:^(NSIndexPath *index,NSString *data){
//                                      self.label.text = data;
//                                  }];

//      #case 2
//    DCPickerRecordModel *model = [DCPickerRecordModel recordModelData:data
//                       numberOfComponent:^NSInteger{
//                           return data.count;
//                       }
//                         rowsInComponent:^NSInteger(NSInteger component) {
//                             return ((NSArray *)data[component]).count;
//                         }
//                                  titles:^NSString *(NSIndexPath *index, NSArray *data) {
//                                      return data[index.component][index.row];
//                                  }
//                             didSelected:^(NSIndexPath *index,NSString *dataString,NSArray *saveComponents){
//                                 NSInteger component0 = [saveComponents[0] integerValue];
//                                 NSInteger component1 = [saveComponents[1] integerValue];
//                                 self.label.text = [NSString stringWithFormat:@"%@,%@",data[0][component0],data[1][component1]];
//                             }];
//    [[DCPickerRecorder shareRecorder] dc_pickerView:self.pickerView
//                                      recorderModel:model];
  
//      #case 3
    [[DCPickerRecorder shareRecorder] dc_pickerView:self.pickerView
                                      recorderClass:NSClassFromString(@"CityPickers")
                                  didSelectedAction:^void(NSIndexPath *index,CityModel *city) {
                                      self.label.text = [NSString stringWithFormat:@"选择了 %@省 %@ 市",city.province,city.name];
                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
