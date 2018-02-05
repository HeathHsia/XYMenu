//
//  RootViewController.swift
//  XYMenuSwiftDemo
//
//  Created by FireHsia on 2018/2/2.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func leftBarItem(_ sender: Any) {
        self.showXYMenu(sender: sender, type: .XYMenuLeftNavBar, isNav: true)
    }
    
    @IBAction func rigthBarItem(_ sender: Any) {
        self.showXYMenu(sender: sender, type: .XYMenuRightNavBar, isNav: true)
    }
}


extension UIViewController {
    
    func showMessage(index: Int, titles: [String]) {
        let title = titles[index - 1]
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showXYMenu(sender: Any, type: XYMenuType, isNav: Bool) {
        let images = ["code", "selected", "swap"]
        let titles = ["付款码", "拍    照", "扫一扫"]
        if isNav {
            if let barButtonItem = sender as? UIBarButtonItem {
                barButtonItem.xy_showXYMenu(images: images, titles: titles, currentNavVC: self.navigationController!, type: type, closure: { [unowned self] (index) in
                    self.showMessage(index: index, titles: titles)
                })
            }
        }else {
            if let senderView = sender as? UIView {
                senderView.xy_showXYMenu(images: images, titles: titles, type: type, closure: { [unowned self] (index) in
                    self.showMessage(index: index, titles: titles)
                })
            }
        }
    }
}
