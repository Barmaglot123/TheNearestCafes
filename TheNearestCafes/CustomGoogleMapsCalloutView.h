//
//  CustomGoogleMapsCalloutView.h
//  TheNearestCafes
//
//  Created by Денислям Ибраим on 19.04.17.
//  Copyright © 2017 Денислям Ибраим. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomGoogleMapsCalloutView : UIView
@property (weak, nonatomic) IBOutlet UILabel *cafeName;
@property (weak, nonatomic) IBOutlet UILabel *cafeWorkTime;
@property (weak, nonatomic) IBOutlet UIImageView *cafeImage;
-(void)loadPlaceDetailsByPlaceID: (NSString*) placeID;
@end
