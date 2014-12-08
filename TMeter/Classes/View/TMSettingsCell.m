//
//  TMSettingsCell.m
//  TMeter
//
//  Created by Mykola Vyshynskyi on 08.12.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "TMSettingsCell.h"
#import "TMUtils.h"
#import "UIImage+Additions.h"
#import "UIView+Sizes.h"
#import "Macros.h"

@interface TMSettingsCell()

@end

@implementation TMSettingsCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        self.titleLabel.textColor = RGB(0, 0, 0);
        self.titleLabel.highlightedTextColor = RGB(255, 255, 255);
        [self.contentView addSubview:self.titleLabel];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_disclosureIndicator"]];
        self.accessoryView.highlightedImage = [self.accessoryView.image tintedImageWithColor:RGB(255, 255, 255) style:UIImageTintedStyleKeepingAlpha];
        [self.contentView addSubview:self.accessoryView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat left = TMDefaultCellInset;
    CGFloat maxWidth = self.contentView.width - (self.accessoryView.image.size.width + 3*TMDefaultCellInset);
    
    if (self.titleLabel.text.length) {
        self.titleLabel.frame = CGRectMake(left, 0, maxWidth, self.contentView.height);
        left += self.titleLabel.width + TMDefaultCellInset;
        maxWidth -= self.titleLabel.width + TMDefaultCellInset;
    } else {
        self.titleLabel.frame = CGRectZero;
    }
    
    self.accessoryView.frame = CGRectMake(self.contentView.width - self.accessoryView.image.size.width - TMDefaultCellInset,
                                          floorf(self.contentView.height/2 - self.accessoryView.image.size.height/2),
                                          self.accessoryView.image.size.width, self.accessoryView.image.size.height);
}

@end
