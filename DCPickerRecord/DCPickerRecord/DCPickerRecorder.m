//
//  HotelSearchDataProcessor.m
//  mhotel
//
//  Created by dingc on 12-9-13.
//  Copyright (c) 2012年 miot. All rights reserved.
//

#import "DCPickerRecorder.h"
#import "DCCommonConstants.h"
#import "NSObject+A2BlockDelegate.h"

DCPickerRecorder *__shareDCPickerSourceRecorder = nil;

@interface DCPickerRecorder ()

@property (nonatomic ,readwrite) DCPickerRecordModel           *currentPickerRecord;
@end

@implementation DCPickerRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    _currentPickerRecord = nil;
}

+ (instancetype)shareRecorder {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shareDCPickerSourceRecorder = [[self alloc] init];
    });
    return __shareDCPickerSourceRecorder;
}

- (void)recordDataClass:(Class)dataClass didSelectedAction:(id (^)())didSelectedAction {
    if ([dataClass isSubclassOfClass:[DCPickerRecordModel class]]) {
        _pickerDataClass = dataClass;
        self.currentPickerRecord = [_pickerDataClass shareRecordModel];
    }
    if (didSelectedAction && self.currentPickerRecord) {
        self.currentPickerRecord.dc_didSelectedBlock = didSelectedAction;
    }
}

@end

