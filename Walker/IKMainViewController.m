//
//  IKMainViewController.m
//  Walker
//
//  Created by ilteris on 12/9/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import "IKMainViewController.h"
#import "IKMainViewCalendarCell.h"
#import "IKMainViewCollectionView.h"
#import "IKDatePickerYearHeader.h"

#import "NSCalendar+DFAdditions.h"



@interface IKMainViewController () <UICollectionViewDataSource, IKMainViewCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet IKMainViewCollectionView *collectionView;

@end

@implementation IKMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        
        
        
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}


- (void) mainCollectionViewWillLayoutSubviews:(IKMainViewCollectionView *)mainCollectionView {
    
    
    CGPoint currentOffset = mainCollectionView.contentOffset;
    CGFloat contentHeight = mainCollectionView.contentSize.height;
    CGFloat centerOffsetY = (contentHeight - mainCollectionView.bounds.size.height)/ 2.0;
    CGFloat distanceFromCenterY = fabsf(currentOffset.y - centerOffsetY);
    
    
    if (distanceFromCenterY > contentHeight/4.0) {
        mainCollectionView.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
    }
    
    CGFloat minimumVisibleY = CGRectGetMinY(mainCollectionView.bounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(mainCollectionView.bounds);
    // NSLog(@"maximumvisibleY is %f and minimumVisibleY is %f", maximumVisibleY, minimumVisibleY);
    
    
    NSLog(@"collectionView contentOffset is %@", NSStringFromCGPoint(mainCollectionView.contentOffset));
    
   
    NSLog(@"maximumvisibleY is %f and minimumVisibleY is %f", maximumVisibleY, minimumVisibleY);
   // [self tileLabelsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];

}



- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		
		IKDatePickerYearHeader *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"IKDatePickerYearHeader" forIndexPath:indexPath];
		
				
		
		monthHeader.textLabel.text = @"2014";//[dateFormatter stringFromDate:formattedDate];
		
		return monthHeader;
		
	}
	
	return nil;
    
}

#pragma mark - Collection View Data Sources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}


// The cell that is returned must be retrieved from a call to - dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IKMainViewCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainViewCalendarCell" forIndexPath:indexPath];
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
