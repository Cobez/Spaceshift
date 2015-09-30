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
    
    var lastUpdateTimeInterval: CFTimeInterval = 0
    var dt: CFTimeInterval = 0
    
    var dY: Double = 0.0
    
    let user:User = User()
    let wall:SKNode = SKNode()
    
    let gx = DataLabel()
    let gy = DataLabel()
    let gz = DataLabel()
    
    let ax = DataLabel()
    let ay = DataLabel()
    let az = DataLabel()
    
    override func didMoveToView(view: SKView) {
        
        setupEnvironment()
        
        setupUser()
        setupColumns()
        
        setupGyroLabels()
        setupAccelLabels()
        
        enableGyroControl()
        enableAccelControl()
    
    }
    
    override func update(currentTime: NSTimeInterval) {
        dt += currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        if dt >= 1.1 {
            dt = 0.5
        }
    }
    
    func enableGyroControl() {
        let delta:CGFloat = 25   // Normalized control movement
        
        if motion.gyroAvailable {
            motion.startGyroUpdates()
            motion.gyroUpdateInterval = 1.0 / 40.0
            motion.startGyroUpdatesToQueue(queue, withHandler: { data, error in
                guard let data = data else {
                    return
                }
                
//                self.updateGyroLabels(data)
                
                if data.rotationRate.y > 0.2 {
                    self.wall.position.y = (self.wall.position.y + delta)
                    
                }
                else if data.rotationRate.y < -0.2 {
                    self.wall.position.y = (self.wall.position.y - delta)
                }
                
                if data.rotationRate.x > 0.10 && /*self.dY < 0.05 &&*/ data.rotationRate.z > 0.1 {
                    self.wall.position.x = (self.wall.position.x + 2*delta)
                }
                else if data.rotationRate.x < -0.10 && /*self.dY < 0.05 &&*/ data.rotationRate.z < -0.1 {
                    self.wall.position.x = (self.wall.position.x - 2*delta)
                }
            })
            
        }
    }
    
    func enableAccelControl() {
        //        let delta:CGFloat = 5
        var deltaY: Double = 0.0
        
        if motion.accelerometerAvailable {
            motion.startAccelerometerUpdates()
            motion.accelerometerUpdateInterval = 1.0 / 40.0
            motion.startAccelerometerUpdatesToQueue(queue, withHandler: { data, error in
                guard let data = data else {
                    return
                }
                
//                self.updateAccelLabels(data)
                
                if self.dt >= 1.0 {
                    deltaY = data.acceleration.y
//                    print("\(deltaY)")
                }
                self.dY = abs(deltaY - data.acceleration.y)
                
//                if abs(deltaY - data.acceleration.y) > 0.1 {
//                    
//                }
                
            })
        }
    }
    
    func setupEnvironment() {
        self.backgroundColor = SKColor(red: 81/255, green: 80/255, blue: 162/255, alpha: 1)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0,0)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var wallBody:SKPhysicsBody
        let lPos = self.user.position.x - contact.contactPoint.x
        let rPos = contact.contactPoint.x - self.user.position.x
        let dPos = self.user.position.y - contact.contactPoint.y
        let uPos = contact.contactPoint.y - self.user.position.y
        var max = rPos
        var ml = "right"
        if lPos > max {
            max = lPos
            ml = "left"
        }
        if uPos > max {
            max = uPos
            ml = "up"
        }
        if dPos > max {
            max = dPos
            ml = "down"
        }
        print(ml)
        //print("Contact point", contact.contactPoint.y)
        //print("User ", self.user.position.y)
        //if contact.contactPoint.y > self.user.position.y {
        //    print("Contact with top of user")
        //}
        //print(NSString(format: "dY: %.2f", contact.contactPoint.y - self.user.position.x))
        /*
        let myLabel:SKLabelNode = SKLabelNode(text: "x")
        let myLabel2:SKLabelNode = SKLabelNode(text: "0")
        myLabel2.position.y = contact.contactPoint.y
        myLabel2.position.x = contact.contactPoint.x
        myLabel.position.y = self.user.position.y
        myLabel.position.x = self.user.position.x
        self.addChild(myLabel)
        self.addChild(myLabel2)
        */
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            wallBody = contact.bodyB
        } else {
            wallBody = contact.bodyA
        }
        
        if wallBody.categoryBitMask == wallPhys {
            // print("Contact")
            user.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        }
        
    }
    
    func setupUser() {
        user.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        addChild(user)
    }
    
    func setupGyroLabels() {
        gx.position = CGPointMake(100, 310)
        gy.position = CGPointMake(100, 250)
        gz.position = CGPointMake(100, 190)
        
        self.addChild(gx)
        self.addChild(gy)
        self.addChild(gz)
    }
    
    func updateGyroLabels(data: CMGyroData) {
        gx.text = NSString(format: "gyro X: %.2f", data.rotationRate.x) as String
        gy.text = NSString(format: "gyro Y: %.2f", data.rotationRate.y) as String
        gz.text = NSString(format: "gyro Z: %.2f", data.rotationRate.z) as String
    }
    
    func setupAccelLabels() {
        ax.position = CGPointMake(300, 310)
        ay.position = CGPointMake(300, 250)
        az.position = CGPointMake(300, 190)
        
        self.addChild(ax)
        self.addChild(ay)
        self.addChild(az)
    }
    
    func updateAccelLabels(data: CMAccelerometerData) {
        ax.text = NSString(format: "Accel X: %.2f", data.acceleration.x) as String
        ay.text = NSString(format: "Accel Y: %.2f", data.acceleration.y) as String
        az.text = NSString(format: "Accel Z: %.2f", data.acceleration.z) as String
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
    
}
