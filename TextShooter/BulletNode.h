//
//  BulletNode.h
//  TextShooter
//
//  Created by lanou on 16/1/2.
//  Copyright (c) 2016年 WB. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BulletNode : SKNode

+ (instancetype)bulletFrom:(CGPoint)start toward:(CGPoint)destination;
- (void)applyRecurringForce;

@end
