//
//  UI.swift
//  Ricochet
//
//  Created by Leo Adberg on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MenuButton2: SKShapeNode {
    
    init(_ buttonName: String) {
        
        super.init()
        super.path = CGPath(rect: CGRect(origin: CGPoint(x: -SCREEN_WIDTH / 5, y: -SWOVER12), size: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6)), transform: nil)
        super.lineWidth = 0
        buttonLabel.text = buttonName
        self.addChild(buttonLabel)
        super.zPosition = 4
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let buttonLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
}

class MenuButton: SKShapeNode {
    init(_ buttonName: String) {
        super.init()
        super.path = CGPath(rect: CGRect(origin: CGPoint(x: -SCREEN_WIDTH / 5, y: -SWOVER12), size: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6)), transform: nil)
        super.lineWidth = 4
        super.fillColor = COLOR_FADED_GREEN
        buttonLabel.fontSize = SCREEN_WIDTH / 9
        buttonLabel.text = buttonName
        buttonLabel.position.y = -SCREEN_WIDTH / 27
        self.addChild(buttonLabel)
    }
    
    let buttonLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    func select() {
        super.fillColor = COLOR_FADED_RED
    }
    
    func deselect() {
        super.fillColor = COLOR_FADED_GREEN
    }
    
    func moveOut() {
        let buttonMove = SKAction.moveTo(x: -SCREEN_WIDTH, duration: 0.5)
        buttonMove.timingMode = .easeInEaseOut
        run(buttonMove)
    }
    
    func moveIn() {
        position.x = SCREEN_WIDTH * 2
        let buttonMove = SKAction.moveTo(x: SWOVER2, duration: 0.5)
        buttonMove.timingMode = .easeInEaseOut
        run(buttonMove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LevelSelector: SKShapeNode {
    override init() {
        super.init()
        super.path = CGPath(rect: CGRect(x: -SCREEN_WIDTH * 0.55, y: -SCREEN_WIDTH / 6, width: SCREEN_WIDTH * 1.1, height: SCREEN_WIDTH / 3), transform: nil)
        super.lineWidth = 4
        super.fillColor = COLOR_FADED_GREEN
        super.zPosition = -1
    }
    
    var active = false
    var scroll: CGFloat = 0
    var scrollSpeed: CGFloat = 0
    
    func moveIn() {
        
        position.x = SCREEN_WIDTH * 2
        let modeSelectorMove = SKAction.moveTo(x: SWOVER2, duration: 0.5)
        modeSelectorMove.timingMode = .easeInEaseOut
        run(modeSelectorMove)
        
    }
    
    func moveOut() {
        let modeSelectorMove = SKAction.moveTo(x: -SCREEN_WIDTH, duration: 0.5)
        modeSelectorMove.timingMode = .easeInEaseOut
        run(modeSelectorMove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Slider: SKNode {
	
	var intValue = false
	var selected = false
	var sliderValue: CGFloat = 0
	var lowerBound: CGFloat = 0
	var upperBound: CGFloat = 0
	var increment: CGFloat = 0
	let textNode = SKLabelNode(fontNamed:"DINAlternate-Bold")
	let valueNode = SKLabelNode(fontNamed:"DINAlternate-Bold")
	let sliderBar = SKShapeNode(path:
		CGPath(roundedRect:
			CGRect(x: 0, y: -SCREEN_WIDTH / 80, width: SCREEN_WIDTH / 3, height: SCREEN_WIDTH / 40),
			   cornerWidth: SCREEN_WIDTH / 100, cornerHeight: SCREEN_WIDTH / 100, transform: nil))
	let slider = SKShapeNode(circleOfRadius: SCREEN_WIDTH / 30)
	
    init(_ text: String, _ lBound: CGFloat, _ uBound: CGFloat, _ i: CGFloat, _ startValue: CGFloat, int: Bool = false) {
        super.init()
        
        intValue = int
        
        textNode.fontSize = SCREEN_WIDTH / 16
        textNode.text = text
        textNode.horizontalAlignmentMode = .left
        textNode.verticalAlignmentMode = .center
        textNode.position.x = SCREEN_WIDTH / 20
        
        valueNode.fontSize = SCREEN_WIDTH / 16
        if int {
            valueNode.text = String(Int(sliderValue))
        } else {
            valueNode.text = String(describing: sliderValue)
        }
        //valueNode.horizontalAlignmentMode =.left
        valueNode.verticalAlignmentMode = .center
        valueNode.position.x = SWOVER2
        
        sliderBar.position = CGPoint(x: SCREEN_WIDTH * 0.6, y: 0)
        sliderBar.fillColor = SKColor.white
        
        slider.lineWidth = 4
        slider.fillColor = COLOR_FADED_GREEN
        slider.position = sliderBar.position
        //slider.position.y += SCREEN_WIDTH / 80
        
        upperBound = uBound
        lowerBound = lBound
        increment = i
        
        let SW06: CGFloat = SCREEN_WIDTH * 0.6
        slider.position.x = max(SW06, SW06 + SCREEN_WIDTH / 3 *  ((startValue - lowerBound + 0.0001) / (upperBound - lowerBound)))
        slider.position.x = min(slider.position.x, SCREEN_WIDTH * 0.9333) //0.9333 = 3/5 + 1/3
        updateValue()
        
        self.addChild(sliderBar)
        self.addChild(textNode)
        self.addChild(valueNode)
        self.addChild(slider)
    }
    
    func updateSlider(_ touch: UITouch) {
        slider.position.x = min(max(SCREEN_WIDTH * 3 / 5, touch.location(in: self).x), SCREEN_WIDTH * 3 / 5 + SCREEN_WIDTH / 3)
        updateValue()
    }
    
    func updateValue() {
        sliderValue = (slider.position.x - SCREEN_WIDTH * 3 / 5) / (SCREEN_WIDTH / 3) * (upperBound - lowerBound) + lowerBound
        sliderValue = CGFloat(Int((sliderValue + increment / 2) / increment)) * increment
        if intValue {
            valueNode.text = String(Int(sliderValue))
        } else {
            valueNode.text = String(format: "%.2f", sliderValue)
        }
    }
    
    func setValue(_ value: CGFloat) {
        sliderValue = value
        slider.position.x = (sliderValue - lowerBound) / (upperBound - lowerBound) * SCREEN_WIDTH / 3 + SCREEN_WIDTH * 3 / 5
        if intValue {
            valueNode.text = String(Int(sliderValue))
        } else {
            valueNode.text = String(describing: sliderValue)
        }
    }
	
	override func contains(_ p: CGPoint) -> Bool {
		return slider.contains(p)
	}
	
	func select(_ touch: CGPoint) {
		selected = true
	}
	
	func endTouch(_ scroll: CGFloat, _ touchStart: CGPoint, _ touchEnd: CGPoint) {
		selected = false
	}
	
	func getHeight() -> CGFloat {
		return SCREEN_HEIGHT / 10
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EffectHeader: Slider {
	var sliders: [Slider]
	
	let deleteButton = SKShapeNode(rectOf: CGSize(width: SWOVER12, height: SWOVER12))
	let deleteText = SKLabelNode(fontNamed:"DINAlternate-Bold")
	
	var toDelete = false
	
	var effect: LevelEffect
	
    init(_ effect: LevelEffect) {
		self.effect = effect
		
		sliders = effect.getSliders()
		
        super.init(effect.name(), 0, 0, 1, 0)
        self.removeAllChildren()
        self.addChild(textNode)
        
        deleteButton.lineWidth = 4
        deleteButton.fillColor = COLOR_FADED_RED_DARKER
        deleteText.text = "×"
        deleteText.fontSize = SCREEN_WIDTH / 8
        deleteButton.position = CGPoint(x: SCREEN_WIDTH * 7 / 8, y: 0)
        deleteText.position.x = deleteButton.position.x
        deleteText.position.y = deleteButton.position.y - SCREEN_WIDTH / 28
        self.addChild(deleteButton)
        self.addChild(deleteText)
		
		var height: CGFloat = SCREEN_HEIGHT / 10
		for s in sliders {
			s.position.y = -height
			height += s.getHeight()
			self.addChild(s)
		}
    }
    
	override func updateSlider(_ touch: UITouch) {
		for s in sliders {
			if s.selected {
				s.updateSlider(touch)
			}
		}
	}
	
	override func contains(_ p: CGPoint) -> Bool {
		var ret = false
		let ref = CGPoint(x: 0, y: -deleteButton.position.y)
		ret = ret || deleteButton.contains(AddPoints(p, ref))
		for s in sliders {
			let ref2 = CGPoint(x: 0, y: -s.position.y)
			ret = ret || s.contains(AddPoints(p, ref2))
		}
		return ret
	}
	
	override func select(_ touch: CGPoint) {
		for s in sliders {
			let ref = CGPoint(x: 0, y: -s.position.y)
			if (s.contains(AddPoints(touch, ref))) {
				s.select(touch)
			}
		}
		let ref = CGPoint(x: 0, y: -deleteButton.position.y - self.position.y)
		if deleteButton.contains(AddPoints(touch, ref)) {
			deleteButton.fillColor = COLOR_FADED_RED_EVEN_DARKER
		}
		self.selected = true
	}
	
	override func endTouch(_ scroll: CGFloat, _ touchStart: CGPoint, _ touchEnd: CGPoint) {
		for s in sliders {
			s.endTouch(scroll, touchStart, touchEnd)
		}
		let ref = CGPoint(x: 0, y: -scroll - deleteButton.position.y - self.position.y)
		deleteButton.fillColor = COLOR_FADED_RED_DARKER
		if deleteButton.contains(AddPoints(touchEnd, ref)) && deleteButton.contains(AddPoints(touchStart, ref)) {
			toDelete = true
		}
		self.selected = false
	}
	
	override func getHeight() -> CGFloat {
		var sum: CGFloat = SCREEN_HEIGHT / 10
		for s in sliders {
			sum += s.getHeight()
		}
		return sum
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TextBox: SKNode {
    init(text: String) {
        super.init()
        
        textNode.fontSize = SCREEN_WIDTH / 16
        textNode.text = text
        textNode.horizontalAlignmentMode = .left
        textNode.verticalAlignmentMode = .center
        textNode.position.x = SCREEN_WIDTH / 20
        
        nameNode.fontSize = SCREEN_WIDTH / 16
        nameNode.text = ""
        nameNode.horizontalAlignmentMode = .right
        nameNode.verticalAlignmentMode = .center
        nameNode.position.x = SCREEN_WIDTH * 19 / 20
        
        nameBox.position.x = SCREEN_WIDTH * 3 / 5
        nameBox.fillColor = SKColor(white: 1, alpha: 1)
        
        self.addChild(textNode)
        self.addChild(nameNode)
        self.addChild(nameBox)
    }
    
    var selected = false
    let textNode = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let nameNode = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let nameBox = SKShapeNode(rect: CGRect(x: 0, y: -SCREEN_WIDTH / 20, width: SCREEN_WIDTH / 3, height: SCREEN_WIDTH / 10))
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func MoveInLevels(_ levels: inout [Level], _ levelSelector: LevelSelector) {
    
    for tempLevel in levels {
        
        let unlockedtemp = UNLOCKED_LEVELS
        let levelcount = levels.count
        let split = min(unlockedtemp, levelcount - 2)
        
        if (tempLevel.levelNumber + 1 < split) {
            tempLevel.position = CGPoint(x: -SCREEN_WIDTH, y: levelSelector.position.y) // Move in from left (not visible)
        }
        else {
            tempLevel.position = CGPoint(x: 2 * SCREEN_WIDTH, y: levelSelector.position.y) // Move in from right (visible)
        }
        
        let tempLevelMove = SKAction.moveTo(x: SCREEN_WIDTH * (CGFloat(tempLevel.levelNumber) + 0.5) / 3 + levelSelector.scroll, duration: 0.5)
        tempLevel.run(tempLevelMove)
    }
    
}

func MoveOutLevels(_ levels: inout [Level], _ levelSelector: LevelSelector) {
    
    for tempLevel in levels {
        let tempLevelMove = SKAction.moveTo(x: -SCREEN_WIDTH, duration: 0.5)
        tempLevel.run(tempLevelMove)
    }
    
}

func AddPoints(_ firstPoint: CGPoint, _ secondPoint: CGPoint) -> CGPoint {
    return CGPoint(x: firstPoint.x + secondPoint.x, y: firstPoint.y + secondPoint.y)
}

