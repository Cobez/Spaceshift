//
//  PassBarrier.swift
//  Spaceshift
//
//  Created by Coburn Brandon on 10/8/15.
//  Copyright © 2015 EElite. All rights reserved.
//

import UIKit
import SpriteKit

class PassBarrier: SKSpriteNode {
    
    // Declare class variables here, such as a grid position
    
    init() {
        let texture = SKTexture(imageNamed: "column2")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "column"
        self.zPosition = 3
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.categoryBitMask = passPhys
        self.physicsBody?.contactTestBitMask = userPhys
        self.physicsBody?.collisionBitMask = 0x0
        self.colorBlendFactor = 1.0
        self.color = SKColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}