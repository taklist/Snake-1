//
//  Snake.swift
//  Snake
//
//  Created by John Tinnerholm on 14/08/16.
//  Copyright © 2016 John Tinnerholm. All rights reserved.
//

import SpriteKit
import Cocoa


enum Direction {
        case north
        case south
        case west
        case east
}

class Snake : SKSpriteNode {
        
        /*Represents the rate of moment gets increased by taking candy! */
        private var movementRate:CGFloat = 5
        private var momentSpeed:CGFloat = 10
        /*Represents the direction the snake is taking */
        private var direction = Direction.north
        
        init() {
                
                let texture = SKTexture(imageNamed: "snakeHead")
                
                super.init(texture: texture, color: SKColor.clearColor() , size: texture.size())
                
                self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
                self.physicsBody?.affectedByGravity = false
                self.physicsBody?.velocity = CGVectorMake(0, 0)
                self.physicsBody?.allowsRotation = false
                self.physicsBody?.density = 0.1
                self.physicsBody?.dynamic = true
                self.physicsBody?.categoryBitMask = PhysicsCategory.snake
                self.physicsBody?.contactTestBitMask = PhysicsCategory.cherry
                
                /*Sets the speed each ms to give the impression of constant moment */
                _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(Snake.move), userInfo: nil, repeats: true)
                
        }
        
        required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        
        func turnRight() {
                
                switch direction {
                        
                case Direction.north:
                        physicsBody?.velocity.dx = movementRate * momentSpeed
                        physicsBody?.velocity.dy = 0
                        
                        direction = Direction.west
                        /*Rotate facing the west */
                        self.zRotation = -(CGFloat(M_PI) / 2)
                        
                case Direction.south:
                        physicsBody?.velocity.dx = movementRate * momentSpeed
                        physicsBody?.velocity.dy = 0
                        
                        direction = Direction.west
                        /*Rotate facing the west */
                        self.zRotation = -(CGFloat(M_PI) / 2)
                        
                case Direction.east:
                        break
                        
                case Direction.west:
                        break
                        
                }
                
        }
        
        func turnLeft() {
                switch direction {
                        
                case Direction.north:
                        physicsBody?.velocity.dx = -(movementRate * momentSpeed)
                        physicsBody?.velocity.dy = 0
                        
                        self.zRotation = (CGFloat(M_PI) / 2)
                        /*Roatating facing east */
                        direction = Direction.east
                        
                case Direction.south:
                        physicsBody?.velocity.dx = -(movementRate * momentSpeed)
                        physicsBody?.velocity.dy = 0
                        
                        direction = Direction.east
                        /*Rotating facing east*/
                        self.zRotation = (CGFloat(M_PI) / 2)
                        
                case Direction.east:
                        break
                        
                case Direction.west:
                        break
                        
                }
        }
        
        func turnUp() {
                
                if direction != Direction.south {
                        physicsBody?.velocity.dx = 0
                        physicsBody?.velocity.dy = momentSpeed * movementRate
                        /*Rotating facing north */
                        direction = Direction.north
                        self.zRotation =  0
                        
                }
        }
        
        func turnDown() {
                
                if direction  != Direction.north {
                        physicsBody?.velocity.dx = 0
                        physicsBody?.velocity.dy = -momentSpeed * movementRate
                        
                        direction = Direction.south
                        /*Rotating facing south  */
                        self.zRotation =  CGFloat(M_PI)
                        
                }
        }
        
        func contactWithCherry() {
                move()
                movementRate += 1
        }
        
        
        
        func move() {
                
                switch direction {
                        
                case Direction.north:
                        /* Keep going up */
                        physicsBody?.velocity.dx = 0
                        physicsBody?.velocity.dy = momentSpeed * movementRate
                case Direction.south:
                        /*Keep going south */
                        physicsBody?.velocity.dx = 0
                        physicsBody?.velocity.dy = -(momentSpeed * movementRate)
                case Direction.east:
                        /*Continue moment to the east */
                        physicsBody?.velocity.dx = -(movementRate * momentSpeed)
                        physicsBody?.velocity.dy = 0
                case Direction.west:
                        /*Continue movement to the west */
                        physicsBody?.velocity.dx = movementRate * momentSpeed
                        physicsBody?.velocity.dy = 0
                        
                }
        }
        
        func stop() {
                physicsBody?.velocity.dx = 0
                physicsBody?.velocity.dy = 0
        }
}
