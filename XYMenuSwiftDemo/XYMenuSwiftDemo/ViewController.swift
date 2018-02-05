//
//  ViewController.swift
//  XYMenuSwiftDemo
//
//  Created by FireHsia on 2018/2/2.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func leftButton(_ sender: Any) {
        self.showXYMenu(sender: sender, type: .XYMenuLeftNormal, isNav: false)
    }
    
    @IBAction func mid(_ sender: Any) {
       self.showXYMenu(sender: sender, type: .XYMenuMidNormal, isNav: false)
    }
    
    @IBAction func right(_ sender: Any) {
       self.showXYMenu(sender: sender, type: .XYMenuRightNormal, isNav: false)
    }
}

