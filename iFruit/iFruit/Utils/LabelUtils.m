////
////  LabelUtils.m
////  iFruit
////
////  Created by mac on 11-12-31.
////  Copyright 2011年 asiainfo-linkage. All rights reserved.
////
//
//#import "LabelUtils.h"
//
//
//@implementation LabelUtils
//
//
//-(void) test {
//    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:20];
//    [ary retain];
//
//    
//    int length = [copyStr length];
//
//    int line = 1; // 必须要有一行
//    int wordCount = 0; // 标记第几个字
//
//    for (int i = 0; i < length; i++) 
//    {
//        // 发现回车行数加1
//        if ([copyStr characterAtIndex:i] == '\n') 
//        {
//            line++;
//            //NSLog(@"subStr === %@",[copyStr substringToIndex:i]);
//            [ary addObject:[copyStr substringToIndex:i]];
//            //NSLog(@"剩余的字符串:%@",[copyStr substringFromIndex:i+1]);
//            copyStr = [copyStr substringFromIndex:i+1];
//            length = [copyStr length];// 截取了回车之前的部分之后，就要从新计算剩余字符串的长度
//            wordCount = 0;
//            i = 0;
//        }
//        
//        
//        if (wordCount*14 > 300) 
//        {
//            line++;
//            //NSLog(@"第一次截取 :%@",[copyStr substringToIndex:wordCount]);
//            [ary addObject:[copyStr substringToIndex:wordCount]];
//            copyStr = [copyStr substringFromIndex:wordCount];
//            //NSLog(@"省下的 === %@",copyStr);
//            length = [copyStr length];
//            if (length < kTextCount) 
//            {
//                [ary addObject:copyStr];
//            }
//            //NSLog(@"省下的长度 === %d",length);
//            wordCount = 0; // 如果发现，到某个字的时候，总的宽度大于了300我们就要手动换行，然后从新开始记数
//            i = 0; // 从新开始循环变量也要归0
//        }
//        
//        //NSLog(@"i == %d",i);
//        wordCount++;
//    
//    
//}
//
////CGSize size = [kString sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:14] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeWordWrap];
//
////[self schedule:@selector(setSubString:) interval:0.03];
//
//}
//
//
//NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
//
//NSMutableString* mStr = [[NSMutableString alloc] init];
//
//int lineCount = 0;
//int maxLine = [ary count];
//
//// 4句话合成一句话
//for(NSString* str in ary)
//{
//    [mStr appendString:str];
//    
//    lineCount++;
//    if(lineCount%4==0||lineCount>=maxLine)
//    {
//        [array addObject:[NSString stringWithFormat:@"%@",mStr]];
//        [mStr deleteCharactersInRange:NSMakeRange(0, [mStr length])];
//    }
//}
//
//// 获取完之后，由于从新组合了数组，我们把这哥ary清空，从新放入新数组中的对象，就是一个方便
//[ary removeAllObjects];
//
//for (int n = 0; n < [array count]; n++) 
//{
//    //NSLog(@"array[%d] == %@",n,[array objectAtIndex:n]);
//    
//    [ary addObject:[array objectAtIndex:n]];
//}
//
//// 标记重新组合的字符串在数组中的索引
//printID = 0;
//[self nextPrint];
//
//return self;
//}
//
//-(void)nextPrint
//{
//	// 标记搜索到的字符数
//	printIndex = 0;
//	strPrint = [ary objectAtIndex:printID];
//	// 求拿出来的字符串的长度
//	maxPrint = [strPrint length];
//	printID++;
//	
//	[self schedule:@selector(print:) interval:0.05];
//	
//}
//
//-(void)print:(ccTime)step
//{
//	printIndex++;
//	[self printString:strPrint index:printIndex];
//	
//	if(printIndex>=maxPrint)
//	{
//		[self unschedule:_cmd];
//		
//		if (printID < [ary count]) 
//		{
//			[self nextPrint];
//		}
//		
//	}
//}
//
//
//-(void)printString:(NSString*)str index:(int)index
//{
//    
//	[label setString:[str substringToIndex:index]];
//}
//
//
//@end
