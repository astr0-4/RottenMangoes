//
//  MapViewController.m
//  RottenMangoes
//
//  Created by Alex on 2015-07-02.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "MapViewController.h"


@import MapKit;

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (assign) BOOL initialLocationSet;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *postalCode;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *myLocationButton;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.initialLocationSet = NO;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
        self.mapView.showsUserLocation = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
   // NSLog(@"%@", currentLocation);
    
    if (!self.initialLocationSet) {
        self.initialLocationSet = YES;
        
        MKCoordinateRegion region = MKCoordinateRegionMake(currentLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
        [self reverseGeocode:currentLocation];
        NSLog(@"reverse geocode happened");
        [self.mapView setRegion:region animated:YES];
    }
}

-(void)getTheatreLocations {
    NSString *postalCode = [self.postalCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *link = [NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", postalCode, self.movie.movieTitle];
    NSLog(@"link: %@", link);
    // to do: add error handling
    NSURL *url = [NSURL URLWithString:link];
   
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        NSDictionary *theatresDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if(!theatresDict) {
            NSLog(@"there was an error! %@", error);
        } else {
            NSArray *theatreArray = [theatresDict objectForKey:@"theatres"];
            for(NSDictionary *theatreDict in theatreArray) {
                Theatre *theatre = [[Theatre alloc] init];
                theatre.postalCode = postalCode;
                theatre.theatreName = [theatreDict objectForKey:@"name"];
                theatre.theatreType = [theatre.theatreName getFirstWord];
                MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
                marker.coordinate = CLLocationCoordinate2DMake([[theatreDict objectForKey:@"lat"] doubleValue] , [[theatreDict objectForKey:@"lng"] doubleValue]);
                marker.title = [theatreDict objectForKey:@"name"];
                [self.mapView addAnnotation:marker];
                }
            }
    }];
    [task resume];
  }

-(UIImage *)imageForTheatreType:(NSString *)theatreType {
    if ([theatreType isEqualToString:@"Cineplex"]) {
        return [UIImage imageNamed:@"galaxy_pin"];
    }
    else if([theatreType isEqualToString:@"SilverCity"]){
        return [UIImage imageNamed:@"colossus_pin"];
    }
    
    else {
        return [UIImage imageNamed:@"theatre_pin"];
    }
                
    
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"TheatreLocation"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"TheatreLocation"];
        NSString *imageTitle = [annotation.title getFirstWord];
        annotationView.image = [self imageForTheatreType:imageTitle];
        annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height / 2);
        annotationView.canShowCallout = YES;
    }
    
    return annotationView;
}




- (IBAction)showTheatreLocations:(id)sender {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        // Prompt User settings
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Denied" message:@"Please let us show you theatre locations near you" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (settingsURL) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }];
        [alertController addAction:openAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if (self.mapView.userLocation) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    }
    [self getTheatreLocations];
}

- (void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         NSLog(@"Finding address");
        if (error) {
            NSLog(@"Error %@", error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            self.postalCode = placemark.postalCode;
            NSLog(@"placemark postalCode %@", placemark.postalCode);
            NSLog(@"postal Code %@", self.postalCode);
           // [self getTheatreLocations];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
