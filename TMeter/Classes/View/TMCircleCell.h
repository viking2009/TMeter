//
//  TMCircleCell.h
//  TMeter
//
//  Created by Mykola Vyshynskyi on 30.11.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TMCircleCellImageSize 15.f
#define TMCircleCellIdentifier @"TMCircleCell"

@interface TMCircleCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
