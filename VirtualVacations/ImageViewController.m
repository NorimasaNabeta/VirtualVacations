//
//  ImageViewController.m
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ImageViewController

@synthesize imageView = _imageView;
@synthesize imageURL = _imageURL;
@synthesize swVisited = _swVisited;
@synthesize delegate = _delegate;

- (IBAction)visitedChange:(UISwitch *)sender {
    [self.delegate setImageStatus:self status:sender.on];
}

- (void)loadImage
{
    if (self.imageView) {
        if (self.imageURL) {
            dispatch_queue_t imageDownloadQ = dispatch_queue_create("ShutterbugViewController image downloader", NULL);
            dispatch_async(imageDownloadQ, ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = image;
                });
            });
            dispatch_release(imageDownloadQ);
        } else {
            self.imageView.image = nil;
        }
    }
}

- (void)setImageURL:(NSURL *)imageURL
{
    if (![_imageURL isEqual:imageURL]) {
        _imageURL = imageURL;
        if (self.imageView.window) {    // we're on screen, so update the image
            [self loadImage];           
        } else {                        // we're not on screen, so no need to loadImage (it will happen next viewWillAppear:)
            self.imageView.image = nil; // but image has changed (so we can't leave imageView.image the same, so set to nil)
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.imageView.image && self.imageURL) [self loadImage];
    self.swVisited.on = NO;
    if( [self.delegate getImageStatus:self] ){
        self.swVisited.on = YES;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload
{
    self.imageView = nil;
    [self setSwVisited:nil];
    [super viewDidUnload];
}

@end
