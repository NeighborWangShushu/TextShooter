//
//  BulletNode.m
//  TextShooter
//
//  Created by lanou on 16/1/2.
//  Copyright (c) 2016年 WB. All rights reserved.
//

#import "BulletNode.h"
#import "PhysicsCategories.h"
#import "Geometry.h"

@interface BulletNode ()

@property (assign, nonatomic) CGVector thrust;

@end

@implementation BulletNode

- (instancetype)init {
    if (self = [super init]) {
        SKLabelNode *dot = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        dot.fontColor = [SKColor blackColor];
        dot.fontSize = 40;
        dot.text = @".";
        [self addChild:dot];
        
        SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:1]; // 以节点的原点为中心，创建一个圆形物理体，圆的半径返回值一个新的基于体积的物理体。
        body.dynamic = YES; // 设置对象是否为动态的 PS:dynamic 一个布尔值，判断物理体是否是运动的。
        body.categoryBitMask = PlayerMissileCategory; // 定义为PlayerMissileCategory物理类别
        body.contactTestBitMask = EnemyCategory; // 定义接触时的位掩码为EnemyCategory的物理类型
        body.collisionBitMask = EnemyCategory; // 定义碰撞时的位掩码为EnemyCategory的物理类型
        body.fieldBitMask = GravityFieldCategory;
        body.mass = 0.01; // 设置质量为0.01，默认单位为千克
        
        self.physicsBody = body; // 将body的载入到self的physicsBody中
        self.name = [NSString stringWithFormat:@"Bullet %p", self]; // 设置名字
    }
    return self;
}

+ (instancetype)bulletFrom:(CGPoint)start toward:(CGPoint)destination {
    BulletNode *bullet = [[self alloc] init];
    
    bullet.position = start;
    
    CGVector movement = VectorBetweenPoints(start, destination);
    CGFloat magnitude = VectorLength(movement);
    if (magnitude == 0.0f) {
        return nil;
    }
    
    CGVector scaledMovement = VectorMultiply(movement, 1 / magnitude);
    
    CGFloat thrustMagnitude = 100.0;
    bullet.thrust = VectorMultiply(scaledMovement, thrustMagnitude);
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"shoot.wav" ofType:nil];

//    [bullet runAction:[SKAction playSoundFileNamed:@"shoot.wav" waitForCompletion:NO]];
    
    return bullet;
}

- (void)applyRecurringForce {
    [self.physicsBody applyForce:self.thrust];
}

@end
