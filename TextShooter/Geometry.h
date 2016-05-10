//
//  Geometry.h
//  TextShooter
//
//  Created by lanou on 15/12/31.
//  Copyright (c) 2015年 WB. All rights reserved.
//

#ifndef TextShooter_Geometry_h
#define TextShooter_Geometry_h

// 接收CGVector和CGFloat为参数
// 返回一个新的CGVector，其中每个元素都已经乘以m
static inline CGVector VectorMultiply(CGVector v, CGFloat m) {
    return CGVectorMake(v.dx * m, v.dy * m);
}

// 接收两个CGPoint为参数
// 返回一个表示p1到p2距离的CGVector
static inline CGVector VectorBetweenPoints(CGPoint p1, CGPoint p2) {
    return CGVectorMake(p2.x - p1.x, p2.y - p1.y);
}

// 接收一个CGPoint为参数
// 通过勾股定理计算出向量的长度并返回CGFloat值
static inline CGFloat VectorLength(CGVector v) {
    return sqrtf(powf(v.dx, 2) + powf(v.dy, 2));
}

// 根据两个CGPoint坐标，通过勾股定理计算除两者间的距离
// 并返回CGFloat类型的长度值
static inline CGFloat PointDistance(CGPoint p1, CGPoint p2) {
    return sqrtf(powf(p2.x - p1.x, 2) + powf(p2.y - p1.y, 2));
}

#endif
