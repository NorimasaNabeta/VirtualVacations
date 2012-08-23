//
//  VacationPhotoTableViewController.h
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/23.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Tag.h"

@interface VacationPhotoTableViewController : CoreDataTableViewController
@property (nonatomic,strong) UIManagedDocument *photoDatabase;
@property (nonatomic,strong) Tag *tag;
@end
