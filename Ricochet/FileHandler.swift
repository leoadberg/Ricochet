//
//  FileHandler.swift
//  Ricochet
//
//  Created by Leo Adberg on 4/2/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import UIKit

func CreateArrayFromPlist(_ plist: String, _ userDomain: Bool) -> NSMutableArray {
    
    var path: String = ""
    
    if (userDomain) {
        path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String) + "/" + plist + ".plist"
    }
    else {
        path = Bundle.main.path(forResource: plist, ofType: "plist")!
    }
    
    if (!FILEMANAGER.fileExists(atPath: path)) {
        //let emptyArray: [Level] = []
        let empty = NSMutableArray()
        return empty
        //FILEMANAGER.createFileAtPath(path, contents: nil, attributes: nil)
    }
    
    return NSMutableArray(contentsOfFile: path)!
}

/*func CreateLevelWithProperties(levelNumber: Int, dict: NSDictionary) -> Level {
    
    let tempLevel = Level(level: levelNumber)
    tempLevel.winConditions = dict["Win Conditions"] as! Int
    tempLevel.hint = dict["Hint"] as! String
    tempLevel.mode = dict["Game Mode"] as! Int
    tempLevel.oneStar = dict["1 Star"] as! Int
    tempLevel.twoStar = dict["2 Star"] as! Int
    tempLevel.threeStar = dict["3 Star"] as! Int
    tempLevel.ballMaxSpeedModifier = dict["Max Speed Multiplier"] as! CGFloat
    tempLevel.ballRadiusModifier = dict["Ball Radius Multiplier"] as! CGFloat
    tempLevel.ballSpeedMultModifier = dict["Speed Increase Multiplier"] as! CGFloat
    tempLevel.obsLengthModifier = dict["Obstacle Size Multiplier"] as! CGFloat
    tempLevel.ballStartSpeedModifier = dict["Start Speed Multiplier"] as! CGFloat
    
    let tempEffects = dict["Effects"] as! NSArray
    for effect in tempEffects {
        switch (effect["EffectID"] as! Int) {
        case 0:
            tempLevel.effects.append(DirectionalGravity(x: effect["Gravity X"] as! Double, y: effect["Gravity Y"] as! Double))
        case 1:
            tempLevel.effects.append(PointGravity(x: effect["Gravity X"] as! Double, y: effect["Gravity Y"] as! Double, str: effect["Gravity Strength"] as! Double))
            
        case 2:
            tempLevel.effects.append(RotatingObstacle(rate: effect["Rotation Rate"] as! Double))
            
        case 3:
            tempLevel.effects.append(ResizingObstacle(rate: effect["Resize Rate"] as! Double, maxScale: effect["Max Scale"] as! Double, minScale: effect["Min Scale"] as! Double))
        case 4:
            tempLevel.effects.append(LimitedObstacles(numPerSecond: effect["Obstacles per second"] as! Double, numPerBounce: effect["Obstacles per bounce"] as! Int, startingNum: effect["Starting Obstacles"] as! Int))
        default:
            break
        }
    }
    return tempLevel
}

func CreateCustomLevelWithProperties(levelNumber: Int, dict: NSDictionary) -> CustomLevel {
    
    let tempLevel = CustomLevel(level: levelNumber)
    tempLevel.label.text = dict["Name"] as? String
    tempLevel.winConditions = dict["Win Conditions"] as! Int
    tempLevel.hint = dict["Hint"] as! String
    tempLevel.mode = dict["Game Mode"] as! Int
    tempLevel.oneStar = dict["1 Star"] as! Int
    tempLevel.twoStar = dict["2 Star"] as! Int
    tempLevel.threeStar = dict["3 Star"] as! Int
    tempLevel.ballMaxSpeedModifier = dict["Max Speed Multiplier"] as! CGFloat
    tempLevel.ballRadiusModifier = dict["Ball Radius Multiplier"] as! CGFloat
    tempLevel.ballSpeedMultModifier = dict["Speed Increase Multiplier"] as! CGFloat
    tempLevel.obsLengthModifier = dict["Obstacle Size Multiplier"] as! CGFloat
    tempLevel.ballStartSpeedModifier = dict["Start Speed Multiplier"] as! CGFloat
    
    let tempEffects = dict["Effects"] as! NSArray
    for effect in tempEffects {
        switch (effect["EffectID"] as! Int) {
        case 0:
            tempLevel.effects.append(DirectionalGravity(x: effect["Gravity X"] as! Double, y: effect["Gravity Y"] as! Double))
        case 1:
            tempLevel.effects.append(PointGravity(x: effect["Gravity X"] as! Double, y: effect["Gravity Y"] as! Double, str: effect["Gravity Strength"] as! Double))
            
        case 2:
            tempLevel.effects.append(RotatingObstacle(rate: effect["Rotation Rate"] as! Double))
            
        case 3:
            tempLevel.effects.append(ResizingObstacle(rate: effect["Resize Rate"] as! Double, maxScale: effect["Max Scale"] as! Double, minScale: effect["Min Scale"] as! Double))
        case 4:
            tempLevel.effects.append(LimitedObstacles(numPerSecond: effect["Obstacles per second"] as! Double, numPerBounce: effect["Obstacles per bounce"] as! Int, startingNum: effect["Starting Obstacles"] as! Int))
        default:
            break
        }
    }
    return tempLevel
}*/

func SaveCustomLevels() {
    
    let path: String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String) + "/CustomLevels.plist"
    
    let plistArray = NSMutableArray()
    for tempLevel in CUSTOM_LEVELS {
        let levelDict = NSMutableDictionary()
        
        levelDict["Name"] = tempLevel.label.text
        levelDict["Win Conditions"] = Int(tempLevel.winConditions)
        levelDict["Hint"] = tempLevel.hint
        levelDict["Game Mode"] = Int(tempLevel.mode)
        levelDict["1 Star"] = Int(tempLevel.oneStar)
        levelDict["2 Star"] = Int(tempLevel.twoStar)
        levelDict["3 Star"] = Int(tempLevel.threeStar)
        levelDict["Max Speed Multiplier"] = tempLevel.ballMaxSpeedModifier
        levelDict["Ball Radius Multiplier"] = tempLevel.ballRadiusModifier
        levelDict["Speed Increase Multiplier"] = tempLevel.ballSpeedMultModifier
        levelDict["Obstacle Size Multiplier"] = tempLevel.obsLengthModifier
        levelDict["Start Speed Multiplier"] = tempLevel.ballStartSpeedModifier
        
        let effectsArray = NSMutableArray()
        
        levelDict["Effects"] = effectsArray
        for tempEffect in tempLevel.effects {
            let tempEffectDict = NSMutableDictionary()
            switch (tempEffect.getID()) {
            case 0:
                tempEffectDict["Effect ID"] = 0
                break
            case 1:
                tempEffectDict["Effect ID"] = 0
                break
            case 2:
                tempEffectDict["Effect ID"] = 0
                break
            case 3:
                tempEffectDict["Effect ID"] = 0
                break
            case 4:
                tempEffectDict["Effect ID"] = 0
                break
            default:
                break
            }
        }
        
        plistArray.add(levelDict)
    }
    plistArray.write(toFile: path, atomically: false)
    print("Custom levels saved")
    print(plistArray)
}
