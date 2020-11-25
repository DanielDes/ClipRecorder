//
//  Dictionary++.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 24/11/20.
//

import Foundation

extension Dictionary{
    init(keys: [Key], values: [Value]){
        precondition(keys.count == values.count)
        self.init()
        for (key,value) in zip(keys,values){
            self[key] = value
        }
    }
}
