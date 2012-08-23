//
//  Place+Create.m
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/22.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "Place+Create.h"
#import "Itinerary+Create.h"


@implementation Place (Create)

+ (Place *)placeWithName:(NSString *)name
  inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *places = [context executeFetchRequest:request error:&error];
    
    if (!places || ([places count] > 1)) {
        // handle error
    } else if (![places count]) {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place"
                                                     inManagedObjectContext:context];
        place.name = name;
        place.itinerary = [Itinerary itineraryInManagedObjectContext:context];
        
    } else {
        place = [places lastObject];
    }
    NSLog(@"Place: %@", place.name);
    
    return place;
}

@end
