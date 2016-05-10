//
//  GameViewController.m
//  TextShooter
//
//  Created by lanou on 15/12/30.
//  Copyright (c) 2015年 WB. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "StartScene.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 配置视图
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // 创建并配置场景
//    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
//    scene.scaleMode = SKSceneScaleModeAspectFill; // 显示部分场景保留场景比例，居中显示
//    scene.scaleMode = SKSceneScaleModeAspectFit; // 显示全部并保留场景比例
//    scene.scaleMode = SKSceneScaleModeFill; // 显示全部场景并将场景拉伸至铺满屏幕
//    scene.scaleMode = SKSceneScaleModeResizeFill; // 显示部分场景保留场景比例显示左下角
    // 呈现场景
//    GameScene *scene = [GameScene sceneWithSize:self.view.frame.size levelNumber:1];
    SKScene *scene = [StartScene sceneWithSize:skView.bounds.size];
    [skView presentScene:scene];
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

// prefersStatusBarHidden可以让iOS的状态栏在游戏运行时消失，YES为隐藏，NO为不隐藏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
