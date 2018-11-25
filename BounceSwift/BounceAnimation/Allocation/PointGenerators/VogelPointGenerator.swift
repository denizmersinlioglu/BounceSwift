//
//  VogelPointGenerator.swift
//  BounceSwift
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit
struct VogelPointGenerator: PointGenerator {
    
    var radius: CGFloat!
    
    init(radius: CGFloat) {
        self.radius = radius
    }
    
    mutating func generatePoints(numPoints: Int, maxWidth: CGFloat, maxLength: CGFloat) -> [CGPoint] {
        var points = [CGPoint]()
        let cc: Float = 0.0
        
        
        let it = Float.pi * (1 - sqrtf(3.0))
//        let it: Float = 0.1
        for p in 0..<numPoints {
            // Calculating polar coordinates theta (t) and radius (r)
            let t = it * Float(p)
            let r: Float = sqrtf( Float(p) / Float(numPoints))
            // Converting to the Cartesian coordinates x, y
            let x = r * cosf(t) + cc
            let y = r * sinf(t) + cc
            
            let point = CGPoint(x: radius * 4 * CGFloat(x), y: radius * 4 * CGFloat(y))
            points.append(point)
        }
        
        return points
    }
}
