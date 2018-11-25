//
//  PointGenerator.swift
//  BounceSwift
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

protocol PointGenerator {
    mutating func generatePoints(numPoints: Int, maxWidth: CGFloat, maxLength: CGFloat) -> [CGPoint]
}
