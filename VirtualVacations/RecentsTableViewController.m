//
//  RecentsTableViewController.m
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/07/27.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoViewController.h"
#import "RecentsStore.h"

@interface RecentsTableViewController ()

@end

@implementation RecentsTableViewController
@synthesize recentPlaces=_recentPlaces;

- (NSArray*) recentPlaces
{
    if(! _recentPlaces){
        _recentPlaces = [RecentsStore getList];
    }
    return _recentPlaces;
}
- (void) setRecentPlaces:(NSArray *)recentPlaces
{
    _recentPlaces = recentPlaces;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}
- (void) viewWillAppear:(BOOL)animated
{
    [self setRecentPlaces:[RecentsStore getList]];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.recentPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recents Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *photo = [self.recentPlaces objectAtIndex:indexPath.row];
    cell.textLabel.text = [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_DESCRIPTION];
 
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.hidesWhenStopped = YES;
    spinner.center=CGPointMake(22, 22); // <-- check !
    spinner.alpha = 0.7f;
    [cell.imageView addSubview:spinner];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatSquare];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageView setImage:[UIImage imageWithData:data]];
            [spinner stopAnimating];
            [spinner removeFromSuperview];
        });
    });    
    
    return cell;
}

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id photoVC = [self.splitViewController.viewControllers lastObject];
    if ([photoVC isKindOfClass:[FlickrPhotoViewController class]]) {
        [photoVC setPhoto:[self.recentPlaces objectAtIndex:indexPath.row]];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%@ :indexPath %@", segue.identifier, indexPath);
    if ([segue.identifier isEqualToString:@"Recents Photo View"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // NSLog(@"indexPath %@", indexPath);
        [segue.destinationViewController setPhoto:[self.recentPlaces objectAtIndex:indexPath.row]];
    }
}


@end
