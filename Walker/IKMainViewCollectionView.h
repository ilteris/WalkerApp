//
//  IKMainViewCollectionView.h
//  Walker
//
//  Created by ilteris on 12/21/13.
//  Copyright (c) 2013 ilteris kaplan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IKMainViewCollectionView;
@protocol IKMainViewCollectionViewDelegate <UICollectionViewDelegate>

- (void) mainCollectionViewWillLayoutSubviews:(IKMainViewCollectionView *)mainCollectionView;

@end



@interface IKMainViewCollectionView : UICollectionView
@property (nonatomic, assign) id <IKMainViewCollectionViewDelegate> delegate;

@end
