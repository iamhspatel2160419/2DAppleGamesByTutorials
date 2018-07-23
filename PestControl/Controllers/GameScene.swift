//
//  GameScene.swift
//  PestControl
//
//  Created by Neil Hiddink on 7/15/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

// MARK: GameScene: SKScene

class GameScene: SKScene {
    
    // MARK: Properties
    
    var background: SKTileMapNode!
    var player = Player()
    var bugsNode = SKNode()
    var obstaclesTileMap: SKTileMapNode?
    var bugSprayTileMap: SKTileMapNode?
    
    var firebugCount: Int = 0
    
    // MARK: Scene Life Cycle
    
    override func didMove(to view: SKView) {
        
        addChild(player)
        
        setupCamera()
        setupWorldPhysics()
        createBugs()
        setupObstaclePhysics()
        
        if firebugCount > 0 {
            createBugSpray(quantity: firebugCount + 10)
        }
    }
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        background = childNode(withName: "background") as? SKTileMapNode
        obstaclesTileMap = childNode(withName: "obstacles") as? SKTileMapNode
    }
    
    // MARK: Helper Methods
    
    func setupCamera() {
        guard let camera = camera,
              let view = view else { return }
        
        let zeroDistance = SKRange(constantValue: 0)
        let playerConstraint = SKConstraint.distance(zeroDistance, to: player)

        let xInset = min(view.bounds.width/2 * camera.xScale, background.frame.width/2)
        let yInset = min(view.bounds.height/2 * camera.yScale, background.frame.height/2)
        let constraintRect = background.frame.insetBy(dx: xInset, dy: yInset)
        
        let xRange = SKRange(lowerLimit: constraintRect.minX, upperLimit: constraintRect.maxX)
        let yRange = SKRange(lowerLimit: constraintRect.minY, upperLimit: constraintRect.maxY)
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        edgeConstraint.referenceNode = background
        
        camera.constraints = [playerConstraint, edgeConstraint]
    }
    
    func setupWorldPhysics() {
        background.physicsBody = SKPhysicsBody.init(edgeLoopFrom: background.frame)
        
        background.physicsBody?.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.contactDelegate = self
    }
    
    func setupObstaclePhysics() {
        guard let obstaclesTileMap = obstaclesTileMap else { return }

        var physicsBodies = [SKPhysicsBody]()

        for row in 0..<obstaclesTileMap.numberOfRows {
            for column in 0..<obstaclesTileMap.numberOfColumns {
                guard let tile = tile(in: obstaclesTileMap, at: (column, row)) else { continue }

                let center = obstaclesTileMap.centerOfTile(atColumn: column, row: row)
                let body = SKPhysicsBody(rectangleOf: tile.size, center: center)
                physicsBodies.append(body)
            }
        }

        obstaclesTileMap.physicsBody = SKPhysicsBody(bodies: physicsBodies)
        obstaclesTileMap.physicsBody?.isDynamic = false
        obstaclesTileMap.physicsBody?.friction = 0
    }
    
    func tile(in tileMap: SKTileMapNode, at coordinates: TileCoordinates) -> SKTileDefinition? {
        return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
    }
    
    func createBugs() {
        guard let bugsMap = childNode(withName: "bugs") as? SKTileMapNode else { return }

        for row in 0..<bugsMap.numberOfRows {
            for column in 0..<bugsMap.numberOfColumns {

                guard let tile = tile(in: bugsMap, at: (column, row)) else { continue }
                
                let bug: Bug
                if tile.userData?.object(forKey: "firebug") != nil {
                    bug = Firebug()
                    firebugCount += 1
                } else {
                    bug = Bug()
                }
                
                bug.position = bugsMap.centerOfTile(atColumn: column, row: row)
                
                bugsNode.addChild(bug)
                bug.move()
            }
        }

        bugsNode.name = "Bugs"
        addChild(bugsNode)

        bugsMap.removeFromParent()
    }
    
    func createBugSpray(quantity: Int) {
        let tile = SKTileDefinition(texture: SKTexture(pixelImageNamed: "bugspray"))
        let tilerule = SKTileGroupRule(adjacency: SKTileAdjacencyMask.adjacencyAll, tileDefinitions: [tile])
        let tilegroup = SKTileGroup(rules: [tilerule])
        let tileSet = SKTileSet(tileGroups: [tilegroup])
        let columns = background.numberOfColumns
        let rows = background.numberOfRows
        
        bugSprayTileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tile.size)
        for _ in 1...quantity {
            let column = Int.random(min: 0, max: columns-1)
            let row = Int.random(min: 0, max: rows-1)
            bugSprayTileMap?.setTileGroup(tilegroup,
                                          forColumn: column, row: row)
        }
        // 7
        bugSprayTileMap?.name = "BugSpray"
        addChild(bugSprayTileMap!)
    }
    
    // MARK: Touch Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        player.move(target: touch.location(in: self))
    }
    
}

// MARK: GameScene: SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    func remove(bug: Bug) {
        bug.removeFromParent()
        
        background.addChild(bug)
        bug.die()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        switch other.categoryBitMask {
            case PhysicsCategory.Bug:
                if let bug = other.node as? Bug {
                    remove(bug: bug)
                }
            default:
                break
        }
        
        if let physicsBody = player.physicsBody {
            if physicsBody.velocity.length() > 0 {
                player.checkDirection()
            }
        }
    }
}
