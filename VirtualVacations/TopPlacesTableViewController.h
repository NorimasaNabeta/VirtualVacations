//
//  TopPlacesTableViewController.h
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/07/27.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CoreDataTableViewController.h"

@interface TopPlacesTableViewController : UITableViewController // <UISplitViewControllerDelegate>
@property (nonatomic,strong) NSArray *topPlaces;
@end

//@interface TopPlacesTableViewController : CoreDataTableViewController
//@property (nonatomic,strong) NSArray *topPlaces;
//@property (nonatomic,strong) UIManagedDocument *photoDatabase;
//@end
