//
//  StartScene.swift
//  Spaceshift
//
//  Created by Coburn Brandon on 10/5/15.
//  Copyright © 2015 EElite. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
    let playLabel = SKLabelNode(fontNamed: "Futura")

    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()
        addTitleLabel(view)
        addPlayLabel(view)
    }
    
    func addTitleLabel(view:SKView) {
        let nameLabel = SKLabelNode(fontNamed: "Futura")
        nameLabel.text = "Spaceshift"
        nameLabel.fontColor = SKColor.grayColor()
        nameLabel.zPosition = 10
        nameLabel.fontSize = 100
        nameLabel.position = CGPointMake(size.width/2, size.height/1.33)
        self.addChild(nameLabel)
    }
    
    func addPlayLabel(view:SKView) {
        playLabel.text = "Play"
        playLabel.fontColor = SKColor.whiteColor()
        playLabel.fontSize = 100
        playLabel.zPosition = 10
        playLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.height/3.33)
        self.addChild(playLabel)
        
        let whiteLabel = SKLabelNode(fontNamed: "Futura")
        whiteLabel.text = "Play"
        whiteLabel.fontColor = SKColor.blackColor()
        whiteLabel.fontSize = 100
        whiteLabel.position = playLabel.position
        self.addChild(whiteLabel)
        
        let fadeOut = SKAction.fadeOutWithDuration(2.0)
        let fadeIn = SKAction.fadeInWithDuration(2.0)
        let sequence = SKAction.sequence([fadeOut,fadeIn])
        let glow = SKAction.repeatActionForever(sequence)
        playLabel.runAction(glow)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let selection = self.nodeAtPoint(location)
            
            if selection == playLabel {
                self.pressPlay(selection)
            }
            
        }
    }
    
    func pressPlay(node: SKNode) {
        if let nextScene = LevelSelectionScene(fileNamed: "LevelSelectionScene") {
        nextScene.size = self.size
        nextScene.scaleMode = .AspectFill
            self.view?.presentScene(nextScene, transition: SKTransition.fadeWithColor(SKColor.blackColor(), duration: 1))
        }
    }

}
