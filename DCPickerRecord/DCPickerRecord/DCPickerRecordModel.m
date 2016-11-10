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

-(void)setDc_didSelectedBlock:(void (^)())dc_didSelectedBlock {
    objc_setAssociatedObject(self, @selector(dc_didSelectedBlock), dc_didSelectedBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)())dc_didSelectedBlock {
    return objc_getAssociatedObject(self, _cmd);
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
    if (self.dc_numberOfComponentsBlock) {
        return self.dc_numberOfComponentsBlock(pickerView);
    }
    return self.numberOfComponent;
}

-(NSInteger)dc_pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.dc_numberOfRowsInComponentBlock) {
        return self.dc_numberOfRowsInComponentBlock(component);
    }
    return self.data ? ((NSArray *)self.data[component]).count : 0;
}

-(NSString *)dc_pickerViewInitTitleWithRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.dc_initTitleWithIndexPathBlock) {
        return self.dc_initTitleWithIndexPathBlock([NSIndexPath indexPathForRow:row inComponent:component],self.data);
    }
    id item = self.data[component][row];
    return [item isKindOfClass:[NSString class]] ? item : @"";
}

- (void)dc_pickerViewDidSelectedWithRow:(NSInteger)row inComponent:(NSInteger)component pickerView:(UIPickerView *)picker {
    id item = self.data[component][row];
    [self saveRowOfComponent:component row:row];
    if (self.dc_didSelectedBlock) {
        self.dc_didSelectedBlock([NSIndexPath indexPathForRow:row inComponent:component],item,self.rowOfComponent);
    }
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
#pragma mark - =============== RecordModelCreation category methods ===============
@implementation DCPickerRecordModel (RecordModelCreation)

+ (instancetype)recordModelData:(NSArray *)data {
    DCPickerRecordModel *model = [[self alloc] init];
    model.data = data;
    return model;
}

+ (instancetype)recordModelData:(NSArray *)data
              numberOfComponent:(NSInteger (^)())components
                rowsInComponent:(NSInteger (^)(NSInteger))rowsInComponent
                         titles:(NSString *(^)(NSIndexPath *index,NSArray *data))titleBlock
                    didSelected:(void (^)())selectedBlock {
    DCPickerRecordModel *model = [[self alloc] init];
    model.data = data;
    model.dc_numberOfComponentsBlock = components;
    model.dc_numberOfRowsInComponentBlock = rowsInComponent;
    model.dc_initTitleWithIndexPathBlock = titleBlock;
    model.dc_didSelectedBlock = selectedBlock;
    return model;
}

@end
#pragma mark - =============== BlocksKit category methods ===============

@implementation DCPickerRecordModel (BlocksKit)

-(void)setDc_initTitleWithIndexPathBlock:(NSString *(^)(NSIndexPath *, NSArray *))dc_didSelectedBlock {
    objc_setAssociatedObject(self, @selector(dc_initTitleWithIndexPathBlock), dc_didSelectedBlock, OBJC_ASSOCIATION_COPY);
}

- (NSString *(^)(NSIndexPath *, NSArray *))dc_initTitleWithIndexPathBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDc_numberOfRowsInComponentBlock:(NSInteger (^)(NSInteger))dc_numberOfRowsInComponentBlock {
    objc_setAssociatedObject(self, @selector(dc_numberOfRowsInComponentBlock), dc_numberOfRowsInComponentBlock, OBJC_ASSOCIATION_COPY);
}

- (NSInteger (^)(NSInteger))dc_numberOfRowsInComponentBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDc_numberOfComponentsBlock:(NSInteger (^)())dc_numberOfComponentsBlock {
    objc_setAssociatedObject(self, @selector(dc_numberOfComponentsBlock), dc_numberOfComponentsBlock, OBJC_ASSOCIATION_COPY);
}

- (NSInteger (^)())dc_numberOfComponentsBlock {
    return objc_getAssociatedObject(self, _cmd);
}

@end

