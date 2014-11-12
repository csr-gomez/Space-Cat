//
//  GameScene.h
//  Space Cat
//

//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//  Test

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) UILongPressGestureRecognizer *lpgr;
@property (nonatomic) NSTimer *laserTimer;
@property (nonatomic) NSTimer *stopLaserTimer;

@end
