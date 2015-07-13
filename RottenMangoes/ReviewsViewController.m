//
//  DetailViewController.m
//  RottenMangoes
//
//  Created by Alex on 2015-07-01.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "ReviewsViewController.h"
#import "Movie.h"
#import "TheatreMapViewController.h"

@interface ReviewsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *reviewQuote1;
@property (weak, nonatomic) IBOutlet UILabel *criticLabel1;
@property (weak, nonatomic) IBOutlet UILabel *freshnessLabel1;

@property (weak, nonatomic) IBOutlet UITextView *reviewQuote2;
@property (weak, nonatomic) IBOutlet UILabel *criticLabel2;
@property (weak, nonatomic) IBOutlet UILabel *freshnessLabel2;

@property (weak, nonatomic) IBOutlet UITextView *reviewQuote3;
@property (weak, nonatomic) IBOutlet UILabel *criticLabel3;
@property (weak, nonatomic) IBOutlet UILabel *freshnessLabel3;

@end

@implementation ReviewsViewController

#pragma mark - Managing the detail item


-(void)getReviews
{
    NSString *apiKey = @"?apikey=sr9tdu3checdyayjz85mff8j&page_limit=3";
            NSURL *url =[NSURL URLWithString:[self.movie.link stringByAppendingString:apiKey]];
            NSLog(@"movie link: %@", self.movie.link);
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSError *jsonError;
                NSDictionary *reviewsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if(!reviewsDict) {
                    NSLog(@"there was an error! %@", error);
                } else {

                NSArray *reviewsArray = [reviewsDict objectForKey:@"reviews"];
                    NSMutableArray *tempReviews = [NSMutableArray array];
                for(NSDictionary *reviewDict in reviewsArray) {
                    [tempReviews addObject:[reviewDict objectForKey:@"critic"]];
                    [tempReviews addObject:[reviewDict objectForKey:@"freshness"]];
                    [tempReviews addObject:[reviewDict objectForKey:@"quote"]];
                }
                    dispatch_async(dispatch_get_main_queue(), ^{
                    self.reviews = [tempReviews mutableCopy];
                    [self configureView];
                    });
                }
            }];
    [task resume];

}

- (void)configureView {
    // Update the user interface for the detail item.
    NSLog(@"self.reviews %@", self.reviews);
    self.criticLabel1.text = self.reviews[0];
    self.freshnessLabel1.text = self.reviews[1];
    self.reviewQuote1.text = self.reviews[2];
    
    self.criticLabel2.text = self.reviews[3];
    self.freshnessLabel2.text = self.reviews[4];
    self.reviewQuote2.text = self.reviews[5];
    
    self.criticLabel3.text = self.reviews[6];
    self.freshnessLabel3.text = self.reviews[7];
    self.reviewQuote3.text = self.reviews[8];
    
    self.title = self.movie.movieTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"";
    [self getReviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showMapView"]) {
        TheatreMapViewController *mapViewController = (TheatreMapViewController *)segue.destinationViewController;
        mapViewController.movie = self.movie;
    }
}

@end
