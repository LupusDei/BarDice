//
//  JMMFoursquareAPIHelper.h
//
//  Created by Justin Martin on 2/28/13.
//
//

#import <Foundation/Foundation.h>

#define FoursquareClientID @"P2O2FX2KUCRMJAK200KFRACPTO0E4GWSORMTATL1EVXU0CBO"
#define FoursquareClientSecret @"UK5BM5U4T3RKWGTVH3KFIUTQ02QXJJ0Q020OFZHWZ4MNYSPO"
#define FoursquareVersion @"20130228"

@interface JMMFoursquareAPIHelper : NSObject

+(NSString *) buildVenuesExploreRequestWithLat:(float)lat lng:(float)ln;
+(NSString *) buildVenuesSearchRequestWithLat:(float)lat lng:(float)ln andSearchString:(NSString *)search;

@end
