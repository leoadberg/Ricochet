//
//  Obstacle.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class Obstacle: SKShapeNode {
    
    var shapeID: Int = -1
    var length: CGFloat = 0.0
    var rotateSpeed: CGFloat = 0.0
    var resizeSpeed: CGFloat = 0.0
    var minScale: Double = -1.0
    var maxScale: Double = -1.0
    
    init(shapeID: Int = -1, length: CGFloat = SCREEN_WIDTH / 5, rotateSpeed: CGFloat = 0.0, resizeSpeed: CGFloat = 0.0, minScale: Double = -1.0, maxScale: Double = -1.0) {
        
        super.init()
        
        self.shapeID = shapeID
        self.length = length
        self.rotateSpeed = rotateSpeed
        self.resizeSpeed = resizeSpeed
        self.minScale = minScale
        self.maxScale = maxScale
        
        super.position = CGPoint(x: self.length * -3, y: self.length * -3)
        super.zPosition = 1
        super.fillColor = COLOR_FADED_RED
        super.lineWidth = 4
        
    }
    
    func draw() {
        
        switch(shapeID) {
            
        case 0:
            length = SCREEN_HEIGHT
            super.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -length * 3, y: -length * 3), size: CGSize(width: length, height: length)), nil)
            
        case 1:
            super.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -length * 3, y: -length * 3), size: CGSize(width: length, height: length)), nil)
            
        case 2:
            super.path = CGPathCreateWithEllipseInRect(CGRectMake(-length / 2, -length / 2, length, length), nil)
            
        default:
            super.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -length * 3, y: -length * 3), size: CGSize(width: length, height: length)), nil)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}