//
//  CollectionViewController.h
//  RottenMangoes
//
//  Created by Alex on 2015-07-01.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "MovieCell.h"

@interface CollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSArray *movieObjects;

@end
