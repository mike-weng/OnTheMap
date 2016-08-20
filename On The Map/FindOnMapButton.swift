//
//  FindOnMapButton.swift
//  On The Map
//
//  Created by Mike Weng on 1/7/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import Foundation
import UIKit

class FindOnMapButton: UIButton {
    
    let borderedButtonCornerRadius : CGFloat = 6.0
    let buttonTitleFontSize : CGFloat = 15.0
    let lightNavyBlue : UIColor = UIColor(red: 10/255, green: 100/255, blue: 165/255, alpha: 1)
    var backingColor : UIColor? = nil
    var highlightedBackingColor : UIColor? = nil
    
    // MARK: Initialization
    required init(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)!
        self.themeBorderedButton()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.themeBorderedButton()
    }
    
    func themeBorderedButton() {
        self.backgroundColor = UIColor.whiteColor()
        self.highlightedBackingColor = UIColor.lightGrayColor()
        self.backingColor = UIColor.whiteColor()
        self.setTitleColor(lightNavyBlue, forState: .Normal)
        self.titleLabel?.font = UIFont(name: "Roboto-Regular", size: buttonTitleFontSize)
        self.layer.cornerRadius = borderedButtonCornerRadius
    }
    
    // MARK: Tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent: UIEvent?) -> Bool {
        self.backgroundColor = self.highlightedBackingColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        self.backgroundColor = self.backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        self.backgroundColor = self.backingColor
    }

    
}
