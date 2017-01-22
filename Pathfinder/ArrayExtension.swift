//
//  ArrayExtension.swift
//  Pathfinder
//
//  Created by Tanmay Bakshi on 2017-01-22.
//  Copyright © 2017 Tanmay Bakshi. All rights reserved.
//

import Darwin

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObjFromArray(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    
}

extension Array {
    
    func get(_ index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
    
    func checkIndex(_ num: Int) -> Bool {
        if let _ = get(num) {
            return true
        } else {
            return false
        }
    }
    
}
