//
//  Util.m
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-10.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "Util.h"

@implementation Util

+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max{
//    return min+arc4random_uniform(max+1-min);
    return arc4random()%((max+1)-min) + min; //arc4random() returns a random unsigned int. When modulo between arc4random’s result and range, you’ll get a range from 0 to 1 less than the range. Adding min to it will place the result in the (min, max) range.
}

@end
