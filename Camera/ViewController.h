//
//  ViewController.h
//  Camera
//
//  Created by Jianqing Gao on 11/9/16.
//  Copyright © 2016 Jianqing Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController{
    IBOutlet UIView *framefoecapture;
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *resultLable;
    
}

- (IBAction)takephoto:(id)sender;


@end

