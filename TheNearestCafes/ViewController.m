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
#import "MarkersDetailsEntity.h"
#import "Markers.h"
#import <Realm/Realm.h>

@interface ViewController () <CLLocationManagerDelegate, GMSMapViewDelegate>
@property (strong, nonatomic) GMSMapView * mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(configureMarkersOnMap)
                                                 name:@"DataUploaded"
                                               object:nil];

    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude zoom:12];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    self.view = self.mapView;
//    [self.markers loadCafeMarkersByLatitude:locationManager.location.coordinate.latitude andLongtitude:locationManager.location.coordinate.longitude];
//    [self loadCafeMarker];
    Markers * markers = [[Markers alloc]init];
    [markers loadCafeMarkersByLatitude:locationManager.location.coordinate.latitude andLongtitude:locationManager.location.coordinate.longitude];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)configureMarkersOnMap{
    for (MarkersDetailsEntity * currentMarker in [MarkersDetailsEntity allObjects] ){
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([currentMarker.latitude floatValue], [currentMarker.longtitude floatValue]);
        marker.map = self.mapView;
    }
}

# pragma mark GMSMapViewDelegate
- (nullable UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{

    CustomGoogleMapsCalloutView * callout = [[[NSBundle mainBundle] loadNibNamed:@"CustomCalloutView" owner:self options:nil] objectAtIndex:0];
    marker.tracksInfoWindowChanges = YES;
    for (MarkersDetailsEntity * currentMarker in [MarkersDetailsEntity allObjects]){
    
        if ([currentMarker.latitude floatValue] == marker.layer.latitude && [currentMarker.longtitude floatValue] == marker.layer.longitude){
            [callout loadPlaceDetailsByPlaceID:currentMarker.placeID];
        }
    }

    return callout;
}

@end
