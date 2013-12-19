//
//  IKMainViewCalendarCell.m
//  Walker
//
//  Created by ilteris on 12/9/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import "IKMonthViewCalendarCell.h"

@interface IKMonthViewCalendarCell ()
@property (nonatomic, readonly, strong) UIImageView *imageView;
@end


@implementation IKMonthViewCalendarCell
//TODO:This is where we setup the monthly view.
//let's start with simple uiimageview.

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
