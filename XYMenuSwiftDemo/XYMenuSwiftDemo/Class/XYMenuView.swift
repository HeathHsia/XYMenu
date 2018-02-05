//
//  XYMenuView.swift
//  XYMenuSwiftDemo
//
//  Created by FireHsia on 2018/2/2.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

import UIKit

private let kItemBtnTag:Int = 1001
private let kXYMenuContentBackColor = UIColor(white: 0.4, alpha: 1.0)
private let kXYMenuContentLineColor = UIColor(white: 0.7, alpha: 1.0)
private let kTriangleHeight:Double = 10
private let kTriangleLength:Double = 16.0

typealias ItemClickBlock = (Int) -> Void

class XYMenuView: UIView {
    
    fileprivate var imagesArr: [String]? = nil
    fileprivate var titlesArr: [String]? = nil
    fileprivate var type: XYMenuType = .XYMenuMidNormal
    fileprivate var isDown:Bool = true
    fileprivate var itemClickBlock: ItemClickBlock? = nil
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.isUserInteractionEnabled = true
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(contentView)
        contentView.frame = frame
        layer.shadowRadius = 2.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfig(images: [String]!, titles: [String]!, rect: CGRect, menuType: XYMenuType, down: Bool, closure: ItemClickBlock!) {
        
        isDown = down
        itemClickBlock = closure
        type = menuType
        imagesArr = images
        titlesArr = titles
        setMenuItems(rect: rect)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let kContentWidth = Double(bounds.size.width)
        let kContentHeight = Double(bounds.size.height)
        let kContentMidX = Double(bounds.midX)
        var triangleX: Double
        let trianglePath = UIBezierPath()
        if isDown {
            switch type {
                case .XYMenuLeftNavBar, .XYMenuLeftNormal:
                    triangleX = (kContentWidth / 4) - (kTriangleLength / 2)
                case .XYMenuRightNormal, .XYMenuRightNavBar:
                    triangleX = kContentMidX + (kContentWidth / 4) - (kTriangleLength / 2)
                case .XYMenuMidNormal:
                    triangleX = kContentMidX - (kTriangleLength / 2)
            }
            trianglePath.move(to: CGPoint(x: Double(triangleX), y: Double(kTriangleHeight)))
            trianglePath.addLine(to: CGPoint(x: Double(triangleX + (kTriangleLength / 2)), y: Double(0)))
            trianglePath.addLine(to: CGPoint(x: Double(triangleX + kTriangleLength), y: Double(kTriangleHeight)))
        }else {
            switch type {
                case .XYMenuLeftNormal, .XYMenuLeftNavBar:
                    triangleX = (kContentWidth / 4) - (kTriangleLength / 2)
                case .XYMenuRightNavBar, .XYMenuRightNormal:
                    triangleX = kContentMidX + (kContentWidth / 4) - (kTriangleLength / 2)
                case .XYMenuMidNormal:
                    triangleX = kContentMidX - (kTriangleLength / 2)
            }
            trianglePath.move(to: CGPoint(x: Double(triangleX), y: Double(kContentHeight - kTriangleHeight)))
            trianglePath.addLine(to: CGPoint(x: Double(triangleX + (kTriangleLength / 2)), y: Double(kContentHeight)))
            trianglePath.addLine(to: CGPoint(x: Double(triangleX + kTriangleLength), y: Double(kContentHeight - kTriangleHeight)))
        }
        kXYMenuContentBackColor.set()
        trianglePath.fill()
        
        if isDown {
            let radiusPath = UIBezierPath(roundedRect: CGRect(x: CGFloat(0.0), y:CGFloat(kTriangleHeight), width: bounds.size.width, height: bounds.size.height - CGFloat(kTriangleHeight)), cornerRadius: 5.0)
            kXYMenuContentBackColor.set()
            radiusPath.fill()
        }else {
            let radiusPath = UIBezierPath(roundedRect: CGRect(x: CGFloat(0.0), y:CGFloat(0.0), width: bounds.size.width, height: bounds.size.height - CGFloat(kTriangleHeight)), cornerRadius: 5.0)
            kXYMenuContentBackColor.set()
            radiusPath.fill()
        }
    }
    
    @objc fileprivate func btnAction(_ sender: Any) {
        if itemClickBlock != nil {
            let view = sender as! UIView
            itemClickBlock!(view.tag - 1000)
        }
    }
    func showContentView() {
        contentView.isHidden = false
        contentView.frame = bounds
    }
    func hideContentView() {
        contentView.isHidden = true
    }
    
    fileprivate func setMenuItems(rect: CGRect) {
        
        let subViews = contentView.subviews
        for view in subViews {
            view.removeFromSuperview()
        }
        let menuContentWidth = Double(rect.size.width)
        let menuContentHeight = Double(rect.size.height)
        
        
        let count = Double(titlesArr!.count)
        let kContentItemHeight = (menuContentHeight - kTriangleHeight) / count
        for i in 0 ..< Int(count)  {
            let itemBtn = UIButton(type: .custom)
            itemBtn.backgroundColor = .clear
            itemBtn.layer.cornerRadius = 5.0
            itemBtn.layer.masksToBounds = true
            itemBtn.tag = kItemBtnTag + i
            itemBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
            contentView.addSubview(itemBtn)
            let item = XYMenuItem.init(imagesArr![i], titlesArr![i])
            item.isUserInteractionEnabled = false
            contentView.addSubview(item)
            if isDown {
                item.setUpViews(CGRect(x: 0.0, y: Double(i) * kContentItemHeight + kTriangleHeight, width: menuContentWidth, height: kContentItemHeight))
                itemBtn.frame = CGRect(x: 0.0, y: Double(i) * kContentItemHeight + kTriangleHeight, width: menuContentWidth, height: kContentItemHeight)
                if i != 0 {
                    let lineLayer = CALayer()
                    lineLayer.cornerRadius = 0.5
                    lineLayer.backgroundColor = kXYMenuContentLineColor.cgColor
                    lineLayer.frame = CGRect(x: (kContentItemHeight / 3) - 4, y: Double(i) * kContentItemHeight + kTriangleHeight - 1, width: menuContentWidth - (kContentItemHeight) * 2.0 / 3.0 + 8, height: 0.5)
                    contentView.layer.addSublayer(lineLayer)
                }
            }else {
                item.setUpViews(CGRect(x: 0, y: Double(i) * kContentItemHeight, width: menuContentWidth, height: kContentItemHeight))
                itemBtn.frame = CGRect(x: 0, y: Double(i) * kContentItemHeight, width: menuContentWidth, height: kContentItemHeight)
                if i != 0 {
                    let lineLayer = CALayer()
                    lineLayer.cornerRadius = 0.5
                    lineLayer.backgroundColor = kXYMenuContentLineColor.cgColor
                    lineLayer.frame = CGRect(x: (kContentItemHeight / 3) - 4, y: (Double(i) * kContentItemHeight) - 1, width: menuContentWidth - (kContentItemHeight) * 2.0 / 3.0 + 8, height: 0.5)
                    contentView.layer.addSublayer(lineLayer)
                }
            }
            let btnHighLightedImg = self.buttonHighLightedImage(imageSize: itemBtn.bounds.size)
            itemBtn.setImage(btnHighLightedImg, for: .highlighted)
        }
    }
    
    fileprivate func buttonHighLightedImage(imageSize: CGSize) -> UIImage {
        let selectedImage: UIImage
        UIGraphicsBeginImageContextWithOptions(imageSize, true, UIScreen.main.scale)
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height), cornerRadius: 5)
        UIColor(white: 0.3, alpha: 1.0).set()
        bezierPath.fill()
        selectedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return selectedImage
    }
    
}
