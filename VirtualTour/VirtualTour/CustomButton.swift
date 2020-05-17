//
//  CustomButton.swift
//  VirtualTour
//
//  Created by Antarpunit Singh on 2012-05-15.
//  Copyright © 2020 AntarpunitSingh. All rights reserved.
//

import UIKit

class CustomButton: UIBarButtonItem {
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    func button(){
        setBackgroundImage(UIImage(systemName: "pin.slash"), for: .normal, style: .plain, barMetrics: .default)
    
        init(bar)
    }
}
