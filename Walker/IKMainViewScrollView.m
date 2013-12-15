//
//  IKMainViewScrollView.m
//  Walker
//
//  Created by ilteris on 12/12/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import "IKMainViewScrollView.h"


@interface IKMainViewScrollView ()

@property (nonatomic, strong) NSMutableArray *visibleYearViews;
@property (nonatomic, strong) UIView *labelContainerView;

@end


@implementation IKMainViewScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        //TODO:This is the first todo.
        self.contentSize = CGSizeMake(self.frame.size.width, 1136);
        
        _visibleYearViews = [[NSMutableArray alloc] init];
        
        _labelContainerView = [[UIView alloc] init];
        self.labelContainerView.frame = CGRectMake(0, 0, self.contentSize.width/2, self.contentSize.height);
        [self addSubview:self.labelContainerView];
        
        
        
        [self.labelContainerView setUserInteractionEnabled:NO];
        
        // hide horizontal scroll indicator so our recentering trick is not revealed
        [self setShowsHorizontalScrollIndicator:NO];
    }
    return self;
}




// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentHeight = [self contentSize].height;
    CGFloat centerOffsetY = (contentHeight - [self bounds].size.height) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
    
    if (distanceFromCenter > (contentHeight / 4.0))
    {
        self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
        
        // move content by the same amount so it appears to stay still
        for (UIView *label in self.visibleYearViews) {
            CGPoint center = [self.labelContainerView convertPoint:label.center toView:self];
            center.y += (centerOffsetY - currentOffset.y);
            label.center = [self convertPoint:center toView:self.labelContainerView];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.labelContainerView];
    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
    
    [self tileLabelsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
}


#pragma mark - Label Tiling

- (UIView *)insertLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 586)];
    [label setNumberOfLines:3];
    [label setText:@"1024 Block Street\nShaffer, CA\n95014"];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 586)];
    imageView.image = [UIImage imageNamed:@"Slice 1.png"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UICollectionViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"monthViewController"];
    NSLog(@"controller.view is %@", controller.view);
    [controller.view setFrame:CGRectMake(0, 0, 320, 586)];
    [self.labelContainerView addSubview:controller.view];

    return controller.view;
}

- (CGFloat)placeNewLabelOnBottom:(CGFloat)bottomEdge
{
    NSLog(@"here place new label on bottom");
    UIView *label = [self insertLabel];
    [self.visibleYearViews addObject:label]; // add rightmost label at the end of the array
    NSLog(@"labrl is %@", label);
    CGRect frame = [label frame];
    frame.origin.y = bottomEdge;
    frame.origin.x = 0;//[self.labelContainerView bounds].size.height - frame.size.height;
    [label setFrame:frame];
    
    return CGRectGetMaxY(frame);
}

- (CGFloat)placeNewLabelOnTop:(CGFloat)topEdge
{
    NSLog(@"here place new label on top");
    UIView *label = [self insertLabel];
    [self.visibleYearViews insertObject:label atIndex:0]; // add leftmost label at the beginning of the array
    
    CGRect frame = [label frame];
    frame.origin.y = topEdge - frame.size.height;
    NSLog(@"frame.origin.y is %f", frame.origin.y);
    frame.origin.x = 0;//[self.labelContainerView bounds].size.height - frame.size.height;
    [label setFrame:frame];
    
    return CGRectGetMinY(frame);
}

- (void)tileLabelsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    NSLog(@"self.visibleLabels is %@", self.visibleYearViews);
    
    if ([self.visibleYearViews count] == 0)
    {
        [self placeNewLabelOnBottom:minimumVisibleY];
    }
    
    // add labels that are missing on right side
    UIView *lastLabel = [self.visibleYearViews lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastLabel frame]);
    NSLog(@"bottomEdge is %f", bottomEdge);
    NSLog(@"maximumVisibleY is %f", maximumVisibleY);
    
    
    while (bottomEdge < maximumVisibleY)
    {
        bottomEdge = [self placeNewLabelOnBottom:bottomEdge];
    }
    
    // add labels that are missing on left side
    UIView *firstLabel = self.visibleYearViews[0];
    CGFloat topEdge = CGRectGetMinY([firstLabel frame]);
    
    NSLog(@"topEdge is %f", topEdge);
    NSLog(@"minimumVisibleY is %f", minimumVisibleY);
    while (topEdge > minimumVisibleY)
    {
        topEdge = [self placeNewLabelOnTop:topEdge];
    }
    
    // remove labels that have fallen off right edge
    lastLabel = [self.visibleYearViews lastObject];
    while ([lastLabel frame].origin.y > maximumVisibleY)
    {
        [lastLabel removeFromSuperview];
        [self.visibleYearViews removeLastObject];
        lastLabel = [self.visibleYearViews lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstLabel = self.visibleYearViews[0];
    while (CGRectGetMaxY([firstLabel frame]) < minimumVisibleY)
    {
        [firstLabel removeFromSuperview];
        [self.visibleYearViews removeObjectAtIndex:0];
        firstLabel = self.visibleYearViews[0];
    }
}

@end
