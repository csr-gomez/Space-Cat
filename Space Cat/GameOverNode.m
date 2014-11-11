//
//  GameOverNode.m
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-11.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "GameOverNode.h"

@implementation GameOverNode

+(instancetype) gameOverAtPosition:(CGPoint)position {
    GameOverNode *gameOverNode = [self node];
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    gameOverLabel.name = @"GameOver";
    gameOverLabel.text = @"Game Over!";
    gameOverLabel.fontSize = 50;
    gameOverLabel.position = position;
    [gameOverNode addChild:gameOverLabel];
    
    return gameOverNode;
}

-(void)performAnimation {
    SKLabelNode *label1 = (SKLabelNode*)[self childNodeWithName:@"GameOver"];
    SKLabelNode *label2 = (SKLabelNode*)[self childNodeWithName:@"Click"];
    label1.xScale = 0;
    label1.yScale = 0;
    label2.xScale = 0;
    label2.yScale = 0;
    SKAction *scaleUp = [SKAction scaleTo:1.2f duration:0.75];
    SKAction *scaleDown = [SKAction scaleTo:0.9f duration:0.25];
    SKAction *addClick = [SKAction runBlock:^{
        SKLabelNode *clickLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        clickLabel.name = @"Click";
        clickLabel.text = @"Touch Screen to Play Again";
        clickLabel.fontSize = 30;
        clickLabel.position = CGPointMake(label1.position.x, label1.position.y-40);
        [self addChild:clickLabel];
    }];
    SKAction *scale = [SKAction sequence:@[scaleUp, scaleDown, addClick]];
    [label1 runAction:scale];
    
}

@end
