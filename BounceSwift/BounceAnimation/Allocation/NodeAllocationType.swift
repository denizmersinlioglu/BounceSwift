//
//  NodeAllocationType.swift
//  BounceSwift
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import Foundation


enum AllocationType{
    case randomInRect(type: DistributionType)
    case randomOnLine
    case regulardInRect
    case regularOnLine
}

enum DistributionType{
    case mitchell
    case sunFlower(theta: Float)
    case vogel(it: Float)
    case basic
}
