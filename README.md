# CXToolKit

介绍：基于Switf的不常用（假的）工具库

### 目录：
### 一，Center：特殊用途单例
### 二，Pages：功能性控制器
### 三，Utils: 系统类目的扩展方法
### 四，Component: 组件


### 一，Center：特殊用途单例

#### AppMessageCenter 
所在路径： /Center/AppMessageCenter
功能:手机信息单例

该类是手机的模拟类，用于获取手机的信息，目前支持的方法：
1.获取手机UUID
2.加密UUID
3.查看手机是否有SIM卡
4.获取手机系统信息
5.检查手机版本
6.获取熟悉内存可用大小


### 二，Pages：功能性控制器

#### BaseViewController 
所在路径： /Pages/BaseViewController
功能:基础的base控制器
简单的base控制器，包含修改navigationBar自定义样式，页面懒刷新页面加载事件分离以及


### 三，Utils: 系统类目的扩展方法

#### UIViewControllerUtils 
所在路径： /Utils/Page/UIViewControllerUtils
功能:UIViewController 扩展方法
UIViewController的扩展方法包含了导航栏样式自定义，以及定义了导航栏Title样式，另外包含获取当前控制器以及弹框方法

#### UILabelUtils 
所在路径： /Utils/View/UILabelUtils
功能:UILabel 扩展方法，包含根据label内文字获取高度


#### UIScrollView 
所在路径： /Utils/View/UIScrollView
功能:UIScroll 扩展基于MJRefresh的上拉刷新和下拉加载

#### ViewUtils 
所在路径： /Utils/View/ViewUtils
功能:View 扩展方法，包含：
1.同时添加阴影以及圆角
注意，本质是在原来的VIew下面再放一个VIew，所以需要关注并设置阴影View的大小以及位置才能正常显示
2.部分圆角
3.渐变色
注意：本质也是在父的Layer上面放一个子Layer，以需要关注并设置子Layer的大小以及位置才能正常显示
4.清除子Layer
5.基于贝塞尔曲线的抛物线动画
6.动画清理
7.虚线
8.基于DispatchSourceTimer的倒计时

#### UIImageUtils 
所在路径： /Utils/View/UIImageUtils
功能:UIImage 扩展方法，包含颜色转图片以及圆角


#### UIColorUtils 
所在路径： /Utils/UIColorUtils
功能:UIColor 16位颜色方法

#### NSAttributedStringUtils 
所在路径： /Utils/NSAttributedStringUtils
功能:NSAttributedString 富文本文字标题

#### DateUtils 
所在路径： /Utils/DateUtils
功能:Date 时间格式化

#### DoubleUtils 
所在路径： /Utils/DoubleUtils
功能:Double 英里单位转换以及添加货币符号

#### StringUtils 
所在路径： /Utils/StringUtils
功能:String 包含追加字符，json字符串转字典，以及常用MD5加密

#### UIApplicationUtils 
所在路径： /Utils/UIApplicationUtils
功能:UIApplication 常用的内部跳转方法，包含跳转WEB，打电话，schemes跳转

#### NSLayoutConstraintUtils 
所在路径： /Utils/NSLayoutConstraintUtils
功能:NSLayoutConstraintUtils LayoutConstraint的动态系数调整，注意使用前，需要判断包含这个LayoutConstraint的View是否存在

## 四：组件

#### AppAlertInputViewController 
所在路径： /Component/Alert/AppAlertInputViewController
功能:带输入框的弹框

```
//使用
let alertController = AppAlertViewController()
UIViewController.visibleViewController().present(alertController, animated: false, completion: nil)
```

#### AppAlertViewController 
所在路径： /Component/Alert/AppAlertViewController
功能: 提示信息弹框

```
//使用
let alertController = AppAlertViewController()
UIViewController.visibleViewController().present(alertController, animated: false, completion: nil)
```

#### RadioButtonView：
所在路径： /Component/RadioButtonView
功能: 单项选择器

```

1. init
var radioView:RadioButtonView = RadioButtonView(frame: CGRect())

2. 使用
radioView.delegate = self
radioView.direction = .vertical
radioView.cellSize = CGSize(width: UIScreen.main.bounds.size.width, height: 60)

3.选中回调
func didSelectItemAt(_ radioView: RadioButtonView, didSelect index: Int) {
        
    //获取选项指
    radioIndex = index
        
}

```

#### TitileTextField：
所在路径： /Component/TitileTextField
功能: 输入下拉选项卡

```

1. init
let textField = TitileTextField.activityView()
textField.inputField.placeholder = ""
textField.delegate = self
textField.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
   

2. 下拉数据使用
textField.textArr = ["123","123"]

3.回调
func FieldDidChange(_ field:TitileTextField){
        
    //文字修改
        
}

```

#### BuMessageInput：
所在路径： /Component/BuMessageInput
功能: 消息通知

```

1. init

func showInteractiveMessage(text:String, buttonText:String) {
        
        //唯一
        if self.messageInputArr.count > 0 {
            return
        }
        
        let messageView:BuMessageInput = BuMessageInput.BumessageInput(type: .userPsuerPermissions)
        messageView.frame = CGRect(x: -(view.frame.width * 0.8), y: view.frame.height * 0.15, width: view.frame.width * 0.8, height: view.frame.height * 0.05)
        messageView.messageLabel.text = text
        messageView.messageButton.setTitle(buttonText, for: .normal)
        self.messageInputArr.append(messageView)
        view.addSubview(messageView)
        
        let that = self
        
        UIView.animate(withDuration: 0.5) {
            messageView.frame = CGRect(x: 0, y: that.view.frame.height * 0.15, width: that.view.frame.width * 0.8, height: that.view.frame.height * 0.05)
        } completion: { isAnimate in
            messageView.removeFromSuperview()
        }
        
}

2.使用
showInteractiveMessage(text: "", buttonText: "")

```
