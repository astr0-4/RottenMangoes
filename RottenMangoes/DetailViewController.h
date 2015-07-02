//
//  DetailViewController.h
//  RottenMangoes
//
//  Created by Alex on 2015-07-01.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"
#import "Movie.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSString *critic;
@property (strong, nonatomic) NSString *quote;
@property (strong, nonatomic) NSString *freshness;
@property (strong, nonatomic) NSArray *reviews;
@property(nonatomic, strong) Movie *movie;

@end

