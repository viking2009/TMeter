//
//  TMSettingsViewController.m
//  TMeter
//
//  Created by Mykola Vyshynskyi on 08.12.14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "TMSettingsViewController.h"
#import "TMSegmentCell.h"
#import "TMSettingsCell.h"
#import "UIImage+Additions.h"
#import "SVSegmentedControl.h"
#import "Macros.h"
#import "TMUtils.h"

@interface TMSettingsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *data;

- (IBAction)doneButtonAction:(id)sender;

@end

@implementation TMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = @[@"Measure", @"About", @"BabyPlanner (free)", @"BabyPlanner (full version)"];
    
    [self.collectionView registerClass:[TMSegmentCell class] forCellWithReuseIdentifier:TMSegmentCellIdentifier];
    [self.collectionView registerClass:[TMSettingsCell class] forCellWithReuseIdentifier:TMSettingsCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)doneButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    if (indexPath.section == 0 && indexPath.item == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TMSegmentCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TMSettingsCellIdentifier forIndexPath:indexPath];
    }
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    
    if ([collectionView numberOfItemsInSection:indexPath.section] == 1) {
        backgroundView.image = [UIImage imageNamed:@"cell_background_single"];
    } else if (indexPath.item == 0) {
        backgroundView.image = [UIImage imageNamed:@"cell_background_top"];
    } else if (indexPath.item == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
        backgroundView.image = [UIImage imageNamed:@"cell_background_bottom"];
    } else {
        backgroundView.image = [UIImage imageNamed:@"cell_background_middle"];
    }
    
    cell.backgroundView = backgroundView;
    
    UIImageView *selectedBackgroundView = [[UIImageView alloc] init];
    selectedBackgroundView.image = [backgroundView.image tintedImageWithColor:RGB(30, 188, 165) style:UIImageTintedStyleKeepingAlpha];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    if (indexPath.section == 0 && indexPath.item == 0) {
        TMSegmentCell *segmentCell = (TMSegmentCell *)cell;
        segmentCell.titleLabel.text = TMLocalizedString(_data[indexPath.item]);
        segmentCell.segmentView = [[SVSegmentedControl alloc] initWithSectionTitles:[TMUtils supportedMetrics]];
        [segmentCell.segmentView setSelectedSegmentIndex:[TMUtils currentMetric] animated:NO];
        segmentCell.segmentView.changeHandler = ^(NSUInteger newIndex) {
            [TMUtils setCurrentMetric:newIndex];
        };
    } else{
        TMSettingsCell *settingsCell = (TMSettingsCell *)cell;
        settingsCell.titleLabel.text = TMLocalizedString(_data[indexPath.item]);
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item > 0;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item > 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        switch (indexPath.item) {
            case 0:
                break;
            case 1:
            case 2:
            case 3:
                [[[UIAlertView alloc] initWithTitle:TMLocalizedString(@"Warning!") message:TMLocalizedString(@"Not implemented") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//                [self.navigationController pushViewController:[UIViewController new] animated:YES];
                break;
                
            default:
                break;
        }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    if ([collectionView numberOfItemsInSection:indexPath.section] == 1) {
        height = 46.f;
    } else if (indexPath.item == 0 || indexPath.item == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
        height = 45.f;
    } else {
        height = 44.f;
    }
    
    return CGSizeMake(302.f, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10.f, 0, 10.f, 0);
    
    if (section < [collectionView numberOfSections] - 1) {
        edgeInsets.bottom = 0;
    }
    
    return edgeInsets;
}

@end
