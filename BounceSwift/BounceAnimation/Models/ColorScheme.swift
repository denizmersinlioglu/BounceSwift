//
//  ColorScheme.swift
//  SwiftBounce
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

public struct ColorScheme{
    var backgroundFillColor:UIColor
    var foregroundFillColor:UIColor
    var actionNodeFillColor:UIColor
    var actionNodeStrokeColor:UIColor
    var targetNodeFillColor:UIColor
    var targetNodeStrokeColor:UIColor
    var targetNodeTextColor:UIColor
    
   public init(backgroundFillColor:UIColor = .clear,
         foregroundFillColor:UIColor = .lightGray,
         actionNodeFillColor:UIColor = .darkGray,
         actionNodeStrokeColor:UIColor = .white,
         targetNodeFillColor:UIColor = .gray,
         targetNodeStrokeColor:UIColor = .darkGray,
         targetNodeTextColor:UIColor = .white) {
        
        self.backgroundFillColor = backgroundFillColor
        self.foregroundFillColor = foregroundFillColor
        self.actionNodeFillColor = actionNodeFillColor
        self.actionNodeStrokeColor = actionNodeStrokeColor
        self.targetNodeFillColor = targetNodeFillColor
        self.targetNodeStrokeColor = targetNodeStrokeColor
        self.targetNodeTextColor = targetNodeTextColor
    }
}
