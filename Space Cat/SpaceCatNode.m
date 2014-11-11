//
//  SpaceCatNode.m
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-10.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "SpaceCatNode.h"

//create class extension - private properties - no one else can have access even if they create instance of our class
@interface SpaceCatNode ()

@property (nonatomic, strong) SKAction *tapAction;

@end

@implementation SpaceCatNode

+(instancetype) spaceCatAtPosition:(CGPoint)position {
    SpaceCatNode *spaceCat = [self spriteNodeWithImageNamed:@"spacecat_1"];
    spaceCat.position = position;
    spaceCat.zPosition = 9;
    spaceCat.anchorPoint = CGPointMake(0.5, 0);
    spaceCat.name = @"SpaceCat";
    
    return spaceCat;
}

//override getter for SKAction
-(SKAction *)tapAction {
    //if someone has tapped
    if (_tapAction !=nil) {
        return _tapAction;
    } else {
        //if it hasn't been initialized, initiliaze our new action
        NSArray *textures = @[[SKTexture textureWithImageNamed:@"spacecat_2"],
                              [SKTexture textureWithImageNamed:@"spacecat_1"]];
        _tapAction = [SKAction animateWithTextures:textures timePerFrame:0.25];
        return _tapAction;
    }
}

-(void) performTap {
    [self runAction:self.tapAction];
}

@end
