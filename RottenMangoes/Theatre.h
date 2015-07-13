//
//  Theatre.h
//  RottenMangoes
//
//  Created by Alex on 2015-07-03.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie, Showtime;

@interface Theatre : NSManagedObject

@property (nonatomic, retain) NSString * theatreName;
@property (nonatomic, retain) NSString * theatreType;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSSet *movies;
@property (nonatomic, retain) NSSet *showtimes;

@end

@interface Theatre (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;

- (void)addShowtimesObject:(Showtime *)value;
- (void)removeShowtimesObject:(Showtime *)value;
- (void)addShowtimes:(NSSet *)values;
- (void)removeShowtimes:(NSSet *)values;

@end
