//
//  cityPickers.m
//  DCPickerSourceRecordDemo
//
//  Created by dingchao on 16/1/6.
//  Copyright © 2016年 dingc. All rights reserved.
//

#import "CityPickers.h"

@implementation CityModel

+(instancetype)cityWithName:(NSString *)name province:(NSString *)province {
    CityModel *city = [[self alloc] init];
    city.name = name;
    city.province = province;
    return city;
}
@end


@implementation CityPickers

-(NSArray *)cityArray {
    if (!_cityArray) {
        _cityArray = @[@[[CityModel cityWithName:@"无" province:@"无"]],
                       @[[CityModel cityWithName:@"北京" province:@"北京"]],
                       @[[CityModel cityWithName:@"上海" province:@"上海"]],
                       @[[CityModel cityWithName:@"深圳" province:@"广东"],[CityModel cityWithName:@"广州" province:@"广东"],[CityModel cityWithName:@"惠州" province:@"广东"]],
                       @[[CityModel cityWithName:@"南宁" province:@"广西"],[CityModel cityWithName:@"桂林" province:@"广西"],[CityModel cityWithName:@"北海" province:@"广西"]],
                       @[[CityModel cityWithName:@"成都" province:@"四川"],[CityModel cityWithName:@"绵阳" province:@"四川"]]];
    }
    return _cityArray;
}

- (NSInteger)dc_pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger row = (component == 0 ?
                     [self.cityArray count] :
                     [self.cityArray[[self dc_rowOfComponent:0]] count]);
    return row;
}

-(NSString *)dc_pickerViewInitTileWithRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *title = (component == 0) ? ((CityModel *)self.cityArray[row][0]).province : ((CityModel *)self.cityArray[[self dc_rowOfComponent:0]][row]).name;
    return title;
}

-(void)dc_pickerViewDidSelectedWithRow:(NSInteger)row inComponent:(NSInteger)component pickerView:(UIPickerView *)picker {
    [super dc_pickerViewDidSelectedWithRow:row inComponent:component pickerView:picker];
    if (component == 0) {
        [picker reloadComponent:1];
    }
    if (self.dc_didSelectedBlock) {
        NSArray *cityArray = self.cityArray[[self dc_rowOfComponent:0]];
        CityModel *city =  ([self dc_rowOfComponent:1] > cityArray.count - 1) ? cityArray[cityArray.count - 1] : cityArray[[self dc_rowOfComponent:1]];
        
        self.dc_didSelectedBlock([NSIndexPath indexPathForRow:[self dc_rowOfComponent:1] inComponent:1],city);
    }
    
}

-(NSInteger)dc_numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger components = 2;
    [self dc_initRowOfComponents:components];
    return components;
}

@end
