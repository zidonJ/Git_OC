//
//  DrawViewController.m
//  Draw
//
//  Created by Zhongwei Sun on 11-10-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DrawViewController.h"
#import "PickColorView.h"
@implementation DrawViewController
@synthesize imageView;
@synthesize pickColorView;
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = [UIImage imageNamed:@"water.jpg"];
}


- (void)viewDidUnload
{
    self.imageView = nil;
    self.pickColorView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)dealloc {
    [imageView release];
    [pickColorView release];
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
   
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PickColorView" owner:self options:nil];
    for (id oneObject in nib) {
        if ([oneObject isKindOfClass:[PickColorView class]]) {
            self.pickColorView = (PickColorView *)oneObject;
            [pickColorView setSourceImage:self.imageView.image];
            [pickColorView showColorAtPoint:point];
            pickColorView.center = point;
            
            [pickColorView showColorAtPoint:point];
            [self.view addSubview:pickColorView];
            
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.imageView];
    [pickColorView showColorAtPoint:point];
    pickColorView.center = point;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.pickColorView removeFromSuperview];
    self.pickColorView = nil;
}
@end
