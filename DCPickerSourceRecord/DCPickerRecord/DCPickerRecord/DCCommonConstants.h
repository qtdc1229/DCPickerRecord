//
//  DCCommonConstants.h
//  DCPickerSourceRecordDemo
//
//  Created by dingchao on 15/11/25.
//  Copyright © 2015年 dingc. All rights reserved.
//

#ifndef DCCommonConstants_h
#define DCCommonConstants_h



#endif /* DCCommonConstants_h */

#if __has_feature(objc_arc)

#define dc__release(expression)       expression
#define dc__autorelease(expression)   expression

#else

#define dc__release(expression)       [expression release]
#define dc__autorelease(expression)   [expression autorelease]

#endif