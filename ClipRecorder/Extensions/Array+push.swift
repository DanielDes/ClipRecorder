//
//  Array+push.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 10/11/20.
//

import Foundation

extension Array {
    
    mutating func push(newElement: ArrayLiteralElement,maxTail: Int = 4){
        self.insert(newElement, at: 0)
        let diferences = self.count - maxTail
        if diferences > 0 {
            self.removeLast(diferences)
        }
    }
}
