//
//  AchievementsHelper.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/29/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import Foundation
import GameKit

// MARK: AchievementsHelper

class AchievementsHelper {
    
    // MARK: Properties
    
    static let MaxCollisions = 20.0
    static let DestructionHeroAchievementId = "circuitracer.destructionhero"
    static let AmateurAchievementId = "circuitracer.amateurracer"
    static let IntermediateAchievementId = "circuitracer.intermediateracer"
    static let ProfessionalHeroAchievementId = "circuitracer.professionalracer"
    
    static let RacingAddictAchievementId = "circuitracer.racingaddict"
    static var numberOfRacesCompleted = 0
    
    // MARK: Methods
    
    class func collisionAchievement(noOfCollisions: Int) -> GKAchievement {
        let percent = Double(noOfCollisions) / AchievementsHelper.MaxCollisions * 100
        let collisionAchievement = GKAchievement(identifier: AchievementsHelper.DestructionHeroAchievementId)
        collisionAchievement.percentComplete = percent
        collisionAchievement.showsCompletionBanner = true
        
        return collisionAchievement
    }
    
    class func achievementForLevel(levelType: LevelType) -> GKAchievement {
        var achievementId = AchievementsHelper.AmateurAchievementId
        if levelType == .medium {
            achievementId = AchievementsHelper.IntermediateAchievementId
        } else if levelType == .hard {
            achievementId = AchievementsHelper.ProfessionalHeroAchievementId
        }
        let levelAchievement = GKAchievement(identifier: achievementId)
        levelAchievement.percentComplete = 100
        levelAchievement.showsCompletionBanner = true
        
        return levelAchievement
    }
    
    class func racingAddictAchievement(plays: Int) -> GKAchievement {
        let achievementId = AchievementsHelper.RacingAddictAchievementId
        let achievement = GKAchievement(identifier: achievementId)
        achievement.percentComplete = Double(plays) * 10.0
        achievement.showsCompletionBanner = true
        
        return achievement
    }
}
