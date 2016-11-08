//
//  HotelPickerProcessorDataModel.h
//  MTonight
//
//  Created by dingc on 12-12-13.
//  Copyright (c) 2012年 dingc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSIndexPath (DCRecorder)

@property (nonatomic ,readonly)NSInteger      component;

+ (instancetype)indexPathForRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@protocol DCPickerRecordModelProtocol <NSObject>

@property (nonatomic ,copy)NSArray   *data;
/**
 *  @brief  get the instance of class
 *
 *  @return instance of class
 */
+ (instancetype)shareRecordModel;
/**
 *  @brief
 *
 *  @param row       行
 *  @param component 列
 *
 *  @return 列返回数据
 */
- (NSString *)dc_pickerViewInitTileWithRow:(NSInteger)row inComponent:(NSInteger)component;
/**
 *  @brief picker did select a row
 *
 *  @param row       row
 *  @param component component
 *  @param picker    picker
 */
- (void)dc_pickerViewDidSelectedWithRow:(NSInteger)row inComponent:(NSInteger)component pickerView:(UIPickerView *)picker;
/**
 *  @brief
 *
 *  @param pickerView pickerview
 *
 *  @return 列的总数
 */
- (NSInteger)dc_numberOfComponentsInPickerView:(UIPickerView *)pickerView;
/**
 *  @brief 统计某行每列有多少
 *
 *  @param pickerView PickerView
 *  @param component  component of index
 *
 *  @return 返回某一行有多少列
 */
- (NSInteger)dc_pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
@optional
/**
 *  @brief 确认动作
 */
- (void)dc_confirmAction;
@end

@interface DCPickerRecordModel : NSObject <DCPickerRecordModelProtocol>

@property (nonatomic ,copy) void (^dc_didSelectedBlock)();
@property (nonatomic, readonly) NSInteger         numberOfComponent;
@property (nonatomic, readonly) NSMutableArray    *rowOfComponent;

/**
 *  @brief 重新选择上次已选数据
 *
 *  @param pickerView pickerView
 */
- (void)dc_PickerViewSelectedComponentsRow:(UIPickerView *)pickerView;

// 初始化 列数据(components) 用于保存每一列的行
- (void)dc_initRowOfComponents:(NSInteger)component;

// 返回 某一列的已选行数
- (NSInteger)dc_rowOfComponent:(NSInteger)component;

// 数据清零
- (void)backRowOfComponentToZero;

//获取之前的选择信息
- (NSInteger)readOldDataOfComponent:(NSInteger)component;


@end



