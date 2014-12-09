//
//  TMMainViewController.m
//  TMeter
//
//  Created by Mykola Vyshynskyi on 30.11.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "TMMainViewController.h"
#import "Macros.h"
#import "TMUtils.h"
#import "TMCircleLayout.h"
#import "TMCircleCell.h"
#import "RIOInterface.h"

#define kOLSParameterA -1.99550610142
#define kOLSParameterB 16351.0179948

@interface TMMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, RIOInterfaceDelegate>

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *iconViews;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet TMCircleLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (strong, nonatomic) RIOInterface *rio;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSUInteger currentStep;
@property (assign, nonatomic) CGFloat currentTemperature;

- (void)updateTemperature;
- (void)updateTemperatureLabel;
- (void)showResults;
- (void)hideResults;

- (void)startTimer;
- (void)stopTimer;

- (IBAction)startButtonAction:(id)sender;

@end

@implementation TMMainViewController

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    
    [self.rio stopListening];
    self.rio.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.rio = [RIOInterface sharedInstance];
    
//    [self updateTemperature];
    self.collectionViewLayout.radius = 90.f;
    self.collectionViewLayout.cellsPerCircle = 30;
    self.collectionViewLayout.itemSize = CGSizeMake(TMCircleCellImageSize, TMCircleCellImageSize);
    self.collectionViewLayout.distance = 18.f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateTemperatureLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private

- (void)updateTemperature {
    // TODO: calculate temperature
//    self.currentTemperature = 36.65f;
    
    [self updateTemperatureLabel];
    [self.collectionView reloadData];
    
    self.currentStep++;

    if (self.currentStep == TMMaxCellsPerCircle) {
        [self stopTimer];
        [self showResults];
    }
}

- (void)updateTemperatureLabel {
    self.temperatureLabel.text = [TMUtils temperatureFromNumber:@(self.currentTemperature)];
}

- (void)showResults {
    // TODO: change hintLabel text, hightlight icon
    self.bubbleView.hidden = NO;
    self.hintLabel.hidden = NO;
    
    for (UIImageView *iconView in self.iconViews) {
        iconView.alpha = 0.2;
    }

    NSString *tempString = @"normal";
    // TODO: update label
    if (self.currentTemperature < 36.5f) {
        [_iconViews[0] setAlpha:1.0];
        tempString = @"low";
    } else if (self.currentTemperature < 36.99f) {
        [_iconViews[1] setAlpha:1.0];
    } else if (self.currentTemperature < 38.99f) {
        [_iconViews[2] setAlpha:1.0];
        tempString = @"high";
    } else {
        [_iconViews[3] setAlpha:1.0];
        tempString = @"very high";
    }
    
    NSString *hintString = [NSString stringWithFormat:@"You have %@ temperature!", tempString];
    UIFont *hintFont = [UIFont fontWithName:@"HelveticaNeue" size:15];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: RGB(0, 0, 0), NSFontAttributeName: hintFont};
    NSMutableAttributedString *hintAttributedText = [[NSMutableAttributedString alloc] initWithString:hintString attributes:attributes];
    
    NSRange range = [hintString rangeOfString:tempString];
    attributes = @{NSForegroundColorAttributeName: RGB(235, 45, 1), NSFontAttributeName: hintFont};
    [hintAttributedText setAttributes:attributes range:range];

    self.hintLabel.attributedText = hintAttributedText;
    
    self.startButton.enabled = YES;
    self.settingsButton.enabled = YES;
}

- (void)hideResults {
    self.bubbleView.hidden = YES;
    self.hintLabel.hidden = YES;
    
    for (UIImageView *iconView in self.iconViews) {
        iconView.alpha = 0.2;
    }
}

- (void)startTimer {
    [self stopTimer];
    [self hideResults];
    
    self.currentTemperature = 0;
    self.temperatureLabel.hidden = NO;

    self.startButton.enabled = NO;
    self.settingsButton.enabled = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateTemperature) userInfo:nil repeats:YES];
    
    [self.rio startListening:self];
}

- (void)stopTimer {
    [self.rio stopListening];
    
    [self.timer invalidate];
    self.timer = nil;
    
    self.currentStep = 0;
    [self.collectionView reloadData];
}

- (IBAction)startButtonAction:(id)sender {
    [self startTimer];
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

#pragma mark RIOInterfaceDelegate

- (void)frequencyChangedWithValue:(float)newFrequency {
    self.currentTemperature = MAX(self.currentTemperature, kOLSParameterA * newFrequency + kOLSParameterB);
//    DLog(@"%f: %f", newFrequency, self.currentTemperature);
}

@end
