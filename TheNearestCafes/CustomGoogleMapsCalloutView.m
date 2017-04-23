//
//  CustomGoogleMapsCalloutView.m
//  TheNearestCafes
//
//  Created by Денислям Ибраим on 19.04.17.
//  Copyright © 2017 Денислям Ибраим. All rights reserved.
//

#import "CustomGoogleMapsCalloutView.h"
#import <AFNetworking.h>
@implementation CustomGoogleMapsCalloutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)loadPlaceDetailsByPlaceID: (NSString*) placeID{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * requestString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=AIzaSyD7MT_lXEXT3Omj1LGGBhyI0xt6nPhNNlU",placeID];
    
        UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview: indicator];
        [self bringSubviewToFront:indicator];
        indicator.center = CGPointMake(75, 70);
        indicator.hidesWhenStopped = YES;
        
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [indicator stopAnimating];
            NSDictionary * resultsDictionary = [responseObject objectForKey:@"result"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.cafeName.text = [resultsDictionary objectForKey:@"name"];
                self.cafeWorkTime.text = [[[resultsDictionary objectForKey:@"opening_hours"] objectForKey:@"weekday_text"] objectAtIndex:[self currentWeekDay]];
                
            });

        } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        }];
    });
  
}
-(NSInteger)currentWeekDay{
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents* dateComponents = [currentCalendar components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    return [dateComponents weekday] - 1;


    
}

@end
