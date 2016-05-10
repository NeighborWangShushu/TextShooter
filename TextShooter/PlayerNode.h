//
//  PlayerNode.h
//  TextShooter
//
//  Created by lanou on 15/12/31.
//  Copyright (c) 2015年 WB. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayerNode : SKNode

// 返回将来移动所用的时间
- (void)moveToward:(CGPoint)location;

@end
