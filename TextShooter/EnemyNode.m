//
//  EnemyNode.m
//  TextShooter
//
//  Created by lanou on 15/12/31.
//  Copyright (c) 2015年 WB. All rights reserved.
//

#import "EnemyNode.h"
#import "PhysicsCategories.h"
#import "Geometry.h"


@implementation EnemyNode

- (instancetype)init {
    if (self = [super init]) {
        self.name = [NSString stringWithFormat:@"Enemy %p", self]; // 设置名字
        [self initNodeGraph]; // 发送一个initNodeGraph给self
        [self initPhysicsBody];
    }
    return self;
}

- (void)initNodeGraph {
    SKLabelNode *topRow = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"]; // 设置字体
    
    topRow.fontColor = [SKColor brownColor]; // 字体颜色
    topRow.fontSize = 20; // 设置字体大小
    topRow.text = @"x x"; // 设置label节点内容
    topRow.position = CGPointMake(0, 15); // 设置位置
    [self addChild:topRow]; // 将设置好的topRow载入
    
    SKLabelNode *middleRow = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"]; // 设置字体
    
    middleRow.fontColor = [SKColor brownColor]; // 字体颜色
    middleRow.fontSize = 20; // 设置字体大小
    middleRow.text = @"x"; // 设置label节点内容
    // 在SKLabelNode中有两个枚举属性，一个是SKLabelVerticalAlignmentMode（标签垂直对齐方式）默认为Baseline（基线），另一个是SKLabelHorizontalAlignmentMode（标签的水平对齐方式）默认为center（居中）
    // 所以第二排显示的x是在中间的
    [self addChild:middleRow]; // 将设置好的middleRow载入
    
    SKLabelNode *bottomRow = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"]; // 设置字体
    
    bottomRow.fontColor = [SKColor brownColor]; // 字体颜色
    bottomRow.fontSize = 20; // 设置字体大小
    bottomRow.text = @"x x"; // 设置label节点内容
    bottomRow.position = CGPointMake(0, -15); // 设置位置
    [self addChild:bottomRow]; // 将设置好的bottomRow载入
}

- (void)initPhysicsBody {
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 40)]; // 以节点的原点为中心，创建一个矩形的物理体
    body.affectedByGravity = NO; // 设置为没有重力
    body.categoryBitMask = EnemyCategory; // 设置自身物理类别为EnemyCategory
    body.contactTestBitMask = PlayerCategory|EnemyCategory; // 设置接触物理类别为PlayerCategory或者EnemyCategory
    body.mass = 0.2; // 设置质量为0.2kg
    body.angularDamping = 0.0f; // 设置角速度阻尼
    body.linearDamping = 0.0f; // 设置线性阻尼
    body.fieldBitMask = 0;
    self.physicsBody = body;
}

- (void)friendlyBumpFrom:(SKNode *)node {
    self.physicsBody.affectedByGravity = YES; // 物理体是否受重力作用影响
}

- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact {
    self.physicsBody.affectedByGravity = YES; // 物理体是否受重力作用影响
    CGVector force = VectorMultiply(attacker.physicsBody.velocity, contact.collisionImpulse); // 获取攻击者的物理体速度，以及接触的碰撞冲击
    CGPoint myContact = [self.scene convertPoint:contact.contactPoint toNode:self]; // 计算出接触发生的位置
    [self.physicsBody applyForce:force atPoint:myContact]; // 给计算出的点位置一个force的推力
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MissileExplosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit = 20;
    explosion.position = contact.contactPoint;
    [self.scene addChild:explosion];
//    [self runAction:[SKAction playSoundFileNamed:@"enemyHit.wav" waitForCompletion:NO]];
}

@end
