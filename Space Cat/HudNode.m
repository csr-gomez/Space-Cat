//
//  HudNode.m
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-11.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "HudNode.h"
#import "Util.h"

@implementation HudNode

+(instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame{
    HudNode *hud = [self node];
    hud.position = position;
    //zPosition: how far or near node is placed near the user. higher the number, the closer it is to the user. lower, further. we want hud to be the first node that appears in front of all the other nodes. so set it high to 10.
    hud.zPosition = 10;
    hud.name = @"HUD";
    SKSpriteNode *catHead = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_cat_1"];
    catHead.position = CGPointMake(30, -10); //position within HUD
    [hud addChild:catHead];
    
    hud.lives = MaxLives; //4
    
    SKSpriteNode *lastLifeBar;

    for (int i = 0; i < hud.lives; i++) {
        SKSpriteNode *lifeBar = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_life_1"]; //one life bar
        lifeBar.name = [NSString stringWithFormat:@"Life%ld", (long)(i+1)];
        [hud addChild:lifeBar];
        
        if (lastLifeBar == nil ) { //if one life, place it 30 poits to right of cat head
            lifeBar.position = CGPointMake(catHead.position.x+30, catHead.position.y);
        } else { // if more than one life, the lifebar you add will be 10 points to right of last life bar
            lifeBar.position = CGPointMake(lastLifeBar.position.x+10, lastLifeBar.position.y);
        }
        
        lastLifeBar = lifeBar; //record position of last life bar just placed.
    }
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    scoreLabel.name = @"Score";
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 24;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    scoreLabel.position = CGPointMake(frame.size.width-20, -10);
    [hud addChild:scoreLabel];
    
    return hud;
}

-(void)addPoints:(NSInteger)points {
    self.score += points;
    
    SKLabelNode *scoreLabel = (SKLabelNode*)[self childNodeWithName:@"Score"]; //find our scoreLabel
    scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
}

-(BOOL)loseLife {
    if (self.lives > 0) {
        NSString *lifeNodeName = [NSString stringWithFormat:@"Life%ld", (long)self.lives];
        SKNode *lifeToRemove = [self childNodeWithName:lifeNodeName];
        [lifeToRemove removeFromParent];
        self.lives--;
    }
    return self.lives == 0;
}

@end
