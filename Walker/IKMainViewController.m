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
@property (nonatomic, strong) IKMonthViewController *currentPage;
@property (nonatomic, strong) IKMonthViewController *nextPage;
@property (nonatomic, assign) BOOL transitioning;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
    
    self.scrollView.delegate = self;
    
    _transitioning          = NO;
    
    
    _currentPage = [[IKMonthViewController alloc] init];
    _nextPage    = [[IKMonthViewController alloc] init];
    
    
    [_scrollView addSubview:_currentPage.view];
	[_scrollView addSubview:_nextPage.view];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
