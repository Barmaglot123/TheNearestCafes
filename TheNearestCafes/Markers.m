//
//  Markers.m
//  TheNearestCafes
//
//  Created by Денислям Ибраим on 22.04.17.
//  Copyright © 2017 Денислям Ибраим. All rights reserved.
//

#import "Markers.h"
#import "MarkersDetailsEntity.h"

@implementation Markers 

NSString *const BaseURL = @"https://maps.googleapis.com/maps/api/";
NSString *const APIkey = @"AIzaSyD7MT_lXEXT3Omj1LGGBhyI0xt6nPhNNlU";


-(void)loadCafeMarkersByLatitude: (CGFloat)latitude andLongtitude: (CGFloat)longtitude{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.realm = [RLMRealm defaultRealm];
        [self.realm beginWriteTransaction];
        [self.realm deleteAllObjects];
        [self.realm commitWriteTransaction];

        NSString * requestString = [NSString stringWithFormat:
                                    @"%@place/nearbysearch/json?location=%f,%f&radius=4500&type=restaurant&key=%@",
                                BaseURL,
                                latitude,
                                longtitude,
                                APIkey];
        
        NSURL * url   = [NSURL URLWithString:requestString];
        NSData * data = [NSData dataWithContentsOfURL:url];
        NSMutableDictionary * parsedJsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary * resultsOfAllData = [parsedJsonData objectForKey:@"results"];
        
        for (NSDictionary * currentPlace in resultsOfAllData){
            [self.realm beginWriteTransaction];
            MarkersDetailsEntity * marker = [[MarkersDetailsEntity alloc]init];
            marker.placeID = [NSString stringWithFormat:@"%@",[currentPlace objectForKey:@"place_id"]];
            marker.latitude = [NSString stringWithFormat:@"%@",[[[currentPlace objectForKey:@"geometry"]
                                                             objectForKey:@"location"]
                                                            objectForKey:@"lat"]];;
            marker.longtitude = [NSString stringWithFormat:@"%@",[[[currentPlace objectForKey:@"geometry"]
                                                               objectForKey:@"location"]
                                                              objectForKey:@"lng"]];
            [self.realm addObject:marker];
            [self.realm commitWriteTransaction];
        
        }
        
        
    });
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUploaded" object:nil];

    

}

@end
