//
//  TempQueue.swift
//  Course2FinalTask
//
//  Created by Елена Поспелова on 22/06/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation


class QProvider {
    static func gueue() -> DispatchQueue {
        return DispatchQueue.global()
    }
}
