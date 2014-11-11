//
//  ProjectileNode.h
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-10.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ProjectileNode : SKSpriteNode

+(instancetype) projectileAtPosition:(CGPoint)position;
-(void)moveTowardsPosition:(CGPoint)position;

@end
