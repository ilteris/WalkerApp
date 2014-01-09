//
//  IKMainViewCalendarCell.h
//  Walker
//
//  Created by ilteris on 12/9/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayFlow.h"

@interface IKMainViewCalendarCell : UICollectionViewCell
@property (nonatomic, readonly, strong) NSCalendar *calendar;
@property (nonatomic, readonly, assign) DFDatePickerDate fromDate;
@property (nonatomic, readonly, assign) DFDatePickerDate toDate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setupCell;

@end
