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
    
    func createAngledRoad(startx: CGFloat, starty: CGFloat, length: CGFloat, startAngle: CGFloat, angleChange: CGFloat) {
        let middleAngle = startAngle + angleChange/2
        
        let middlex = startx + cos(startAngle)*(length/2)
        let middley = starty + sin(startAngle)*(length/2)
        
        let endx = middlex + cos(startAngle+angleChange)*(length/2)
        let endy = middley + sin(startAngle+angleChange)*(length/2)
        
        let leftx1 = startx + cos(startAngle-Double.pi/2)*(width/2)
        let lefty1 = starty + sin(startAngle-Double.pi/2)*(width/2)
        let leftx2 = middlex + cos(middleAngle-Double.pi/2)*((width/2)/cos(middleAngle-startAngle))
        let lefty2 = middley + sin(middleAngle-Double.pi/2)*((width/2)/cos(middleAngle-startAngle))
        let leftx3 = endx + cos(startAngle+angleChange-Double.pi/2)*(width/2)
        let lefty3 = endy + sin(startAngle+angleChange-Double.pi/2)*(width/2)
        
        let rightx1 = startx + cos(startAngle+Double.pi/2)*(width/2)
        let righty1 = starty + sin(startAngle+Double.pi/2)*(width/2)
        let rightx2 = middlex + cos(middleAngle+Double.pi/2)*((width/2)/cos(middleAngle-startAngle))
        let righty2 = middley + sin(middleAngle+Double.pi/2)*((width/2)/cos(middleAngle-startAngle))
        let rightx3 = endx + cos(startAngle+angleChange+Double.pi/2)*(width/2)
        let righty3 = endy + sin(startAngle+angleChange+Double.pi/2)*(width/2)
        
        createWall(x: leftx1 + (leftx2-leftx1)/2, y: lefty1 + (lefty2-lefty1)/2, width: sqrt(pow(leftx1-leftx2, 2) + pow(lefty1-lefty2, 2)), height: wallThickness, rotation: startAngle)
        createWall(x: leftx2 + (leftx3-leftx2)/2, y: lefty2 + (lefty3-lefty2)/2, width: sqrt(pow(leftx2-leftx3, 2) + pow(lefty2-lefty3, 2)), height: wallThickness, rotation: startAngle+angleChange)
        
        createWall(x: rightx1 + (rightx2-rightx1)/2, y: righty1 + (righty2-righty1)/2, width: sqrt(pow(rightx1-rightx2, 2) + pow(righty1-righty2, 2)), height: wallThickness, rotation: startAngle)
        createWall(x: rightx2 + (rightx3-rightx2)/2, y: righty2 + (righty3-righty2)/2, width: sqrt(pow(rightx2-rightx3, 2) + pow(righty2-righty3, 2)), height: wallThickness, rotation: startAngle+angleChange)
        
        createCircleWall(x: leftx2, y: lefty2, radius: wallThickness/2)
        createCircleWall(x: rightx2, y: righty2, radius: wallThickness/2)
        
//        roadPosition.x = endx
//        roadPosition.y = endy
//        roadRotation = startAngle + angleChange
    }
    
    mutating func createWall(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, rotation: CGFloat) {
        var wall = SKSpriteNode(color: .black, size: CGSize(width: width, height: height))
        wall.position = CGPoint(x: x, y: y)
        wall.zRotation = rotation
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = wallCategory
        walls.append(wall)
    }
    
    mutating func createCircleWall(x: CGFloat, y: CGFloat, radius: CGFloat) {
        let shapeNode = SKShapeNode(circleOfRadius: radius)
        shapeNode.fillColor = .black
        shapeNode.lineWidth = 0
        
        var wall = SKSpriteNode()
        wall.position = CGPoint(x: x, y: y)
        wall.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = wallCategory
        
        wall.addChild(shapeNode)
        
        walls.append(wall)
    }
    
    
}

