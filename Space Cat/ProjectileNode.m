//
//  ProjectileNode.m
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-10.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "ProjectileNode.h"
#import "Util.h"

@implementation ProjectileNode

+(instancetype) projectileAtPosition:(CGPoint)position {
    ProjectileNode *projectile = [self spriteNodeWithImageNamed:@"projectile_1"];
    projectile.position = position;
    projectile.name = @"Projectile";
    
    [projectile setUpAnimation];
    [projectile setupPhysicsBody];
    
    return projectile;
}

-(void)setUpAnimation {
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"projectile_1"],
                          [SKTexture textureWithImageNamed:@"projectile_2"],
                          [SKTexture textureWithImageNamed:@"projectile_3"]];
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    SKAction *repeatAction = [SKAction repeatActionForever:animation];
    [self runAction:repeatAction];
}

-(void)setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryProjectile;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryEnemy;
}

-(void)moveTowardsPosition:(CGPoint)position {
    //slope = y3-y1/x3-x1
    //position being passed to our method is where our user is touching the screen (x3, y3)
    //self.position is the orig position of our projectile (x1, y1)
    float slope = (position.y - self.position.y)/(position.x - self.position.x);
    
    //final yellow point is (-10, y2)
    //slope = y2-y1/x2-x1 - we know the slope, what is unknown here is y2
    //y2-y1 = slope * (x2-x1)
    //y2 = (slope * (x2-x1)) + y1
    float offscreenX;
    if (position.x <= self.position.x) { //if user clicks to the left of the screen
        offscreenX = -10;
    } else {
        offscreenX = self.parent.frame.size.width + 10;
    }
    
    float offscreenY = slope * offscreenX - slope * self.position.x + self.position.y;
    
    CGPoint pointOffscreen = CGPointMake(offscreenX, offscreenY);
    
    float distanceA = pointOffscreen.y - self.position.y;
    float distanceB = pointOffscreen.x - self.position.x;
    
    float distanceC = sqrtf(powf(distanceA, 2) + powf(distanceB, 2));
    
    //distance = speed * time
    //time = distance / speed
    
    float time = distanceC / ProjectileSpeed;
    float fadeOutTime = 0.75*time;
    float fadeTime = time - fadeOutTime;
    
    SKAction *moveProjectile = [SKAction moveTo:pointOffscreen duration:time];
    [self runAction:moveProjectile];
    
    NSArray *sequence = @[[SKAction waitForDuration:fadeOutTime],
                          [SKAction fadeOutWithDuration:fadeTime],
                          [SKAction removeFromParent]]; //generally scene manages for us, but good practice to remove nodes
    [self runAction:[SKAction sequence:sequence]];
}

@end
