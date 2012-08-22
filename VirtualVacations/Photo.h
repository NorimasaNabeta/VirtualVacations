//
//  Photo.h
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/22.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place, Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSNumber * visited;
@property (nonatomic, retain) NSDate * visitDate;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) Tag *tag;

@end
