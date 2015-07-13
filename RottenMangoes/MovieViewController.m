//
//  CollectionViewController.m
//  RottenMangoes
//
//  Created by Alex on 2015-07-01.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "MovieViewController.h"
#import "ReviewsViewController.h"

@interface MovieViewController ()

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=sr9tdu3checdyayjz85mff8j&page_limit=50";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSOperations
    
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        NSDictionary *moviesDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSArray *moviesArray = [moviesDict objectForKey:@"movies"];
        
        if(!moviesDict) {
            NSLog(@"there was an error! %@", error);
        } else {
            NSMutableArray *moviesTemp = [NSMutableArray array];
            
            for(NSDictionary *movieDict in moviesArray) {
                Movie *movie = [[Movie alloc] init];
                movie.movieTitle = [movieDict objectForKey:@"title"];
                movie.thumbnail = [[movieDict objectForKey:@"posters"] objectForKey:@"thumbnail"];
                movie.link = [[movieDict objectForKey:@"links"] objectForKey:@"reviews"];
                [moviesTemp addObject:movie];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.movieObjects = [moviesTemp mutableCopy];
                [self.collectionView reloadData];
            });
        }
    }];
    
    [task resume];

    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showDetail"]) {
        ReviewsViewController *detailViewController = (ReviewsViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        detailViewController.movie = self.movieObjects[indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  //  [self getReviews:indexPath];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.movieObjects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [self getMovieImage:indexPath forCell:cell];
    return cell;
}

-(void)getMovieImage:(NSIndexPath *)indexPath forCell:(MovieCell *)cell
{
    // download the image asynchronously
  dispatch_async(dispatch_get_main_queue(), ^{
      Movie *movie = [self.movieObjects objectAtIndex:indexPath.row];
      NSString *imageString = movie.thumbnail;
      NSURL *imageURL = [NSURL URLWithString:imageString];
      
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      cell.movieImageView.image = [UIImage imageWithData:imageData];
  });
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


@end
