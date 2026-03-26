//
//  RoadSection.swift
//  Car Game
//
//  Created by Mobile on 3/23/26.
//

import Foundation
import SpriteKit

let none: UInt32 = 0
let carCategory: UInt32 = 0x1 << 0
let wallCategory: UInt32 = 0x1 << 1

struct RoadSection {
    var x = 0
    var y = 0
    var length = 0
    var width = 0
    var wallThickness = 0
    var angle = 0
    
    var walls = [SKSpriteNode]()
    
    init(x: Int = 0, y: Int = 0, length: Int = 0, width: Int = 0, wallThickness: Int = 0, angle: Int = 0) {
        self.x = x
        self.y = y
        self.length = length
        self.width = width
        self.wallThickness = wallThickness
        self.angle = angle
    }
    
    func createWall(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, rotation: CGFloat) -> SKSpriteNode {
        var wall = SKSpriteNode(color: .black, size: CGSize(width: width, height: height))
        wall.position = CGPoint(x: x, y: y)
        wall.zRotation = rotation
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = wallCategory
        return wall
    }
    
    func createCircleWall(x: CGFloat, y: CGFloat, radius: CGFloat) -> SKSpriteNode {
        let shapeNode = SKShapeNode(circleOfRadius: radius)
        shapeNode.fillColor = .black
        shapeNode.lineWidth = 0
        
        var wall = SKSpriteNode()
        wall.position = CGPoint(x: x, y: y)
        wall.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = wallCategory
        
        wall.addChild(shapeNode)
        
        return wall
    }
    
    
}

