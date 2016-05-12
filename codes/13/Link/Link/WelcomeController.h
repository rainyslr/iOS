//
//  WelcomeController.h
//  Link
//
//  Created by 苏丽荣 on 16/4/26.
//  Copyright © 2016年 crazyit.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeController : UIViewController
@property (nonatomic,strong) NSString* chosenMode;
@property (nonatomic,strong) NSString* chosenScene;
- (IBAction)chooseMode:(id)sender;
- (IBAction)chooseScene:(id)sender;

@end
