//
//  GameScene.swift
//  TrigTutorial
//
//  Created by Chris on 5/4/15.
//  Copyright (c) 2015 Chris Scott. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "Player")
    let motionManager = CMMotionManager()
    
    var accelerometerX: UIAccelerationValue = 0
    var accelerometerY: UIAccelerationValue = 0
    
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
        /* Called before each frame is rendered */
    }
    
    //Moving the Player
    func updatePlayerAccelerationFromMotionManager() {
        if let acceleration = motionManager.accelerometerData?.acceleration {
            let factor = 0.75
            
            accelerometerX = acceleration.x * factor + accelerometerX * (1 - FilterFactor)
            accelerometerY = acceleration.y * factor + accelerometerY * (1 - FilterFactor)
        }
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
