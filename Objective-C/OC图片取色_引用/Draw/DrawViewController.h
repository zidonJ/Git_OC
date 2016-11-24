//
//  DrawViewController.h
//  Draw
//
//  Created by Zhongwei Sun on 11-10-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickColorView.h"
@interface DrawViewController : UIViewController {
    UIImageView *imageView;
    PickColorView *pickColorView;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) PickColorView *pickColorView;
@end
