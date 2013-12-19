//
//  IKMonthPickerView.m
//  Walker
//
//  Created by ilteris on 12/15/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import "IKMonthPickerView.h"
#import "IKMonthPickerCollectionView.h"
#import "IKMonthViewCalendarCell.h"
#import "IKMonthViewCalendarHeader.h"

typedef struct {
	NSUInteger year;
	NSUInteger month;
	NSUInteger day;
} DFDatePickerDate;


static NSString * const IKMonthViewCalendarCellIdentifier = @"dateCell";
static NSString * const IKMonthViewCalendarHeaderIdentifier = @"monthHeader";


@interface IKMonthPickerView () < UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, readonly, strong) NSCalendar *calendar;
@property (nonatomic, readonly, assign) DFDatePickerDate fromDate;
@property (nonatomic, readonly, assign) DFDatePickerDate toDate;
@property (nonatomic, readonly, strong) UICollectionView *collectionView;
@property (nonatomic, readonly, strong) UICollectionViewFlowLayout *collectionViewLayout;

@end

@implementation IKMonthPickerView
@synthesize collectionView = _collectionView;
@synthesize calendar = _calendar;
@synthesize fromDate = _fromDate;
@synthesize toDate = _toDate;
@synthesize collectionViewLayout = _collectionViewLayout;



- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithCalendar:[NSCalendar currentCalendar]];
    if (self) {
       self.frame = frame;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initWithCalendar:[NSCalendar currentCalendar]];
    if (self) {
    }
    return self;
}


- (instancetype) initWithCalendar:(NSCalendar *)calendar {
	
	self = [super initWithFrame:CGRectZero];
	if (self) {
		
		_calendar = calendar;
		
		NSDate *now = [_calendar dateFromComponents:[_calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:[NSDate date]]];
		
		_fromDate = [self pickerDateFromDate:[_calendar dateByAddingComponents:((^{
			NSDateComponents *components = [NSDateComponents new];
			components.month = -1;
			return components;
		})()) toDate:now options:0]];
		
		_toDate = [self pickerDateFromDate:[_calendar dateByAddingComponents:((^{
			NSDateComponents *components = [NSDateComponents new];
			components.month = 1;
			return components;
		})()) toDate:now options:0]];
        
        NSLog(@"_toDate is %i - %i - %i", _toDate.day, _toDate.month, _toDate.year);
        
        NSLog(@"_fromDate is %i - %i - %i", _fromDate.day, _fromDate.month, _fromDate.year);
		
	}
	
	return self;
	
}



- (UICollectionView *) collectionView {
    
	if (!_collectionView) {
		_collectionView = [[IKMonthPickerCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewLayout];
		_collectionView.backgroundColor = [UIColor whiteColor];
		_collectionView.dataSource = self;
		_collectionView.delegate = self;
		_collectionView.showsVerticalScrollIndicator = NO;
		_collectionView.showsHorizontalScrollIndicator = NO;
		[_collectionView registerClass:[IKMonthViewCalendarCell class] forCellWithReuseIdentifier:IKMonthViewCalendarCellIdentifier];
		[_collectionView registerClass:[IKMonthViewCalendarHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IKMonthViewCalendarHeaderIdentifier];
        
      
        
		[_collectionView reloadData];
	}
	
	return _collectionView;
    
}


- (UICollectionViewFlowLayout *) collectionViewLayout {
	
	//	Hard key these things.
	//	44 * 7 + 2 * 6 = 320; this is how the Calendar.app works
	//	and this also avoids the “one pixel” confusion which might or might not work
	//	If you need to decorate, key decorative views in.
	
	if (!_collectionViewLayout) {
		_collectionViewLayout = [UICollectionViewFlowLayout new];
		_collectionViewLayout.headerReferenceSize = (CGSize){ 320, 64 };
		_collectionViewLayout.itemSize = (CGSize){ 44, 44 };
		_collectionViewLayout.minimumLineSpacing = 2.0f;
		_collectionViewLayout.minimumInteritemSpacing = 2.0f;
	}
	
	return _collectionViewLayout;
    
}





- (IKMonthViewCalendarCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	IKMonthViewCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IKMonthViewCalendarCellIdentifier forIndexPath:indexPath];
	
	
	
	return cell;
	
}



- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	return [self.calendar components:NSMonthCalendarUnit fromDate:[self dateFromPickerDate:self.fromDate] toDate:[self dateFromPickerDate:self.toDate] options:0].month;
	
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return 7 * [self numberOfWeeksForMonthOfDate:[self dateForFirstDayInSection:section]];
	
}



- (NSDate *) dateForFirstDayInSection:(NSInteger)section {
    
	return [self.calendar dateByAddingComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.month = section;
		return dateComponents;
	})()) toDate:[self dateFromPickerDate:self.fromDate] options:0];
    
}

- (NSUInteger) numberOfWeeksForMonthOfDate:(NSDate *)date {
    
	NSDate *firstDayInMonth = [self.calendar dateFromComponents:[self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date]];
	
	NSDate *lastDayInMonth = [self.calendar dateByAddingComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.month = 1;
		dateComponents.day = -1;
		return dateComponents;
	})()) toDate:firstDayInMonth options:0];
	
	NSDate *fromSunday = [self.calendar dateFromComponents:((^{
		NSDateComponents *dateComponents = [self.calendar components:NSWeekOfYearCalendarUnit|NSYearForWeekOfYearCalendarUnit fromDate:firstDayInMonth];
		dateComponents.weekday = 1;
		return dateComponents;
	})())];
	
	NSDate *toSunday = [self.calendar dateFromComponents:((^{
		NSDateComponents *dateComponents = [self.calendar components:NSWeekOfYearCalendarUnit|NSYearForWeekOfYearCalendarUnit fromDate:lastDayInMonth];
		dateComponents.weekday = 1;
		return dateComponents;
	})())];
	
	return 1 + [self.calendar components:NSWeekCalendarUnit fromDate:fromSunday toDate:toSunday options:0].week;
	
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



@end
