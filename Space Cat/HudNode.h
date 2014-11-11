//
//  HudNode.h
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-11.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HudNode : SKNode

@property (nonatomic) NSInteger lives;
@property (nonatomic) NSInteger score;

+(instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame;

-(void)addPoints:(NSInteger)points;
-(BOOL)loseLife;

@end
