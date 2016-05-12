//
//  FKViewController.m
//  Link
//
//  Created by yeeku on 13-7-16.
//  Copyright (c) 2013年 crazyit.org. All rights reserved.
//

#import "FKViewController.h"
#import "FKGameView.h"
#import "Constants.h"
#import "FKPiece.h"

@interface FKViewController ()

@end

@implementation FKViewController
// 游戏界面类
FKGameView* gameView;
// 游戏剩余时间
NSInteger leftTime;
// 定时器
NSTimer* timer;
BOOL isPlaying;
UIAlertView* lostAlert;
UIAlertView* successAlert;
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"room.jpg"];
    self.view.layer.contents = (id) image.CGImage;
    
	[UIApplication sharedApplication].statusBarHidden = YES;
	self.timeText.textColor = [UIColor colorWithRed:1 green:1
		blue: 9/15 alpha:1];
   
	[self.startBn addTarget:self action:@selector(startGame)
		forControlEvents:UIControlEventTouchUpInside];
    // 创建FKGameView控件
    gameView = [[FKGameView alloc] initWithFrame:CGRectMake(0, 20, 500, 600)];
	// 创建FKGameService对象
    gameView.gameService = [[FKGameService alloc] initWithMode:self.chosenMode Scene:self.chosenScene];

	gameView.delegate = self;
	gameView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:gameView];
	// 初始化游戏失败的对话框
	lostAlert = [[UIAlertView alloc] initWithTitle:@"失败！"
		message:@"游戏失败！重新开始？"delegate:self
		cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	// 初始化游戏胜利的对话框
	successAlert = [[UIAlertView alloc] initWithTitle:@"胜利！"
		message:@"游戏胜利！重新开始？"delegate:self
		cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}
- (void) startGame
{
    gameView.hidden = NO;
    self.returnBtn.enabled = NO;
	// 如果之前的timer还未取消，取消timer
	if (timer != nil)
	{
		[timer invalidate];
	}
	// 重新设置游戏时间
	leftTime = DEFAULT_TIME;
	// 开始新的游戏游戏
	[gameView startGame];
	isPlaying = YES;
	timer = [NSTimer scheduledTimerWithTimeInterval:1
		target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
	// 将选中方块设为nil。
	gameView.selectedPiece = nil;
}
- (void) refreshView
{
	self.timeText.text = [NSString stringWithFormat:@"剩余时间：%d" , leftTime];
	leftTime--;
	// 时间小于0, 游戏失败
	if (leftTime < 0)
	{
		[timer invalidate];
		// 更改游戏的状态
		isPlaying = NO;
		[lostAlert show];
        self.returnBtn.enabled = YES;
		return;
	}
}
- (void) alertView:(UIAlertView *)alertView
	clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// 如果用户选中的“确定”按钮
	if(buttonIndex == 1)
	{
		[self startGame];
	}
    // 如果用户选中的“取消”按钮
    else if(buttonIndex == 0)
    {
        self.timeText.text = @"";
    }
}
- (void)checkWin:(FKGameView *)gameView
{
	// 判断是否还有剩下的方块, 如果没有, 游戏胜利
	if (![gameView.gameService hasPieces])
	{
		// 游戏胜利
		[successAlert show];
		// 停止定时器
		[timer invalidate];
		// 更改游戏状态
		isPlaying = NO;
        self.returnBtn.enabled = YES;
	}
}
- (IBAction)stopGame:(id)sender {
    [timer invalidate];
    // 更改游戏的状态
    isPlaying = NO;
    self.returnBtn.enabled = YES;
    self.timeText.text = @"";
//    [self.gameView.gameService.pieces removeAllObjects];
      gameView.hidden = YES;
//    [self viewDidLoad];
}
@end
