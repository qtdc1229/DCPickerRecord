//
//  HotelSearchDataProcessor.h
//  mhotel
//
//  Created by dingc on 12-9-13.
//  Copyright (c) 2012年 miot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DCPickerRecordModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface DCPickerRecorder : NSObject

@property (nonatomic ,readonly) DCPickerRecordModel             *currentPickerRecord;


+ (instancetype)shareRecorder;

- (void)dc_pickerView:(nonnull UIPickerView *)pickerView recordData:(NSArray *)data didSelectedAction:(void (^)())didSelectedAction;

- (void)dc_pickerView:(nonnull UIPickerView *)pickerView recorderClass:(Class)dataClass didSelectedAction:(void (^)())didSelectedAction;

- (void)dc_pickerView:(nonnull UIPickerView *)pickerView recorderModel:(DCPickerRecordModel *)model;

@end
NS_ASSUME_NONNULL_END
