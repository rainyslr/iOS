//
//  FKViewController.h
//  Link
//
//  Created by yeeku on 13-7-16.
//  Copyright (c) 2013年 crazyit.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FKGameView.h"

@interface FKViewController : UIViewController <UIAlertViewDelegate
	, FKGameViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *startBn;
@property (strong, nonatomic) IBOutlet UIButton *returnBtn;
@property (strong, nonatomic) IBOutlet UILabel *timeText;
@property (nonatomic,strong) NSString* chosenMode;
@property (nonatomic,strong) NSString* chosenScene;
- (IBAction)stopGame:(id)sender;

@end
