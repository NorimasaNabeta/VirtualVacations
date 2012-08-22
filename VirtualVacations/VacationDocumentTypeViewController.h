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
//@property (nonatomic,strong) UIManagedDocument *photoDatabase;
@property (nonatomic,strong) NSURL *urlDocument;
@end

// NSFetchedResultsControllerDelegate
// – controllerWillChangeContent:
// – controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:
// – controller:didChangeSection:atIndex:forChangeType:
// **– controllerDidChangeContent:
// NSFetchedResultsController during a call to -controllerDidChangeContent:.  attempt to insert row 2 into section 0, but there are only 2 rows in section 0 after the update with userInfo (null)
