//
//  Movie.h
//  RottenMangoes
//
//  Created by Alex on 2015-07-03.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Showtime, Theatre;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * movieTitle;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSSet *theatres;
@property (nonatomic, retain) NSSet *showtimes;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addTheatresObject:(Theatre *)value;
- (void)removeTheatresObject:(Theatre *)value;
- (void)addTheatres:(NSSet *)values;
- (void)removeTheatres:(NSSet *)values;

- (void)addShowtimesObject:(Showtime *)value;
- (void)removeShowtimesObject:(Showtime *)value;
- (void)addShowtimes:(NSSet *)values;
- (void)removeShowtimes:(NSSet *)values;

@end
