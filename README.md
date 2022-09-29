# CXToolKit

介绍：基于Switf的不常用（假的）工具库

目录：1.单项选择器


## 单项选择器：

所在路径： /Component/RadioButtonView
使用方式:

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
