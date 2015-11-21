//
//  MenuView.swift
//  Business Solutions
//
//  Created by Timothy Transue on 7/26/15.
//  Copyright © 2015 Timothy Transue. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        let borderPath = UIBezierPath(rect: bounds)
        borderPath.lineWidth = 2
        let borderColor = UIColor.blueColor()
        borderColor.setStroke()
        borderPath.stroke()
        alpha = 0.8
    }
    

}
