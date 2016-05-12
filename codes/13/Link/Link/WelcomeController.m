//
//  WelcomeController.m
//  Link
//
//  Created by 苏丽荣 on 16/4/26.
//  Copyright © 2016年 crazyit.org. All rights reserved.
//

#import "WelcomeController.h"
#import "FKViewController.h"

@interface WelcomeController ()

@end

@implementation WelcomeController
NSArray* modes;
NSArray* scenes;
- (instancetype)init
{
//    [super init];
      return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     //UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome.png"]];
//    [self.view insertSubview:imgView atIndex:0];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"welcome.png"]];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"small_bg.png"]];
//    UIImage *image = [UIImage imageNamed:@"welcome.png"];
//    self.view.layer.contents = (id) image.CGImage;
    modes = [[NSArray alloc] initWithObjects:@"完满模式", @"竖条纹", @"横条纹", nil];
    scenes = [[NSArray alloc] initWithObjects:@"动物世界", @"qq风格", nil];
    self.chosenMode = [modes objectAtIndex:0];
    self.chosenScene = [scenes objectAtIndex:0];
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chooseMode:(id)sender {
    UIActionSheet* sheet = [[UIActionSheet alloc]
                            initWithTitle:@"请选择模式" // 指定标题
                            delegate:self // 指定该UIActionSheet的委托对象就是该控制器自身
                            cancelButtonTitle:@"取消" // 指定取消按钮的标题
                            destructiveButtonTitle:@"确定" // 指定销毁按钮的标题
                            otherButtonTitles:@"完满模式", @"竖条纹", @"横条纹",nil]; // 为其他按钮指定标题
    // 设置UIActionSheet的风格	
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];

}

- (IBAction)chooseScene:(id)sender {
        UIActionSheet* sheet = [[UIActionSheet alloc]
                                initWithTitle:@"请选择场景" // 指定标题
                                delegate:self // 指定该UIActionSheet的委托对象就是该控制器自身
                                cancelButtonTitle:@"取消" // 指定取消按钮的标题
                                destructiveButtonTitle:@"确定" // 指定销毁按钮的标题
                                otherButtonTitles:@"动物世界", @"qq风格",nil]; // 为其他按钮指定标题
        // 设置UIActionSheet的风格
        sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"请选择模式"]) {
        if (buttonIndex > 0 && buttonIndex <=[modes count]) {
            self.chosenMode = [modes objectAtIndex:buttonIndex - 1];
        }
    }
    if (buttonIndex > 0 && buttonIndex <=[scenes count]) {
        self.chosenScene = [scenes objectAtIndex:buttonIndex - 1];
    }
    NSLog(@"%@",actionSheet.title);
//    NSLog(@"%@",[NSString stringWithFormat:@"您单击了第%ld个按钮" , buttonIndex]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    FKViewController* fkVc = segue.destinationViewController;
    fkVc.chosenMode = self.chosenMode;
    fkVc.chosenScene = self.chosenScene;
}

@end
