//
//  CustomizableTableViewIndexOption.swift
//  CustomizableTableViewIndex
//
//  Created by 王 きん on 2019/07/22.
//

import Foundation

public struct CustomizableTableViewIndexOption {
    
    public init() { }
    
    public var enableScrollShow: Bool = true
    
    public var indexViewWidth: CGFloat = 20.0
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 10)
    public var color: UIColor = UIColor.blue
    
    public var indicatorSize: CGFloat = 80
    public var indicatorFont: UIFont = UIFont.boldSystemFont(ofSize: 32)
    public var indicatorColor: UIColor = UIColor.white
    public var indicatorBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)

}
