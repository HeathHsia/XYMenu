# XYMenu

简易集成弹出菜单

三种显示方式(Left, Mid, Right)

自动监测菜单是否超出屏幕(若超出则向上弹出菜单)

若使用中发现问题请提出Issue或heathhsia@gmail.com联系我 

客观慢用 O(∩_∩)O谢谢!

![demo.gif](img/demo.gif)

## OC
1. 将XYMenu文件夹拖入工程中
2. UIView调用菜单 

	引用 ```UIView+XYMenu.h```头文件
	
	```
	@interface UIView (XYMenu)
	/**
 View Show XYMenu
 @param imagesArr 图片
 @param titles 标题
 @param menuType 菜单类型( XYMenuLeftNormal,XYMenuMidNormal,XYMenuRightNormal)
 @param block 回调Block
 */
- (void)xy_showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block
	```
	
3. UIBarButtonItem调用菜单

	引用```UIBarButtonItem+XYMenu.h```头文件
	
	```
	@interface UIBarButtonItem (XYMenu)
	/**
	 NavBarItem Show XYMenu
 	 @param imagesArr 图片
	 @param titles 标题
	 @param menuType 菜单类型(XYMenuLeftNavBar,XYMenuRightNavBar)
 	 @param currentNavVC BarButoonItem的当前NavVC
 	 @param block 回调Block
 	*/
- (void)xy_showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles menuType:(XYMenuType)menuType currentNavVC:(UINavigationController *)currentNavVC withItemClickIndex:(ItemClickIndexBlock)block;
	```

## Swift
后续补上 >_<

## 版本记录
1.0.1 --- 实现View BarButtonItem弹出菜单
	 

	