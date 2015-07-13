//
//  DetailViewController.h
//  RottenMangoes
//
//  Created by Alex on 2015-07-01.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface ReviewsViewController : UIViewController

@property (strong, nonatomic) NSArray *reviews;
@property(nonatomic, strong) Movie *movie;

@end

