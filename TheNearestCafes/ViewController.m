//
//  ViewController.m
//  TheNearestCafes
//
//  Created by Денислям Ибраим on 18.04.17.
//  Copyright © 2017 Денислям Ибраим. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomGoogleMapsCalloutView.h"
#import <AFNetworking.h>

@interface ViewController () <CLLocationManagerDelegate, GMSMapViewDelegate>
@property (strong, nonatomic) GMSMapView * mapView;
@property (strong, nonatomic) NSMutableArray * markerArray;
@property (strong, nonatomic) NSMutableArray * placeIDArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.markerArray = [NSMutableArray new];
    self.placeIDArray = [NSMutableArray new];
    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude zoom:12];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    self.view = self.mapView;
    [self loadCafeMarker];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadCafeMarker{
    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    
     NSString * requestString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=4500&type=restaurant&key=AIzaSyD7MT_lXEXT3Omj1LGGBhyI0xt6nPhNNlU",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude];
    NSURL * url = [NSURL URLWithString:requestString];
    NSData * data  = [NSData dataWithContentsOfURL:url];
    NSMutableDictionary * parsedJsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary * resultsOfAllData = [parsedJsonData objectForKey:@"results"];

    for (NSDictionary * currentPlace in resultsOfAllData){
        
        
        NSString * lat = [NSString stringWithFormat:@"%@",[[[currentPlace objectForKey:@"geometry"]
                                                                             objectForKey:@"location"]
                                                                             objectForKey:@"lat"]];
        
        NSString * lng = [NSString stringWithFormat:@"%@",[[[currentPlace objectForKey:@"geometry"]
                                                                          objectForKey:@"location"]
                                                                          objectForKey:@"lng"]];
        [self.placeIDArray addObject:[NSString stringWithFormat:@"%@",[currentPlace objectForKey:@"place_id"]]];
        [self configureMarkerOfLatitude:[lat floatValue] andLongtitude:[lng floatValue]];
        NSLog(@" lat %@ lng %@ ", lat, lng);
}
    
    

    
}
-(void)configureMarkerOfLatitude: (CGFloat)latitude andLongtitude: (CGFloat)longtitude{
    GMSMarker *marker = [[GMSMarker alloc] init];
    
    marker.position = CLLocationCoordinate2DMake(latitude, longtitude);
    marker.map = self.mapView;
    [self.markerArray addObject:marker];
    

    
}

# pragma mark GMSMapViewDelegate
- (nullable UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{

    CustomGoogleMapsCalloutView * callout = [[[NSBundle mainBundle] loadNibNamed:@"CustomCalloutView" owner:self options:nil] objectAtIndex:0];
    marker.tracksInfoWindowChanges = YES;
    [callout loadPlaceDetailsByPlaceID:[self.placeIDArray objectAtIndex:
                                        [self.markerArray indexOfObject:marker]]];

    return callout;
}

@end
