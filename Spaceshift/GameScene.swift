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
let blackPhys:UInt32 = 0x1 << 3
let wallPhys:UInt32 = 0x1 << 5
let passPhys:UInt32 = 0x1 << 4

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
    var center:CGPoint?
    

    let clouds:SKEmitterNode = SKEmitterNode(fileNamed: "Clouds")!
    let shootingStar:SKEmitterNode = SKEmitterNode(fileNamed: "Spark")!
    
    var starTimer:Int = 0
    var worldPosition:CGPoint = CGPointMake(0.5, 0.5)

    var collisions:[Int] = [0, 0, 0, 0,]
    
    
    let gx = DataLabel()
    let gy = DataLabel()
    let gz = DataLabel()
    
    let ax = DataLabel()
    let ay = DataLabel()
    let az = DataLabel()
    
    override func didMoveToView(view: SKView) {
        center = CGPointMake(self.frame.width/2, self.frame.height/2)

        self.worldPosition = CGPointMake(self.frame.width/2, self.frame.height/2)
        setupEnvironment()
        setupUser()
        
        setupGyroLabels()
        setupAccelLabels()
        performSelector(Selector("enableGyroControl"), withObject: nil, afterDelay: 1)
//        enableGyroControl()
        
//        enableGyroControl()
        rotateBlackHole()
    }
    
    func rotateBlackHole() {
        print("trying to rotate")
        if let blackhole = self.childNodeWithName("wall")!.childNodeWithName("blackhole") {
            print("trying harder")
            self.physicsBody = SKPhysicsBody(circleOfRadius: 10)
            blackhole.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(-1, duration: 1)))
            
            let spark = SKEmitterNode(fileNamed: "BlackHoleEmitter")
            spark!.advanceSimulationTime(10)
            spark!.position = blackhole.position
            spark!.zPosition = blackhole.zPosition + 1
            spark!.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(1, duration: 1)))
            self.childNodeWithName("wall")!.addChild(spark!)
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        if let wall = self.childNodeWithName("wall") {
            wall.position = worldPosition
        }

        starTimer += 1
        if (starTimer >= 40) {
            addShootingStars()
            starTimer = 0
        }

        face.position = user.position
    }
    
    func enableGyroControl() {
        let delta:CGFloat = 20   // Normalized control movement
        
//        let wall = self.childNodeWithName("wall")
        if motion.gyroAvailable {
            motion.startGyroUpdates()
            motion.gyroUpdateInterval = 1.0 / 100.0
            motion.startGyroUpdatesToQueue(queue, withHandler: { data, error in
                guard let data = data else {
                    return
                }
//                                self.updateGyroLabels(data)
                
                // Move either vertically or horizontally, but not both
                if abs(data.rotationRate.y) > abs(data.rotationRate.x) {
                    self.dY = data.rotationRate.y
                    if data.rotationRate.y > self.threshold && self.collisions[1] == 0  {
                        self.worldPosition.y = (self.worldPosition.y + delta)
                        self.collisions[0] = 0
                    }
                    else if data.rotationRate.y < -self.threshold && self.collisions[0] == 0 {
                        self.worldPosition.y = (self.worldPosition.y - delta)
                        self.collisions[1] = 0
                    }
                } else {
                    self.dX = data.rotationRate.x
                    if data.rotationRate.x > self.threshold && self.collisions[3] == 0 {
                        self.worldPosition.x = (self.worldPosition.x + delta)
                        self.collisions[2] = 0
                    }
                    else if data.rotationRate.x < -self.threshold && self.collisions[2] == 0 {
                        self.worldPosition.x = (self.worldPosition.x - delta)
                        self.collisions[3] = 0
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
        user.startSpin()
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
            
//            print("\(magX), \(magY)")
            //            colliding = true
            if magY > magX && abs(magX - magY) > 5 {
                if contact.contactPoint.y > user.position.y {
                    // Moving wall down, phone up
                    collisions[0] = 1
//                    print("Contact Above")
                }
                else if contact.contactPoint.y < user.position.y {
                    // Moving wall up, phone down
                    collisions[1] = 1
//                    print("Contact Below")
                }
            }
            else if magY < magX && abs(magX-magY) > 5 {
                if contact.contactPoint.x > user.position.x  {
                    // Moving wall right, phone left
                    collisions[2] = 1
//                    print("Contact Right")
                }
                else if contact.contactPoint.x < user.position.x  {
                    // Moving wall left, phone right
                    collisions[3] = 1
//                    print("Contact Left")
                }
            }
//         print("\(collisions)")
        }
        else if boundary.categoryBitMask == passPhys {
            let magY = abs(contact.contactPoint.y - user.position.y)
            let magX = abs(contact.contactPoint.x - user.position.x)
            
//            print("\(magX), \(magY)")
            //            colliding = true
            if magY > magX && abs(magX - magY) > 5 {
                if contact.contactPoint.y > user.position.y {
                    // Moving wall down, phone up
                    collisions[2] = 0
                    collisions[3] = 0
                    print("Contact Above")
                }
                else if contact.contactPoint.y < user.position.y {
                    // Moving wall up, phone down
                    collisions[2] = 0
                    collisions[3] = 0
                    print("Contact Below")
                }
            }
            else if magY < magX && abs(magX-magY) > 5 {
                if contact.contactPoint.x > user.position.x  {
                    // Moving wall right, phone left
                    collisions[0] = 0
                    collisions[1] = 0
                    print("Contact Right")
                }
                else if contact.contactPoint.x < user.position.x  {
                    // Moving wall left, phone right
                    collisions[1] = 0
                    collisions[0] = 0
                    print("Contact Left")
                }
            }
            //         print("\(collisions)")
        }
        
        else if boundary.categoryBitMask == blackPhys {
            print("Contact with hole")
            let finish = SKSpriteNode(imageNamed: "FinishWindow")
            finish.position = center!
            finish.zPosition = 30
            self.addChild(finish)
            motion.stopGyroUpdates()
            performSelector(Selector("presentNextLevel"), withObject: nil, afterDelay: 3)
        }

    }
    
    func presentNextLevel() {
        if let nextScene = GameScene(fileNamed: "GameScene") {
            nextScene.size = self.size
            nextScene.scaleMode = .AspectFill
            self.view?.presentScene(nextScene, transition: SKTransition.fadeWithColor(SKColor.blackColor(), duration: 1))
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
