//
//  RatingAlbum.swift
//  MixItApp
//
//  Created by KWANIL KIM on 5/21/16.
//  Copyright © 2016 MixItApp. All rights reserved.
//

import UIKit
import Foundation

struct CosmosAccessibility {


static func accessibilityValue(view: UIView, rating: Double, settings: CosmosSettings) -> String {
    let accessibilityRating = CosmosRating.displayedRatingFromPreciseRating(rating,
                                                                            fillMode: settings.fillMode, totalStars: settings.totalStars)
    
    // Omit decimals if the value is an integer
    let isInteger = (accessibilityRating * 10) % 10 == 0
    
    if isInteger {
        return "\(Int(accessibilityRating))"
    } else {
        // Only show a single decimal place
        let roundedToFirstDecimalPlace = Double( round(10 * accessibilityRating) / 10 )
        return "\(roundedToFirstDecimalPlace)"
    }
}

static func accessibilityIncrement(rating: Double, settings: CosmosSettings) -> Double {
    var increment: Double = 0
    
    switch settings.fillMode {
        
    case .Half:
        increment = (ceil(rating * 2) - rating * 2) / 2
        if increment == 0 { increment = 0.5 }
    }
    
    if rating >= Double(settings.totalStars) { increment = 0 }
    
    return increment
}

static func accessibilityDecrement(rating: Double, settings: CosmosSettings) -> Double {
    var increment: Double = 0
    
    switch settings.fillMode {
        
    case .Half:
        increment = (rating * 2 - floor(rating * 2)) / 2
        if increment == 0 { increment = 0.5 }
    }
    
    if rating <= settings.minTouchRating { increment = 0 }
    
    return increment
}
}

struct CosmosDefaultSettings {
    init() {}
    
    static let defaultColor = UIColor(red: 1, green: 149/255, blue: 0, alpha: 1)
    
    
    // MARK: - Star settings
    // -----------------------------
    
    /// Border color of an empty star.
    static let emptyBorderColor = defaultColor
    
    /// Width of the border for the empty star.
    static let emptyBorderWidth: Double = 1 / Double(UIScreen.mainScreen().scale)
    
    /// Border color of a filled star.
    static let filledBorderColor = defaultColor
    
    /// Width of the border for a filled star.
    static let filledBorderWidth: Double = 1 / Double(UIScreen.mainScreen().scale)
    
    /// Background color of an empty star.
    static let emptyColor = UIColor.clearColor()
    
    /// Background color of a filled star.
    static let filledColor = defaultColor
    
    /**
     
     Defines how the star is filled when the rating value is not an integer value. It can either show full stars, half stars or stars partially filled according to the rating value.
     
     */
    static let fillMode = StarFillMode.Half
    
    /// Rating value that is shown in the storyboard by default.
    static var rating: Double = 0
    
    /// Distance between stars.
    static let starMargin: Double = 5

    static let starPoints: [CGPoint] = [
        CGPoint(x: 49.5,  y: 0.0),
        CGPoint(x: 60.5,  y: 35.0),
        CGPoint(x: 99.0, y: 35.0),
        CGPoint(x: 67.5,  y: 58.0),
        CGPoint(x: 78.5,  y: 92.0),
        CGPoint(x: 49.5,    y: 71.0),
        CGPoint(x: 20.5,  y: 92.0),
        CGPoint(x: 31.5,  y: 58.0),
        CGPoint(x: 0.0,   y: 35.0),
        CGPoint(x: 38.5,  y: 35.0)
    ]
    
    /// Size of a single star.
    static var starSize: Double = 45
    
    /// The total number of stars to be shown.
    static let totalStars = 5
    
    /// Color of the text.
    static let textColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
    
    /// Font for the text.
    static let textFont = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
    
    /// Distance between the text and the stars.
    static let textMargin: Double = 5
    
    /// Calculates the size of the default text font. It is used for making the text size configurable from the storyboard.
    static var textSize: Double {
        get {
            return Double(textFont.pointSize)
        }
    }
    
    
    static let minTouchRating: Double = 1
    static let updateOnTouch = true
}


public enum StarFillMode: Int {
    case Half = 0
}



func calculateSizeToFitLayers(layers: [CALayer]) -> CGSize {
    var size = CGSize()
    
    for layer in layers {
        if layer.frame.maxX > size.width {
            size.width = layer.frame.maxX
        }
        
        if layer.frame.maxY > size.height {
            size.height = layer.frame.maxY
        }
    }
    
    return size
}

/*Text*/
class CosmosText {

    class func position(layer: CALayer, starsSize: CGSize, textMargin: Double) {
        layer.position.x = starsSize.width + CGFloat(textMargin)
        let yOffset = (starsSize.height - layer.bounds.height) / 2
        layer.position.y = yOffset
    }
}



/*Touch Precision*/
struct CosmosTouch {
    static func touchRating(locationX: CGFloat, starsWidth: CGFloat, settings: CosmosSettings) -> Double {
        
        let position = locationX / starsWidth
        let totalStars = Double(settings.totalStars)
        let actualRating = totalStars * Double(position)
        var correctedRating = actualRating
        
        if settings.fillMode == .Half {
            correctedRating += 0.25
        }
        
        correctedRating = CosmosRating.displayedRatingFromPreciseRating(correctedRating,
                                                                        fillMode: settings.fillMode, totalStars: settings.totalStars)
        
        correctedRating = max(settings.minTouchRating, correctedRating)
        
        return correctedRating
    }
}


/*First start Layers*/
class CosmosLayers {

    class func createStarLayers(rating: Double, settings: CosmosSettings) -> [CALayer] {
        
        var ratingRemander = CosmosRating.numberOfFilledStars(rating,
                                                              totalNumberOfStars: settings.totalStars)
        
        var starLayers = [CALayer]()
        
        for _ in (0..<settings.totalStars) {
            
            let fillLevel = CosmosRating.starFillLevel(ratingRemainder: ratingRemander,
                                                       fillMode: settings.fillMode)
            
            let starLayer = createCompositeStarLayer(fillLevel, settings: settings)
            starLayers.append(starLayer)
            ratingRemander -= 1
        }
        
        positionStarLayers(starLayers, starMargin: settings.starMargin)
        return starLayers
    }
    
    
    class func createCompositeStarLayer(starFillLevel: Double, settings: CosmosSettings) -> CALayer {
        
        if starFillLevel >= 1 {
            return createStarLayer(true, settings: settings)
        }
        
        if starFillLevel == 0 {
            return createStarLayer(false, settings: settings)
        }
        
        return createPartialStar(starFillLevel, settings: settings)
    }
    
    class func createPartialStar(starFillLevel: Double, settings: CosmosSettings) -> CALayer {
        let filledStar = createStarLayer(true, settings: settings)
        let emptyStar = createStarLayer(false, settings: settings)
        
        let parentLayer = CALayer()
        parentLayer.contentsScale = UIScreen.mainScreen().scale
        parentLayer.bounds = CGRect(origin: CGPoint(), size: filledStar.bounds.size)
        parentLayer.anchorPoint = CGPoint()
        parentLayer.addSublayer(emptyStar)
        parentLayer.addSublayer(filledStar)
        
        // make filled layer width smaller according to the fill level.
        filledStar.bounds.size.width *= CGFloat(starFillLevel)
        
        return parentLayer
    }
    
    private class func createStarLayer(isFilled: Bool, settings: CosmosSettings) -> CALayer {
        let fillColor = isFilled ? settings.filledColor : settings.emptyColor
        let strokeColor = isFilled ? settings.filledBorderColor : settings.emptyBorderColor
        
        return StarLayer.create(settings.starPoints,
                                size: settings.starSize,
                                lineWidth: isFilled ? settings.filledBorderWidth : settings.emptyBorderWidth,
                                fillColor: fillColor,
                                strokeColor: strokeColor)
    }
    

    class func positionStarLayers(layers: [CALayer], starMargin: Double) {
        var positionX:CGFloat = 0
        
        for layer in layers {
            layer.position.x = positionX
            positionX += layer.bounds.width + CGFloat(starMargin)
        }
    }
}

class CosmosLayerHelper {
    class func createTextLayer(text: String, font: UIFont, color: UIColor) -> CATextLayer {
        let size = NSString(string: text).sizeWithAttributes([NSFontAttributeName: font])
        
        let layer = CATextLayer()
        layer.bounds = CGRect(origin: CGPoint(), size: size)
        layer.anchorPoint = CGPoint()
        
        layer.string = text
        layer.font = CGFontCreateWithFontName(font.fontName)
        layer.fontSize = font.pointSize
        layer.foregroundColor = color.CGColor
        layer.contentsScale = UIScreen.mainScreen().scale
        
        return layer
    }
}

class CosmosSize {
    class func calculateSizeToFitLayers(layers: [CALayer]) -> CGSize {
        var size = CGSize()
        
        for layer in layers {
            if layer.frame.maxX > size.width {
                size.width = layer.frame.maxX
            }
            
            if layer.frame.maxY > size.height {
                size.height = layer.frame.maxY
            }
        }
        
        return size
    }
}

struct CosmosTouchTarget {
    static func optimize(bounds: CGRect) -> CGRect {
        let recommendedHitSize: CGFloat = 44
        
        var hitWidthIncrease:CGFloat = recommendedHitSize - bounds.width
        var hitHeightIncrease:CGFloat = recommendedHitSize - bounds.height
        
        if hitWidthIncrease < 0 { hitWidthIncrease = 0 }
        if hitHeightIncrease < 0 { hitHeightIncrease = 0 }
        
        let extendedBounds: CGRect = CGRectInset(bounds,
                                                 -hitWidthIncrease / 2,
                                                 -hitHeightIncrease / 2)
        
        return extendedBounds
    }
}


struct CosmosRating {
    

    static func starFillLevel(ratingRemainder ratingRemainder: Double, fillMode: StarFillMode) -> Double {
        
        var result = ratingRemainder
        
        if result > 1 { result = 1 }
        if result < 0 { result = 0 }
        
        return roundFillLevel(result, fillMode: fillMode)
    }
    

    static func roundFillLevel(starFillLevel: Double, fillMode: StarFillMode) -> Double {
            return Double(round(starFillLevel * 2) / 2)
    }
    
    
    static func displayedRatingFromPreciseRating(preciseRating: Double,
                                                 fillMode: StarFillMode, totalStars: Int) -> Double {
        
        let starFloorNumber = floor(preciseRating)
        let singleStarRemainder = preciseRating - starFloorNumber
        
        var displayedRating = starFloorNumber + starFillLevel(
            ratingRemainder: singleStarRemainder, fillMode: fillMode)
        
        displayedRating = min(Double(totalStars), displayedRating) // Can't go bigger than number of stars
        displayedRating = max(0, displayedRating) // Can't be less than zero
        
        return displayedRating
    }
    

    static func numberOfFilledStars(rating: Double, totalNumberOfStars: Int) -> Double {
        if rating > Double(totalNumberOfStars) { return Double(totalNumberOfStars) }
        if rating < 0 { return 0 }
        
        return rating
    }
}

struct StarLayer {

    static func create(starPoints: [CGPoint], size: Double,
                       lineWidth: Double, fillColor: UIColor, strokeColor: UIColor) -> CALayer {
        
        let containerLayer = createContainerLayer(size)
        let path = createStarPath(starPoints, size: size, lineWidth: lineWidth)
        
        let shapeLayer = createShapeLayer(path.CGPath, lineWidth: lineWidth,
                                          fillColor: fillColor, strokeColor: strokeColor, size: size)
        
        containerLayer.addSublayer(shapeLayer)
        
        return containerLayer
    }
    

    static func createShapeLayer(path: CGPath, lineWidth: Double, fillColor: UIColor,
                                 strokeColor: UIColor, size: Double) -> CALayer {
        
        let layer = CAShapeLayer()
        layer.anchorPoint = CGPoint()
        layer.contentsScale = UIScreen.mainScreen().scale
        layer.strokeColor = strokeColor.CGColor
        layer.fillColor = fillColor.CGColor
        layer.lineWidth = CGFloat(lineWidth)
        layer.bounds.size = CGSize(width: size, height: size)
        layer.masksToBounds = true
        layer.path = path
        layer.opaque = true
        return layer
    }
    

    static func createContainerLayer(size: Double) -> CALayer {
        let layer = CALayer()
        layer.contentsScale = UIScreen.mainScreen().scale
        layer.anchorPoint = CGPoint()
        layer.masksToBounds = true
        layer.bounds.size = CGSize(width: size, height: size)
        layer.opaque = true
        return layer
    }
    

    static func createStarPath(starPoints: [CGPoint], size: Double,
                               lineWidth: Double) -> UIBezierPath {
        
        let lineWidthLocal = lineWidth + ceil(lineWidth * 0.3)
        let sizeWithoutLineWidth = size - lineWidthLocal * 2
        
        let points = scaleStar(starPoints, factor: sizeWithoutLineWidth / 100,
                               lineWidth: lineWidthLocal)
        
        let path = UIBezierPath()
        path.moveToPoint(points[0])
        let remainingPoints = Array(points[1..<points.count])
        
        for point in remainingPoints {
            path.addLineToPoint(point)
        }
        
        path.closePath()
        return path
    }

    static func scaleStar(starPoints: [CGPoint], factor: Double, lineWidth: Double) -> [CGPoint] {
        return starPoints.map { point in
            return CGPoint(
                x: point.x * CGFloat(factor) + CGFloat(lineWidth),
                y: point.y * CGFloat(factor) + CGFloat(lineWidth)
            )
        }
    }
}