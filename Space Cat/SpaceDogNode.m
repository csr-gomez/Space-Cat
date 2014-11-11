//
//  SpaceDogNode.m
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-10.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "SpaceDogNode.h"
#import "Util.h"

@implementation SpaceDogNode

+(instancetype) spaceDogOfType:(SpaceDogType)type {
    SpaceDogNode *spaceDog;
    
    NSArray *textures;
    
    if (type==SpaceDogTypeA) {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_A_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_A_2"],
                     [SKTexture textureWithImageNamed:@"spacedog_A_3"]];
    } else {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_2"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_3"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_4"]];
    }
    
    //randomize the size between 85% and 100% big.. default value of xScale and yScale is 1.0 or 100%
    float scale = [Util randomWithMin:85 max:100]/100.0f;
    spaceDog.xScale = scale;
    spaceDog.yScale = scale;
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    [spaceDog runAction:[SKAction repeatActionForever:animation]];
    [spaceDog setUpPhysicsBody];
    
    return spaceDog;
}

-(void)setUpPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryGround | CollisionCategoryProjectile; //or operation - 0010 | 1000 = 1010
    
}

@end
