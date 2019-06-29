//
//  TempQueue.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 22/06/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
import UIKit
class QProvider {
    static func gueue() -> DispatchQueue {
        return DispatchQueue.global()
    }
}

class VProvider {
    

    
    static var loadingView: UIView {
        let a = UIView(frame: UIScreen.main.bounds)
        a.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        return a
    }
}
