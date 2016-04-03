//
//  FileHandler.swift
//  Ricochet
//
//  Created by Leo Adberg on 4/2/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import UIKit

func CreateArrayFromPlist(plist: String, userDomain: Bool) -> NSMutableArray {
    var path: String = ""
    if (userDomain) {
        path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String).stringByAppendingString(plist+".plist")
    }
    else {
        path = NSBundle.mainBundle().pathForResource(plist, ofType: "plist")!
    }
    if (!FILEMANAGER.fileExistsAtPath(path)) {
        //let emptyArray: [Level] = []
        let empty = NSMutableArray()
        return empty
        //FILEMANAGER.createFileAtPath(path, contents: nil, attributes: nil)
    }
    return NSMutableArray(contentsOfFile: path)!
}

func CreateLevelWithProperties(levelNumber: Int, dict: NSDictionary) -> Level {
    let tempLevel = Level(level: levelNumber)
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
            break;
        case 1:
            tempLevel.effects.append(PointGravity(x: effect["Gravity X"] as! Double, y: effect["Gravity Y"] as! Double, str: effect["Gravity Strength"] as! Double))
        default:
            break;
        }
    }
    return tempLevel
}