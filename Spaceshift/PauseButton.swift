//
//  PauseButton.swift
//  Spaceshift
//
//  Created by Coburn Brandon on 11/14/15.
//  Copyright © 2015 EElite. All rights reserved.
//

import UIKit
import SpriteKit

class PauseButton: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "pauseButton")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "pauseButton"
        self.zPosition = 20
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}
