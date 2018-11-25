//
//  NodeUtils.swift
//  SwiftBounce
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

@available(iOS 9.0, *)
public struct TargetInfo {
    public var name: String
    public var image: UIImage?
    public var imageURL: String?
    public var info: String
    
    public init(name: String, info: String, image: UIImage? = nil, imageURL: String? = nil) {
        self.name = name
        self.image = image
        self.imageURL = imageURL
        self.info = info
    }
}

@available(iOS 9.0, *)
public enum NodeType{
    case target
    case action
}

@available(iOS 9.0, *)
public protocol NodeDelegate{
    func nodeTapped(to node: Node)
}
