//
//  Review.h
//  RottenMangoes
//
//  Created by Alex on 2015-07-01.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject

@property (strong, nonatomic) NSString *critic;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *originalScore;
@property (strong, nonatomic) NSString *freshness;
@property (strong, nonatomic) NSString *publication;
@property (strong, nonatomic) NSString *quote;
@property (strong, nonatomic) NSURL *link;

@end
