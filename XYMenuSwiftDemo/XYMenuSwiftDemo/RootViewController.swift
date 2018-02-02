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
    }
    
    @IBAction func rigthBarItem(_ sender: Any) {
        print("rightBarItem")
    }
}
