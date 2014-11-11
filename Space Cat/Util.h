//
//  Util.h
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-10.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int ProjectileSpeed = 400;

//for bitmask
//Shift Operator - shift the bit left by 0.
// 0001 << 1 = 0010
//moving bit one

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryEnemy              = 1 << 0, //0000
    CollisionCategoryProjectile         = 1 << 1, //0010 move bit once to left
    CollisionCategoryDebris             = 1 << 2, //0100 move bit 2x to the left
    CollisionCategoryGround             = 1 << 3  //1000 move 3x to the left
};

@interface Util : NSObject

@end
