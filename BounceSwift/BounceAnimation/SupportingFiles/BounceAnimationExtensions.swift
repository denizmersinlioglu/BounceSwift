//
//  Extensions.swift
//  SwiftBounce
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

extension UIColor{
    func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)?
    {
        var (red, green, blue, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        {
            return (red, green, blue, alpha)
        }
        else
        {
            return nil
        }
    }
    
    static func * (lhs: UIColor, rhs: CGFloat) -> UIColor{
        guard let rgbValues = lhs.getRGBAComponents() else {return UIColor()}
        return UIColor(red: rgbValues.red * rhs, green: rgbValues.green * rhs, blue: rgbValues.blue * rhs, alpha: rgbValues.alpha)
    }
}
extension UIView {
    func dg_center(_ usePresentationLayerIfPossible: Bool) -> CGPoint {
        if usePresentationLayerIfPossible, let presentationLayer = layer.presentation() {
            return presentationLayer.position
        }
        return center
    }
    
    func removeAllRecognizers(){
        if let recognizers = gestureRecognizers {
            for recognizer in recognizers {
                removeGestureRecognizer(recognizer)
            }
        }
    }
}

extension CGPath {
    
    func getPointAt(percent t: CGFloat, start: CGFloat, c1: CGFloat, end: CGFloat ) -> CGFloat {
        let t_: CGFloat = t
        let tt_: CGFloat = t_ * t_
        let tt: CGFloat = t * t
        return start * tt_
            + 2.0 * c1 * t_ * t
            + end * tt
    }
    
    func getPoint(percent : CGFloat) -> CGPoint {
        let leftPoint = self.getPathElementsPoints()[1]
        let centerPoint = self.getPathElementsPoints()[2]
        let rightPoint = self.getPathElementsPoints()[3]
        let middleX = getPointAt(percent: percent, start: leftPoint.x , c1: centerPoint.x, end: rightPoint.x)
        let middleY = getPointAt(percent: percent, start: leftPoint.y, c1: centerPoint.y, end: rightPoint.y)
        return CGPoint(x: middleX, y: middleY)
    }
    
    func forEach( body: @escaping @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
    
    func getPathElementsPoints() -> [CGPoint] {
        var arrayPoints : [CGPoint]! = [CGPoint]()
        self.forEach { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
            default: break
            }
        }
        return arrayPoints
    }
    
    func getPathElementsPointsAndTypes() -> ([CGPoint],[CGPathElementType]) {
        var arrayPoints : [CGPoint]! = [CGPoint]()
        var arrayTypes : [CGPathElementType]! = [CGPathElementType]()
        self.forEach { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
                arrayTypes.append(element.type)
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
                arrayTypes.append(element.type)
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
                arrayTypes.append(element.type)
            default: break
            }
        }
        return (arrayPoints,arrayTypes)
    }
}

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: self.text ?? " ")
        }
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

public extension Float {
    public static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}

public extension CGFloat {
    public static var randomSign: CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
    
    public static var random: CGFloat {
        return CGFloat(Float.random)
    }
   
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random * (max - min) + min
    }
}

