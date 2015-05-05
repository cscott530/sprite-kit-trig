//
//  GameScene.swift
//  TrigTutorial
//
//  Created by Chris on 5/4/15.
//  Copyright (c) 2015 Chris Scott. All rights reserved.
//

import SpriteKit
import CoreMotion

let MaxPlayerAcceleration: CGFloat = 400
let MaxPlayerSpeed: CGFloat = 200
let MaximumDifferential = CFTimeInterval(1.0 / 30)

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "Player")
    let motionManager = CMMotionManager()
    
    var accelerometerX: UIAccelerationValue = 0
    var accelerometerY: UIAccelerationValue = 0
    var playerAcceleration = CGVector(dx: 0, dy: 0)
    var playerVelocity = CGVector(dx: 0, dy: 0)
    
    var lastTime: CFTimeInterval = 0.0
    
    deinit {
        self.stopMonitoringAcceleration()
    }
    
    override func didMoveToView(view: SKView) {
        self.size = view.bounds.size
        
        self.backgroundColor = SKColor(red: 94.0 / 255.0, green: 63.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0)
        
        self.player.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        self.addChild(player)
        
        self.startMonitoringAcceleration()
    }
    
    override func update(currentTime: CFTimeInterval) {
        let differential = max(currentTime - lastTime, MaximumDifferential)
        lastTime = currentTime
        updatePlayerAccelerationFromMotionManager()
        updatePlayer(differential)
    }
    
    //Moving the Player
    func updatePlayerAccelerationFromMotionManager() {
        if let acceleration = motionManager.accelerometerData?.acceleration {
            let factor = 0.75
            
            accelerometerX = acceleration.x * factor + accelerometerX * (1 - factor)
            accelerometerY = acceleration.y * factor + accelerometerY * (1 - factor)
            
            playerAcceleration.dx = CGFloat(accelerometerY) * -MaxPlayerAcceleration
            playerAcceleration.dy = CGFloat(accelerometerX) * MaxPlayerAcceleration
        }
    }
    
    func updatePlayer(dt: CFTimeInterval) {
        playerVelocity.dx = playerVelocity.dx + playerAcceleration.dx * CGFloat(dt)
        playerVelocity.dy = playerVelocity.dy + playerAcceleration.dy * CGFloat(dt)
        
        playerVelocity.dx = max(-MaxPlayerSpeed, min(MaxPlayerSpeed, playerVelocity.dx))
        playerVelocity.dy = max(-MaxPlayerSpeed, min(MaxPlayerSpeed, playerVelocity.dy))
        
        var newX = player.position.x + (playerVelocity.dx * CGFloat(dt))
        var newY = player.position.y + (playerVelocity.dy * CGFloat(dt))
        
        newX = max(0, min(newX, size.width))
        newY = max(0, min(newY, size.height))
        
        player.position = CGPointMake(newX, newY)
    }
    
    //Accelerometer
    func startMonitoringAcceleration() {
        if motionManager.accelerometerAvailable {
            motionManager.startAccelerometerUpdates()
        }
    }
    func stopMonitoringAcceleration() {
        if motionManager.accelerometerAvailable && motionManager.accelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
}
