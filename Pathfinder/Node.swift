//
//  Node.swift
//  Pathfinder
//
//  Created by Tanmay Bakshi on 2017-01-22.
//  Copyright © 2017 Tanmay Bakshi. All rights reserved.
//

import UIKit

enum BlockType {
    
    case Air, Obstacle, pointA, pointB, Path, ExploredPath
    
}

class Node: NSObject {
    
    var type: BlockType = .Air
    var x: Int = 0
    var y: Int = 0
    
    var g: Int = -100
    var h: Int = -100
    var f: Int {
        return g + h
    }
    
    var from: Node!
    
    var color: UIColor {
        get {
            if type == .Air {
                return UIColor.white
            } else if type == .Obstacle {
                return UIColor.black
            } else if type == .pointA {
                return UIColor.red
            } else if type == .pointB {
                return UIColor.green
            } else if type == .Path {
                return UIColor.blue
            } else if type == .ExploredPath {
                return UIColor.cyan
            }
            return UIColor.orange
        }
    }
    
}
