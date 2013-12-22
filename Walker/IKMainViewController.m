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


typedef struct {
	NSUInteger year;
	NSUInteger month;
	NSUInteger day;
} DFDatePickerDate;


@interface IKMainViewController () <IKMainViewCollectionViewDelegate>
@property (nonatomic, readonly, strong) NSCalendar *calendar;
@property (nonatomic, readonly, assign) DFDatePickerDate fromDate;
@property (nonatomic, readonly, assign) DFDatePickerDate toDate;

@end

@implementation IKMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSDate *now = [_calendar dateFromComponents:[_calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:[NSDate date]]];
        _fromDate = [self pickerDateFromDate:[_calendar dateByAddingComponents:((^{
			NSDateComponents *components = [NSDateComponents new];
			components.month = -6;
			return components;
		})()) toDate:now options:0]];
		
		_toDate = [self pickerDateFromDate:[_calendar dateByAddingComponents:((^{
			NSDateComponents *components = [NSDateComponents new];
			components.month = 6;
			return components;
		})()) toDate:now options:0]];
        

        
        
        
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}


- (void) mainCollectionViewWillLayoutSubviews:(IKMainViewCollectionView *)mainCollectionView {
    NSLog(@"collectionView contentOffset is %@", NSStringFromCGPoint(mainCollectionView.contentOffset));
}
    

#pragma mark - Collection View Data Sources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 36;
}


// The cell that is returned must be retrieved from a call to - dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IKMainViewCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainViewCalendarCell" forIndexPath:indexPath];
    UIImage* image = [UIImage imageNamed:@"slice1.jpg"];
    cell.imageView.image = image;
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
