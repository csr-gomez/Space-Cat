//
//  TitleScene.m
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-10.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//


#import "TitleScene.h"
#import "GameScene.h"
#import <AVFoundation/AVFoundation.h>

@interface TitleScene ()

@property (nonatomic) SKAction *pressStartSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;

@end

@implementation TitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splash_1"];
        background.size = self.frame.size;
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
        //once it loads, loops over, won't be playing it at the same time so can use mp3
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@"mp3"];
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.backgroundMusic.numberOfLoops = -1; //repeat infinitely
        [self.backgroundMusic prepareToPlay]; //load and will have ready to play .. in didMoveToView (equivalent of ViewDidLoad)
        
    }
    return self;
}

- (void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.backgroundMusic stop];
    [self runAction:self.pressStartSFX];
    GameScene *gamePlayScene = [GameScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}

@end
