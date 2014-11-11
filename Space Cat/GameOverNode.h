//
//  GameOverNode.h
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-11.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverNode : SKNode

+(instancetype) gameOverAtPosition:(CGPoint)position;

-(void)performAnimation;

@end
