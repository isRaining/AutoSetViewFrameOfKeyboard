//
//  ViewController.m
//  keyboardHeight
//
//  Created by Code on 15/11/26.
//  Copyright © 2015年 Code. All rights reserved.
//

#import "ViewController.h"
#define kdeviceHeight [UIScreen mainScreen].bounds.size.height
#define kdeviceWidth [UIScreen mainScreen].bounds.size.width
@interface ViewController ()
{
    UITextField * textField;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHue:118/255.0 saturation:175/255.0 brightness:222/255.0 alpha:1];
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(10, kdeviceHeight-100, kdeviceWidth-20, 40)];
    textField.layer.cornerRadius=4;
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"请输入内容";
    [self.view addSubview:textField];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)keyboardWillChangeFrame:(NSNotification * )notification
{
    NSDictionary * info = [notification userInfo];
    NSLog(@"%@",info);
    //获取键盘弹出结束的使用时间
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGPoint beginPoint = [[info objectForKey:UIKeyboardCenterBeginUserInfoKey] CGPointValue];
    CGPoint endPoint = [[info objectForKey:UIKeyboardCenterEndUserInfoKey] CGPointValue];
    CGFloat distanceY = endPoint.y-beginPoint.y;
    NSLog(@"%f",distanceY);
    
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y +=distanceY;
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = currentFrame;
    }];
    NSLog(@"%@",textField);
}
-(void)tapAction
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
