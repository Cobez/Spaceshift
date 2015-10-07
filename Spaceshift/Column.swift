//
//  Column.swift
//  GyroTest
//
//  Created by Coburn Brandon on 9/14/15.
//  Copyright © 2015 Coburn Brandon. All rights reserved.
//

import UIKit
import SpriteKit

class Column: SKSpriteNode {
    
    // Declare class variables here, such as a grid position
    
    init() {
        let texture = SKTexture(imageNamed: "column")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "column"
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
