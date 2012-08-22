//
//  Tag+Create.m
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/22.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

+ (Tag *)tagWithName:(NSString *)name
  inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tag *tag = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *tags = [context executeFetchRequest:request error:&error];
    
    if (!tags || ([tags count] > 1)) {
        // handle error
    } else if (![tags count]) {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                              inManagedObjectContext:context];
        tag.name = name;
    } else {
        tag = [tags lastObject];
    }
    NSLog(@"Tag: %@", tag.name);
    
    return tag;
}

@end
