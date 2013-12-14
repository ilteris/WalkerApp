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


@property (nonatomic, strong) IKMonthViewController *currentPage;
@property (nonatomic, strong) IKMonthViewController *nextPage;
@property (nonatomic, assign) BOOL transitioning;

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
    
  
     _transitioning          = NO;
     
     //   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     self.currentPage = [self.storyboard instantiateViewControllerWithIdentifier:@"monthViewController"];
     self.nextPage = [self.storyboard instantiateViewControllerWithIdentifier:@"monthViewController"];
     
     
     
     
     [self.scrollView addSubview:self.currentPage.view];
     [self.scrollView addSubview:self.nextPage.view];
     
     
    
     //  NSLog(@"[self.dataController.bookItemList count]; is %i", [self.dataController.bookItemList count]);
     NSInteger sceneCount = 2;//[[ATPDatasource sharedInstance] numOfScenes];
     if (sceneCount == 0)
     {
     sceneCount = 1;
     }
     
     self.scrollView.contentSize =CGSizeMake(self.scrollView.frame.size.width,         self.scrollView.frame.size.height * sceneCount);
     self.scrollView.contentOffset = CGPointMake(0, 0);
     
     
     self.scrollView.pagingEnabled = NO;
     
     [self applyNewIndex:0 pageController:_currentPage];
     [self applyNewIndex:1 pageController:_nextPage];
    
    
    
    // Do any additional setup after loading the view.
}


- (void)applyNewIndex:(NSInteger)newIndex pageController:(IKMonthViewController *)monthViewController
{
    NSInteger pageCount = 2;//[[ATPDatasource sharedInstance] numOfScenes];//[_currentPage numDoses];
    BOOL outOfBounds = newIndex >= pageCount || newIndex < 0;
    
    
    if (!outOfBounds)
    {
        CGRect pageFrame = monthViewController.view.frame;
        pageFrame.origin.y = self.scrollView.frame.size.height * newIndex;
        pageFrame.origin.x = 0;
        monthViewController.view.frame = pageFrame;
    }
    else
    {
        CGRect pageFrame = monthViewController.view.frame;
        pageFrame.origin.x = 0;
        monthViewController.view.frame = pageFrame;
    }
    
    monthViewController.pageIndex = newIndex;
    // _currentIndex = newIndex;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    _transitioning = YES;
    
    
    CGFloat pageWidth = self.scrollView.frame.size.height;
    float fractionalPage = self.scrollView.contentOffset.y / pageWidth;
    
    NSInteger lowerNumber = floor(fractionalPage);
    NSInteger upperNumber = lowerNumber + 1;
    
    
    if (lowerNumber == _currentPage.pageIndex)
    {
            NSLog(@"lowerNumber == _currentPage.pageIndex");
        if (upperNumber != _nextPage.pageIndex)
        {
             NSLog(@"upperNumber != _nextPage.pageIndex");
            [self applyNewIndex:upperNumber pageController:_nextPage];
            
        }
    }
    else if (upperNumber == _currentPage.pageIndex)
    {
        NSLog(@"upperNumber == _currentPage.pageIndex");
        if (lowerNumber != _nextPage.pageIndex)
        {
            NSLog(@"lowerNumber != _nextPage.pageIndex");

            [self applyNewIndex:lowerNumber pageController:_nextPage];
        }
    }
    else
    {
        if (lowerNumber == _nextPage.pageIndex)
        {
             NSLog(@"lowerNumber == _nextPage.pageIndex");
            [self applyNewIndex:upperNumber pageController:_currentPage];
            
            
            
        }
        else if (upperNumber == _nextPage.pageIndex)
        {
            NSLog(@"upperNumber == _nextPage.pageIndex");

            [self applyNewIndex:lowerNumber pageController:_currentPage];
            
        }
        else
        {
            NSLog(@"else");

            [self applyNewIndex:lowerNumber pageController:_currentPage];
            
            [self applyNewIndex:upperNumber pageController:_nextPage];
        }
    }
    //[self.currentPage updateTextViews:NO];
    //[self.nextPage updateTextViews:NO];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
