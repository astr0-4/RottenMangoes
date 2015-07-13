//
//  Showtime.h
//  RottenMangoes
//
//  Created by Alex on 2015-07-03.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie, Theatre;

@interface Showtime : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) Movie *movie;
@property (nonatomic, retain) Theatre *theatre;

@end
