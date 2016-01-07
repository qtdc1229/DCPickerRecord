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

@interface DCPickerRecorder : NSObject
@property (nonatomic ,assign) Class                             pickerDataClass;
@property (nonatomic ,readonly) DCPickerRecordModel             *currentPickerRecord;
+ (instancetype)shareRecorder;

- (void)recordDataClass:(Class)dataClass didSelectedAction:(id (^)())didSelectedAction;

@end

