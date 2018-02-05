//
//  XYMenu.swift
//  XYMenuSwiftDemo
//
//  Created by FireHsia on 2018/2/2.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

import UIKit

enum XYMenuType {
    case XYMenuLeftNavBar
    case XYMenuRightNavBar
    case XYMenuLeftNormal
    case XYMenuMidNormal
    case XYMenuRightNormal
}

private let kXYMenuScreenWidth = Double(UIScreen.main.bounds.size.width)
private let kXYmenuScreenHeight = Double(UIScreen.main.bounds.size.height)
private let XYMenuWidth: Double = 120
private let XYMenuItemHeight: Double = 60

class XYMenu: UIView {
    
    var menuType: XYMenuType
    var menuInitRect: CGRect
    var menuResultRect: CGRect
    var isDismiss: Bool
    var isDown: Bool
    var isShow: Bool
    

    lazy var menuView: XYMenuView = {
        let view = XYMenuView(frame: .zero)
        return view
    }()

    init() {
        isDismiss = false
        isDown = true
        isShow = false
        menuType = .XYMenuMidNormal
        menuInitRect = .zero
        menuResultRect = .zero
        super.init(frame: .zero)
        frame = CGRect(x: 0, y: 0, width: kXYMenuScreenWidth, height: kXYmenuScreenHeight)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
        backgroundColor = .clear
        addSubview(menuView)
    }
    
    @objc func panAction(_ sender : UIPanGestureRecognizer) {
        if (sender.view?.isKind(of: XYMenu.classForCoder()))! {
            return ;
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isInMenuViewWith(point: point) {
            disMissXYMenu()
        }
        return super.hitTest(point, with: event)
    }
    
    fileprivate func isInMenuViewWith(point: CGPoint) -> Bool {
        for subViewV in subviews {
            if (subViewV.isKind(of: XYMenuView.classForCoder())) {
                let menuVPoint = convert(point, to: subViewV)
                let isInMenu = subViewV.point(inside: menuVPoint, with: nil)
                return isInMenu
            }
        }
        return false
    }
    
    fileprivate func disMissXYMenu() {
        if isDismiss || isShow {return}
        isDismiss = true
        menuView.hideContentView()
        menuView.alpha = 1.0
        UIView.animate(withDuration: 0.2, animations: {
            self.menuView.frame = self.menuInitRect
            self.menuView.alpha = 1.0
        }) { (finished) in
            self.isDismiss = false
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: 展示View菜单
    class func showMenuInView(images: Array<String>, titles: Array<String>, inView: UIView, type: XYMenuType, clickClosure: @escaping ItemClickBlock) {
        let xy_menu = XYMenu.init()
        xy_menu.showMenuInView(images: images, titles: titles, inView: inView, type: type, clickClosure: clickClosure)
    }
    
    // MARK: 展示BarbuttonItem菜单
    class func showMenuInBarButtonItem(images: Array<String>, titles: Array<String>, currentNavVC: UINavigationController, type: XYMenuType, clickClosure: @escaping ItemClickBlock) {
        let xy_menu = XYMenu.init()
        xy_menu.showMenuInBarButtonItem(images: images, titles: titles, currentNavVC: currentNavVC, type: type, clickClosure: clickClosure)
    }
    
    
    fileprivate func showMenuInView(images: Array<String> , titles: Array<String>, inView: UIView, type: XYMenuType, clickClosure: @escaping ItemClickBlock) {
        if isShow {return}
        configRect(type: type, inView: inView, titles: titles)
        showAnimateMenu(images: images, titles: titles, type: type, closure: clickClosure)
    }
    
    fileprivate func showMenuInBarButtonItem(images: Array<String>, titles: Array<String>, currentNavVC: UINavigationController, type: XYMenuType, clickClosure: @escaping ItemClickBlock) {
        if isShow {return}
        let statusRect = UIApplication.shared.statusBarFrame
        let statusHeight = Double(statusRect.size.height)
        let navigationBarHeight = Double(currentNavVC.navigationBar.bounds.size.height)
        let XYMenuHeight = XYMenuItemHeight * Double(titles.count)
        menuType = type
        switch menuType {
        case .XYMenuLeftNavBar:
            menuInitRect = CGRect(x: 10 + (XYMenuWidth / 4), y: statusHeight + navigationBarHeight, width: 1, height: 1)
            menuResultRect = CGRect(x: 10, y: statusHeight + navigationBarHeight, width: XYMenuWidth, height: XYMenuHeight)
        case .XYMenuRightNavBar:
            menuInitRect = CGRect(x: Double(kXYMenuScreenWidth) - 10 - (XYMenuWidth / 4), y: statusHeight + navigationBarHeight, width: 1, height: 1)
            menuResultRect = CGRect(x: Double(kXYMenuScreenWidth) - 10 - XYMenuWidth, y: statusHeight + navigationBarHeight, width: XYMenuWidth, height: XYMenuHeight)
        default:
            break
        }
        currentNavVC.view.addSubview(self)
        showAnimateMenu(images: images, titles: titles, type: type, closure: clickClosure)
    }
    
    fileprivate func configRect(type: XYMenuType, inView: UIView, titles: [String])
    {
        menuType = type
        let vcView = XYMenu.rootViewFromSubView(viewSubView: inView)
        let viewSuperView = inView.superview
        let viewRect = inView.frame
        let viewRectFromWindow = viewSuperView?.convert(viewRect, to: vcView)
        let midX = Double((viewRectFromWindow?.midX)!)
        let minY = Double((viewRectFromWindow?.minY)!)
        let maxY = Double((viewRectFromWindow?.maxY)!)
        let XYMenuHeight = XYMenuItemHeight * Double(titles.count)
        
        if (maxY + XYMenuHeight + 5) > kXYmenuScreenHeight {
            isDown = false
        }
        switch menuType {
        case .XYMenuLeftNormal:
            if isDown {
                menuInitRect = CGRect(x: midX, y: maxY, width: 1, height: 1)
                menuResultRect = CGRect(x: midX - (XYMenuWidth / 4), y: maxY + 5, width: XYMenuWidth, height: XYMenuHeight)
            }else {
                menuInitRect = CGRect(x: midX, y: minY, width: 1, height: 1)
                menuResultRect = CGRect(x: midX - (XYMenuWidth / 4), y: minY - 5 - XYMenuHeight, width: XYMenuWidth, height: XYMenuHeight)
            }
        case .XYMenuMidNormal:
            if isDown {
                menuInitRect = CGRect(x: midX, y: maxY, width: 1, height: 1)
                menuResultRect = CGRect(x: midX - (XYMenuWidth / 2), y: maxY + 5, width: XYMenuWidth, height: XYMenuHeight)
            }else {
                menuInitRect = CGRect(x: midX, y: minY, width: 1, height: 1)
                menuResultRect = CGRect(x: midX - (XYMenuWidth / 2), y: minY - 5 - XYMenuHeight, width: XYMenuWidth, height: XYMenuHeight)
            }
        case .XYMenuRightNormal:
            if isDown {
                menuInitRect = CGRect(x: midX, y: maxY, width: 1, height: 1)
                menuResultRect = CGRect(x: midX - (XYMenuWidth * 3 / 4), y: maxY + 5, width: XYMenuWidth, height: XYMenuHeight)
            }else {
                menuInitRect = CGRect(x: midX, y: minY, width: 1, height: 1)
                menuResultRect = CGRect(x: midX - (XYMenuWidth * 3 / 4), y: minY - 5 - XYMenuHeight, width: XYMenuWidth, height: XYMenuHeight)
            }
        default:
            if isDown {
                menuInitRect = CGRect(x: midX, y: maxY, width: 1, height: 1)
                menuResultRect = CGRect(x: midX - (XYMenuWidth / 2), y: maxY + 5, width: XYMenuWidth, height: XYMenuHeight)
            }else {
                menuInitRect = CGRect(x: midX, y: minY, width: 1, height: 1)
                menuResultRect = CGRect(x: midX - (XYMenuWidth / 2), y: minY - 5 - XYMenuHeight, width: XYMenuWidth, height: XYMenuHeight)
            }
        }
        vcView!.addSubview(self)
    }
    fileprivate func showAnimateMenu(images: [String], titles: [String], type: XYMenuType, closure: @escaping ItemClickBlock) {
        if isShow {return}
        isShow = true
        menuView.setConfig(images: images, titles: titles, rect: menuResultRect, menuType: type, down: isDown) { [unowned self] (index) in
            self.disMissXYMenu()
            closure(index)
        }
        menuView.frame = menuInitRect
        menuView.hideContentView()
        menuView.alpha = 0.1
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            self.menuView.frame = self.menuResultRect
            self.menuView.alpha = 1.0
        }) { [unowned self] (finished) in
            self.isShow = false
            self.menuView .showContentView()
        }
    }

    // MARK: 隐藏菜单
    class func disMissMenu(inView: UIView) {
        let xy_menu = XYMenu.XYMenuIn(XYMenuInView: inView)
        if xy_menu != nil {
            xy_menu!.disMissXYMenu()
        }
    }
    
    class func XYMenuIn(XYMenuInView: UIView) -> XYMenu? {
        let rootView = XYMenu.rootViewFromSubView(viewSubView: XYMenuInView)
        if rootView != nil {
            for subV in rootView!.subviews {
                if subV.isKind(of: XYMenu.classForCoder()) {
                    let xy_menu = subV as! XYMenu
                    return xy_menu
                }
            }
        }
        return nil
    }
    
    // MARK: 工具
    class func rootViewFromSubView(viewSubView: UIView) -> UIView? {
        
        
        
        var vc: UIViewController? = nil
        var next = viewSubView.next
        while next != nil {
            if next!.isKind(of: UINavigationController.classForCoder()) {
                vc = next as? UIViewController
                break
            }
            next = next!.next
        }
        if vc == nil {
            next = viewSubView.next
            while next != nil {
                if (next!.isKind(of: UIViewController.classForCoder()) || next!.isKind(of: UITableViewController.classForCoder())) {
                    vc = next as? UIViewController
                    break
                }
                next = next!.next
            }
        }
        if vc != nil {return vc!.view}
        return nil
    }
    
    class func scrollViewFromView(viewSubView: UIView) -> UIScrollView? {
        var scrollView: UIScrollView? = nil
        var next = viewSubView.next
        while next != nil {
            if next!.isKind(of: UIScrollView.classForCoder()) {
                scrollView = next as? UIScrollView
            }
            next = next!.next
        }
        return scrollView
    }
    
}

extension UIBarButtonItem {
    
    func xy_showXYMenu(images: [String], titles: [String], currentNavVC: UINavigationController, type: XYMenuType, closure: @escaping ItemClickBlock) {
        XYMenu.showMenuInBarButtonItem(images: images, titles: titles, currentNavVC: currentNavVC, type: type, clickClosure: closure)
    }
}

extension UIView {
    func xy_showXYMenu(images: [String], titles: [String], type: XYMenuType, closure: @escaping ItemClickBlock) {
        XYMenu.showMenuInView(images: images, titles: titles, inView: self, type: type, clickClosure: closure)
    }
}

