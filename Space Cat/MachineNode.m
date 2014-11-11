//
//  MachineNode.m
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-10.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "MachineNode.h"

@implementation MachineNode

+(instancetype) machineAtPosition:(CGPoint)position {
    MachineNode *machine = [self spriteNodeWithImageNamed:@"machine_1"];
    machine.position = position;
    machine.anchorPoint = CGPointMake(0.5, 0);
    machine.name = @"Machine";
    
    //array of textures
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"machine_1"],
                          [SKTexture textureWithImageNamed:@"machine_2"]];
    
    SKAction *machineAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    //how long will this action be repeated
    SKAction *machineRepeat = [SKAction repeatActionForever:machineAnimation];
    
    [machine runAction:machineRepeat];
    
    return machine;
}

@end
