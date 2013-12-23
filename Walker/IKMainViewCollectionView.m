//
//  IKMainViewCollectionView.m
//  Walker
//
//  Created by ilteris on 12/21/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import "IKMainViewCollectionView.h"

@implementation IKMainViewCollectionView
@dynamic delegate;

-(void)layoutSubviews {
    
    
    [super layoutSubviews];
    
  //  NSLog(@"IKMainViewCollectionView layoutSubviews");
    
    
    
       [self.delegate mainCollectionViewWillLayoutSubviews:self];
    
    
}

@end
