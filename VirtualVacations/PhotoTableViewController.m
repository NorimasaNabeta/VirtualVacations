//
//  PhotoTableViewController.m
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/22.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "PhotoTableViewController.h"

#import "FlickrFetcher.h"
#import "FlickrPhotoViewController.h"
#import "PhotoMapViewController.h"
#import "FlickrPhotoAnnotation.h"

@interface PhotoTableViewController ()  <PhotoMapViewControllerDelegate>

@end

@implementation PhotoTableViewController

@synthesize detailPlaces=_detailPlaces;

- (void)setDetailPlaces:(NSArray *)detailPlaces
{
    if (_detailPlaces != detailPlaces) {
        _detailPlaces = detailPlaces;
        if (self.tableView.window) [self.tableView reloadData];
    }
}
- (NSArray*) detailPlaces
{
    if (! _detailPlaces){
        _detailPlaces= [NSMutableArray array];
    }
    return _detailPlaces;
}

- (void) resetPlaces:(NSDictionary *)place {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    UIBarButtonItem *backupButtonItem = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader2", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *detailPlaces = [FlickrFetcher photosInPlace:place maxResults:50];
        NSLog(@"[DETAIL] Download cont: %d", [detailPlaces count]);
        
        // detailPacces must be also display in alphabetical order.
        // Reuiqred Task #2
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PHOTO_TITLE ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedDetailPlaces = [detailPlaces sortedArrayUsingDescriptors:sortDescriptors];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // self.navigationItem.rightBarButtonItem = sender;
            self.detailPlaces = sortedDetailPlaces;
            self.navigationItem.rightBarButtonItem=backupButtonItem;
        });
    });
    dispatch_release(downloadQueue);
}

- (void) setPlace:(NSDictionary *)place
{
    if(_place != place){
        _place = place;
        self.title = [FlickrFetcher namePlace:place];
        [self resetPlaces:place];
        [self.tableView reloadData];
    }
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
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.detailPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // "placeholder.png"(48x48) from apple sample "LazyTableImage"
        // [cell.imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
    }
    NSDictionary *photo = [self.detailPlaces objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
    cell.textLabel.text=[FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text=[FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_DESCRIPTION];
    
    // ExtraCredit1
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.hidesWhenStopped = YES;
    spinner.center=CGPointMake(22, 22); // <-- check !
    spinner.alpha = 0.7f;
    [cell.imageView addSubview:spinner];
    
    // @1594 IMAGE UPDATE RACE CONDITION
    NSString *idRequested = [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_ID];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatSquare];
        NSData *data = [NSData dataWithContentsOfURL:url];
        // id requestedIV = cell.imageView;
        // DEBUG
        // [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]]; // simulate 2 sec latency
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *photo = [self.detailPlaces objectAtIndex:indexPath.row];
            NSString *idCurrent = [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_ID];
            // if( requestedIV == cell.imageView){
            //     NSLog(@"CELL: OK");
            // } else {
            //     NSLog(@"CELL: SWAPPED");
            // }
            
            if ( [idRequested isEqualToString:idCurrent] ){
                [cell.imageView setImage:[UIImage imageWithData:data]];
                [spinner stopAnimating];
                [spinner removeFromSuperview];
            } else {
                NSLog(@"CELL:Image-Update-skip: %@ vs %@", idRequested, idCurrent);
            }
        });
    });
    
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%@ :indexPath %@", segue.identifier, indexPath);

    if ([segue.identifier isEqualToString:@"Flickr Photo View"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"indexPath %@", indexPath);
        NSDictionary *photo = [self.detailPlaces objectAtIndex:indexPath.row];
        [segue.destinationViewController setPhoto:photo];
    }
    else if ([segue.identifier isEqualToString:@"Photo Map Show"]) {
        id detail = segue.destinationViewController;
        if ([detail isKindOfClass:[PhotoMapViewController class]]) {
            PhotoMapViewController *mapVC = (PhotoMapViewController *)detail;
            mapVC.delegate = self;
            mapVC.annotations = [self mapAnnotations];
        }
        
    }
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.detailPlaces count]];
    for (NSDictionary *photo in self.detailPlaces) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

#pragma mark - PhotoMapViewControllerDelegate
- (UIImage *)mapViewController:(PhotoMapViewController *)sender
            imageForAnnotation:(id <MKAnnotation>)annotation
{
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return data ? [UIImage imageWithData:data] : nil;
}



@end
