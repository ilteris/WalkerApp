//
//  IKMonthPickerView.m
//  Walker
//
//  Created by ilteris on 12/15/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import "IKMonthPickerView.h"

typedef struct {
	NSUInteger year;
	NSUInteger month;
	NSUInteger day;
} DFDatePickerDate;


@interface IKMonthPickerView ()
@property (nonatomic, readonly, strong) NSCalendar *calendar;
@property (nonatomic, readonly, assign) DFDatePickerDate fromDate;
@property (nonatomic, readonly, assign) DFDatePickerDate toDate;
@property (nonatomic, readonly, strong) UICollectionView *collectionView;
@property (nonatomic, readonly, strong) UICollectionViewFlowLayout *collectionViewLayout;

@end

@implementation IKMonthPickerView



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
        
        NSLog(@"_toDate is %i", _toDate.day);
		
	}
	
	return self;
	
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
