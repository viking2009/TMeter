//
//  TMSettingsCell.h
//  TMeter
//
//  Created by Mykola Vyshynskyi on 08.12.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TMSettingsCellIdentifier @"TMSettingsCell"

@interface TMSettingsCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *accessoryView;

@end
