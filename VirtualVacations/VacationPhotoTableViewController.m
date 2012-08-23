//
//  VacationPhotoTableViewController.m
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/23.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "VacationPhotoTableViewController.h"
#import "ImageViewController.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "Photo.h"
#import "Place.h"
#import "Tag.h"

@interface VacationPhotoTableViewController () <ImageViewControllerDelegate>

@end

@implementation VacationPhotoTableViewController
@synthesize photoDatabase=_photoDatabase;
@synthesize tag=_tag;

- (void) setTag:(Tag *)tag
{
    if (_tag != tag) {
        _tag = tag;
    }
     self.title = tag.name;
    [self setupFetchedResultsController];
    NSLog(@"tag: %@", tag.name);
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // no predicate because we want ALL the Photographers

    NSManagedObjectContext *context;
    //    if (self.place) {
    //        request.predicate = [NSPredicate predicateWithFormat:@"place.name = %@", self.place.name];
    //        context = self.place.managedObjectContext;
    //    }
    if (self.tag) {
        request.predicate = [NSPredicate predicateWithFormat:@"%@ in tags", self.tag];
        context = self.tag.managedObjectContext;
    }
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:request
                                     managedObjectContext:self.tag.managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
    
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Photo *photo = [self.vacationPhotos objectAtIndex:indexPath.row];
    // Then configure the cell using it ...
    cell.textLabel.text = photo.title;
    // cell.detailTextLabel.text = [NSString stringWithFormat:@"photo: %d", [tag.photos count]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // be somewhat generic here (slightly advanced usage)
    // we'll segue to ANY view controller that has a photographer @property
    // if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
    if ([segue.destinationViewController respondsToSelector:@selector(setDelegate:)]) {
        // use performSelector:withObject: to send without compiler checking
        // (which is acceptable here because we used introspection to be sure this is okay)
        
        NSURL *url = [NSURL URLWithString:photo.imageURL];
        [segue.destinationViewController setTitle:photo.title];
        [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
        [segue.destinationViewController performSelector:@selector(setDelegate:) withObject:self];
    }
    
}

#pragma mark - ImageViewControllerDelegate
- (BOOL) getImageStatus:(ImageViewController *)sender
{
    BOOL result = NO;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow ];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (photo){
        result = [photo.place.visited boolValue];
    }
    
    return result;
}
- (void)setImageStatus:(ImageViewController *)sender status:(BOOL) sw
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow ];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (photo){
        photo.place.visited = [NSNumber numberWithBool:sw];
    }
}

@end
