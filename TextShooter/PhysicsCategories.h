//
//  PhysicsCategories.h
//  TextShooter
//
//  Created by lanou on 16/1/2.
//  Copyright (c) 2016年 WB. All rights reserved.
//

#ifndef TextShooter_PhysicsCategories_h
#define TextShooter_PhysicsCategories_h

typedef NS_OPTIONS(uint32_t, PhsicsCategory) { // 设置多个物理类别 PS：4字节——uint32_t
    // 利用了左移运算符
    PlayerCategory        = 1 << 1, // 玩家类别
    EnemyCategory         = 1 << 2, // 敌人类别
    PlayerMissileCategory = 1 << 3, // 玩家子弹类别
    GravityFieldCategory  = 1 << 4  // 重力场范畴
};


#endif
