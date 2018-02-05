//
//  XYMenuItem.swift
//  XYMenuSwiftDemo
//
//  Created by FireHsia on 2018/2/2.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

import UIKit

class XYMenuItem: UIView {
    
    var icon: String
    var title: String
    
    // MARK: LazyLoad
    lazy var iconImage: UIImageView = {
        var image = UIImageView.init(image: UIImage.init(named: icon))
        return image
    }()
    
    lazy var titleLab: UILabel = {
        var label = UILabel.init(frame: CGRect.zero)
        label.text = title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.backgroundColor = .clear
        return label
    }()
    
    // MARK: 初始化方法
    init(_ iconStr: String,_ titleStr: String) {
        icon = iconStr
        title = titleStr
        super.init(frame: CGRect.zero)
    }
    
    func setUpViews(_ rect: CGRect) {
        frame = rect
        let kItemHeight = bounds.size.height
        let iconHeight = kItemHeight / 3
        addSubview(iconImage)
        addSubview(titleLab)
        iconImage.frame = CGRect(x: iconHeight, y: iconHeight, width: iconHeight, height: iconHeight)
        let iconMaxY = iconImage.frame.maxY
        titleLab.frame = CGRect(x: iconMaxY + (iconHeight * 3) / 4, y: iconHeight, width: iconHeight * 3, height: iconHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
