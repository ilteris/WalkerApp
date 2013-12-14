//
//  IKMainViewController.m
//  Walker
//
//  Created by ilteris on 11/13/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import "IKMainViewController.h"
#import "IKMonthViewController.h"


@interface IKMainViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *visibleLabels;
@property (nonatomic, strong) UIView *labelContainerView;

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
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 1136);
    
    _visibleLabels = [[NSMutableArray alloc] init];
    
    _labelContainerView = [[UIView alloc] init];
    self.labelContainerView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width/2, self.scrollView.contentSize.height);
    [self.scrollView addSubview:self.labelContainerView];
    
    [self.labelContainerView setUserInteractionEnabled:NO];
    
    // hide horizontal scroll indicator so our recentering trick is not revealed
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    [self recenterIfNecessary];
    
    // tile content in visible bounds
    CGRect visibleBounds = [self.scrollView convertRect:[self.scrollView bounds] toView:self.labelContainerView];
    CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
    
    [self tileLabelsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
  
	
}


#pragma mark - Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary
{
    CGPoint currentOffset = [self.scrollView contentOffset];
    CGFloat contentHeight = [self.scrollView contentSize].height;
    CGFloat centerOffsetY = (contentHeight - [self.scrollView bounds].size.height) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
    
    if (distanceFromCenter > (contentHeight / 4.0))
    {
        self.scrollView.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
        
        // move content by the same amount so it appears to stay still
        for (UILabel *label in self.visibleLabels) {
            CGPoint center = [self.labelContainerView convertPoint:label.center toView:self.scrollView];
            center.y += (centerOffsetY - currentOffset.y);
            label.center = [self.scrollView convertPoint:center toView:self.labelContainerView];
        }
    }
}



#pragma mark - Label Tiling

- (UIView *)insertLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 586)];
    [label setNumberOfLines:3];
    [label setText:@"1024 Block Street\nShaffer, CA\n95014"];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 586)];
    
    
    UICollectionViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"monthViewController"];
    NSLog(@"controller.view is %@", controller.view);
    //[controller.view setFrame:CGRectMake(0, 0, 320, 586)];
    
    imageView.image = [UIImage imageNamed:@"Slice 1.png"];
    [self.labelContainerView addSubview:controller.view];
    
    return controller.view;
}

- (CGFloat)placeNewLabelOnBottom:(CGFloat)bottomEdge
{
    NSLog(@"here place new label on bottom");
    UIView *label = [self insertLabel];
    [self.visibleLabels addObject:label]; // add rightmost label at the end of the array
    
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
    [self.visibleLabels insertObject:label atIndex:0]; // add leftmost label at the beginning of the array
    
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
    NSLog(@"self.visibleLabels is %@", self.visibleLabels);
    
    if ([self.visibleLabels count] == 0)
    {
        [self placeNewLabelOnBottom:minimumVisibleY];
    }
    
    // add labels that are missing on right side
    UILabel *lastLabel = [self.visibleLabels lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastLabel frame]);
    NSLog(@"bottomEdge is %f", bottomEdge);
    NSLog(@"maximumVisibleY is %f", maximumVisibleY);
    
    
    while (bottomEdge < maximumVisibleY)
    {
        bottomEdge = [self placeNewLabelOnBottom:bottomEdge];
    }
    
    // add labels that are missing on left side
    UILabel *firstLabel = self.visibleLabels[0];
    CGFloat topEdge = CGRectGetMinY([firstLabel frame]);
    
    NSLog(@"topEdge is %f", topEdge);
    NSLog(@"minimumVisibleY is %f", minimumVisibleY);
    while (topEdge > minimumVisibleY)
    {
        topEdge = [self placeNewLabelOnTop:topEdge];
    }
    
    // remove labels that have fallen off right edge
    lastLabel = [self.visibleLabels lastObject];
    while ([lastLabel frame].origin.y > maximumVisibleY)
    {
        [lastLabel removeFromSuperview];
        [self.visibleLabels removeLastObject];
        lastLabel = [self.visibleLabels lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstLabel = self.visibleLabels[0];
    while (CGRectGetMaxY([firstLabel frame]) < minimumVisibleY)
    {
        [firstLabel removeFromSuperview];
        [self.visibleLabels removeObjectAtIndex:0];
        firstLabel = self.visibleLabels[0];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
