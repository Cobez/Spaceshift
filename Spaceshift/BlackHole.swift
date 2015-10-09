//
//  FinishLevel.swift
//  Spaceshift
//
//  Created by Anthony Meyer on 10/8/15.
//  Copyright © 2015 EElite. All rights reserved.
//

import Foundation
import SpriteKit


class BlackHole: SKSpriteNode {
    // Declare class variables here, such as a grid position
    init() {
        print("hello")
        let texture = SKTexture(imageNamed: "black_butthole")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "blackhole"
        self.zPosition = 3
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = wallPhys
        self.physicsBody?.contactTestBitMask = userPhys
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.friction = 0.0
        self.physicsBody?.restitution = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Declare functions here
}