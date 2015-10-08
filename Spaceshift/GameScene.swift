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
    var dX: Double = 0.0
    let threshold:Double = 0.12
    
    let user:User = User()
//    var wall:SKNode?
    let face = SKSpriteNode(imageNamed: "face")
    

    let clouds:SKEmitterNode = SKEmitterNode(fileNamed: "Clouds")!
    let shootingStar:SKEmitterNode = SKEmitterNode(fileNamed: "Spark")!
    
    var starTimer:Int = 0
    var worldPosition:CGPoint = CGPointMake(0.5, 0.5)
//    var lastWorldPosition:CGPoint = CGPointMake(0, 0)
    var collisions:UInt32 = 0x0
    
    let gx = DataLabel()
    let gy = DataLabel()
    let gz = DataLabel()
    
    let ax = DataLabel()
    let ay = DataLabel()
    let az = DataLabel()
    
    override func didMoveToView(view: SKView) {
        self.worldPosition = CGPointMake(self.frame.width/2, self.frame.height/2)
        setupEnvironment()
        setupUser()
        
        setupGyroLabels()
        setupAccelLabels()
        
        enableGyroControl()
    }
    
    override func update(currentTime: NSTimeInterval) {
        if let wall = self.childNodeWithName("wall") {
//            if collisions & (0x1 << 1) > 0 && dY < threshold {
//                // Moving wall down, phone up
//                print("Trying to move downward")
//                //                collisions = collisions & (0x0 << 2)
//                //                collisions = collisions & (0x0 << 1)
//                print("Collision is now \(collisions)")
//                collisions = 0x0
//                wall.position = worldPosition
//            }
//            else if collisions & (0x1 << 2) > 0 {
//                print("trying to move upward")
//                //                collisions = collisions & (0x0 << 1)
//                //                collisions = collisions & (0x0 << 2)
////                collisions = 0x0
//                print("Collision is now \(collisions)")
//                wall.position.x - worldPosition.x
//                if worldPosition.y > wall.position.y {
//                    wall.position.y = worldPosition.y
//                }
////                wall.position = worldPosition
//            }
//            if collisions & (0x1 << 3) > 0 {
//                print("Trying to move left")
//                collisions = collisions & (0x0 << 3)
//                wall.position = worldPosition
//            }
//            else if collisions & (0x1 << 4) > 0 {
//                print("Trying to move right")
//                collisions = collisions & (0x0 << 4)
//                wall.position = worldPosition
//            }
//            if (collisions == 0x0) {
                wall.position = worldPosition
//            }
            
        }
//        collisions = 0x0

        starTimer += 1
        if (starTimer >= 40) {
            addShootingStars()
            starTimer = 0
        }
        
        face.position = user.position
        
        if (user.position != CGPointMake(self.frame.width/2, self.frame.height/2)) &&
        collisions == 0x0 {
            user.position = CGPointMake(self.frame.width/2, self.frame.height/2)
            user.stopSpin()
        }
//        else if user.actionForKey("rotation") == nil {
//            user.startSpin()
//        }
    }
    
    func enableGyroControl() {
        let delta:CGFloat = 17   // Normalized control movement
        
//        let wall = self.childNodeWithName("wall")
        if motion.gyroAvailable {
            motion.startGyroUpdates()
            motion.gyroUpdateInterval = 1.0 / 60.0
            motion.startGyroUpdatesToQueue(queue, withHandler: { data, error in
                guard let data = data else {
                    return
                }
//                                self.updateGyroLabels(data)
                
                // Move either vertically or horizontally, but not both
                if abs(data.rotationRate.y) > abs(data.rotationRate.x) {
                    self.dY = data.rotationRate.y
                    if data.rotationRate.y > self.threshold && self.collisions & (0x1 << 2) <= 0 {
//                        wall!.position.y = (wall!.position.y + round(CGFloat(data.rotationRate.y+1))*delta)
                        self.collisions = self.collisions & (0x0 << 1)
                        self.worldPosition.y = (self.worldPosition.y + round(CGFloat(data.rotationRate.y+1))*delta)
                    }
                    else if data.rotationRate.y < -self.threshold && self.collisions & (0x1 << 1) <= 0 {
//                        wall!.position.y = (wall!.position.y + round(CGFloat(data.rotationRate.y-1))*delta)
                        self.collisions = self.collisions & (0x0 << 2)
                        self.worldPosition.y = (self.worldPosition.y + round(CGFloat(data.rotationRate.y-1))*delta)
                    }
                } else {
                    self.dX = data.rotationRate.x
                    if data.rotationRate.x > self.threshold && self.collisions & (0x1 << 4) <= 0 {
//                        wall!.position.x = (wall!.position.x + round(CGFloat(data.rotationRate.x+1))*delta)
                        self.collisions = self.collisions & (0x0 << 3)
                        self.worldPosition.x = (self.worldPosition.x + round(CGFloat(data.rotationRate.x+1))*delta)
                    }
                    else if data.rotationRate.x < -self.threshold && self.collisions & (0x1 << 3) <= 0 {
//                        wall!.position.x = (wall!.position.x + round(CGFloat(data.rotationRate.x-1))*delta)
                        self.collisions = self.collisions & (0x0 << 4)
                        self.worldPosition.x = (self.worldPosition.x + round(CGFloat(data.rotationRate.x-1))*delta)
                    }
                }
            })
        }
    }
    
    func enableAccelControl() {
        //        let delta:CGFloat = 5
        var deltaY: Double = 0.0
        
        if motion.accelerometerAvailable {
            motion.startAccelerometerUpdates()
            motion.accelerometerUpdateInterval = 1.0 / 60.0
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
        //        self.backgroundColor = SKColor(red: 31/255, green: 122/255, blue: 31/255, alpha: 1.0)
        //        self.backgroundColor = SKColor.blackColor()
        //        self.backgroundColor = SKColor.clearColor()
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0,0)
        
        //        let background = SKSpriteNode(imageNamed: "SSBackground")
        //        background.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        //        background.zRotation = CGFloat(M_PI_2)
        //        background.zPosition = -20
        //        self.addChild(background)
    }
    
    func setupUser() {
        user.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        user.zPosition = 10
        face.zPosition = 20
        face.position = user.position

        addChild(user)
        addChild(face)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var boundary:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            boundary = contact.bodyB
        } else {
            boundary = contact.bodyA
        }
        
        if boundary.categoryBitMask == wallPhys {
            let magY = abs(contact.contactPoint.y - user.position.y)
            let magX = abs(contact.contactPoint.x - user.position.x)
            
            print("\(magX), \(magY)")
            //            colliding = true
            if magY > magX && abs(magX - magY) > 5 {
                if contact.contactPoint.y > user.position.y {
                    // Moving wall down, phone up
                    collisions = collisions | (0x1 << 1)
                    print("Contact Above")
                }
                else if contact.contactPoint.y < user.position.y {
                    // Moving wall up, phone down
                    collisions = collisions | (0x1 << 2)
                    print("Contact Below")
                }
            } else if magY < magX && abs(magX-magY) > 5 {
                if contact.contactPoint.x > user.position.x  {
                    // Moving wall right, phone left
                    collisions = collisions | (0x1 << 3)
                    print("Contact Right")
                }
                else if contact.contactPoint.x < user.position.x  {
                    // Moving wall left, phone right
                    collisions = collisions | (0x1 << 4)
                    print("Contact Left")
                }
            }
//         print("\(collisions)")
        }
    }
    
    func setupGyroLabels() {
        gx.position = CGPointMake(100, 310)
        gy.position = CGPointMake(100, 250)
        gz.position = CGPointMake(100, 190)
        
        addChild(gx)
        addChild(gy)
        addChild(gz)
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
        
        addChild(ax)
        addChild(ay)
        addChild(az)
    }
    
    func updateAccelLabels(data: CMAccelerometerData) {
        ax.text = NSString(format: "Accel X: %.2f", data.acceleration.x) as String
        ay.text = NSString(format: "Accel Y: %.2f", data.acceleration.y) as String
        az.text = NSString(format: "Accel Z: %.2f", data.acceleration.z) as String
    }
    
    func addShootingStars() {
        let pos = CGFloat(arc4random_uniform(UInt32(self.frame.width)))
        let zPos = CGFloat(arc4random_uniform(UInt32(6)))
        
        
        let spark = SKEmitterNode(fileNamed: "Spark")
        spark!.advanceSimulationTime(10)
        spark!.position = CGPointMake(pos, self.frame.height)
        spark!.zPosition = zPos
        self.addChild(spark!)
        
        let fly = SKAction.moveTo(CGPointMake(pos, -35), duration: 1)
        let remove = SKAction.removeFromParent()
        let sparkSeq = SKAction.sequence([fly, remove])
        spark!.runAction(sparkSeq)
    }
    
}
