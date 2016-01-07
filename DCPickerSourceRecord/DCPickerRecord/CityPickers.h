//
//  cityPickers.h
//  DCPickerSourceRecordDemo
//
//  Created by dingchao on 16/1/6.
//  Copyright © 2016年 dingc. All rights reserved.
//

#import "DCPickerRecordModel.h"

@interface CityModel : NSObject

@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *province;

+ (instancetype)cityWithName:(NSString *)name province:(NSString *)province;
@end

@interface CityPickers : DCPickerRecordModel
@property (nonatomic ,copy)NSArray *cityArray;
@end
