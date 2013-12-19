//
//  IKMonthViewCalendarHeader.m
//  Walker
//
//  Created by ilteris on 12/18/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import "IKMonthViewCalendarHeader.h"

@implementation IKMonthViewCalendarHeader
@synthesize textLabel = _textLabel;

- (UILabel *) textLabel {
	if (!_textLabel) {
		_textLabel = [[UILabel alloc] initWithFrame:self.bounds];
		_textLabel.textAlignment = NSTextAlignmentCenter;
		_textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
		_textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[self addSubview:_textLabel];
	}
	return _textLabel;
}


@end
