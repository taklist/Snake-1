//
//  Tail.swift
//  Snake
//
//  Created by John Tinnerholm on 23/08/16.
//  Copyright © 2016 John Tinnerholm. All rights reserved.
//

import Foundation
import SpriteKit

class Tail : SKSpriteNode {
        init() {
                let texture = SKTexture(imageNamed: "snakeTail")
                super.init(texture: texture, color: SKColor.clear , size: texture.size())
                
                self.physicsBody = SKPhysicsBody.init(rectangleOf: size)
                self.physicsBody?.affectedByGravity = false
                self.physicsBody?.isDynamic = true
                self.physicsBody?.allowsRotation = false
                self.physicsBody?.pinned = true
                self.physicsBody?.angularDamping = 0
                self.physicsBody?.linearDamping = 0
                self.physicsBody?.mass = 0.1
                self.physicsBody?.density = 0.1

        }
        
        required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
}
