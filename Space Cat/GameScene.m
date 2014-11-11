//
//  GameScene.m
//  Space Cat
//
//  Created by Daniel Mathews on 2014-11-02.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "GameScene.h"
#import "MachineNode.h"
#import "SpaceCatNode.h"
#import "ProjectileNode.h"
#import "SpaceDogNode.h"
#import "GroundNode.h"
#import "Util.h"

@implementation GameScene

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)); //get middle of scene's frame
        background.size = self.frame.size;
        [self addChild:background];
        
        MachineNode *machine = [MachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
        [self addChild:machine];
        
        SpaceCatNode *spaceCat = [SpaceCatNode spaceCatAtPosition:CGPointMake(machine.position.x, machine.position.y-2)]; // get the midpoint of the machine b/c you want cat in front of the machine
        [self addChild:spaceCat];
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self;
        
        [self addSpaceDog];
        
        GroundNode *ground = [GroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        [self addChild:ground];
        
    }
    return self;
}

//-(void)update:(NSTimeInterval)currentTime { //every second the update method is being called, called before each frame is rendered
//    
////    NSTimeInterval = current time in seconds, it's a double
////    NSLog(@"%f", fmod(currentTime, 60)); //modulo - see how many seconds left
//    
//    
//}

//-(void)didMoveToView:(SKView *)view {
//    /* Setup your scene here */
//    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    
//    myLabel.text = @"Hello, World!";
//    myLabel.fontSize = 65;
//    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                   CGRectGetMidY(self.frame));
//    
//    [self addChild:myLabel];
//}

//inherits from UIResponder???
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint position = [touch locationInNode:self];
        [self shootProjectileTowardsPosition:position];
    }
}

-(void)shootProjectileTowardsPosition:(CGPoint)position {
    
    SpaceCatNode *spaceCat = (SpaceCatNode*)[self childNodeWithName:@"SpaceCat"];
    [spaceCat performTap];
    
    MachineNode *machine = (MachineNode*)[self childNodeWithName:@"Machine"]; //get access to the machine and its position
    
    ProjectileNode *projectile = [ProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y+machine.frame.size.height-15)]; //starting position of projectile
    [self addChild:projectile];
    [projectile moveTowardsPosition:position]; //where user touches the screen - see above in touchesBegan
    
}

-(void)addSpaceDog {
    SpaceDogNode *spaceDogA = [SpaceDogNode spaceDogOfType:SpaceDogTypeA];
    spaceDogA.position = CGPointMake(100, 300);
    [self addChild:spaceDogA];
    
    SpaceDogNode *spaceDogB = [SpaceDogNode spaceDogOfType:SpaceDogTypeB];
    spaceDogB.position = CGPointMake(200, 300);
    [self addChild:spaceDogB];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    if (contact.bodyA.categoryBitMask==CollisionCategoryEnemy && contact.bodyB.categoryBitMask==CollisionCategoryProjectile) {
        SpaceDogNode = contact.bodyA.node;
    } else if (contact.bodyA.categoryBitMask==CollisionCategoryEnemy && contact.bodyB.categoryBitMask==CollisionCategoryGround) {
        
    }
}


@end
