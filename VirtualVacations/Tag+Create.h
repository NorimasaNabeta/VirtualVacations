//
//  Tag+Create.h
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/22.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)

+ (Tag *)tagWithName:(NSString *)name
  inManagedObjectContext:(NSManagedObjectContext *)context;

@end
