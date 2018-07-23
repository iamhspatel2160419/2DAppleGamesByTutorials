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
    var hud = HUD()
    
    var firebugCount: Int = 0
    var timeLimit: Int = 10
    
    var elapsedTime: Int = 0
    var startTime: Int?
    
    var gameState: GameState = .initial {
        didSet {
            hud.updateGameState(from: oldValue, to: gameState)
        }
    }
    
    var currentLevel: Int = 1
    
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
        
        setupHUD()
        
        hud.addTimer(time: timeLimit)
        gameState = .start
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard gameState == .play else {
            isPaused = true
            return
        }
        
        if !player.hasBugspray {
            updateBugspray()
        }
        advanceBreakableTile(locatedAt: player.position)
        updateHUD(currentTime: currentTime)
        
        checkEndGame()
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

        for row in 0..<obstaclesTileMap.numberOfRows {
            for column in 0..<obstaclesTileMap.numberOfColumns {

                guard let tile = tile(in: obstaclesTileMap, at: (column, row)) else { continue }
                guard tile.userData?.object(forKey: "obstacle") != nil else { continue }

                let node = SKNode()
                node.physicsBody = SKPhysicsBody(rectangleOf: tile.size)
                node.physicsBody?.isDynamic = false
                node.physicsBody?.friction = 0
                node.physicsBody?.categoryBitMask = PhysicsCategory.Breakable
                node.position = obstaclesTileMap.centerOfTile(atColumn: column, row: row)
                obstaclesTileMap.addChild(node)
            }
        }
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
    
    func tileCoordinates(in tileMap: SKTileMapNode, at position: CGPoint) -> TileCoordinates {
        let column = tileMap.tileColumnIndex(fromPosition: position)
        let row = tileMap.tileRowIndex(fromPosition: position)
        
        return (column, row)
    }
    
    func updateBugspray() {
        guard let bugSprayTileMap = bugSprayTileMap else { return }
        let (column, row) = tileCoordinates(in: bugSprayTileMap, at: player.position)
        if tile(in: bugSprayTileMap, at: (column, row)) != nil {
            bugSprayTileMap.setTileGroup(nil, forColumn: column, row: row)
            player.hasBugspray = true
        }
    }
    
    func tileGroupForName(tileSet: SKTileSet, name: String) -> SKTileGroup? {
        let tileGroup = tileSet.tileGroups.filter { $0.name == name }.first
        return tileGroup
    }
    
    func advanceBreakableTile(locatedAt nodePosition: CGPoint) {
        guard let obstaclesTileMap = obstaclesTileMap else { return }
        let (column, row) = tileCoordinates(in: obstaclesTileMap, at: nodePosition)
        let obstacle = tile(in: obstaclesTileMap, at: (column, row))
        guard let nextTileGroupName = obstacle?.userData?.object(forKey: "breakable") as? String else { return }
        
        if let nextTileGroup = tileGroupForName(tileSet: obstaclesTileMap.tileSet, name: nextTileGroupName) {
            obstaclesTileMap.setTileGroup(nextTileGroup, forColumn: column, row: row)
        }
    }
    
    func setupHUD() {
        camera?.addChild(hud)
    }
    
    func updateHUD(currentTime: TimeInterval) {

        if let startTime = startTime {
            elapsedTime = Int(currentTime) - startTime
        } else {
            startTime = Int(currentTime) - elapsedTime
        }
        hud.updateTimer(time: timeLimit - elapsedTime)
    }
    
    func checkEndGame() {
        if bugsNode.children.count == 0 {
            player.physicsBody?.linearDamping = 1
            gameState = .win
        } else if timeLimit - elapsedTime <= 0 {
            player.physicsBody?.linearDamping = 1
            gameState = .lose
        }
    }
    
    func transitionToScene(level: Int) {

        guard let newScene = SKScene(fileNamed: "Level\(level)") as? GameScene else {
            fatalError("Level: \(level) not found")
        }

        newScene.currentLevel = level
        view?.presentScene(newScene, transition: SKTransition.flipVertical(withDuration: 0.5))
    }
    
    // MARK: Touch Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        switch gameState {
            case .start:
                gameState = .play
                isPaused = false
                startTime = nil
                elapsedTime = 0
            case .play:
                player.move(target: touch.location(in: self))
            case .win:
                transitionToScene(level: currentLevel + 1)
            case .lose:
                transitionToScene(level: 1)
            default:
                    break
        }
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
            case PhysicsCategory.Firebug:
                if player.hasBugspray {
                    if let firebug = other.node as? Firebug {
                        remove(bug: firebug)
                        player.hasBugspray = false
                    }
                }
            case PhysicsCategory.Breakable:
                if let obstacleNode = other.node {
                    advanceBreakableTile(locatedAt: obstacleNode.position)
                    obstacleNode.removeFromParent()
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
