//
//  TableViewController.swift
//  XYMenuSwiftDemo
//
//  Created by FireHsia on 2018/2/2.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func left(_ sender: UIButton) {
        self.showXYMenu(sender: sender, type: .XYMenuLeftNormal, isNav: false)
    }
    
    
    @IBAction func mid(_ sender: Any) {
        self.showXYMenu(sender: sender, type: .XYMenuMidNormal, isNav: false)
    }
    
    @IBAction func right(_ sender: Any) {
        self.showXYMenu(sender: sender, type: .XYMenuRightNormal, isNav: false)
    }
   
    // MARK: TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)


        return cell
    }

}
