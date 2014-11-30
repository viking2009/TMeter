//
//  TMCircleLayout.h
//  TMeter
//
//  Created by Mykola Vyshynskyi on 30.11.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TMMaxDistance 18.f
#define TMMaxCellsPerCircle 30

@interface TMCircleLayout : UICollectionViewLayout

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) NSInteger cellsPerCircle;
@property (nonatomic, assign) CGSize itemSize;

@end
