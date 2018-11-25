//
//  NodeManager.swift
//  BounceSwift
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

public class NodeManager{
    
    public var targetInfo: [TargetInfo]!
    public var colorScheme: ColorScheme!
    public var diameter: CGFloat = 80
    let hCenter = UIScreen.main.bounds.width/2
    let vCenter = UIScreen.main.bounds.height/2

    public init(targetInfo: [TargetInfo], colorScheme: ColorScheme){
        self.targetInfo = targetInfo
        self.colorScheme = colorScheme
    }
    
    func createtargetNodes() -> [Node]{
        var pointGenerator = MitchellPointGenerator()
        let points = pointGenerator.generatePoints(numPoints: targetInfo.count, maxWidth: hCenter * 1.5 , maxLength:  vCenter)
        return targetInfo.enumerated().map{ (arg) -> Node in
            let (offset, element) = arg
            let frame =  CGRect(x: hCenter + points[offset].x - diameter/2,
                                y: vCenter/1.5 + points[offset].y - diameter/2,
                                width: diameter,
                                height: diameter)
            let targetNode = Node(frame: frame,
                                  targetInfo: element,
                                  type: .target,
                                  index: offset)
            targetNode.strokeColor = colorScheme.targetNodeStrokeColor
            targetNode.fillColor = colorScheme.targetNodeFillColor
            return targetNode
        }
    }
}
