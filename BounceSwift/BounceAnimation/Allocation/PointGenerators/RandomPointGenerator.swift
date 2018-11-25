//
//  RandomPointGenerator.swift
//  BounceSwift
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

struct RandomPointGenerator: PointGenerator {
    mutating func generatePoints(numPoints: Int, maxWidth: CGFloat, maxLength: CGFloat) -> [CGPoint] {
        var points = [CGPoint]()
        
        for _ in 0..<numPoints {
            let x = CGFloat.random(min: -maxWidth/2, max: maxWidth/2)
            let y = CGFloat.random(min: -maxLength/2, max: maxLength/2)
            
            let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
            points.append(point)
        }
        
        return points
    }
}
