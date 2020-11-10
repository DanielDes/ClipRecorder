//
//  String+Truncate.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 10/11/20.
//

import Foundation


extension String {
    
    func truncate(length: Int) -> String{
        return (self.count > length) ? self.prefix(length) + "..." : self
    }
}
