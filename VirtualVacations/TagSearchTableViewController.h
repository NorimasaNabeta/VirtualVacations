//
//  TagSearchTableViewController.h
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/22.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface TagSearchTableViewController : CoreDataTableViewController
@property (nonatomic,strong) UIManagedDocument *photoDatabase;
@property (nonatomic,strong) NSURL *urlDocument;
@end
