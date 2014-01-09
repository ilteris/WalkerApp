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
	
	NSInteger numberOfSections = 1;
    
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
    
    NSInteger numberrOfSections = [self.calendar components:NSCalendarUnitYear fromDate:self.fromDate toDate:self.toDate options:0].year;

    NSLog(@"numberrOfSections are %i",numberrOfSections);

    
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
    
	[self shiftDatesByComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.month = -6;
		return dateComponents;
	})())];
    
}

- (void) appendFutureDates {
	
	[self shiftDatesByComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.month = 6;
		return dateComponents;
	})())];
	
}



- (void) shiftDatesByComponents:(NSDateComponents *)components {
	
	NSLog(@"shiftDatesByComponents");
    
   
	
    
	
}


- (NSDate *) dateFromPickerDate:(DFDatePickerDate)dateStruct {
	return [self.calendar dateFromComponents:[self dateComponentsFromPickerDate:dateStruct]];
}

- (NSDateComponents *) dateComponentsFromPickerDate:(DFDatePickerDate)dateStruct {
	NSDateComponents *components = [NSDateComponents new];
	components.year = dateStruct.year;
	components.month = dateStruct.month;
	components.day = dateStruct.day;
	return components;
}

- (DFDatePickerDate) pickerDateFromDate:(NSDate *)date {
	NSDateComponents *components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
	return (DFDatePickerDate) {
		components.year,
		components.month,
		components.day
	};
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
    return 12; //this needs to be dynamic?
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
