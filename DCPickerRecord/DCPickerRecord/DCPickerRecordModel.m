//
//  HotelPickerProcessorDataModel.m
//  MTonight
//
//  Created by dingc on 12-12-13.
//  Copyright (c) 2012年 dingc. All rights reserved.
//

#import "DCPickerRecordModel.h"
#import <objc/runtime.h>

@implementation NSIndexPath (DCRecorder)

-(NSInteger)component {
    return self.section;
}

+ (instancetype)indexPathForRow:(NSInteger)row inComponent:(NSInteger)component {
    return [self indexPathForRow:row inSection:component];
}

@end

@interface DCPickerRecordModel ()

@property (nonatomic, readwrite) NSMutableArray    *rowOfComponent;

//保存选择信息
- (void)saveRowOfComponent:(NSInteger)component row:(NSInteger)row;
@end

@implementation DCPickerRecordModel

+ (void)killProcessor {

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self dc_initRowOfComponents:0];
    }
    return self;
}
#pragma mark - =============== DCPickerRecordModelProtocol ===============

-(void)setData:(NSArray *)data {
    [self backRowOfComponentToZero];
    [self dc_initRowOfComponents:data.count];
    objc_setAssociatedObject(self, @selector(data), data, OBJC_ASSOCIATION_COPY);
}

- (NSArray *)data {
    return objc_getAssociatedObject(self, @selector(data));
}


+ (instancetype)shareRecordModel {
    static DCPickerRecordModel *__shareRecordModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shareRecordModel = [[self alloc] init];
    });
    return __shareRecordModel;
}

- (NSInteger)dc_numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.numberOfComponent;
}

-(NSInteger)dc_pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data ? ((NSArray *)self.data[component]).count : 0;
}

-(NSString *)dc_pickerViewInitTileWithRow:(NSInteger)row inComponent:(NSInteger)component {
    id item = self.data[component][row];
    return [item isKindOfClass:[NSString class]] ? item : @"";
}

- (void)dc_pickerViewDidSelectedWithRow:(NSInteger)row inComponent:(NSInteger)component pickerView:(UIPickerView *)picker {
    id item = self.data[component][row];
    if (self.dc_didSelectedBlock) {
        self.dc_didSelectedBlock([NSIndexPath indexPathForRow:row inComponent:component],item);
    }
    [self saveRowOfComponent:component row:row];
}

#pragma mark - =============== interface method ===============

- (void)dc_PickerViewSelectedComponentsRow:(UIPickerView *)pickerView {
    NSNumber *rowNumber = nil;
    for (int i = 0;i < pickerView.numberOfComponents;i++) {
        rowNumber = _rowOfComponent[i];
        if (rowNumber) {
            [pickerView selectRow:[rowNumber integerValue] inComponent:i animated:NO];
        }else if (i == 0) {
            [pickerView selectRow:0 inComponent:0 animated:NO];
            break;
        }
    }
}

- (void)dc_initRowOfComponents:(NSInteger)components {
    if (!_rowOfComponent || self.numberOfComponent < components) {
        if (!_rowOfComponent) {
            self.rowOfComponent = [NSMutableArray arrayWithCapacity:0];
        }
        for (NSInteger i = MAX(self.numberOfComponent, 0); i < components; i++) {
            [_rowOfComponent addObject:@([self readOldDataOfComponent:i])];
        }
    }
}

-(NSInteger)dc_pickerViewNumberOfComponent {
    NSInteger components = 1;
    [self dc_initRowOfComponents:components];
    return components;
}

- (NSInteger)dc_rowOfComponent:(NSInteger)component {
    NSInteger row = 0;
    if (component < self.numberOfComponent) {
        row = [_rowOfComponent[component] integerValue];
    }
    return row;
}


- (NSInteger)readOldDataOfComponent:(NSInteger)component {
    return 0;
}

- (void)backRowOfComponentToZero {
    if (_rowOfComponent) {
        [_rowOfComponent enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj = @0;
        }];
        
//        for (int i = 0; i < self.numberOfComponent; i++) {
//            [_rowOfComponent replaceObjectAtIndex:i withObject:@0];
//        }
    }
}

- (void)saveRowOfComponent:(NSInteger)component row:(NSInteger)row {
    // NSLog(@"component :%ld, row :%ld",(long)component,(long)row);
    if (component < self.numberOfComponent) {
        [_rowOfComponent replaceObjectAtIndex:component withObject:@(row)];
    }else if (component == self.numberOfComponent) {
        [_rowOfComponent addObject:@(row)];
    }
}

#pragma mark - =============== prive methods ===============
-(NSInteger)numberOfComponent {
    return self.rowOfComponent.count;
}


@end
