//
//  PhotoTableViewController.h
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/22.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTableViewController : UITableViewController
@property (nonatomic,strong) NSDictionary *place;
@property (nonatomic,strong) NSArray *detailPlaces;
@end
