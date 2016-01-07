//
//  HotelPickerProcessorDataModel.m
//  MTonight
//
//  Created by dingc on 12-12-13.
//  Copyright (c) 2012年 dingc. All rights reserved.
//

#import "DCPickerRecordModel.h"

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
    return [self dc_rowOfComponent:component];
}

-(NSString *)dc_pickerViewInitTileWithRow:(NSInteger)row inComponent:(NSInteger)component {
    return @"";
}

- (void)dc_pickerViewDidSelectedWithRow:(NSInteger)row inComponent:(NSInteger)component pickerView:(UIPickerView *)picker {
    [self saveRowOfComponent:component row:row];
}

#pragma mark - =============== interface method ===============

- (void)dc_PickerViewSelectedComponentsRow:(UIPickerView *)pickerView {
    NSNumber *rowNumber = nil;
    for (int i = 0;i < pickerView.numberOfComponents;i++) {
        rowNumber = _rowOfComponent[i];
        if (rowNumber) {
            [pickerView selectRow:[rowNumber intValue] inComponent:i animated:NO];
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
            [_rowOfComponent addObject:[NSNumber numberWithInteger:[self readOldDataOfComponent:i]]];
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
        for (int i = 0; i < self.numberOfComponent; i++) {
            [_rowOfComponent replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:0]];
        }
    }
}

- (void)saveRowOfComponent:(NSInteger)component row:(NSInteger)row {
    NSLog(@"component :%ld, row :%ld",(long)component,(long)row);
    if (component < self.numberOfComponent) {
        [_rowOfComponent replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
    }else if (component == self.numberOfComponent) {
        [_rowOfComponent addObject:[NSNumber numberWithInteger:row]];
    }
}

#pragma mark - =============== prive methods ===============
-(NSInteger)numberOfComponent {
    return self.rowOfComponent.count;
}


@end