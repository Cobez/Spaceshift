//
//  LevelTile.swift
//  Spaceshift
//
//  Created by Coburn Brandon on 10/6/15.
//  Copyright © 2015 EElite. All rights reserved.
//

import SpriteKit
class LevelTile: SKSpriteNode {
    
    init(level: Int) {
        let texture = SKTexture(imageNamed: "LevelTile")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "tile"
        self.zPosition = 3
        
        let levelLabel = SKLabelNode(fontNamed: "Futura")
        levelLabel.fontSize = 60
        levelLabel.zPosition = 4
        levelLabel.position = CGPointMake(0.5, 0.5)
        levelLabel.text = "\(level)"
        self.addChild(levelLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


}
