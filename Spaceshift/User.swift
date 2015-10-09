//
//  User.swift
//  GyroTest
//
//  Created by Coburn Brandon on 9/14/15.
//  Copyright © 2015 Coburn Brandon. All rights reserved.
//

import UIKit
import SpriteKit
/*
class User: SKSpriteNode {
    // Vars here
    init() {
        let texture = SKTexture(imageNamed: "user")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "user"
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = userPhys
        self.physicsBody?.contactTestBitMask = wallPhys
        self.physicsBody?.collisionBitMask = wallPhys
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Funcs here
    private func animate() {
        var userTextures:[SKTexture] = []
        for i in 1...2 {
            userTextures.append(SKTexture(imageNamed: "user\(i)"))
        }
        let userAnimation = SKAction.repeatActionForever(SKAction.animateWithTextures(userTextures, timePerFrame: 0.1))
        self.runAction(userAnimation)
        let userRot = SKAction.rotateByAngle(20, duration: 0.1)
        if self.physicsBody?.velocity.dx != 0 && self.physicsBody?.velocity.dy != 0 {
            self.runAction(userRot)
        }
    }
}*/
class User: SKSpriteNode {
    // Vars here
    init() {
        let texture = SKTexture(imageNamed: "body")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "user"
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        self.physicsBody?.dynamic = true
//        self.physicsBody!.resting = true
        self.physicsBody?.categoryBitMask = userPhys
        self.physicsBody?.contactTestBitMask = wallPhys | passPhys | blackPhys
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.friction = 0.0
        self.physicsBody?.restitution = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Funcs here
    private func animate() {
        var userTextures:[SKTexture] = []
        for i in 1...2 {
            userTextures.append(SKTexture(imageNamed: "user\(i)"))
        }
        let userAnimation = SKAction.repeatActionForever(SKAction.animateWithTextures(userTextures, timePerFrame: 0.1))
        self.runAction(userAnimation)
        let userRot = SKAction.rotateByAngle(20, duration: 0.1)
        if self.physicsBody?.velocity.dx != 0 && self.physicsBody?.velocity.dy != 0 {
            self.runAction(userRot)
        }
    }
    
    func startSpin() {
        let userRot = SKAction.repeatActionForever(SKAction.rotateByAngle(5, duration: 1))
        self.runAction(userRot, withKey: "rotation")
        
    }
    
    func stopSpin() {
        self.removeActionForKey("rotation")
    }
}


