//
//  GameOverNode.m
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-11.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "GameOverNode.h"
#import "AppDelegate.h"

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
    
    __weak GameOverNode *safeSelf = self;
    SKAction *addClick = [SKAction runBlock:^{
        SKLabelNode *clickLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
        clickLabel.name = @"Click";
        clickLabel.text = @"Touch Screen to Play Again";
        clickLabel.fontSize = 30;
        clickLabel.position = CGPointMake(label1.position.x, label1.position.y-40);
        [safeSelf addChild:clickLabel];
        
        SKSpriteNode *buttonNode = [SKSpriteNode spriteNodeWithImageNamed:@"scoreboard"];
        buttonNode.position = CGPointMake(label1.position.x, label1.position.y-80);
        buttonNode.name = @"buttonNode";//how the node is identified later
        buttonNode.zPosition = 1.0;
        [safeSelf addChild:buttonNode];
        
    }];
    SKAction *scale = [SKAction sequence:@[scaleUp, scaleDown, addClick]];
    [label1 runAction:scale];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"buttonNode"]) {
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ScoreNavigation"];
    }
}

@end
