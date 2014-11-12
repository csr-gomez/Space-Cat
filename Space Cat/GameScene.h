//
//  GameScene.h
//  Space Cat
//

//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//  Test

#import <SpriteKit/SpriteKit.h>
#import "HudNode.h"
#import <Parse/Parse.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) UILongPressGestureRecognizer *lpgr;
@property (nonatomic) NSTimer *laserTimer;
@property (nonatomic) NSTimer *stopLaserTimer;
@property (nonatomic) HudNode *hud;

@end
