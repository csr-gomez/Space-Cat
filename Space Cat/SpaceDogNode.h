//
//  SpaceDogNode.h
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-10.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
typedef NS_ENUM(NSUInteger, SpaceDogType) {
    SpaceDogTypeA = 0,
    SpaceDogTypeB = 1
};

@interface SpaceDogNode : SKSpriteNode

//if want more than one life/number of hits before damaged, make INT instead of BOOL.
@property (nonatomic, getter=isDamaged) BOOL damaged;

@property (nonatomic) SpaceDogType type;

+(instancetype) spaceDogOfType:(SpaceDogType)type;

@end