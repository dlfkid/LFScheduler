# LFScheduler
 Central scheduler for modular project, helping you discouple modules in your project,  ie: Instance in module A invoke methods in module B without import any thing from moudle B.

以Category+NSInvokation实现的组件化项目的中央调度模块，可以实例化并缓存任何对象，并调用对象的方法。

# Usage

1. **Customize Your Module**
Build your own module like you nomally do, it can consist of serval classes or just one class. But be sure each method from the class should use NSDictionary as parameter. This is the only way to make the scheduler to invoke method from your moduls.
  
   **生成你的模块**
模块可以由一个或多个类构成，每个类的方法，无论是类方法或是对象方法，都必须以NSDictionary作为参数，方便该模块在任何情况下都能被调用。每个类的类名和方法名都要以宏定义的形式声明在头文件中，以便中央模块调用。

2. **Customize Interface Headers**
Generate a header file and name it after your module name, make sure to import every class you wanna expose.

   **生成模块接口头文件**
头文件需要引入模块的所有类，以便被中央调度模块识别并生成相应类的对象，并且可以调用类名和方法名的宏。

3. **Build Categroies for your module**
Import interface Header of your module in category, as well as the LFScheduler, transform your category methods parameter as NSDictionary and use the scheduler to invoke your module method.

   **生成中央调度模块的Category**
类别的命名推荐使用模块名，同时在实现文件中需要引入中央调度模块，以及本模块的接口头文件，在实现文件中规范要传入的参数和返回值，并使用中央模块的invoke方法调用模块中指定类的指定方法，参数经抓换以NSDictionary的形式传入。

4. **Call Category methods to use your own module**
Import the category to use your module.

   **在上层业务中调用**
首先引入对应模块的Category，并调用Category中声明的方法即可。使用组件化调度的模式可以使业务层和组件层之间不产生依赖关系，双方通过调度层进行中转，因此无论业务层还是组件层的实现发生变化，最多只需要修改接口头文件/模块实现文件/模块类别文件三个文件即可。

# License
LFBannerView is released under the MIT License. See LICENSE for details.

本仓库遵守MIT开源协议，详情请见LICENSE细节。