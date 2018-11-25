//
//  Node.swift
//  SwiftBounce
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit
import AlamofireImage

@available(iOS 9.0, *)
public class Node: UIView {
    private let imageView = UIImageView()
    private let infoLabel = UILabel()
    private let maskImageView = UIImageView()
    
    var delegate: NodeDelegate?
    var targetInfo: TargetInfo?
    var index: Int = 0
    public var type: NodeType = NodeType.action
    var lineWidth: CGFloat = 3
    
    var fillColor: UIColor = UIColor.red.withAlphaComponent(0.5) {
        didSet{
            backgroundColor = fillColor
        }
    }
    var strokeColor: UIColor = .red {
        didSet{
            layer.borderColor = strokeColor.cgColor
        }
    }
    
    convenience init(frame: CGRect, targetInfo: TargetInfo?,type: NodeType, index: Int) {
        self.init(frame: frame)
        self.targetInfo = targetInfo
        self.type = type
        self.index = index
        if let imageURL = targetInfo?.imageURL,
            let url = URL(string: imageURL){
            imageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "icon_contactbook.png"))
        }else {
            imageView.image = targetInfo?.image ?? #imageLiteral(resourceName: "icon_contactbook.png")
        }
        addImageView(imageView: imageView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.borderWidth = lineWidth
        layer.cornerRadius = bounds.width/2
        backgroundColor = fillColor
        layer.borderColor = strokeColor.cgColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelAlpha(fraction: CGFloat){
        self.infoLabel.alpha = fraction
    }
    
    func setLabelText(text: String, font: UIFont = UIFont.boldSystemFont(ofSize: 14), color: UIColor = .white){
        infoLabel.text = text
        infoLabel.font = font
        infoLabel.textColor = color
    }
    
    func addCollisionBehaivor(to items: [UIView] = [Node](), delegate: UICollisionBehaviorDelegate) -> UICollisionBehavior{
        var arr = items
        arr.append(self)
        let collision = UICollisionBehavior(items: arr )
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionMode = [.items, .boundaries]
        collision.collisionDelegate = delegate
        return collision
    }
    
    fileprivate func setProfileMaskImage(alpha: CGFloat){
        maskImageView.image = UIImage.from(color: UIColor.black.withAlphaComponent(alpha))
        addImageView(imageView: maskImageView)
    }
    
    func addImageView(imageView: UIImageView){
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = bounds.width/2 - lineWidth
        imageView.clipsToBounds = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: lineWidth).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -lineWidth).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: lineWidth).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -lineWidth).isActive = true
    }
    
    func addLabel(text: String, font: UIFont, maskEnabled: Bool = true){
        if maskEnabled{
            setProfileMaskImage(alpha: 0.15)
        }
        setLabelText(text: text, font: font, color: .white)
        addSubview(infoLabel)
        infoLabel.numberOfLines = 1
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.textAlignment = .center
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        infoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: lineWidth).isActive = true
    }
    
    func removeLabel(){
        infoLabel.removeFromSuperview()
        setProfileMaskImage(alpha: 0)
    }
    
    func addTapGesture(delegate: NodeDelegate){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(nodeTapped))
        addGestureRecognizer(tapRecognizer)
        self.delegate = delegate
    }
    
    @objc func nodeTapped(){
        delegate?.nodeTapped(to: self)
    }
    
    private func circularPath(lineWidth: CGFloat = 0, center: CGPoint = .zero) -> UIBezierPath {
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
    }
    
    override public var collisionBoundsType: UIDynamicItemCollisionBoundsType { return .path }
    
    override public var collisionBoundingPath: UIBezierPath { return circularPath() }
}
