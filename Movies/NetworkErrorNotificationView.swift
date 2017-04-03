//
//  NetworkErrorNotificationBar.swift
//  Movies
//
//  Created by Sean McRoskey on 4/2/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

@IBDesignable class NetworkErrorNotificationView: UIView {
    func commonInit() {
        let view = Bundle.main.loadNibNamed("NetworkErrorNotificationView", owner: nil, options: nil)![0] as! UIView
        self.addSubview(view)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
