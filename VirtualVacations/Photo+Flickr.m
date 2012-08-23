//
//  Photo+Flickr.m
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/22.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Place+Create.h"
#import "Tag+Create.h"

@implementation Photo (Flickr)

// 9. Query the database to see if this Flickr dictionary's unique id is already there
// 10. If error, handle it, else if not in database insert it, else just return the photo we found
// 11. Create a category to Photographer to add a factory method and use it to set whoTook
// (then back to PhotographersTableViewController)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)flickrInfo
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        
        
        // -- FLICKR_PHOTO_DESCRIPTION>> description = {"_content" = "";};
        // -- FLICKR_PHOTO_ID>> id = 7835922000;
        // FLICKR_LATITUDE>> latitude = "49.280052";
        // FLICKR_LONGTITUDE>> longitude = "-123.120475";
        // FLICKR_PHOTO_OWNER>> owner = "63754555@N00";
        // ownername = "Stv.";
        // FLICKR_PLACE_ID>> "place_id" = bIDw3tNTVLmESaK1Qg;
        // FLICKR_TAGS>>   tags = "canada vancouver bc livemusic beirut orpheumtheatre exif:iso_speed=1600 geo:city=vancouver camera:make=olympusimagingcorp exif:focal_length=12mm exif:make=olympusimagingcorp geo:countrys=canada exif:aperture=\U019235 geo:state=bc jfflickr olympusomdem5 olympusm1250mmf3563 camera:model=em5 exif:lens=olympusm1250mmf3563 exif:model=em5 geo:lon=123120475 geo:lat=49280052777778";
        // -- FLICKR_PHOTO_TITLE>> title = "Beirut (2)";
        // FLICKR_PHOTO_PLACE_NAME>>

        
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
        photo.place = [Place placeWithName:[flickrInfo objectForKey:FLICKR_PLACE_ID] inManagedObjectContext:context];
        
        NSString *tagWork = [flickrInfo objectForKey:FLICKR_TAGS];
        NSArray *tagParts = [tagWork componentsSeparatedByString:@" "];
        NSMutableSet *tags = [[NSMutableSet alloc] initWithObjects: nil];
        // NSString *tagCooked = [[checked copy] componentsJoinedByString:@" "];
        // NSUTF8StringEncoding = 4,
        for (NSString *part in tagParts){
            //if ([part rangeOfString:@":"].length == NSNotFound){ // <-- NOT WORKING!!!
                Tag *check = [Tag tagWithName:part inManagedObjectContext:context];
                NSLog(@"ADD: %@", part);
                if( check){
                    [tags addObject:check];
                }
            // } else {
            //     NSLog(@"SKIP: %@", part);
            // }
        }
        
        photo.tags = tags;
        // NSLog(@"Photo: %@", photo.imageURL);
    } else {
        photo = [matches lastObject];
    }
    
    return photo;
}

@end
