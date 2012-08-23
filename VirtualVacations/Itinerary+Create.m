//
//  Itinerary+Create.m
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/23.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "Itinerary+Create.h"

@implementation Itinerary (Create)

+ (Itinerary *)itineraryInManagedObjectContext:(NSManagedObjectContext *)context
{
    Itinerary *itinerary = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Itinerary"];
    // request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    // NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    // request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *itineraries = [context executeFetchRequest:request error:&error];
    
    if (!itineraries || ([itineraries count] > 1)) {
        // handle error
    } else if (![itineraries count]) {
        itinerary= [NSEntityDescription insertNewObjectForEntityForName:@"Itinerary"
                                              inManagedObjectContext:context];
        // itineraries.name = name;
    } else {
        itinerary = [itineraries lastObject];
    }
    NSLog(@"Itinerary: %@", @"OK");
    
    return itinerary;
}

@end
