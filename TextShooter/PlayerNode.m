//
//  PlayerNode.m
//  TextShooter
//
//  Created by lanou on 15/12/31.
//  Copyright (c) 2015年 WB. All rights reserved.
//

#import "PlayerNode.h"
#import "Geometry.h"
#import "PhysicsCategories.h"

@implementation PlayerNode

- (instancetype)init {
    if (self = [super init]) {
        self.name = [NSString stringWithFormat:@"Player %p",self];
        [self initNodeGraph];
        [self initPhsysicsBody];
    }
    return self;
}

- (void)initNodeGraph {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Courier"]; // 创建带有字体命名的标签节点
    label.name = @"label"; // 设置节点的名称（名称不是内容）
    label.fontColor = [SKColor darkGrayColor]; // 设置节点字体颜色
    label.fontSize = 40; // 设置节点的字体大小40
    label.text = @"v"; // 创建的节点显示为v
    label.zRotation = M_PI; // 文字的翻转（传入的值是“弧度”，不是角度，M_PI指π——180的弧度）
//    label.zPosition =
    [self addChild:label];
}

- (void)moveToward:(CGPoint)location {
    [self removeActionForKey:@"movement"]; // 删除关键字就可以实现快速的点击，而不会因为多个移动操作造成冲突（多个方向的点击，不同方向移动的冲突就解决了）
    [self removeActionForKey:@"wobbling"]; // 删除关键字理由同上
    CGFloat distance =  PointDistance(self.position, location); // 利用Geometry中的几何算法计算出两个坐标点的距离
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width; // 获取屏幕宽度
    CGFloat duration = 2.0 * distance / screenWidth; // 算出移动所需的时间（通过两点的距离和屏幕的宽度来计算）
    
    [self runAction:[SKAction moveTo:location duration:duration] withKey:@"movement"]; // 添加动作的关键字
    
    CGFloat wobbleTime = 0.3; // 设置摆动时间
    CGFloat halfWobbleTime = wobbleTime * 0.5; // 计算摆动时间的一半（因为摆动是分为两部分的，先变小，在变回来，就是两次变换，所以半摆动时间就是，一次变换的时间）
    SKAction *wobbling = [SKAction sequence:@[[SKAction scaleTo:0.2 duration:halfWobbleTime], [SKAction scaleTo:1.0 duration:halfWobbleTime]]]; // 设置两次变换，第一次变换大小为0.2（1是正常大小），变换时间为halfWobbleTime，第二次变换大小为1（原来大小），变幻时间为halfWobbleTime。
    NSUInteger wobbleCount = duration / wobbleTime; // 取到之前的移动时间duration在与一次变换时间相除得出来的整数就是，在移动时间内可以变换的次数
    
    [self runAction:[SKAction repeatAction:wobbling count:wobbleCount] withKey:@"wobbling"]; // 变换的模式为wobbling，变换次数为wobbleCount，添加关键字
}

- (void)initPhsysicsBody {
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    
    body.affectedByGravity = NO;
    body.categoryBitMask = PlayerCategory;
    body.contactTestBitMask = EnemyCategory;
    body.collisionBitMask = 0;
    body.fieldBitMask = 0;
    self.physicsBody = body;
}

- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EnemyExplosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit = 50;
    explosion.position = contact.contactPoint;
    [self.scene addChild:explosion];
}

@end
