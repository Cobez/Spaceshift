//
//  GameScene.swift
//  GyroTest
//
//  Created by Coburn Brandon on 3/17/15.
//  Copyright (c) 2015 Coburn Brandon. All rights reserved.
//

import SpriteKit
import CoreMotion

let userPhys:UInt32 = 0x1
let leftUser:UInt32 = 0x1 << 1
let rightUser:UInt32 = 0x1 << 2
let topUser:UInt32 = 0x1 << 3
let lowUser:UInt32 = 0x1 << 4
let wallPhys:UInt32 = 0x1 << 5

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let motion = CMMotionManager()
    let queue = NSOperationQueue()
    
    let user:User = User()
    var columns:[Column] = []
    
    let wall:SKNode = SKNode()
    
    override func didMoveToView(view: SKView) {
        
        setupUser()
        setupColumns()
        
        let delta:CGFloat = 5
        
//        self.wall.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/1.1)
        
        self.backgroundColor = SKColor(red: 81/255, green: 80/255, blue: 162/255, alpha: 1)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0,0)
        
        
        if motion.gyroAvailable {
            motion.startGyroUpdates()
//            motion.startAccelerometerUpdates()
//            motion.accelerometerUpdateInterval = 1.0 / 100.0
            motion.gyroUpdateInterval = 1.0 / 100.0
            motion.startGyroUpdatesToQueue(queue, withHandler: {data, error in
                guard let data = data else {
                    return
                }
                
//                self.showGyroLabels(data)
                
                if data.rotationRate.y > 0.2 {
                    self.wall.position.y = (self.wall.position.y + delta)
                    
                }
                else if data.rotationRate.y < -0.2 {
                    self.wall.position.y = (self.wall.position.y - delta)
                }
                
                if data.rotationRate.x > 0.15 {
                    self.wall.position.x = (self.wall.position.x + 2*delta)
                }
                else if data.rotationRate.x < -0.15 {
                    self.wall.position.x = (self.wall.position.x - 2*delta)
                }
            })
            
//            motion.startAccelerometerUpdatesToQueue(queue, withHandler: {data, error in
//                guard let data = data else {
//                    return
//                }
//                    self.showAccelLabels(data)
//
//                })
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var wallBody:SKPhysicsBody
        print("Contact")
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            wallBody = contact.bodyB
        } else {
            wallBody = contact.bodyA
        }
        
        if wallBody.categoryBitMask == wallPhys {
            print("Contact")

//            user.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        }
        
    }
    
    func setupUser() {
        user.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
//        let centerX = SKRange(constantValue: self.frame.width/2)
//        let centerY = SKRange(constantValue: self.frame.height/2)
//        let centerConstraint = SKConstraint.positionX(centerX, y: centerY)
//        user.constraints = [centerConstraint]

        addChild(user)
    }
    
    func setupColumns() {
        var rotation = 1;
        // Create a wall of multiple columns stacked on each side
        for var i = -1; i <= 1; i += 2 {
            for var j = -2; j <= 2; j++ {
                let tempCol:Column = Column()
                let tempX:CGFloat = self.frame.size.width/2 + CGFloat(i) * tempCol.frame.height/1.3
                tempCol.position = CGPointMake(tempX, self.frame.height/2 + CGFloat(j)*tempCol.frame.height)
                tempCol.zRotation = CGFloat(M_PI/Double(rotation))
                wall.addChild(tempCol)
            }
            rotation *= -1
        }
        rotation = 2
        // Create the rows centered between the walls to weave through
        for var i = -2; i <= 2; i++ {
            if i == 0 {
                rotation *= 1
            }
            else {
                let tempCol:Column = Column()
                let tempY:CGFloat = self.frame.size.height/2 + CGFloat(i) * tempCol.frame.height/2.2
                tempCol.position = CGPointMake(self.frame.width/2, tempY)
                tempCol.zRotation = CGFloat(M_PI/Double(rotation))
                wall.addChild(tempCol)
            }
        }
        rotation = 2
        // Create top and bottom borders
        for var i = -2; i <= 2; i += 4 {
            for var j = -1; j <= 1; j += 2 {
                let tempCol:Column = Column()
                let tempY:CGFloat = self.frame.size.height/2 + CGFloat(i) * tempCol.frame.height
                tempCol.position = CGPointMake(self.frame.width/2 + CGFloat(j) * tempCol.frame.height/2, tempY)
                tempCol.zRotation = CGFloat(M_PI/Double(rotation))
                wall.addChild(tempCol)
            }
            rotation *= -1
        }
        self.addChild(wall)
        
    }
    
    func showGyroLabels(data:CMGyroData) {
        let gyroXLabel = SKLabelNode(fontNamed: "Helvetica Neue Thin")
        let gyroYLabel = SKLabelNode(fontNamed: "Helvetica Neue Thin")
        let gyroZLabel = SKLabelNode(fontNamed: "Helvetica Neue Thin")
        
        gyroXLabel.fontSize = 22
        gyroXLabel.fontColor = SKColor.blackColor()
        gyroXLabel.position = CGPointMake(100, 310)
       
        gyroYLabel.fontSize = 22
        gyroYLabel.fontColor = SKColor.blackColor()
        gyroYLabel.position = CGPointMake(100, 250)
       
        gyroZLabel.fontSize = 22
        gyroZLabel.fontColor = SKColor.blackColor()
        gyroZLabel.position = CGPointMake(100, 190)
        
        gyroXLabel.text = NSString(format: "gyro X: %.2f", data.rotationRate.x) as String
        gyroYLabel.text = NSString(format: "gyro Y: %.2f", data.rotationRate.y) as String
        gyroZLabel.text = NSString(format: "gyro Z: %.2f", data.rotationRate.z) as String
        
        self.addChild(gyroXLabel)
        self.addChild(gyroYLabel)
        self.addChild(gyroZLabel)
    }
    
    func showAccelLabels(data:CMAccelerometerData) {
        let accelXLabel = SKLabelNode(fontNamed: "Helvetica Neue Thin")
        let accelYLabel = SKLabelNode(fontNamed: "Helvetica Neue Thin")
        let accelZLabel = SKLabelNode(fontNamed: "Helvetica Neue Thin")
        
        accelXLabel.fontSize = 22
        accelXLabel.fontColor = SKColor.blackColor()
        accelXLabel.position = CGPointMake(100, 280)
        
        accelYLabel.fontSize = 22
        accelYLabel.fontColor = SKColor.blackColor()
        accelYLabel.position = CGPointMake(100, 220)
        
        accelZLabel.fontSize = 22
        accelZLabel.fontColor = SKColor.blackColor()
        accelZLabel.position = CGPointMake(100, 160)
        
        accelXLabel.text = NSString(format: "accel X: %.2f", data.acceleration.x) as String
        accelYLabel.text = NSString(format: "accel Y: %.2f", data.acceleration.y) as String
        accelZLabel.text = NSString(format: "accel Z: %.2f", data.acceleration.z) as String
        
        self.addChild(accelXLabel)
        self.addChild(accelYLabel)
        self.addChild(accelZLabel)
    }
    
}
