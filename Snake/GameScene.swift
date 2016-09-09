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
        
        
        override func didMoveToView(view: SKView) {
                /* Setting this scene to be the contact delegate */
                physicsWorld.contactDelegate = self
                
                self.backgroundColor = NSColor.blackColor()
                
                /*Init the walls enclosing the game area */
                initWalls()
                /*Add the snake to the scene */
                self.addChild(snake)
                snake.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
                
                scoreLabel.text =  "Score \(score)"
                scoreLabel.color = SKColor.greenColor()
                scoreLabel.position = CGPointMake(self.frame.width / 2 , self.frame.height - 30)
                self.addChild(scoreLabel)
                
                /*Timer to make new cherrys spawn each 10 seconds */
                _ = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(GameScene.spawnCherry), userInfo: nil, repeats: true)
                
        }
        
        /*Calls the key changed events below */
        override func keyDown(event: NSEvent) {
                interpretKeyEvents([event])
        }
        
        override func moveUp(sender: AnyObject?) {
                snake.turnUp()
                
        }
        
        override func moveDown(sender: AnyObject?) {
                snake.turnDown()
        }
        
        override func moveLeft(sender: AnyObject?) {
                snake.turnLeft()
        }
        
        override func moveRight(sender: AnyObject?) {
                snake.turnRight()
        }
        
        override func update(currentTime: CFTimeInterval) {
                
        }
        
        override func mouseDown(theEvent: NSEvent) {
                addTail()
        }
        
        
        func didBeginContact(contact: SKPhysicsContact) {
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
                        EndLabel.position = CGPointMake(self.frame.width / 2 , self.frame.height / 2)
                        EndLabel.color = SKColor.greenColor()
                        self.addChild(EndLabel)
                }
        }
        
        /*Places the cherry on the game scene*/
        func spawnCherry() {
                if self.childNodeWithName("cherry") == nil {
                        
                        print("Spawned a cherry")
                        
                        /*Values representing the bounds in which the cherry can spawn */
                        let MAX_X_VAL :UInt32 = UInt32(self.frame.width - 60)
                        let MAX_Y_VAL :UInt32 = UInt32(self.frame.height - 60)
                        let MIN_VAL :CGFloat = 60
                        
                        
                        /*The spawning indexes for the cherry */
                        let randomX :CGFloat = CGFloat(arc4random_uniform(MAX_X_VAL))
                        let randomY :CGFloat = CGFloat(arc4random_uniform(MAX_Y_VAL))
                        
                        self.addChild(cherry)
                        cherry.position = CGPointMake(MIN_VAL + randomX, MIN_VAL + randomY )
                        
                } else {
                        return
                }
        }
        
        /*Inits the walls enclosing the game area */
        func initWalls() {
                
                /*Sets the properties of the physicbodies of the walls */
                func setPhysicsBody(spriteNode:SKSpriteNode) {
                        spriteNode.physicsBody?.affectedByGravity = false
                        spriteNode.physicsBody?.dynamic = false
                        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.wall
                        spriteNode.physicsBody?.collisionBitMask = PhysicsCategory.snake
                }
                
                func setColour(spriteNode:SKSpriteNode) {
                        spriteNode.color = SKColor.brownColor()
                }
                
                
                /*Setting positions of the walls */
                leftWall.position = CGPointMake(0 ,self.frame.height/2)
                rightWall.position = CGPointMake(self.frame.width, self.frame.height/2)
                topWall.position = CGPointMake(self.frame.width/2 , self.frame.height);
                bottomWall.position = CGPointMake(self.frame.width/2, 0)
                
                
                /*Setting the colour for the sprites */
                setColour(leftWall)
                setColour(rightWall)
                setColour(topWall)
                setColour(bottomWall)
                
                /*Setting the size for the walls*/
                leftWall.size = CGSizeMake(60, self.frame.maxX)
                rightWall.size = CGSizeMake(60, self.frame.maxY)
                topWall.size = CGSizeMake(self.frame.maxX, 60)
                bottomWall.size = CGSizeMake(self.frame.maxX, 60)
                
                /*Setting up the physicsbody of the walls */
                leftWall.physicsBody = SKPhysicsBody(rectangleOfSize: leftWall.size)
                rightWall.physicsBody = SKPhysicsBody(rectangleOfSize: rightWall.size)
                topWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
                bottomWall.physicsBody = SKPhysicsBody(rectangleOfSize: bottomWall.size)
                
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
