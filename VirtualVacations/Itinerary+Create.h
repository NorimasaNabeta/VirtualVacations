//
//  Itinerary+Create.h
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/23.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "Itinerary.h"

@interface Itinerary (Create)
+ (Itinerary *)itineraryInManagedObjectContext:(NSManagedObjectContext *)context;
@end
