# LFScheduler
 Central scheduler for modular project, helping you discouple modules in your project,  ie: Instance in module A invoke methods in module B without import any thing from moudle B.

以Category+NSInvokation实现的组件化项目的中央调度模块，可以实例化并缓存任何对象，并调用对象的方法。

# Usage

1.**生成你的模块**
模块可以由一个或多个类构成，每个类的方法，无论是类方法或是对象方法，都必须以NSDictionary作为参数，返回值则必须是系统类，方便该模块在任何情况下都能被调用。每个类的类名和方法名都要以宏定义的形式声明在头文件中，以便中央模块调用。

2.**生成模块接口头文件**
头文件需要引入模块的所有类，以便被中央调度模块识别并生成相应类的对象，并且可以调用类名和方法名的宏。

3.**生成中央调度模块的Category**
类别的命名推荐使用模块名，同时在实现文件中需要引入中央调度模块，以及本模块的接口头文件，在实现文件中规范要传入的参数和返回值，并使用中央模块的invoke方法调用模块中指定类的指定方法，参数经抓换以NSDictionary的形式传入。

4.**在上层业务中调用**
首先引入对应模块的Category，并调用Category中声明的方法即可。

5**业务需求不变而需要修改实现的逻辑**
只需要替换掉模块中的具体实现即可，不需要在业务的每一个地方都重新引入新的模块，因为中央调度模块不需要改动。

6.**增加新的模块功能**
完成对模块的改动后，将新增的类引入到接口头文件中，同时在对应模块的Category中规范这个接口的参数即可在业务层调用。

7.**业务层参数改变**
首先修改Category中的参数规范，并将新的参数值添加到NSDictionary中，然后在对应的模块方法中将参数取出进行操作即可。

#License
LFBannerView is released under the MIT License. See LICENSE for details.

本仓库遵守MIT开源协议，详情请见LICENSE细节。