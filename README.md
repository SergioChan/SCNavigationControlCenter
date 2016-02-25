# SCNavigationControlCenter
This is an advanced navigation control center that can allow you to navigate to whichever view controller you want.  
iOS上的改进的导航栏控制中心。

[![CI Status](http://img.shields.io/travis/Sergio Chan/SCNavigationControlCenter.svg?style=flat)](https://travis-ci.org/Sergio Chan/SCNavigationControlCenter)
[![Version](https://img.shields.io/cocoapods/v/SCNavigationControlCenter.svg?style=flat)](http://cocoapods.org/pods/SCNavigationControlCenter)
[![License](https://img.shields.io/cocoapods/l/SCNavigationControlCenter.svg?style=flat)](http://cocoapods.org/pods/SCNavigationControlCenter)
[![Platform](https://img.shields.io/cocoapods/p/SCNavigationControlCenter.svg?style=flat)](http://cocoapods.org/pods/SCNavigationControlCenter)
## Preview 预览
![image](https://raw.githubusercontent.com/SergioChan/SCNavigationControlCenter/master/Preview/preview.png)

![image](https://raw.githubusercontent.com/SergioChan/SCNavigationControlCenter/master/Preview/preview.gif)

## Version 版本
0.1.5

## Usage 用法

To run the example project, clone the repo, and run `pod install` from the Example directory first.

This idea is originated from [In-App-Navigation-Improvement](https://dribbble.com/shots/2363812-In-App-Navigation-Improvement), since iOS9 has new multi-tasking control center, we are able to transfer the old style of navigation which you have to pop to root view by clicking Back button many times to a similar new one . You can now be able to pop to any previous view controller without clicking Back button for so many times.   
It's a simple improvement anyway. This library may only be suitable for massive and complicated project like Facebook, so I designed this library mostly for its coupling. Bringing this library into your project won't bring you extra work, you only need to implement a line of code in your navigation controller's `viewDidLoad` method as shown in the Demo.  
You can custom the entrance for triggering the control center. In the Demo, I will show you by long pressing the navigation Bar. You can simply custom the triggering by calling:

```Objective-C
[[SCNavigationControlCenter sharedInstance] showWithNavigationController:self];
```

这个创意起源于[In-App-Navigation-Improvement](https://dribbble.com/shots/2363812-In-App-Navigation-Improvement)，由于iOS9推出了新的多任务控制交互，我们可以将传统的一层一层手动返回navigation的逻辑修改为类似的交互。你可以在当前navigationController的视图栈中任意抽取控制器然后pop到那个控制器，而不用手动连续点按Back。这是一个很简单的交互改进。  
由于这个控件可能只适用于规模较大，且页面逻辑极为庞大和复杂的项目，因此我在设计之初考虑的重点就是耦合性。集成这个控件不会给你的项目带去一丝一毫的影响和多余的工作量，你只需要在navigationController的`viewDidLoad`中加上demo中所示的一行代码，并且为控制中心的触发添加一个事件入口。在demo中我展示的是navigationBar长按触发，这个事件可以由你自定义，只要相同的调用

```Objective-C
[[SCNavigationControlCenter sharedInstance] showWithNavigationController:self];
```

即可。进入控制中心页面后，你可以滑动所有视图控制器的列表，点击其中最上面的一个然后返回到这个控制器。也可以点击空白区域取消操作。对于现有的控制器无需任何改动。

## Requirements 环境
iOS 8.0 Above

## Installation 如何集成

SCNavigationControlCenter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SCNavigationControlCenter"
```

## Backlog 日志
* v0.1.0 Basic Version
* v0.1.1 Add demo project
* v0.1.2 Add pop out animation
* v0.1.3 Add appear animation
* v0.1.5 Fix a memory issue
---  
  
* v0.1.0 基本版本
* v0.1.1 添加示例程序
* v0.1.2 添加弹出动画
* v0.1.3 添加出现动画
* v0.1.5 修复一个内存bug


## Author

Sergio Chan, yuheng9211@qq.com

## License

SCNavigationControlCenter is available under the MIT license. 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
