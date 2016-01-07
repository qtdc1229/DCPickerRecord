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

@property (nonatomic, copy, setter = bk_setCancelBlock:) NSInteger (^dc_)(void);

/** The block to be fired before the alert view will show. */
@property (nonatomic, copy, setter = bk_setWillShowBlock:) void (^bk_willShowBlock)(UIAlertView *alertView);

/** The block to be fired when the alert view shows. */
@property (nonatomic, copy, setter = bk_setDidShowBlock:) void (^bk_didShowBlock)(UIAlertView *alertView);

/** The block to be fired before the alert view will dismiss. */
@property (nonatomic, copy, setter = bk_setWillDismissBlock:) void (^bk_willDismissBlock)(UIAlertView *alertView, NSInteger buttonIndex);

/** The block to be fired after the alert view dismisses. */
@property (nonatomic, copy, setter = bk_setDidDismissBlock:) void (^bk_didDismissBlock)(UIAlertView *alertView, NSInteger buttonIndex);


+ (instancetype)shareRecorder;

- (void)dc_pickerView:(nonnull UIPickerView *)pickerView recordDataClass:(Class)dataClass didSelectedAction:(id (^)())didSelectedAction;

@end
NS_ASSUME_NONNULL_END
