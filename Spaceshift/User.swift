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
    let userParticles = SKNode()
    init() {
        let texture = SKTexture(imageNamed: "body")
        super.init(texture: nil, color: SKColor.clearColor(), size: texture.size())
        self.name = "user"
        
        let aura = SKEmitterNode(fileNamed: "userParticle")
        aura?.advanceSimulationTime(10)
        aura?.zPosition = 20
        self.addChild(aura!)
        
        // create revolving sprite
        let cwParticle = SKEmitterNode(fileNamed: "userBound")
        cwParticle?.advanceSimulationTime(10)
        cwParticle?.zPosition = 21
        cwParticle?.targetNode = self;
        self.addChild(cwParticle!)
        
        let cParticle = SKEmitterNode(fileNamed: "userBound")
        cParticle?.advanceSimulationTime(10)
        cParticle?.zPosition = 21
        cParticle?.targetNode = self;
        self.addChild(cParticle!)
        
        let crossParticle = SKEmitterNode(fileNamed: "userBound")
        crossParticle?.advanceSimulationTime(10)
        crossParticle?.zPosition = 21
        crossParticle?.targetNode = self;
        userParticles.addChild(crossParticle!)
        
        let vParticle = SKEmitterNode(fileNamed: "userBound")
        vParticle?.advanceSimulationTime(10)
        vParticle?.zPosition = 21
        vParticle?.targetNode = self;
        userParticles.addChild(vParticle!)
        
        let xParticle = SKEmitterNode(fileNamed: "userBound")
        xParticle?.advanceSimulationTime(10)
        xParticle?.zPosition = 21
        xParticle?.targetNode = self;
        userParticles.addChild(xParticle!)
        
        var boundary: CGPathRef? = nil
        boundary = CGPathCreateWithEllipseInRect(CGRectMake(self.frame.width/2 - 120, self.frame.height/2 - 120, 120, 120), nil)
        let trace = SKAction.followPath(boundary!, asOffset: false, orientToPath: true, duration: 1.5)
        let traceForever = SKAction.repeatActionForever(trace)
        cwParticle!.runAction(traceForever)
//        cParticle!.runAction(traceForever.reversedAction())
        let rTrace = SKAction.followPath(boundary!, asOffset: false, orientToPath: true, duration: 1)
        let rTraceForever = SKAction.repeatActionForever(rTrace)
        cParticle!.runAction(rTraceForever.reversedAction())
        
        var cross: CGPathRef? = nil
        cross = CGPathCreateWithEllipseInRect(CGRectMake(self.frame.width/2 - 120, self.frame.height/2 - 75, 120, 20), nil)
        let cCross = SKAction.followPath(cross!, asOffset: false, orientToPath: true, duration: 1)
        let cCrossForever = SKAction.repeatActionForever(cCross)
        crossParticle!.runAction(cCrossForever)
        
        var vert: CGPathRef? = nil
        vert = CGPathCreateWithEllipseInRect(CGRectMake(self.frame.width/2 - 70, self.frame.height/2 - 120, 10, 120), nil)
        let cVert = SKAction.followPath(vert!, asOffset: false, orientToPath: true, duration: 1)
        let cVertForever = SKAction.repeatActionForever(cVert)
        vParticle!.runAction(cVertForever)
        
        var xert: CGPathRef? = nil
        xert = CGPathCreateWithEllipseInRect(CGRectMake(self.frame.width/2 - 105, self.frame.height/2 - 105, 70, 40), nil)
        let cXert = SKAction.followPath(xert!, asOffset: false, orientToPath: true, duration: 1)
        let cXertForever = SKAction.repeatActionForever(cXert)
        xParticle!.runAction(cXertForever)
        
        let rot = SKAction.rotateByAngle(20, duration: 5)
        let rotForev = SKAction.repeatActionForever(rot)
        userParticles.runAction(rotForev)
        
        self.addChild(userParticles)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 70)
        self.physicsBody?.dynamic = true
//        self.physicsBody!.resting = true
        self.physicsBody?.categoryBitMask = userPhys
        self.physicsBody?.contactTestBitMask = wallPhys | blackPhys | passPhys
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.friction = 0.0
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.allowsRotation = false    
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
//        let userRot = SKAction.repeatActionForever(SKAction.rotateByAngle(20, duration: 5))
//        let userRot = SKAction.rotateByAngle(4, duration: 1)
//        userParticles.runAction(userRot, withKey: "rotation")
        
    }
    
    func stopSpin() {
        userParticles.removeActionForKey("rotation")
    }
}


