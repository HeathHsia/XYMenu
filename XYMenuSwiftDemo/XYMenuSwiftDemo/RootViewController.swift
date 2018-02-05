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
        print("leftBarItem")
        let images = ["code", "selected", "swap"]
        let titles = ["付款码", "拍    照", "扫一扫"]
        
        XYMenu.showMenuInBarButtonItem(images: images, titles: titles, currentNavVC: self.navigationController!, type: .XYMenuLeftNavBar) { (index) in
            print("%ld", index)
        }
    }
    
    @IBAction func rigthBarItem(_ sender: Any) {
        print("rightBarItem")
    }
}
