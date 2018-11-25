//
//  AllocationType.swift
//  BounceSwift
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

struct AllocationLine{
    var start: CGPoint
    var end: CGPoint
    
    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
    
    init(start: CGPoint, length: CGFloat, theta: CGFloat) {
        let t = (theta * 2 * CGFloat.pi) / 360
        self.start = start
        self.end = CGPoint(x: start.x + length * cos(t), y:  start.y + length * sin(t))
    }
    
    func length() -> CGFloat{
        let x = abs(end.x - start.x)
        let y = abs(end.y - start.y)
        let x2 = pow(x, 2)
        let y2 = pow(y, 2)
        return sqrt(x2+y2)
    }
}
