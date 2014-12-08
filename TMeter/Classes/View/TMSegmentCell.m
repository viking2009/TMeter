//
//  TMSegmentCell.m
//  TMeter
//
//  Created by Mykola Vyshynskyi on 08.12.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "TMSegmentCell.h"
#import "SVSegmentedControl.h"
#import "Macros.h"
#import "UIView+Sizes.h"

#define TMDefaultSegmentWidth 152.f
#define TMDefaultSegmentHeight 28.f

@implementation TMSegmentCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        self.titleLabel.textColor = RGB(0, 0, 0);
        [self.contentView addSubview:self.titleLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(TMDefaultCellInset, 0,
                                       self.contentView.width - TMDefaultSegmentWidth - 3*TMDefaultCellInset,
                                       self.contentView.height);
    
    self.segmentView.frame = CGRectMake(self.contentView.width - self.segmentView.width - TMDefaultCellInset,
                                       floorf(self.contentView.height/2 - TMDefaultSegmentHeight/2),
                                       self.segmentView.width, self.segmentView.height);
}

- (void)setSegmentView:(SVSegmentedControl *)segmentView {
    if (_segmentView != segmentView) {
        [_segmentView removeFromSuperview];
        
        _segmentView = segmentView;
        _segmentView.backgroundImage = [[UIImage imageNamed:@"segmented_control_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15.f, 0, 15.f) resizingMode:UIImageResizingModeStretch];
        _segmentView.crossFadeLabelsOnDrag = YES;
        _segmentView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        _segmentView.textColor = RGB(127, 127, 127);
        _segmentView.textShadowColor = RGBA(255, 255, 255, 0.75);
        _segmentView.textShadowOffset = CGSizeMake(0, 1);
        _segmentView.thumbEdgeInset = UIEdgeInsetsZero;
        _segmentView.thumb.backgroundImage = [[UIImage imageNamed:@"segmented_control_thumb_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15.f, 0, 15.f) resizingMode:UIImageResizingModeStretch];
        _segmentView.thumb.highlightedBackgroundImage = [[UIImage imageNamed:@"segmented_control_thumb_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15.f, 0, 15.f) resizingMode:UIImageResizingModeStretch];
        _segmentView.thumb.textShadowColor = RGBA(255, 255, 255, 0.75);
        _segmentView.thumb.textShadowOffset = CGSizeMake(0, 1);
        [self.contentView addSubview:_segmentView];
        
        [self setNeedsLayout];
    }
}

@end
