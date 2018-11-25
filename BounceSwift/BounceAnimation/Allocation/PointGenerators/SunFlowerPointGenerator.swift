//
//  SunFlowerPointGenerator.swift
//  BounceSwift
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

struct SunflowerPointGenerator: PointGenerator {
    let phi: Float = 1.618

    mutating func generatePoints(numPoints: Int, maxWidth: CGFloat, maxLength: CGFloat) -> [CGPoint] {
        let points = sunflower(numPoints: numPoints, alpha: 2.0)
        return points
    }
    
    public func sunflower(numPoints: Int, alpha: Float) -> [CGPoint] {
        var points = [CGPoint]()
        let b = roundf(alpha * sqrtf(Float(numPoints))) // number of boundary points
        for k in 1...numPoints {
            let rad = radius(k: Float(k), n: Float(numPoints), b: b)
            //            let theta = Float(k) * Float(360) * phi
            let theta = 2 * Float.pi * Float(k)/powf(phi, 2.0)
            let thePoint = CGPoint(x: CGFloat(rad * cosf(theta)), y: CGFloat(rad * sinf(theta)))
            points.append(thePoint)
        }
        return points
    }
    
    public func radius(k: Float, n: Float, b: Float) -> Float {
        var r: Float = 0.0
        if k > n - b {
            r = 1.0
        } else {
            r = sqrtf(k - 1/2) / sqrtf(n - (b+1)/2)
        }
        
        return r
    }
    
}
