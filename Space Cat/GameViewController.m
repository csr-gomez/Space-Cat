//
//  GameViewController.m
//  Space Cat
//
//  Created by Daniel Mathews on 2014-11-02.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "TitleScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser==nil) {
        //no one is logged in, go to login page
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
    } else {
        //if CurrentUser is logged in
         NSLog(@"Current user: %@", currentUser.username);
        
        // Configure the view.
        SKView * skView = (SKView *)self.view;
        skView.showsFPS = NO; //turn off when done testing
        skView.showsNodeCount = NO;
        
        // Create and configure the scene.
        SKScene * scene = [TitleScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        
        // Present the scene.
        [skView presentScene:scene];
        
    }

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
