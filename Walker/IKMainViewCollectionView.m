//
//  IKMainViewCollectionView.m
//  Walker
//
//  Created by ilteris on 12/21/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import "IKMainViewCollectionView.h"

@implementation IKMainViewCollectionView


-(void)layoutSubviews {
    
    
    [super layoutSubviews];
    
    NSLog(@"IKMainViewCollectionView layoutSubviews");
    
    CGPoint currentOffset = self.contentOffset;
    CGFloat contentHeight = self.contentSize.height;
    CGFloat centerOffsetY = (contentHeight - self.bounds.size.height)/ 2.0;
    CGFloat distanceFromCenterY = fabsf(currentOffset.y - centerOffsetY);
    
   
    if (distanceFromCenterY > contentHeight/4.0) {
        self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
    }
     
    
}

@end
