//
//  Cherry.swift
//  Snake
//
//  Created by John Tinnerholm on 19/08/16.
//  Copyright © 2016 John Tinnerholm. All rights reserved.
//

import SpriteKit

class Cherry : SKSpriteNode {
        
        init() {
                let texture = SKTexture(imageNamed:"cherry")
                
                super.init(texture: texture, color: SKColor.clear, size: texture.size())
                
                self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
                self.physicsBody?.affectedByGravity = false
                self.name = "cherry"
                self.physicsBody?.isDynamic = false
                self.physicsBody?.categoryBitMask = PhysicsCategory.cherry
                self.physicsBody?.contactTestBitMask = PhysicsCategory.snake
                
        }
        
        required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
}
