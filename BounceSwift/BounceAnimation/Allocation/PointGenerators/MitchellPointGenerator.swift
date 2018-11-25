//
//  MitchellPointGenerator.swift
//  BounceSwift
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

struct MitchellPointGenerator: PointGenerator {
    var radius: Float = 0.4
    let pos: CGPoint = CGPoint.zero
    var points = [CGPoint]()
    var width: Float = 4
    var height: Float = 4
    
    mutating func generatePoints(numPoints: Int, maxWidth: CGFloat, maxLength: CGFloat) -> [CGPoint] {
        self.width = Float(maxWidth)
        self.height = Float(maxLength)
        
        for _ in 0..<numPoints {
            
            let pointSample = sample(anchorPos: CGPoint(x: CGFloat(pos.x), y: CGFloat(pos.y)))
            points.append(pointSample)
        }
        
        return points
        
    }
    
    func sample(anchorPos: CGPoint) -> CGPoint {
        var bestCandidate: CGPoint = CGPoint(x: 0, y: 0)
        var bestDistance: Float = 0
        let numCandidates = 20
        let anchorX = Float(anchorPos.x)
        let anchorZ = Float(anchorPos.y)
        for _ in 0..<numCandidates {
            let xVal = CGFloat(Float.random(min: anchorX - radius, max: anchorX + radius) * width)
            let zVal = CGFloat(Float.random(min: anchorZ - radius, max: anchorZ + radius) * height)
            let c = CGPoint(x: xVal, y: zVal)
            let d = distance(a: findClosest(pool: points, point: c), b: c)
            if (d > bestDistance) {
                bestDistance = d;
                bestCandidate = c;
            }
        }
        return bestCandidate;
    }
    
    func findClosest(pool: [CGPoint], point: CGPoint) -> CGPoint {
        var currentClosest = point
        
        var minDistance = Float.infinity
        for aPointInPool in pool {
            let dist = distance(a: aPointInPool, b: point)
            if dist < minDistance {
                currentClosest = aPointInPool
                minDistance = dist
            }
        }
        
        return currentClosest
    }
    
    func distance(a: CGPoint, b: CGPoint) -> Float {
        let dx = a.x - b.x
        let dy = a.y - b.y
        return Float((dx * dx + dy * dy).squareRoot())
    }
}
