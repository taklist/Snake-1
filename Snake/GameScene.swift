//
//  GameScene.swift
//  Snake
//
//  Created by John Tinnerholm on 13/08/16.
//  Copyright (c) 2016 John Tinnerholm. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
        static let snake : UInt32 = 1
        static let cherry : UInt32 = 2
        static let wall : UInt32 = 3
}


class GameScene: SKScene , SKPhysicsContactDelegate {
        
        let cherry = Cherry()
        
        let crate = SKSpriteNode(imageNamed: "crate")
        
        let snake  = Snake()
        
        let scoreLabel : SKLabelNode = SKLabelNode()
        
        var tail = Tail()
        
        var score = 0
        
        /*The walls enclosing the game area */
        let rightWall  = SKSpriteNode()
        let leftWall = SKSpriteNode()
        let bottomWall = SKSpriteNode()
        let topWall = SKSpriteNode()
        
        
        override func didMove(to view: SKView) {
                /* Setting this scene to be the contact delegate */
                physicsWorld.contactDelegate = self
                
                self.backgroundColor = NSColor.black
                
                /*Init the walls enclosing the game area */
                initWalls()
                /*Add the snake to the scene */
                self.addChild(snake)
                snake.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                
                scoreLabel.text =  "Score \(score)"
                scoreLabel.color = SKColor.green
                scoreLabel.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height - 30)
                self.addChild(scoreLabel)
                
                /*Timer to make new cherrys spawn each 10 seconds */
                _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(GameScene.spawnCherry), userInfo: nil, repeats: true)
                
        }
        
        /*Calls the key changed events below */
        override func keyDown(with event: NSEvent) {
                interpretKeyEvents([event])
        }
        
        override func moveUp(_ sender: Any?) {
                snake.turnUp()
                
        }
        
        override func moveDown(_ sender: Any?) {
                snake.turnDown()
        }
        
        override func moveLeft(_ sender: Any?) {
                snake.turnLeft()
        }
        
        override func moveRight(_ sender: Any?) {
                snake.turnRight()
        }
        
        override func update(_ currentTime: TimeInterval) {
                
        }
        
        override func mouseDown(with theEvent: NSEvent) {
                addTail()
        }
        
        
        func didBegin(_ contact: SKPhysicsContact) {
                let bodyA : SKPhysicsBody = contact.bodyA
                let bodyB : SKPhysicsBody = contact.bodyB
                
                if bodyA.categoryBitMask == PhysicsCategory.snake && bodyB.categoryBitMask == PhysicsCategory.cherry {
                        cherry.removeFromParent()
                        snake.contactWithCherry()
                        score += 1
                        scoreLabel.text = "Score \(score)"
                        addTail()
                } else if (bodyA.categoryBitMask == PhysicsCategory.snake && bodyB.categoryBitMask == PhysicsCategory.wall )
                        || (bodyA.categoryBitMask == PhysicsCategory.wall && bodyB.categoryBitMask == PhysicsCategory.snake) {
                        
                        snake.removeFromParent()
                        
                        let EndLabel = SKLabelNode()
                        EndLabel.text = "Game over"
                        EndLabel.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2)
                        EndLabel.color = SKColor.green
                        self.addChild(EndLabel)
                }
        }
        
        /*Places the cherry on the game scene*/
        func spawnCherry() {
                if self.childNode(withName: "cherry") == nil {
                        
                        print("Spawned a cherry")
                        
                        /*Values representing the bounds in which the cherry can spawn */
                        let MAX_X_VAL :UInt32 = UInt32(self.frame.width - 60)
                        let MAX_Y_VAL :UInt32 = UInt32(self.frame.height - 60)
                        let MIN_VAL :CGFloat = 60
                        
                        
                        /*The spawning indexes for the cherry */
                        let randomX :CGFloat = CGFloat(arc4random_uniform(MAX_X_VAL))
                        let randomY :CGFloat = CGFloat(arc4random_uniform(MAX_Y_VAL))
                        
                        self.addChild(cherry)
                        cherry.position = CGPoint(x: MIN_VAL + randomX, y: MIN_VAL + randomY )
                        
                } else {
                        return
                }
        }
        
        /*Inits the walls enclosing the game area */
        func initWalls() {
                
                /*Sets the properties of the physicbodies of the walls */
                func setPhysicsBody(_ spriteNode:SKSpriteNode) {
                        spriteNode.physicsBody?.affectedByGravity = false
                        spriteNode.physicsBody?.isDynamic = false
                        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.wall
                        spriteNode.physicsBody?.collisionBitMask = PhysicsCategory.snake
                }
                
                func setColour(_ spriteNode:SKSpriteNode) {
                        spriteNode.color = SKColor.brown
                }
                
                
                /*Setting positions of the walls */
                leftWall.position = CGPoint(x: 0 ,y: self.frame.height/2)
                rightWall.position = CGPoint(x: self.frame.width, y: self.frame.height/2)
                topWall.position = CGPoint(x: self.frame.width/2 , y: self.frame.height);
                bottomWall.position = CGPoint(x: self.frame.width/2, y: 0)
                
                
                /*Setting the colour for the sprites */
                setColour(leftWall)
                setColour(rightWall)
                setColour(topWall)
                setColour(bottomWall)
                
                /*Setting the size for the walls*/
                leftWall.size = CGSize(width: 60, height: self.frame.maxX)
                rightWall.size = CGSize(width: 60, height: self.frame.maxY)
                topWall.size = CGSize(width: self.frame.maxX, height: 60)
                bottomWall.size = CGSize(width: self.frame.maxX, height: 60)
                
                /*Setting up the physicsbody of the walls */
                leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
                rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
                topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
                bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
                
                setPhysicsBody(leftWall)
                setPhysicsBody(rightWall)
                setPhysicsBody(topWall)
                setPhysicsBody(bottomWall)
                
                
                /* Adding the walls to the scene */
                self.addChild(leftWall)
                self.addChild(rightWall)
                self.addChild(topWall)
                self.addChild(bottomWall)
                
        }
        
        func addTail() {
                /*
                tail = Tail()
                tail.position.x = snake.position.x
                tail.position.y = snake.position.y - 30
                self.addChild(tail)

                let joint =  SKPhysicsJointFixed.jointWithBodyA(snake.physicsBody!,
                                                            bodyB: tail.physicsBody!,
                                                            anchor: CGPoint(x: CGRectGetMaxX(self.tail.frame), y: CGRectGetMinY(self.snake.frame)))
                self.physicsWorld.addJoint(joint)
                tail.physicsBody?.velocity = (snake.physicsBody?.velocity)!
                snake.stop()
                 */
        }
}
