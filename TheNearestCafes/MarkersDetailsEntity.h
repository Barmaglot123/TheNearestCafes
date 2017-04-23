//
//  MarkersDetailsEntity.h
//  TheNearestCafes
//
//  Created by Денислям Ибраим on 23.04.17.
//  Copyright © 2017 Денислям Ибраим. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
@interface MarkersDetailsEntity : RLMObject

@property (strong, nonatomic) NSString * placeID;
@property (strong, nonatomic) NSString * latitude;
@property (strong, nonatomic) NSString * longtitude;



@end
