//
//  LevelSelectionScene.swift
//  Spaceshift
//
//  Created by Coburn Brandon on 10/5/15.
//  Copyright © 2015 EElite. All rights reserved.
//

import SpriteKit

var level = 0

class LevelSelectionScene: SKScene {
    var starTimer:Int = 0
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()
        addTitleLabel(view)
        createTiles()
        addShootingStars() 
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        starTimer += 1
        if (starTimer >= 10) {
            addShootingStars()
            starTimer = 0
        }
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
    
    internal func createTiles() {
        var offset: CGFloat = 0
        
        for i in 1...3 {
            let tile = LevelTile(level: i)
            tile.name = "Level \(i)"
            if offset > 0 {
                tile.colorBlendFactor = 1.0
                tile.color = SKColor.darkGrayColor()
            }
            tile.position = CGPointMake(self.frame.width/2 + offset, self.frame.height/2)
            offset += 240
            self.addChild(tile)
        }
        
    }
    
    internal func loadLevel(level: String) {
        let level = GameScene(fileNamed: "\(level)")
        level?.size = self.size
        level?.scaleMode = .AspectFill
        self.view?.presentScene(level!, transition: SKTransition.fadeWithColor(SKColor.blackColor(), duration: 1))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touches: AnyObject in touches {
            // Do error checking here before assigning the touch location as a node
            let node = self.nodeAtPoint(touches.locationInNode(self))
            let name: String? = node.name
            
            if name == "Level 1" {
                loadLevel("GameScene")
                level += 1
            }
//            if node.name == "Level 2" || node.parent!.name == "Level 2" {
//                loadLevel("2")
//            }
//            if node.name == "Level 3" || node.parent!.name == "Level 3" {
//                loadLevel("3")
//            }
//            if node.name == "Level 4" || node.parent!.name == "Level 4" {
//                loadLevel("4")
//            }
        }
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
