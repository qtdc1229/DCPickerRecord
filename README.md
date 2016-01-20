# DCPickerRecord
Quick recoder for UIPickerView

##简介
DCPickerRecord 是用来简化UIPickerView 管理以及使用的组件。

以往使用Picker 需要实现UIPicker 的代理，


```objective-c
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *ret = @"";
    // ret = 你某一行显示的内容
    return ret;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
		//选择某一行后的行动
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger ret = 0;	
    // 总共的列数
    return ret;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
		 NSInteger ret = 0;
		 //某一列的行数
		 return ret;
}
```

Picker 的选择记录记录比较混乱。