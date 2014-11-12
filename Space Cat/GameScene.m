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
#import "LaserNode.h"
#import "SpaceDogNode.h"
#import "GroundNode.h"
#import "Util.h"
#import <AVFoundation/AVFoundation.h>
#import "HudNode.h"
#import "GameOverNode.h"
#import "AppDelegate.h"

@interface GameScene ()

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTimePlayed;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) NSInteger maxSpeed;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;
@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *laserSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;
@property (nonatomic) AVAudioPlayer *gameOverMusic;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) BOOL gameOverShowing;
@property (nonatomic) BOOL restart;

@end

@implementation GameScene{
    NSDictionary *timerInfo;
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        self.addEnemyTimeInterval = 0;
        self.totalGameTimePlayed = 0;
        self.minSpeed = SpaceDogMinSpeed;
        self.restart = NO;
        self.gameOver = NO;
        self.gameOverShowing = NO;
        
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
        
        GroundNode *ground = [GroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        [self addChild:ground];
        
        [self setUpSounds];
        
        //start at left edge of the screen and at the top of our screen // right below from the top
        self.hud = [HudNode hudAtPosition:CGPointMake(0, self.frame.size.height-20) inFrame:self.frame];
        [self addChild:self.hud];

        
    }
    return self;
}

-(void)setUpSounds {
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
    
    //once it loads, loops over, won't be playing it at the same time so can use mp3
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1; //repeat infinitely
    [self.backgroundMusic prepareToPlay]; //load and will have ready to play .. in didMoveToView (equivalent of ViewDidLoad)
    
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"GameOver" withExtension:@"mp3"];
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
    self.gameOverMusic.numberOfLoops = 1; //repeat infinitely
    [self.gameOverMusic prepareToPlay]; //load and will have ready to play .. in didMoveToView (equivalent of ViewDidLoad)

}

-(void)didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
    
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressed:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 100.0f;
    self.lpgr.cancelsTouchesInView = NO;
    self.lpgr.delaysTouchesBegan = NO;
    self.lpgr.delaysTouchesEnded = NO;
    self.lpgr.delegate = self;
    
    [self.view addGestureRecognizer:self.lpgr];
}

-(void)update:(NSTimeInterval)currentTime { //called right before every frame / every second the update method is being called, called before each frame is rendered / NSTimeInterval = current time in seconds, it's a double
//    NSLog(@"%f", fmod(currentTime, 60)); //modulo - see how many seconds left
    
    //to make multiple space dogs:
    if (self.lastUpdateTimeInterval) {
        self.timeSinceEnemyAdded += (currentTime - self.lastUpdateTimeInterval); //checking to see how many seconds passed since the last time the game run loop executed, then adding it to my timeSinceEnemyAdded property. add it to timeSinceEnemyAdded because it is continuously being added to every time you run through the update loop
        self.totalGameTimePlayed += (currentTime - self.lastUpdateTimeInterval);
    }
    
    if (self.timeSinceEnemyAdded > self.addEnemyTimeInterval && !self.gameOver) {
        [self addSpaceDog];
        self.timeSinceEnemyAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime; // time stamp of last game run loop
    
    if (self.totalGameTimePlayed > 480) { //or 8 minutes
        
        self.addEnemyTimeInterval = 0.5;
        self.minSpeed = SpaceDogMinSpeed - 60;
        self.maxSpeed = SpaceDogMaxSpeed - 60;
        
    } else if (self.totalGameTimePlayed > 240) { //or 4 minutes

        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = SpaceDogMinSpeed - 50;
        self.maxSpeed = SpaceDogMaxSpeed - 50;
        
    } else if (self.totalGameTimePlayed > 120) {
        
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = SpaceDogMinSpeed - 30;
        self.maxSpeed = SpaceDogMaxSpeed - 30;
        
    } else if (self.totalGameTimePlayed > 60) {
        
        self.addEnemyTimeInterval = 1.0;
        self.minSpeed = SpaceDogMinSpeed - 15;
        self.maxSpeed = SpaceDogMaxSpeed - 15;
        
    } else {
        self.addEnemyTimeInterval = 1.5;
        self.minSpeed = SpaceDogMinSpeed - 0;
        self.maxSpeed = SpaceDogMaxSpeed - 0;
    }
    
    //add !self.gameOverShowing so don't keep generating nodes from performGameOver after the first time game over.
    if (self.gameOver && !self.gameOverShowing) {
        [self performGameOver];
        self.gameOverShowing = YES;
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (!self.gameOver) {
        for (UITouch *touch in touches) {
            CGPoint position = [touch locationInNode:self];
            [self shootProjectileTowardsPosition:position];
        }
    } else if (self.restart) {
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        //if fire button touched, bring the rain
        if ([node.name isEqualToString:@"buttonNode"]) {
            AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
            appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ScoreNavigation"];
        } else {
            
            //safety measure that all current nodes are destroyed
            for (SKNode *node in [self children]) {
                [node removeFromParent];
            }
            //present brand new scene:
            GameScene *scene = [GameScene sceneWithSize:self.view.bounds.size];
            [self.view presentScene:scene];
            
        }

    }
}

-(void)performGameOver {
    
    PFObject *score = [PFObject objectWithClassName:@"Scores"];
    [score setObject:[PFUser currentUser] forKey:@"player"];
    score[@"score"] = [NSNumber numberWithInteger:self.hud.score];
    [score saveInBackground];
    
    GameOverNode *gameOverNode = [GameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self addChild:gameOverNode];
    self.restart = YES;
    [gameOverNode performAnimation];
    [self.backgroundMusic stop];
    [self.gameOverMusic play];
}

-(void)shootProjectileTowardsPosition:(CGPoint)position {
    
    SpaceCatNode *spaceCat = (SpaceCatNode*)[self childNodeWithName:@"SpaceCat"];
    [spaceCat performTap];
    
    MachineNode *machine = (MachineNode*)[self childNodeWithName:@"Machine"]; //get access to the machine and its position
    
    ProjectileNode *projectile = [ProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y+machine.frame.size.height-15)]; //starting position of projectile
    [self addChild:projectile];
    [projectile moveTowardsPosition:position]; //where user touches the screen - see above in touchesBegan
    
    [self runAction:self.laserSFX];
}

- (void)cellLongPressed:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"cellLongPressed in action");
    CGPoint position = [gestureRecognizer locationInView:self.view];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self shootLaserTowardsPosition:position];
            break;
        case UIGestureRecognizerStateEnded:
            if (self.laserTimer) {
                [self.laserTimer invalidate];
                self.laserTimer = nil;
            }
            break;
        case UIGestureRecognizerStateChanged:
            //change its shooting angle here
            break;
        case UIGestureRecognizerStateFailed:
            //
            break;
            
        default:
            break;
    }
}

-(void)shootLaserTowardsPosition:(CGPoint)position {
    
    SpaceCatNode *spaceCat = (SpaceCatNode*)[self childNodeWithName:@"SpaceCat"];
    [spaceCat performTap];
    
    MachineNode *machine = (MachineNode*)[self childNodeWithName:@"Machine"]; //get access to the machine and its position
    
    CGPoint ourPosition = position;
    
    timerInfo =  @{@"machine": machine,
                   @"positionX": [NSNumber numberWithFloat: ourPosition.x],
                   @"positionY": [NSNumber numberWithFloat: ourPosition.y]
                   };

    
    self.laserTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(runGameLoop:)
                                                userInfo:timerInfo
                                                 repeats:YES];
    
    [self runAction:self.laserSFX];
}

-(void)runGameLoop:(NSTimer*)timer {
    NSDictionary *info = [timer userInfo];
    MachineNode *machine = [info valueForKey:@"machine"];
    CGPoint position = CGPointMake([[info valueForKey:@"positionX"] floatValue], [[info valueForKey:@"positionY"] floatValue]);

    LaserNode *projectile = [LaserNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y+machine.frame.size.height-15)]; //starting position of projectile
    [self addChild:projectile];
    [projectile moveTowardsPosition:position]; //where user touches the screen - see above in touchesBegan
}


-(void)addSpaceDog {
    
    NSUInteger randomSpaceDog = [Util randomWithMin:0 max:1];
    SpaceDogNode *spaceDog = [SpaceDogNode spaceDogOfType:randomSpaceDog];
    spaceDog.physicsBody.velocity = CGVectorMake(0, [Util randomWithMin:self.minSpeed max:self.maxSpeed]);
    float y = self.frame.size.height + spaceDog.size.height;
    float x = [Util randomWithMin:10+spaceDog.size.width
                              max:self.frame.size.width-spaceDog.size.width];
    spaceDog.position = CGPointMake(x, y);
    [self addChild:spaceDog];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
//The properties bodyA and bodyB of SKPhysicsContact are not in a specific order so we cannot predict which nodes they represent.
    SKPhysicsBody *firstBody, *secondBody;
    
    //make sure that firstBody is always the smaller one.
    //enemy < projectile < debris < ground - see Util.h
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ( firstBody.categoryBitMask == CollisionCategoryEnemy &&
        secondBody.categoryBitMask == CollisionCategoryProjectile ) {
        
        SpaceDogNode *spaceDog = (SpaceDogNode *)firstBody.node;
        ProjectileNode *projectile = (ProjectileNode*)secondBody.node;
        
        if ([spaceDog isDamaged]) {
            [self runAction:self.explodeSFX];
            [self addPoints:PointsPerHit];
            [spaceDog removeFromParent];
            [projectile removeFromParent];
            [self createDebrisAtPosition:contact.contactPoint];
        }
        
        if (self.laserTimer) {
            [self.laserTimer invalidate];
            self.laserTimer = nil;
        }
        
    } else if ( firstBody.categoryBitMask == CollisionCategoryEnemy &&
               secondBody.categoryBitMask == CollisionCategoryGround ) {
        SpaceDogNode *spaceDog = (SpaceDogNode *)firstBody.node;
        [self runAction:self.damageSFX];
        [spaceDog removeFromParent];
        [self createDebrisAtPosition:contact.contactPoint];
        [self loseLife];
    }
}

-(void)addPoints:(NSInteger)points {
    HudNode *hud = (HudNode*)[self childNodeWithName:@"HUD"];
    [hud addPoints:points];
}

-(void)loseLife {
    HudNode *hud = (HudNode*)[self childNodeWithName:@"HUD"];
    self.gameOver = [hud loseLife];
}

-(void)createDebrisAtPosition:(CGPoint)position {
    NSInteger numberOfPieces = [Util randomWithMin:5 max:20];
    
    for (int i = 0; i < numberOfPieces; i++) {
        NSInteger randomPiece = [Util randomWithMin:1 max:3];
        NSString *imageName = [NSString stringWithFormat:@"debri_%ld", (long)randomPiece];
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.position = position;
        [self addChild:debris];
        
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.categoryBitMask = CollisionCategoryDebris;
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.collisionBitMask = CollisionCategoryGround | CollisionCategoryDebris;
        debris.name = @"Debris";
        debris.physicsBody.velocity = CGVectorMake([Util randomWithMin:-150 max:150], //x: left or right
                                                   [Util randomWithMin:150 max:450]); //y: higher than when it exploded, then fall b/c of gravity
        
        //remove from scene after 2 seconds:
        [debris runAction:[SKAction waitForDuration:2.0] completion:^{
        [debris removeFromParent];
        }];
        
    }
    
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
    //the particle effect is stored in the sks file which needs to be deserialized into an object
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.position = position;
    [self addChild:explosion];
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{
        [explosion removeFromParent];
    }];
}


@end
