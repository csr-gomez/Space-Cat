//
//  Util.h
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-10.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int ProjectileSpeed = 400;
static const int SpaceDogMinSpeed = -100;
static const int SpaceDogMaxSpeed = -50;
static const int MaxLives = 3;
static const int PointsPerHit = 10;
//for bitmask
//Shift Operator - shift the bit left by 0.
// 0001 << 1 = 0010
//moving bit one

//These constants are known as "bit masks". They're values that have bits set in particularly interesting positions. We can take an individual bit mask, like CollisionCategoryEnemy and use it to twiddle that individual bit in some piece of memory, such as a method parameter.

typedef NS_OPTIONS(uint32_t, CollisionCategory) { //binary + hex representaions
    CollisionCategoryEnemy              = 1 << 0, //00000001 (value of 1, unchanged) + 0x01
    CollisionCategoryProjectile         = 1 << 1, //00000010 move single-bit number 1 once to left + 0x02
    CollisionCategoryDebris             = 1 << 2, //00000100 move bit 2x to the left + 0x04
    CollisionCategoryGround             = 1 << 3  //00001000 move 3x to the left + 0x08
};

@interface Util : NSObject

+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max;

@end
