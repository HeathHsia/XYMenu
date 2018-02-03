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

private let kXYMenuScreenWidth = UIScreen.main.bounds.size.width
private let kXYmenuScreenHeight = UIScreen.main.bounds.size.height
private let XYMenuWidth: Double = 120
private let XYMenuItemHeight: Double = 60


class XYMenu: UIView {
    
    var menuType: XYMenuType
    var menuInitRect: CGRect
    var menuResultRect: CGRect
    var isDismiss: Bool
    var isDown: Bool

    lazy var menuView: XYMenuView = {
        let view = XYMenuView(frame: .zero)
        
        return view
    }()

    init() {
        isDismiss = false
        isDown = true
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: 展示菜单
    class func showMenuInView(images: Array<String>, titles: Array<String>, inView: UIView, type: XYMenuType, clickClosure: ItemClickBlock) {
        let xy_menu = XYMenu.init()
        xy_menu.showMenuInView(images: images, titles: titles, inView: inView, type: type, clickClosure: clickClosure)
    }
    
    class func showMenuInBarButtonItem(images: Array<String>, titles: Array<String>, inNavVC: UINavigationController, type: XYMenuType, clickClosure: ItemClickBlock) {
        let xy_menu = XYMenu.init()
        xy_menu.showMenuInBarButtonItem(images: images, titles: titles, inNavVC: inNavVC, type: type, clickClosure: clickClosure)
        
    }
    
    fileprivate func showMenuInView(images: Array<String> , titles: Array<String>, inView: UIView, type: XYMenuType, clickClosure: ItemClickBlock) {
        
    }
    
    fileprivate func showMenuInBarButtonItem(images: Array<String>, titles: Array<String>, inNavVC: UINavigationController, type: XYMenuType, clickClosure: ItemClickBlock) {
        
    }

    // MARK: 隐藏菜单
    class func disMissMenu(inView: UIView) {
        let xy_menu = XYMenu.XYMenuIn(XYMenuInView: inView)
        if xy_menu != nil {
            xy_menu!.dismissMenu()
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
    
    fileprivate func dismissMenu() {
        
    }
    
    // MARK: 工具
    class func rootViewFromSubView(viewSubView: UIView) -> UIView? {
        var vc: UIViewController? = nil
        var next = viewSubView.next
        while next != nil {
            if (next?.isKind(of: UINavigationController.classForCoder()))! {
                vc = next as? UIViewController
                break
            }
            next = next?.next
        }
        if vc == nil {
            next = viewSubView.next
            while next != nil {
                if ((next?.isKind(of: UIViewController.classForCoder()))! || (next?.isKind(of: UITableViewController.classForCoder()))!) {
                    vc = next as? UIViewController
                    break
                }
                next = next?.next
            }
        }
        if vc != nil {return vc!.view}
        return nil
    }
    
    class func scrollViewFromView(viewSubView: UIView) -> UIScrollView? {
        var scrollView: UIScrollView? = nil
        var next = viewSubView.next
        while next != nil {
            if (next?.isKind(of: UIScrollView.classForCoder()))! {
                scrollView = next as? UIScrollView
            }
            next = next?.next
        }
        return scrollView
    }
    
}
