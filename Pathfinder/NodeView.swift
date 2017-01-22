//
//  NodeView.swift
//  Pathfinder
//
//  Created by Tanmay Bakshi on 2017-01-22.
//  Copyright © 2017 Tanmay Bakshi. All rights reserved.
//

import UIKit

let INFINITE = 99999

class NodeView: UIView {
    
    let size: Int = 4
    var nodes: [[Node]] = []
    
    override func awakeFromNib() {
        for _ in 0..<size {
            var final: [Node] = []
            for _ in 0..<size {
                let node = Node()
                node.type = .Air
                final.append(node)
            }
            nodes.append(final)
        }
        nodes[size-1][0].type = .pointA
        nodes[0][size-1].type = .pointB
        self.setNeedsDisplay()
        for i in 0..<nodes.count {
            for j in 0..<nodes[i].count {
                nodes[i][j].x = j
                nodes[i][j].y = i
            }
        }
    }
    
    func createLabel(text: String, pos: CGPoint, size_: CGSize) {
        let label = UILabel(frame: CGRect(x: pos.x, y: pos.y, width: size_.width, height: size_.height))
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = text
        self.addSubview(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var locOfTouch = CGPoint()
        for i in touches {
            locOfTouch = i.location(in: self)
        }
        let colNum = Int(locOfTouch.x / (self.frame.size.width / CGFloat(size)))
        let rowNum = Int(locOfTouch.y / (self.frame.size.height / CGFloat(size)))
        if rowNum <= size-1 && colNum <= size-1 {
            if nodes[rowNum][colNum].type == .Obstacle {
                nodes[rowNum][colNum].type = .Air
                self.setNeedsDisplay()
            } else if nodes[rowNum][colNum].type == .Air || nodes[rowNum][colNum].type == .Path || nodes[rowNum][colNum].type == .ExploredPath {
                nodes[rowNum][colNum].type = .Obstacle
                self.setNeedsDisplay()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var locOfTouch = CGPoint()
        for i in touches {
            locOfTouch = i.location(in: self)
        }
        let colNum = Int(locOfTouch.x / (self.frame.size.width / CGFloat(size)))
        let rowNum = Int(locOfTouch.y / (self.frame.size.height / CGFloat(size)))
        if rowNum <= size-1 && colNum <= size-1 && rowNum >= 0 && colNum >= 0 {
            if nodes[rowNum][colNum].type == .Air || nodes[rowNum][colNum].type == .Path || nodes[rowNum][colNum].type == .ExploredPath {
                nodes[rowNum][colNum].type = .Obstacle
                self.setNeedsDisplay()
            }
        }
    }
    
    func createRect(rect: CGRect, color: UIColor) {
        let cont = UIGraphicsGetCurrentContext()
        cont?.setFillColor(color.cgColor)
        cont?.setStrokeColor(UIColor.orange.cgColor)
        cont?.fill(rect)
        cont?.stroke(rect, width: 2)
    }
    
    func getNeighborForNode(node: Node) -> [Node] {
        let nodex = node.x
        let nodey = node.y
        var finalNodes: [Node] = []
        if nodes.checkIndex(nodey-1) {
            finalNodes.append(nodes[nodey-1][nodex])
        }
        if nodes.checkIndex(nodey+1) {
            finalNodes.append(nodes[nodey+1][nodex])
        }
        if nodes[nodey].checkIndex(nodex+1) {
            finalNodes.append(nodes[nodey][nodex+1])
        }
        if nodes[nodey].checkIndex(nodex-1) {
            finalNodes.append(nodes[nodey][nodex-1])
        }
        var realFinNode: [Node] = []
        for i in finalNodes {
            if i.from == nil && i.type != .Obstacle {
                realFinNode.append(i)
            }
        }
        return realFinNode
    }
    
    func heuristicCostEstimate(from: Node, to: Node) -> Int {
        return (abs(from.x - to.x) + abs(from.y - to.y)) * 40
    }
    
    func lowestFScore() -> Node {
        var finalNode = Node()
        finalNode.g = INFINITE
        finalNode.h = INFINITE
        for i in nodes {
            for j in i {
                if j.f <= finalNode.f && j.g != -100 {
                    finalNode = j
                }
            }
        }
        return finalNode
    }
    
    func reconstructpath(current: Node) -> [Node] {
        var totalPath: [Node] = [current]
        while let par = totalPath.first!.from {
            totalPath.insert(par, at: 0)
        }
        return totalPath
    }
    
    func a_star(_start: Node, _goal: Node) -> [Node] {
        let start = _start
        let goal = _goal
        var closedSet: [Node] = []
        var openSet: [Node] = [start]
        start.g = 0
        start.h = heuristicCostEstimate(from: start, to: goal)
        while openSet.count != 0 {
            var current = lowestFScore()
            if closedSet.count > 0 && openSet.count > 0 {
                if current == closedSet.last! {
                    current = openSet[0]
                }
            }
            if current == goal {
                return reconstructpath(current: current)
            }
            openSet.removeObjFromArray(current)
            closedSet.append(current)
            for neighbor in getNeighborForNode(node: current) {
                var shouldExecuteIf = true
                if closedSet.contains(neighbor) {
                    shouldExecuteIf = false
                }
                if shouldExecuteIf {
                    var tentative_g_score = 0
                    tentative_g_score = current.g + 10
                    if !openSet.contains(neighbor) || tentative_g_score < neighbor.g {
                        neighbor.from = current
                        neighbor.g = tentative_g_score
                        neighbor.h = heuristicCostEstimate(from: neighbor, to: goal)
                        if !openSet.contains(neighbor) {
                            openSet.append(neighbor)
                        }
                    }
                    nodes[neighbor.y][neighbor.x].type = .ExploredPath
                    self.setNeedsDisplay()
                }
            }
        }
        self.setNeedsDisplay()
        return []
    }
    
    @IBAction
    func solve() {
        resetNodes()
        let path = a_star(_start: nodes[size-1][0], _goal: nodes[0][size-1])
        for i in path {
            if nodes[i.y][i.x].type != .pointA && nodes[i.y][i.x].type != .pointB {
                nodes[i.y][i.x].type = .Path
            }
        }
        nodes[0][size-1].type = .pointB
        nodes[size-1][0].type = .pointA
        self.setNeedsDisplay()
    }
    
    @IBAction
    func clear() {
        resetAllNodes()
    }
    
    func resetNodes() {
        var tempNodes = nodes
        nodes = []
        for _ in 0..<size {
            var final: [Node] = []
            for _ in 0..<size {
                let node: Node = Node()
                node.type = .Air
                final.append(node)
            }
            nodes.append(final)
        }
        nodes[size-1][0].type = .pointA
        nodes[0][size-1].type = .pointB
        for i in 0..<nodes.count {
            for j in 0..<nodes[i].count {
                nodes[i][j].x = j
                nodes[i][j].y = i
            }
        }
        for i in 0..<tempNodes.count {
            for j in 0..<tempNodes[i].count {
                if tempNodes[i][j].type == .Obstacle {
                    nodes[i][j].type = .Obstacle
                }
            }
        }
        self.setNeedsDisplay()
    }
    
    func resetAllNodes() {
        nodes = []
        for _ in 0..<size {
            var final: [Node] = []
            for _ in 0..<size {
                let node = Node()
                node.type = .Air
                final.append(node)
            }
            nodes.append(final)
        }
        nodes[size-1][0].type = .pointA
        nodes[0][size-1].type = .pointB
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        self.subviews.map({ $0.removeFromSuperview() })
        let width = self.frame.size.width / CGFloat(size)
        let height = self.frame.size.height / CGFloat(size)
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for i in 0..<nodes.count {
            for j in 0..<nodes[i].count {
                let rect = CGRect(x: x, y: y, width: width, height: height)
                createRect(rect: rect, color: nodes[i][j].color)
                x += width
                nodes[i][j].x = j
                nodes[i][j].y = i
                createLabel(text: "\(nodes[i][j].g) \(nodes[i][j].h) \(nodes[i][j].f)", pos: rect.origin, size_: rect.size)
            }
            y += height
            x = 0
        }
    }
    
}
