//
//  GameScene.m
//  TextShooter
//
//  Created by lanou on 15/12/30.
//  Copyright (c) 2015年 WB. All rights reserved.
//

#import "GameScene.h"
#import "PlayerNode.h"
#import "EnemyNode.h"
#import "BulletNode.h"
#import "SKNode+Extra.h"
#import "GameOverScene.h"
#import "PhysicsCategories.h"
@interface GameScene()<SKPhysicsContactDelegate>

@property (strong, nonatomic) PlayerNode *playerNode;
@property (strong, nonatomic) SKNode *enemies;
@property (strong, nonatomic) SKNode *playerBullets;
@property (strong, nonatomic) SKNode *forceFields;

@end


@implementation GameScene

+ (instancetype)sceneWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber {
    return [[self alloc] initWithSize:size levelNumber:levelNumber];
}

- (instancetype)initWithSize:(CGSize)size {
    return [self initWithSize:size levelNumber:1];
}

- (instancetype)initWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber {
    if (self = [super initWithSize:size]) {
        _levelNumber = levelNumber;
        _playerLives = 5;
        
        self.backgroundColor = [SKColor whiteColor];
        
        SKLabelNode *lives = [SKLabelNode labelNodeWithFontNamed:@"Courier"]; // 创建显示生命的label，并设置字体类型
        lives.fontSize = 16; // 设置字体大小
        lives.fontColor = [SKColor blackColor]; // 设置字体颜色
        lives.name = @"LivesLabel"; // 设置lives名称
        lives.text = [NSString stringWithFormat:@"Lives:%lu",(unsigned long)_playerLives]; // 设置lives内容
        lives.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop; // 设置垂直对齐方式，居于顶部
        lives.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight; // 设置水平对齐方式，居于右侧
        lives.position = CGPointMake(self.frame.size.width, self.frame.size.height); // 将位置信息设置为lives的坐标
        
        [self addChild:lives]; // 将lives载入场景中
        
        SKLabelNode *level = [SKLabelNode labelNodeWithFontNamed:@"Courier"]; // 创建显示难度等级的label，并设置字体类型
        level.fontSize = 16; // 设置字体大小
        level.fontColor = [SKColor blackColor]; // 设置字体颜色
        level.name = @"LevelLabel"; // 设置level名称
        level.text = [NSString stringWithFormat:@"Level:%lu",(unsigned long)_levelNumber]; // 设置level内容
        level.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop; // 设置垂直对齐方式，居于顶部
        level.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft; // 设置水平对齐方式，居于左侧
        level.position = CGPointMake(0, self.frame.size.height); // 将位置信息设置为level的坐标
        
        [self addChild:level]; // 将level载入场景中
        
        _playerNode = [PlayerNode node];
        _playerNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) * 0.1);
        [self addChild:_playerNode];
        _enemies = [SKNode node]; // 创建敌人节点
        [self addChild:_enemies]; // 将敌人节点导入
        [self spawnEnemies]; // 将spawnEnemies消息发送至场景中
        _playerBullets = [SKNode node];
        [self addChild:_playerBullets];
        
        _forceFields = [SKNode node];
        [self addChild:_forceFields];
        [self createForceFields];
        
        self.physicsWorld.gravity = CGVectorMake(0, -1); // 设置物理世界重力
        self.physicsWorld.contactDelegate = self; // 委托方
    }
    return self;
}

- (void)spawnEnemies {
    NSUInteger count = log(self.levelNumber) + self.levelNumber; // 通过关卡数来计算出敌人的个数
    for (NSUInteger i = 0; i < count; i ++) { // 设置for循环以创建多个敌人
        EnemyNode *enemy = [EnemyNode node]; // 创建敌人
        CGSize size = self.frame.size;
        CGFloat x = arc4random_uniform(size.width * 0.8) + (size.width * 0.1); // 设置X轴随机数，范围是width的（10%，90%）之间
        CGFloat y = arc4random_uniform(size.height * 0.5) + (size.height * 0.5); // 设置Y轴随机数，范围是height的（50%，100%）之间
        enemy.position = CGPointMake(x, y); // 设置位置
        [self.enemies addChild:enemy]; // 将敌人放入enemies节点中
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (location.y < CGRectGetHeight(self.frame) * 0.2) {
            CGPoint target = CGPointMake(location.x, self.playerNode.position.y);
            [self.playerNode moveToward:target];
        } else {
            BulletNode *bullet = [BulletNode bulletFrom:self.playerNode.position toward:location];
            [self.playerBullets addChild:bullet];
        }

    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.finished) return;
    [self updateBullets];
    [self updateEnemies];
    if (![self checkForGameOver]) {
        [self checkForNextLevel];
    }
}

- (void)updateBullets {
    NSMutableArray *bulletsToRemove = [NSMutableArray array];
    
    for (BulletNode *bullet in self.playerBullets.children) {
        if (!CGRectContainsPoint(self.frame, bullet.position)) {
            [bulletsToRemove addObject:bullet];
            continue;
        }
        [bullet applyRecurringForce];
    }
    [self.playerBullets removeChildrenInArray:bulletsToRemove];
}

- (void)updateEnemies {
    NSMutableArray *enemiesToRemove = [NSMutableArray array];
    
    for (SKNode *node in self.enemies.children) {
        if (!CGRectContainsPoint(self.frame, node.position)) {
            [enemiesToRemove addObject:node];
            continue;
        }
    }
    if ([enemiesToRemove count] > 0) {
        [self.enemies removeChildrenInArray:enemiesToRemove];
    }
}

- (void)checkForNextLevel {
    if ([self.enemies.children count] == 0) {
        [self goToNextLevel];
    }
    
}

- (void)goToNextLevel {
    self.finished = YES;

    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    label.text = @"Level Complete!";
    label.fontColor = [SKColor blueColor];
    label.fontSize = 32;
    label.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    [self addChild:label];
    GameScene *nextLevel = [[GameScene alloc] initWithSize:self.frame.size levelNumber:self.levelNumber + 1]; // 重新设置生命和关卡数
    nextLevel.playerLives = self.playerLives;
    [self.view presentScene:nextLevel transition:[SKTransition flipHorizontalWithDuration:1.0]]; // 设置进入下一个关卡的水平翻转时间为1.0秒
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask) {
        SKNode *nodeA = contact.bodyA.node;
        SKNode *nodeB = contact.bodyB.node;
        
        [nodeA friendlyBumFrom:nodeB];
        [nodeB friendlyBumFrom:nodeA];
    } else {
        SKNode *attacker = nil;
        SKNode *attackee = nil;
        
        if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
            attacker = contact.bodyA.node;
            attackee = contact.bodyB.node;
        } else {
            attacker = contact.bodyB.node;
            attackee = contact.bodyA.node;
        }
        if ([attackee isKindOfClass:[PlayerNode class]]) {
            self.playerLives--;
        }
        [attackee receiveAttacker:attacker contact:contact];
        [self.playerBullets removeChildrenInArray:@[attacker]];
        [self.enemies removeChildrenInArray:@[attacker]];
    }
}

- (void)setPlayerLives:(NSUInteger)playerLives {
    _playerLives = playerLives;
    SKLabelNode *lives = (id)[self childNodeWithName:@"LivesLabel"];
    lives.text = [NSString stringWithFormat:@"lives: %lu", (unsigned long)_playerLives];
    
}

- (void)triggerGameOver {
    self.finished = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EnemyExplosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit = 200;
    explosion.position = _playerNode.position;
    [self addChild:explosion];
    [_playerNode removeFromParent];
    
    SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:1.0];
    SKScene *gameOver = [[GameOverScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:gameOver transition:transition];
}

- (BOOL)checkForGameOver {
    if (self.playerLives == 0) {
        [self triggerGameOver];
        return YES;
    }
    return NO;
}

- (void)createForceFields {
    static int fieldCount = 3;
    CGSize size = self.frame.size;
    float sectionWidth = size.width / fieldCount;
    for (NSUInteger i = 0; i < fieldCount; i++) {
        CGFloat x = i * sectionWidth + arc4random_uniform(sectionWidth);
        CGFloat y = arc4random_uniform(size.height * 0.25) + (size.height * 0.25);
        
        SKFieldNode *gravityField = [SKFieldNode radialGravityField];
        gravityField.position = CGPointMake(x, y);
        gravityField.categoryBitMask = GravityFieldCategory;
        gravityField.strength = 4;
        gravityField.falloff = 2;
        gravityField.region = [[SKRegion alloc] initWithSize:CGSizeMake(size.width * 0.3, size.height * 0.1)];
        [self.forceFields addChild:gravityField];
        
        SKLabelNode *fieldLocationNode = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        fieldLocationNode.fontSize = 16;
        fieldLocationNode.fontColor = [SKColor redColor];
        fieldLocationNode.name = @"GravityField";
        fieldLocationNode.text = @"*";
        fieldLocationNode.position = CGPointMake(x, y);
        [self.forceFields addChild:fieldLocationNode];
    }
}

@end
