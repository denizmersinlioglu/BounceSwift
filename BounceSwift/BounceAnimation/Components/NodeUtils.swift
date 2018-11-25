//
//  NodeUtils.swift
//  SwiftBounce
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

@available(iOS 9.0, *)
struct TargetInfo {
    var name: String
    var image: UIImage?
    var imageURL: String?
    var info: String
    
    init(name: String, info: String, image: UIImage? = nil, imageURL: String? = nil) {
        self.name = name
        self.image = image
        self.imageURL = imageURL
        self.info = info
    }
}

@available(iOS 9.0, *)
enum NodeType{
    case target
    case action
}

@available(iOS 9.0, *)
protocol NodeDelegate{
    func nodeTapped(to node: Node)
}
