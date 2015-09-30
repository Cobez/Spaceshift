//
//  DataLabel.swift
//  Spaceshift
//
//  Created by Coburn Brandon on 9/18/15.
//  Copyright © 2015 EElite. All rights reserved.
//

import UIKit
import SpriteKit

class DataLabel: SKLabelNode {
    // vars here
    override init() {
        super.init()
    }
    
    override init(fontNamed fontName: String?) {
        super.init(fontNamed: fontName)
        self.fontSize = 22
        self.fontColor = SKColor.blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
