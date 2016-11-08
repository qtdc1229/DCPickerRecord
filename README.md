# DCPickerRecord

Quick recoder for UIPickerView

##What
什么是DCPickerRecord？一句话：快速记录UIPickerView的工具。

你不用再去管理UIPickerView的代理方法，你只需要给他数据就可以了

#Why
以往使用Picker 你至少要实现 **UIPicker** 以下的代理。

假设我们要实现一个星期的picker选择：

```objective-c
NSArray *array = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天"];
```


```objective-c

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger ret = array.count;	
    // 总共的列数
    return ret;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
		 NSInteger ret = array.count;
		 //某一列的行数
		 return ret;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *ret = array[row];
    // ret = @#(你某一列某一行显示的内容)
    return ret;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

		//选择某一行后的行动
		// do something
}

```

这里你至少要实现四个方法，而且管理混乱：需要在每个需要控制地方去实现。

接下来让我给你展示新的方式。

##How
只要一句就能完成：

```objective-c

[[DCPickerRecorder shareRecorder] dc_pickerView:self.pickerView
                                         recordData:@[@[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天"]]
                                  didSelectedAction:^(NSIndexPath *index,NSString *data){
						// do sth
                                  }];

```