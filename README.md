# 设置视图自动跟随键盘显隐调整Frame
	由于iPhone系统版本以及屏幕的不同，以及键盘类型的切换，键盘的高度也是随之变化的，所以对于需要弹出键盘的界面，我们也常常会涉及到需要调整视图的偏移，以便于用户输入调整。
	
## 使用KVO监听键盘的变化

### **系统提供三个Key可以方便我们来在键盘发生变化的时候监听它**

* **UIKeyboardWillChangeFrameNotification**  键盘Frame将要发生变化的时候，发出通知
* **UIKeyboardWillHideNotification**  键盘将要隐藏时，发出通知
* **UIKeyboardWillShowNotification**  键盘将要出现时，发出通知

### **根据这三个Key来给当前控制器添加观察者**

```objc
//本例对键盘Frame变化的Key，添加观察者，另外两个可自行撸出
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
```
以上代码可在键盘Frame将要变化时，触发方法**keyboardWillChangeFrame:**，所以我们可以在这个方法中设置当前视图的Frame

```objc
-(void)keyboardWillChangeFrame:(NSNotification * )notification
{
	//notification[@"userInfo"]就是对应的键盘对象的属性，我们可以将它输出下来看
    NSDictionary * info = [notification userInfo];
    NSLog(@"%@",info);
}
```


### **输出后的键盘对应属性**

* **UIKeyboardAnimationCurveUserInfoKey = 7;** 键盘出现的动画类型
* **UIKeyboardAnimationDurationUserInfoKey = "0.25";**  键盘从开始显示到结束的所用时长
* **UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 253}}";**  键盘的尺寸大小(我用的4s的模拟器)
* **UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 606.5}";**  键盘变化之前位置中心
* **UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 353.5}";**  键盘变化之后位置中心
* **UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 480}, {320, 253}}";**  键盘变化之前frame
* **UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 227}, {320, 253}}";**  键盘变化之后frame
* **UIKeyboardIsLocalUserInfoKey = 1;**  这个不知道，有知道的同学请告诉我一下

### **计算键盘高度变化设置View的frame**

1、**获取键盘的变化高度**

* 可根据键盘位置中心的高度变化获得键盘高度变化的距离


```objc
CGPoint beginPoint = [[info objectForKey:UIKeyboardCenterBeginUserInfoKey] CGPointValue];//变化前的中心位置
CGPoint endPoint = [[info objectForKey:UIKeyboardCenterEndUserInfoKey] CGPointValue];//变化后的中心位置
CGFloat distanceY = endPoint.y-beginPoint.y;//变化的高度
```

* 根据键盘frame的变化求得变化高度

```objc
CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];//变化之前的frame
CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];//变化之后的frame  
CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y; //变化的高度
```

2、**设置View的frame**

```objc
//获取view当前的frame
CGRect currentFrame = self.view.frame;
//设置将要取到的frame
currentFrame.origin.y +=distanceY;
//动画
[UIView animateWithDuration:duration animations:^{
        self.view.frame = currentFrame;
    }];
```

可对View添加手势，结束编辑状态，用来使taxtField失去第一响应者

```objc
//创建点击手势
UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
[self.view addGestureRecognizer:tap];//将手势添加至View上
//手势触发的方法
-(void)tapAction
{
    [self.view endEditing:YES];
}
```


