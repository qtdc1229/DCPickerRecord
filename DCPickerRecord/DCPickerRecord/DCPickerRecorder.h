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
@property (nonatomic ,weak) Class                               pickerDataClass;
@property (nonatomic ,readonly) DCPickerRecordModel             *currentPickerRecord;


/** The block to be fired when set components. */
@property (nonatomic, copy, setter = dc_setNumberOfComponentsBlock:) NSInteger (^dc_numberOfComponentsBlock)(UIPickerView *pickerView);

/** The block to be fired set titles in index. */
@property (nonatomic, copy, setter = dc_setInitTileBlock:) void (^dc_initTileBlock)(NSIndexPath *index);

/** The block to be fired when set row in component. */
@property (nonatomic, copy, setter = dc_setNumberOfRowsBlock:) void (^dc_numberOfRowsBlock)(NSInteger component,UIPickerView *pickerView);


+ (instancetype)shareRecorder;

- (void)dc_pickerView:(nonnull UIPickerView *)pickerView recordDataClass:(Class)dataClass didSelectedAction:(id (^)())didSelectedAction;

@end
NS_ASSUME_NONNULL_END
