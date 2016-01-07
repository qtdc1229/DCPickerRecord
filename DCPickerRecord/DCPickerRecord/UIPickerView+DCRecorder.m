//
//  UIPickerView+DCPickerRecord.m
//  DCPickerSourceRecordDemo
//
//  Created by dingchao on 15/12/22.
//  Copyright © 2015年 dingc. All rights reserved.
//

#import "UIPickerView+DCRecorder.h"
#import "A2DynamicDelegate.h"
#import "NSObject+A2BlockDelegate.h"
#import "DCPickerRecorder.h"

@interface A2DynamicUIPickerViewDelegate : A2DynamicDelegate <UIPickerViewDelegate>

@end

@implementation A2DynamicUIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *ret = @"";
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
        ret = [realDelegate pickerView:pickerView titleForRow:row forComponent:component];
    }
    if ([DCPickerRecorder shareRecorder].currentPickerRecord) {
        ret = [[DCPickerRecorder shareRecorder].currentPickerRecord dc_pickerViewInitTileWithRow:row inComponent:component];
    }
    
    return ret;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [realDelegate pickerView:pickerView didSelectRow:row inComponent:component];
    }
    
    if ([DCPickerRecorder shareRecorder].currentPickerRecord) {
        [[DCPickerRecorder shareRecorder].currentPickerRecord dc_pickerViewDidSelectedWithRow:row inComponent:component pickerView:pickerView];
    }
}

@end

@interface A2DynamicUIPickerViewDataSource : A2DynamicDelegate <UIPickerViewDataSource>

@end

@implementation A2DynamicUIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger ret = 0;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        ret = [realDelegate numberOfComponentsInPickerView:pickerView];
    }
    if ([DCPickerRecorder shareRecorder].currentPickerRecord) {
        ret = [[DCPickerRecorder shareRecorder].currentPickerRecord dc_numberOfComponentsInPickerView:pickerView];
    }
    return ret;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger ret = 0;
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        ret = [realDelegate pickerView:pickerView numberOfRowsInComponent:component];
    }
    if ([DCPickerRecorder shareRecorder].currentPickerRecord) {
        ret = [[DCPickerRecorder shareRecorder].currentPickerRecord dc_pickerView:pickerView numberOfRowsInComponent:component];
    }
    return ret;
}

@end

@implementation UIPickerView (DCRecorder)

+(void)load {
    @autoreleasepool {
        [self bk_registerDynamicDataSource];
        [self bk_registerDynamicDelegate];
//        [self bk_linkDataSourceMethods:@{}];
//        [self bk_linkDelegateMethods:@{}];
    }
}

@end
