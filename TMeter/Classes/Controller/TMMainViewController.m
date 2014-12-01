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
#import "TMUtils.h"
#import "TMCircleLayout.h"
#import "TMCircleCell.h"

@interface TMMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) SVSegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *iconViews;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet TMCircleLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSUInteger currentStep;
@property (assign, nonatomic) CGFloat currentTemperature;

- (void)updateDate;
- (void)updateTemperature;
- (void)showResults;
- (void)hideResults;

- (void)startTimer;
- (void)stopTimer;

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
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self updateDate];
//    [self updateTemperature];

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
    
    __weak typeof(self) weakSelf = self;
    _segmentedControl.changeHandler = ^(NSUInteger newIndex) {
        DLog(@"%u", newIndex);
        [TMUtils setCurrentMetric:newIndex];
        DLog(@"%u", [TMUtils currentMetric]);
        
        [weakSelf startTimer];
    };
    
    [_segmentedControl setSelectedSegmentIndex:[TMUtils currentMetric] animated:NO];
    [self.view addSubview:_segmentedControl];
    
    self.collectionViewLayout.radius = 80.f;
    self.collectionViewLayout.cellsPerCircle = 30;
    self.collectionViewLayout.itemSize = CGSizeMake(TMCircleCellImageSize, TMCircleCellImageSize);
    self.collectionViewLayout.distance = 18.f;
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
    
    self.dayLabel.text = [TMUtils dayStringFromDate:now];
    self.monthLabel.text = [TMUtils monthStringFromDate:now];
}

- (void)updateTemperature {
    // TODO: calculate temperature
    self.currentTemperature = 36.65f;
    
    self.temperatureLabel.text = [TMUtils temperatureFromNumber:@(self.currentTemperature)];
    [self.collectionView reloadData];
    
    self.currentStep++;

    if (self.currentStep == TMMaxCellsPerCircle) {
        [self stopTimer];
        [self showResults];
    }
}

- (void)showResults {
    // TODO: change hintLabel text, hightlight icon
    self.bubbleView.hidden = NO;
    self.hintLabel.hidden = NO;
    
    for (UIImageView *iconView in self.iconViews) {
        iconView.hidden = NO;
        iconView.alpha = 0.5;
    }

    // TODO: update label
    if (self.currentTemperature < 36.5f) {
        [_iconViews[0] setAlpha:1.0];
    } else if (self.currentTemperature < 36.99f) {
        [_iconViews[1] setAlpha:1.0];
    } else if (self.currentTemperature < 38.99f) {
        [_iconViews[2] setAlpha:1.0];
    } else {
        [_iconViews[3] setAlpha:1.0];
    }
}

- (void)hideResults {
    self.bubbleView.hidden = YES;
    self.hintLabel.hidden = YES;
    
    for (UIImageView *iconView in self.iconViews) {
        iconView.hidden = YES;
    }
}

- (void)startTimer {
    [self stopTimer];
    [self hideResults];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateTemperature) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
    
    self.currentStep = 0;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return TMMaxCellsPerCircle;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMCircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TMCircleCellIdentifier forIndexPath:indexPath];
    
    NSString *imageName = @"point_green";
    if (indexPath.item < self.currentStep) {
        imageName = @"point_red";
    } else if (indexPath.item && indexPath.item == self.currentStep) {
        imageName = @"point_red_active";
    }
    
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
