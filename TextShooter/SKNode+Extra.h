//
//  SKNode+Extra.h
//  TextShooter
//
//  Created by lanou on 16/1/2.
//  Copyright (c) 2016年 WB. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (Extra)

- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact;

- (void)friendlyBumFrom:(SKNode *)node;

@end
