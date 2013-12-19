//
//  IKMainViewController.m
//  Walker
//
//  Created by ilteris on 11/13/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import "IKMonthPickerViewController.h"
#import "IKMonthViewController.h"
#import "IKMonthPickerView.h"

@interface IKMonthPickerViewController ()
@property(nonatomic, strong, readwrite) IBOutlet IKMonthPickerView *monthPickerView;

@end

@implementation IKMonthPickerViewController

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

    // Do any additional setup after loading the view.
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
