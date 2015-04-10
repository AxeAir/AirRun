//
//  QBAssetsCollectionViewController.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionViewController.h"

// Views
#import "QBAssetsCollectionViewCell.h"
#import "QBAssetsCollectionFooterView.h"

@interface QBAssetsCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, assign) NSUInteger numberOfAssets;
@property (nonatomic, assign) NSUInteger numberOfPhotos;
@property (nonatomic, assign) NSUInteger numberOfVideos;

@property (nonatomic, assign) BOOL disableScrollToBottom;


@property (nonatomic, strong) UIButton *importButton;

@end

@implementation QBAssetsCollectionViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        // View settings
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        // Register cell class
        [self.collectionView registerClass:[QBAssetsCollectionViewCell class]
                forCellWithReuseIdentifier:@"AssetsCell"];
        [self.collectionView registerClass:[QBAssetsCollectionFooterView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:@"FooterView"];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(camera:)];
        self.navigationItem.rightBarButtonItem = doneButton;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Scroll to bottom
    if (self.isMovingToParentViewController && !self.disableScrollToBottom) {
        CGFloat topInset;
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) { // iOS7 or later
            topInset = ((self.edgesForExtendedLayout && UIRectEdgeTop) && (self.collectionView.contentInset.top == 0)) ? (20.0 + 44.0) : 0.0;
        } else {
            topInset = (self.collectionView.contentInset.top == 0) ? (20.0 + 44.0) : 0.0;
        }

        [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.collectionViewLayout.collectionViewContentSize.height - self.collectionView.frame.size.height + topInset)
                                     animated:NO];
    }
    
    // Validation
    if (self.allowsMultipleSelection) {
        if ([self validateNumberOfSelections:self.imagePickerController.selectedAssetURLs.count]) {
            [self showImportButton];
        }
        else
        {
            [self dismissImportButton];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.disableScrollToBottom = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.disableScrollToBottom = NO;
}


#pragma mark - Accessors

- (void)setFilterType:(QBImagePickerControllerFilterType)filterType
{
    _filterType = filterType;
    
    // Set assets filter
    [self.assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(self.filterType)];
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    // Set title
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    // Set assets filter
    [self.assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(self.filterType)];
    
    // Load assets
    NSMutableArray *assets = [NSMutableArray array];
    __block NSUInteger numberOfAssets = 0;
    __block NSUInteger numberOfPhotos = 0;
    __block NSUInteger numberOfVideos = 0;
    
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            numberOfAssets++;
            
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            if ([type isEqualToString:ALAssetTypePhoto]) numberOfPhotos++;
            else if ([type isEqualToString:ALAssetTypeVideo]) numberOfVideos++;
            
            [assets addObject:result];
        }
    }];
    
    self.assets = assets;
    self.numberOfAssets = numberOfAssets;
    self.numberOfPhotos = numberOfPhotos;
    self.numberOfVideos = numberOfVideos;
    
    // Update view
    [self.collectionView reloadData];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    self.collectionView.allowsMultipleSelection = allowsMultipleSelection;
    
//    // Show/hide done button
//    if (allowsMultipleSelection) {
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
//        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
//
//    } else {
//        [self.navigationItem setRightBarButtonItem:nil animated:NO];
//    }
    
    
}

- (void)showImportButton
{
    if (_importButton == nil) {
        _importButton = [[UIButton alloc] init];
        [_importButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        [_importButton setBackgroundColor:[UIColor blueColor]];
    }
    
    if (self.imagePickerController.selectedAssetURLs.count==0) {
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGRect StartFrame = CGRectMake(0, frame.size.height+40, frame.size.width, 40);
        CGRect FinalFrame = CGRectMake(0, frame.size.height-40, frame.size.width, 40);
        [_importButton setFrame:StartFrame];
        [UIView animateWithDuration:0.4 animations:^{
            [_importButton setFrame:FinalFrame];
        } completion:^(BOOL finished) {
        }];
        [self.view addSubview:_importButton];
    }
     [_importButton setTitle:[NSString stringWithFormat:@"导入%ld张图片",self.imagePickerController.selectedAssetURLs.count+1] forState:UIControlStateNormal];
    
}


- (void)dismissImportButton
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    CGRect FinalFrame = CGRectMake(0, frame.size.height+40, frame.size.width, 40);
    
    
    [UIView animateWithDuration:0.4 animations:^{
        [_importButton setFrame:FinalFrame];
    } completion:^(BOOL finished) {
        [_importButton removeFromSuperview];
    }];
}



- (BOOL)allowsMultipleSelection
{
    return self.collectionView.allowsMultipleSelection;
}


#pragma mark - Actions

- (void)done:(id)sender
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewControllerDidFinishSelection:)]) {
        [self.delegate assetsCollectionViewControllerDidFinishSelection:self];
    }
}

- (void)camera:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(assetsCollectionViewControllerDidClickCamera)]) {
        [self.delegate assetsCollectionViewControllerDidClickCamera];
    }
}

#pragma mark - Managing Selection

- (void)selectAssetHavingURL:(NSURL *)URL
{
    for (NSInteger i = 0; i < self.assets.count; i++) {
        ALAsset *asset = self.assets[i];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        
        if ([assetURL isEqual:URL]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
            return;
        }
    }
}


#pragma mark - Validating Selections

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        return (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return YES;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfAssets;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QBAssetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetsCell" forIndexPath:indexPath];
    cell.showsOverlayViewWhenSelected = self.allowsMultipleSelection;
    
    ALAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 66.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        QBAssetsCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                      withReuseIdentifier:@"FooterView"
                                                                                             forIndexPath:indexPath];
        
        switch (self.filterType) {
            case QBImagePickerControllerFilterTypeNone:{
                NSString *format;
                if (self.numberOfPhotos == 1) {
                    if (self.numberOfVideos == 1) {
                        format = @"";
                    } else {
                        format = @"";
                    }
                } else if (self.numberOfVideos == 1) {
                    format = @"";
                } else {
                    format = @"";
                }
                
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(format, @"QBImagePickerController", nil),
                                             self.numberOfPhotos,
                                             self.numberOfVideos];
                break;
            }

            case QBImagePickerControllerFilterTypePhotos:{
                NSString *format = (self.numberOfPhotos == 1) ? @"format_photo" : @"";
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(format, @"QBImagePickerController", nil),
                                             self.numberOfPhotos];
                break;
            }
                
            case QBImagePickerControllerFilterTypeVideos:{
                NSString *format = (self.numberOfVideos == 1) ? @"format_video" : @"";
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(format, @"QBImagePickerController", nil),
                                             self.numberOfVideos];
                break;
            }
        }
        
        return footerView;
    }
    
    return nil;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:
        {
            CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
            
            if (screenHeight == 667.0) {
                size = CGSizeMake(91.0, 91.0);
            } else if (screenHeight == 736) {
                size = CGSizeMake(101.0, 101.0);
            } else {
                size = CGSizeMake(77.5, 77.5);
            }
        }
            break;
            
        case UIUserInterfaceIdiomPad:
        {
            if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
                size = CGSizeMake(202.0, 202.0);
            } else {
                size = CGSizeMake(151.0, 151.0);
            }
        }
            break;
    }
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self validateMaximumNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = self.assets[indexPath.row];
    
    // Validation
    if (self.allowsMultipleSelection) {
        if ([self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)]) {
            [self showImportButton];
        }
    }
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didSelectAsset:)]) {
        [self.delegate assetsCollectionViewController:self didSelectAsset:asset];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = self.assets[indexPath.row];
    
    // Validation
    if (self.allowsMultipleSelection) {        
        if (![self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count - 1)]) {
            [self dismissImportButton];
        }
    }
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didDeselectAsset:)]) {
        [self.delegate assetsCollectionViewController:self didDeselectAsset:asset];
    }
}

@end
