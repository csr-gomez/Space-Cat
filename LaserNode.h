//
//  LaserNode.h
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-11.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@interface LaserNode : SKShapeNode
//@interface LaserNode : SKSpriteNode

+(instancetype) projectileAtPosition:(CGPoint)position;
-(void)moveTowardsPosition:(CGPoint)position;

@end
