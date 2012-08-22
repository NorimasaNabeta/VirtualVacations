//
//  ImageViewController.h
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageViewController;
@protocol ImageViewControllerDelegate <NSObject>
- (BOOL)getImageStatus:(ImageViewController *)sender;
- (void)setImageStatus:(ImageViewController *)sender status:(BOOL) sw;
@end


@interface ImageViewController : UIViewController

@property (nonatomic, strong) NSURL *imageURL;
@property (weak, nonatomic) IBOutlet UISwitch *swVisited;
@property (nonatomic, strong) id delegate;
@end
