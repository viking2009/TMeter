//
//  TMMainViewController.m
//  TMeter
//
//  Created by Mykola Vyshynskyi on 30.11.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "TMMainViewController.h"
#import "SVSegmentedControl.h"
#import "Macros.h"
#import "MTUtils.h"

@interface TMMainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) SVSegmentedControl *segmentedControl;

- (void)updateDate;

@end

@implementation TMMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDate) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self updateDate];

    _segmentedControl = [[SVSegmentedControl alloc] initWithSectionTitles:@[@"°F", @"°C"]];
    _segmentedControl.frame = CGRectMake(184, 21, 134, 28);
    _segmentedControl.backgroundImage = [[UIImage imageNamed:@"segmented_control_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15.f, 0, 15.f) resizingMode:UIImageResizingModeStretch];
    _segmentedControl.crossFadeLabelsOnDrag = YES;
    _segmentedControl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    _segmentedControl.textColor = RGB(127, 127, 127);
    _segmentedControl.textShadowColor = RGBA(255, 255, 255, 0.75);
    _segmentedControl.textShadowOffset = CGSizeMake(0, 1);
    _segmentedControl.thumbEdgeInset = UIEdgeInsetsZero;
    _segmentedControl.thumb.backgroundImage = [[UIImage imageNamed:@"segmented_control_thumb_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15.f, 0, 15.f) resizingMode:UIImageResizingModeStretch];
    _segmentedControl.thumb.highlightedBackgroundImage = [[UIImage imageNamed:@"segmented_control_thumb_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15.f, 0, 15.f) resizingMode:UIImageResizingModeStretch];
    _segmentedControl.thumb.textShadowColor = RGBA(255, 255, 255, 0.75);
    _segmentedControl.thumb.textShadowOffset = CGSizeMake(0, 1);
    _segmentedControl.changeHandler = ^(NSUInteger newIndex) {
        DLog(@"%u", newIndex);
        [MTUtils setCurrentMetric:newIndex];
        DLog(@"%u", [MTUtils currentMetric]);
    };
    
    [_segmentedControl setSelectedSegmentIndex:[MTUtils currentMetric] animated:NO];

    [self.view addSubview:_segmentedControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private

- (void)updateDate {
    NSDate *now = [NSDate date];
    
    self.dayLabel.text = [MTUtils dayStringFromDate:now];
    self.monthLabel.text = [MTUtils monthStringFromDate:now];
}

@end
