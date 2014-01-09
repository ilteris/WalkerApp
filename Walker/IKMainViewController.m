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
@property (nonatomic, readonly, strong) NSCalendar *calendar;
@property (nonatomic, readonly, assign) NSDate* fromDate;
@property (nonatomic, readonly, assign) NSDate* toDate;
@property (weak, nonatomic) IBOutlet IKMainViewCollectionView *collectionView;

@end

@implementation IKMainViewController
@synthesize calendar = _calendar;
@synthesize fromDate = _fromDate;
@synthesize toDate = _toDate;


- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        // Do something
        _calendar = [NSCalendar currentCalendar];
    }
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}



- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
    
    NSDate *now = [_calendar dateFromComponents:[_calendar components:NSYearCalendarUnit fromDate:[NSDate date]]];

    //add 5 years from now on
    //remove 5 years from now on and return that back as numberOfSection
    _fromDate = [_calendar dateByAddingComponents:((^{
        NSDateComponents *components = [NSDateComponents new];
        components.year = -5;
        return components;
    })()) toDate:now options:0];
    
    _toDate = [_calendar dateByAddingComponents:((^{
        NSDateComponents *components = [NSDateComponents new];
        components.year = 5;
        return components;
    })()) toDate:now options:0];
    
    NSInteger numberOfSections = [self.calendar components:NSCalendarUnitYear fromDate:self.fromDate toDate:self.toDate options:0].year;
    
    return numberOfSections;
    
}



- (void) mainCollectionViewWillLayoutSubviews:(IKMainViewCollectionView *)mainCollectionView {
    
    
    /*
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
    */
    if (mainCollectionView.contentOffset.y < 0.0f) {
        	[self appendPastDates];
	}
	
	if (mainCollectionView.contentOffset.y > (mainCollectionView.contentSize.height - CGRectGetHeight(mainCollectionView.bounds))) {
        	[self appendFutureDates];
	}
    
    

}




- (void) appendPastDates {
    NSLog(@"appendPastDates");
	[self shiftDatesByComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.year = -5;
		return dateComponents;
	})())];
    
}

- (void) appendFutureDates {
    NSLog(@"appendFutureDates");
	[self shiftDatesByComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.year = 5;
		return dateComponents;
	})())];
	
}



- (void) shiftDatesByComponents:(NSDateComponents *)components {
	/*
	NSLog(@"shiftDatesByComponents");
    UICollectionView *cv = self.collectionView;
	UICollectionViewFlowLayout *cvLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;

    NSArray *visibleCells = [self.collectionView visibleCells];
	if (![visibleCells count])
		return;

    NSIndexPath *fromIndexPath = [cv indexPathForCell:((UICollectionViewCell *)visibleCells[0]) ];
	NSInteger fromSection = fromIndexPath.section;
	NSDate *fromSectionOfDate = [self dateForFirstYearInSection:fromSection];
	CGPoint fromSectionOrigin = [self.view convertPoint:[cvLayout layoutAttributesForItemAtIndexPath:fromIndexPath].frame.origin fromView:cv];
    NSDate *now = [_calendar dateFromComponents:[_calendar components:NSYearCalendarUnit fromDate:[NSDate date]]];

    
    _fromDate = [_calendar dateByAddingComponents:((^{
        NSDateComponents *components = [NSDateComponents new];
        components.year = -5;
        return components;
    })()) toDate:now options:0];
    
    _toDate = [_calendar dateByAddingComponents:((^{
        NSDateComponents *components = [NSDateComponents new];
        components.year = 5;
        return components;
    })()) toDate:now options:0];
    
    
	
	NSInteger toSection = [self.calendar components:NSMonthCalendarUnit fromDate:[self dateForFirstYearInSection:0] toDate:fromSectionOfDate options:0].month;
	UICollectionViewLayoutAttributes *toAttrs = [cvLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:toSection]];
	CGPoint toSectionOrigin = [self.view convertPoint:toAttrs.frame.origin fromView:cv];
	
    */
}


- (NSDate *) dateForFirstYearInSection:(NSInteger)section {
    
	return [self.calendar dateByAddingComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.year = 5;
		return dateComponents;
	})()) toDate:self.fromDate options:0];
    
}



- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		
		IKDatePickerYearHeader *yearHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"IKDatePickerYearHeader" forIndexPath:indexPath];
			
		yearHeader.textLabel.text = @"2014";//[dateFormatter stringFromDate:formattedDate];
		
		return yearHeader;
	}
	return nil;
    
}


#pragma mark - Collection View Data Sources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;  //each section have 12 items. this is static.
}


// The cell that is returned must be retrieved from a call to - dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    IKMainViewCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainViewCalendarCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    //set the month of the cell here.
    [cell setupCell];
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
