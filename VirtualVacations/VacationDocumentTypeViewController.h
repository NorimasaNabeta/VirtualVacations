//
//  VacationDocumentTypeViewController.h
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/22.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

#define TITLE_ITINERARY @"Itinerary"
#define TITLE_TAGSEARCH @"Tag Search"

@interface VacationDocumentTypeViewController : UITableViewController
@property (nonatomic,strong) UIManagedDocument *photoDatabase;
@end
