//
//  GameScene.swift
//  Car Game
//
//  Created by Mobile on 2/9/26.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //car handling variables
    var maxSpeed: CGFloat = 1000
    var acceleration: CGFloat = 500
    var turnSpeed: CGFloat = 0.002
    var turnDampner: CGFloat = 6
    
    //camera variables
    var cameraRotationDampner: CGFloat = 20
    var cameraScale: CGFloat = 3
    var cameraYOffset: CGFloat = 1000
    
    //road variables
    var roadSize = CGFloat(800)
    var wallThickness: CGFloat = 100
    var roadSectionLength: CGFloat = 1000
    var trackLength = 100
    
    
    var leftButton = SKSpriteNode()
    var isLeftPressed: Bool = false
    var rightButton = SKSpriteNode()
    var isRightPressed: Bool = false
    var restartButton = SKSpriteNode()
    
    var car = SKSpriteNode()
    var cameraRotation = CGFloat(0)
    var turnValue = CGFloat(0)
    
    let sceneCamera = SKCameraNode()
    
    var wall: SKSpriteNode!
    var roadPosition = CGPoint(x: 0, y: 0)
    var roadRotation = CGFloat(0)
    
    var particle: SKSpriteNode!
    
    var time: CGFloat = 0
    let timerText = SKLabelNode()
    
    var endposition: CGPoint!
    
    
    
    override func didMove(to view: SKView) {
        sceneCamera.xScale = cameraScale
        sceneCamera.yScale = cameraScale
        camera = sceneCamera
        self.addChild(camera!)
        
        timerText.fontSize = 100
        timerText.fontColor = .white
        timerText.position = CGPoint(x: 0, y: size.height/2 - 300)
        timerText.text = "\(time)"
        sceneCamera.addChild(timerText)
        
        leftButton = SKSpriteNode(color: .orange, size: CGSize(width: size.width, height: size.height))
        leftButton.position = CGPoint(x: -size.width/2, y: 0)
        leftButton.isHidden = true
        sceneCamera.addChild(leftButton)
        
        rightButton = SKSpriteNode(color: .red, size: CGSize(width: size.width, height: size.height))
        rightButton.position = CGPoint(x: size.width/2, y: 0)
        rightButton.isHidden = true
        sceneCamera.addChild(rightButton)
        
        restartButton = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
        restartButton.position = CGPoint(x: 0, y: size.height/2 - 100)
        sceneCamera.addChild(restartButton)
        
        car = SKSpriteNode(color: .blue, size: CGSize(width: 200, height: 100))
        car.position = CGPoint(x: 0, y: 0)
        car.physicsBody = SKPhysicsBody(rectangleOf: car.size)
        addChild(car)
        
        
        
        straightRoad(startx: roadPosition.x, starty: roadPosition.y, length: roadSectionLength, startAngle: roadRotation)
        
        
        for _ in 1...trackLength {
            
            
            angledRoad(startx: roadPosition.x, starty: roadPosition.y, length: roadSectionLength, startAngle: roadRotation, angleChange: Double.random(in: -Double.pi/4...Double.pi/4))
        }
        endposition = CGPoint(x: roadPosition.x, y: roadPosition.y)
        
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let touchPosition = touch.location(in: self)
            let touchPositionConvertedToCamera = convert(touchPosition, to: sceneCamera)
            if restartButton.frame.contains(touchPositionConvertedToCamera){
                restartButton.color = .blue
                let nextScene = MenuScene(fileNamed: "MenuScene")
                nextScene?.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                view?.presentScene(nextScene!, transition: transition)
                
            } else if leftButton.frame.contains(touchPositionConvertedToCamera){
                isLeftPressed = true
            } else if rightButton.frame.contains(touchPositionConvertedToCamera){
                isRightPressed = true
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        var isOverLeftButton = false
//        var isOverRightButton = false
//        
//        for touch in touches {
//            let touchPosition = touch.location(in: self)
//            let touchPositionConvertedToCamera = convert(touchPosition, to: sceneCamera)
//            if leftButton.frame.contains(touchPositionConvertedToCamera){
//                isLeftPressed = true
//            } else if rightButton.frame.contains(touchPositionConvertedToCamera){
//                isRightPressed = true
//            }
            
//            isLeftPressed = isOverLeftButton
//            isRightPressed = isOverRightButton
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPosition = touch.location(in: self)
            let touchPositionConvertedToCamera = convert(touchPosition, to: sceneCamera)
            if leftButton.frame.contains(touchPositionConvertedToCamera){
                isLeftPressed = false
            } else if rightButton.frame.contains(touchPositionConvertedToCamera){
                isRightPressed = false
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPosition = touch.location(in: self)
            let touchPositionConvertedToCamera = convert(touchPosition, to: sceneCamera)
            if leftButton.frame.contains(touchPositionConvertedToCamera){
                isLeftPressed = false
            } else if rightButton.frame.contains(touchPositionConvertedToCamera){
                isRightPressed = false
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        let dx = cos(car.zRotation) * acceleration
        let dy = sin(car.zRotation) * acceleration
        
//        if isRightPressed{
//            rightButton.isHidden = false
//        } else {
//            rightButton.isHidden = true
//        }
//        
//        if isLeftPressed{
//            leftButton.isHidden = false
//        } else {
//            leftButton.isHidden = true
//        }
        
        if isLeftPressed && isRightPressed{
            car.physicsBody?.applyForce(CGVector(dx: -dx, dy: -dy))
        } else {
            car.physicsBody?.applyForce(CGVector(dx: dx, dy: dy)) //apply forward velocity
        }
        
        
        
        
        let xVelocity = car.physicsBody!.velocity.dx
        let yVelocity = car.physicsBody!.velocity.dy
        var speed = sqrt(pow(xVelocity, 2) + pow(yVelocity, 2))
        
        
        
        if(speed > maxSpeed){
            let ratio = maxSpeed / speed
            car.physicsBody?.velocity = CGVector(dx: car.physicsBody!.velocity.dx * ratio, dy: car.physicsBody!.velocity.dy * ratio) //clamp speed to maxSpeed
        }
        
        
        
        speed = sqrt(pow(car.physicsBody!.velocity.dx, 2) + pow(car.physicsBody!.velocity.dy, 2)) //re-adjust speed value
        
        if isLeftPressed{
            //car.color = .green
            
            turnValue = turnValue + (1-turnValue)/turnDampner
        }
        if isRightPressed{
            //car.color = .red
            
            turnValue = turnValue + (-1-turnValue)/turnDampner
        }
        if isLeftPressed == false && isRightPressed == false{
            //car.color = .blue
            turnValue = turnValue + (0-turnValue)/turnDampner
        }
        
        car.physicsBody?.angularVelocity = speed * turnValue * turnSpeed //apply rotational velocity
        
        let newCameraRotation = atan2(car.physicsBody!.velocity.dy, car.physicsBody!.velocity.dx)
        
        if(speed > 1){
            cameraRotation += (shortestAngleChange(start: cameraRotation, end: newCameraRotation))/cameraRotationDampner
        }
        
        
        if cameraRotation > Double.pi{
            cameraRotation -= Double.pi*2
        } else if cameraRotation < -Double.pi{
            cameraRotation += Double.pi*2
        }
        
        //testText.text = "\(cameraRotation)"
        
        if abs(car.zRotation - atan2(car.physicsBody!.velocity.dy, car.physicsBody!.velocity.dx)) > 0.5{
            particleEffect(x: car.position.x - cos(car.zRotation)*100 + cos(car.zRotation-Double.pi/2)*50, y: car.position.y - sin(car.zRotation)*100 + sin(car.zRotation-Double.pi/2)*50,rotation: car.zRotation, color: .black)
            particleEffect(x: car.position.x - cos(car.zRotation)*100 + cos(car.zRotation+Double.pi/2)*50, y: car.position.y - sin(car.zRotation)*100 + sin(car.zRotation+Double.pi/2)*50,rotation: car.zRotation, color: .black)
        }
        
        sceneCamera.position.x = car.position.x + cos(cameraRotation) * cameraYOffset
        sceneCamera.position.y = car.position.y + sin(cameraRotation) * cameraYOffset
        sceneCamera.zRotation = cameraRotation - Double.pi/2
        
        time += 1
        timerText.text = "\(round(time/60*10)/10)"
        
        if(abs(car.position.x - endposition.x) < 1000) && (abs(car.position.y - endposition.y) < 1000){
            car.color = .purple
        }
    }
    
    func shortestAngleChange(start: CGFloat, end: CGFloat) -> CGFloat{
        if abs(end - start) > Double.pi{
            //car.color = .orange
            if end < 0{
                car.color = .yellow
                return Double.pi-start + Double.pi+end
            } else {
                car.color = .orange
                return -Double.pi-start - (Double.pi-end)
            }
        } else {
            car.color = .blue
        }
        
        return end - start
    }
    
    func particleEffect(x: CGFloat, y: CGFloat, rotation: CGFloat, color: UIColor){
        particle = SKSpriteNode(color: color, size: CGSize(width: 10, height: 10))
        particle.position = CGPoint(x: x, y: y)
        particle.zRotation = rotation
        addChild(particle)
        let sequence = SKAction.sequence([SKAction.fadeOut(withDuration: 10), SKAction.removeFromParent()])
        particle.run(sequence)
    }
    
    func makeWall(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, rotation: CGFloat){
        wall = SKSpriteNode(color: .black, size: CGSize(width: width, height: height))
        wall.position = CGPoint(x: x, y: y)
        wall.zRotation = rotation
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.isDynamic = false
        addChild(wall)
    }
    
    func makeCircleWall(x: CGFloat, y: CGFloat, radius: CGFloat){
        let shapeNode = SKShapeNode(circleOfRadius: radius)
        shapeNode.fillColor = .black
        shapeNode.lineWidth = 0
        
        wall = SKSpriteNode()
        wall.position = CGPoint(x: x, y: y)
        wall.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        wall.physicsBody?.isDynamic = false
        
        addChild(wall)
        wall.addChild(shapeNode)
    }
    
    func straightRoad(startx: CGFloat, starty: CGFloat, length: CGFloat, startAngle: CGFloat){
        let x1 = startx + cos(startAngle-Double.pi/2)*(roadSize/2) + cos(startAngle)*(length/2)
        let y1 = starty + sin(startAngle-Double.pi/2)*(roadSize/2) + sin(startAngle)*(length/2)
        let x2 = startx + cos(startAngle+Double.pi/2)*(roadSize/2) + cos(startAngle)*(length/2)
        let y2 = starty + sin(startAngle+Double.pi/2)*(roadSize/2) + sin(startAngle)*(length/2)
        
        makeWall(x: x1, y: y1, width: length, height: wallThickness, rotation: startAngle)
        makeWall(x: x2, y: y2, width: length, height: wallThickness, rotation: startAngle)
        
        roadPosition.x = startx + cos(startAngle)*length
        roadPosition.y = starty + sin(startAngle)*length
    }
    
    func angledRoad(startx: CGFloat, starty: CGFloat, length: CGFloat, startAngle: CGFloat, angleChange: CGFloat){
        let middleAngle = startAngle + angleChange/2
        
        let middlex = startx + cos(startAngle)*(length/2)
        let middley = starty + sin(startAngle)*(length/2)
        
        let endx = middlex + cos(startAngle+angleChange)*(length/2)
        let endy = middley + sin(startAngle+angleChange)*(length/2)
        
        let leftx1 = startx + cos(startAngle-Double.pi/2)*(roadSize/2)
        let lefty1 = starty + sin(startAngle-Double.pi/2)*(roadSize/2)
        let leftx2 = middlex + cos(middleAngle-Double.pi/2)*((roadSize/2)/cos(middleAngle-startAngle))
        let lefty2 = middley + sin(middleAngle-Double.pi/2)*((roadSize/2)/cos(middleAngle-startAngle))
        let leftx3 = endx + cos(startAngle+angleChange-Double.pi/2)*(roadSize/2)
        let lefty3 = endy + sin(startAngle+angleChange-Double.pi/2)*(roadSize/2)
        
        let rightx1 = startx + cos(startAngle+Double.pi/2)*(roadSize/2)
        let righty1 = starty + sin(startAngle+Double.pi/2)*(roadSize/2)
        let rightx2 = middlex + cos(middleAngle+Double.pi/2)*((roadSize/2)/cos(middleAngle-startAngle))
        let righty2 = middley + sin(middleAngle+Double.pi/2)*((roadSize/2)/cos(middleAngle-startAngle))
        let rightx3 = endx + cos(startAngle+angleChange+Double.pi/2)*(roadSize/2)
        let righty3 = endy + sin(startAngle+angleChange+Double.pi/2)*(roadSize/2)
        
        makeWall(x: leftx1 + (leftx2-leftx1)/2, y: lefty1 + (lefty2-lefty1)/2, width: sqrt(pow(leftx1-leftx2, 2) + pow(lefty1-lefty2, 2)), height: wallThickness, rotation: startAngle)
        makeWall(x: leftx2 + (leftx3-leftx2)/2, y: lefty2 + (lefty3-lefty2)/2, width: sqrt(pow(leftx2-leftx3, 2) + pow(lefty2-lefty3, 2)), height: wallThickness, rotation: startAngle+angleChange)
        
        makeWall(x: rightx1 + (rightx2-rightx1)/2, y: righty1 + (righty2-righty1)/2, width: sqrt(pow(rightx1-rightx2, 2) + pow(righty1-righty2, 2)), height: wallThickness, rotation: startAngle)
        makeWall(x: rightx2 + (rightx3-rightx2)/2, y: righty2 + (righty3-righty2)/2, width: sqrt(pow(rightx2-rightx3, 2) + pow(righty2-righty3, 2)), height: wallThickness, rotation: startAngle+angleChange)
        
        makeCircleWall(x: leftx2, y: lefty2, radius: wallThickness/2)
        makeCircleWall(x: rightx2, y: righty2, radius: wallThickness/2)
        
        roadPosition.x = endx
        roadPosition.y = endy
        roadRotation = startAngle + angleChange
    }
    
}
