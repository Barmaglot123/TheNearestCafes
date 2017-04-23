//
//  Markers.h
//  TheNearestCafes
//
//  Created by Денислям Ибраим on 22.04.17.
//  Copyright © 2017 Денислям Ибраим. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Realm/Realm.h>

@interface Markers : NSObject <CLLocationManagerDelegate>
@property (strong, nonatomic) RLMRealm * realm;


-(void)loadCafeMarkersByLatitude: (CGFloat)latitude andLongtitude: (CGFloat)longtitude;
@end
