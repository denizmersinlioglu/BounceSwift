//
//  BounceAnimationViewController.swift
//  SwiftBounce
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit
import CoreMotion

@available(iOS 9.0, *)
public class BounceAnimationController: UIViewController {
    
    init(colorScheme: ColorScheme, targetInfo: [TargetInfo], delegate: BounceAnimationDelegate, actionNodeTitle: String, transactionSummary: NSAttributedString, transactionDescription: NSAttributedString) {
        self.colorScheme = colorScheme
        self.targetInfo = targetInfo
        self.bounceAnimationDelegate = delegate
        self.transactionSummary = transactionSummary
        self.transactionDescription = transactionDescription
        self.actionNodeTitle = actionNodeTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var bounceAnimationDelegate: BounceAnimationDelegate!
    private var actionNodeTitle: String = ""
    private let minimalHeight: CGFloat = UIScreen.main.bounds.height * 0.75
    private let maxWaveHeight: CGFloat = UIScreen.main.bounds.height * 0.22
    private let shapeLayer = CAShapeLayer()
    private let leftControlPointView = UIView()
    private let centerControlPointView = UIView()
    private let rightControlPointView = UIView()
    private let targetNodeInitialVelocity: CGFloat = 150
    private var targetInfo: [TargetInfo]!
    private var transactionSummary: NSAttributedString!
    private var transactionDescription: NSAttributedString!
    private var colorScheme: ColorScheme!
    private var collisionBehaivors = [UICollisionBehavior]()
    private var targetNodesInitialVerticalPosition: CGFloat!
    private var motionManager: CMMotionManager!
    private var hitCount = 0
    private var touchCount = 0
    private var screenWidth:CGFloat = 0
    private var displayLink: CADisplayLink!
    private var locationX: CGFloat = 0
    private var isPhysicsActive = false
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var dynamicItemBehaivor: UIDynamicItemBehavior!
    private var targetNodes = [Node](){
        didSet{
            targetNodes.forEach {
                $0.addTapGesture(delegate: self)
                collisionBehaivors.append($0.addCollisionBehaivor(to: [actionNode], delegate: self))
                view.addSubview($0)
            }
        }
    }
    
    private var animating = false {
        didSet {
            view.isUserInteractionEnabled = !animating
            displayLink.isPaused = !animating
        }
    }
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .black
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 10, lineHeightMultiple: 0)
        label.textAlignment = .center
        return label
    }()
    
    let actionNode: Node = {
        let view = Node(frame:  CGRect(x: 0, y: 0, width: 72, height: 72))
        view.addLabel(text: "", font: UIFont.boldSystemFont(ofSize: 14), maskEnabled: false)
        view.lineWidth = 2
        view.type = .action
        return view
    }()
    
    // MARK: - Life Cycle
    override public func loadView() {
        super.loadView()
        screenWidth = view.bounds.width
        actionNode.setLabelText(text: actionNodeTitle)
        shapeLayer.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: minimalHeight)
        shapeLayer.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
        view.layer.addSublayer(shapeLayer)
        
        descriptionLabel.attributedText = transactionDescription
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        summaryLabel.attributedText = transactionSummary
        view.addSubview(summaryLabel)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        summaryLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        summaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(actionNode)
        view.addSubview(leftControlPointView)
        view.addSubview(centerControlPointView)
        view.addSubview(rightControlPointView)
        
        actionNode.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureDidMove(gesture:))))
        actionNode.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionButtonTapped(recognizer:))))
        layoutControlPoints(baseHeight: minimalHeight, waveHeight: 0.0, locationX: screenWidth / 2.0)
        updateShapeLayer()
        
        displayLink = CADisplayLink(target: self, selector:  #selector(updateShapeLayer))
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        displayLink.isPaused = true
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let manager = NodeManager(targetInfo: targetInfo, colorScheme: colorScheme)
        targetNodes = manager.createtargetNodes()
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: targetNodes)
        gravity.addItem(actionNode)
        dynamicItemBehaivor = UIDynamicItemBehavior(items: targetNodes)
        dynamicItemBehaivor.addItem(actionNode)
        _ = actionNode.addCollisionBehaivor(delegate: self)
        motionManager = CMMotionManager()
        actionNode.fillColor = colorScheme.actionNodeFillColor
        actionNode.strokeColor = colorScheme.actionNodeStrokeColor
        shapeLayer.fillColor = colorScheme.foregroundFillColor.cgColor
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopAccelerometerUpdates()
        displayLink.isPaused = true
    }
    
    func currentPath() -> CGPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0.0, y: 0.0))
        bezierPath.addLine(to: CGPoint(x: 0.0, y: leftControlPointView.dg_center(animating).y))
        bezierPath.addQuadCurve(to: rightControlPointView.dg_center(animating), controlPoint: centerControlPointView.dg_center(animating))
        bezierPath.addLine(to: CGPoint(x: screenWidth, y: 0))
        bezierPath.close()
        return bezierPath.cgPath
    }
    
    func layoutControlPoints(baseHeight: CGFloat, waveHeight: CGFloat, locationX: CGFloat) {
        let minLeftX:CGFloat = 0.0
        let maxRightX: CGFloat = screenWidth
        
        leftControlPointView.center = CGPoint(x: minLeftX, y: baseHeight)
        centerControlPointView.center = CGPoint(x: locationX , y: baseHeight + waveHeight * 1.6)
        rightControlPointView.center = CGPoint(x: maxRightX, y: baseHeight)
    }
    
    @objc func updateShapeLayer() {
        let path = currentPath()
        shapeLayer.path = path
        if !isPhysicsActive{
            let pathMiddlePoint = path.getPoint(percent: 0.5)
            let distanceToCenter = abs(screenWidth/2 - pathMiddlePoint.x)
            let horizontalOffset = locationX > screenWidth/2 ? distanceToCenter * 0.4 : -distanceToCenter * 0.4
            actionNode.layer.position = CGPoint(x: pathMiddlePoint.x + horizontalOffset, y: pathMiddlePoint.y)
        }
    }
    
    // MARK: Pan Gesture Methods
    @objc func panGestureDidMove(gesture: UIPanGestureRecognizer) {
        let panVertical = max(gesture.translation(in: view).y, -maxWaveHeight * 1/4)
        let panPoint =  gesture.location(in: view)
        let panHorizontal = gesture.translation(in: view).x
        let velocity = CGPoint(x: panHorizontal * -4 , y: 8 * (minimalHeight - panPoint.y ))
        if gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled {
            bounceAnimationDelegate.bounceAnimation(self, endMove: gesture)
            isPhysicsActive = panVertical > maxWaveHeight * 1/2
            if isPhysicsActive {
                bounceAnimationDelegate.bounceAnimation(self, launchedWithVelocity: velocity, from: gesture.location(in: view))
                launchActionButton(velocity: velocity)
            }else{
                let maxDistance = max(abs(panVertical),abs(panHorizontal))
                let ratio = maxDistance / maxWaveHeight
                simulateBounceAnimation(toVerticalPosition: 0, duration: 0.2 + TimeInterval(1.8 * ratio), withDamping: 0.16 * (2 - ratio), completion: nil)
            }
        } else {
            let _ =  gesture.state == .began ? bounceAnimationDelegate.bounceAnimation(self, startedToMove: gesture) : bounceAnimationDelegate.bounceAnimation(self, recognizer: gesture, didMoveTo: gesture.location(in: view))
            animator!.removeAllBehaviors()
            let waveHeight = min(panVertical, maxWaveHeight)
            locationX = gesture.location(in: view).x
            updateUI(ratio:  max(panVertical / maxWaveHeight,0))
            layoutControlPoints(baseHeight: minimalHeight, waveHeight: waveHeight, locationX: locationX)
            updateShapeLayer()
        }
    }
    
    func updateUI(ratio: CGFloat){
        let colorRatio = 1 - min(ratio / 2, 0.6)
        let alphaRatio = max(1 - 2 * ratio , 0)
        actionNode.setLabelAlpha(fraction: alphaRatio)
        descriptionLabel.alpha = alphaRatio
        summaryLabel.alpha = alphaRatio
        shapeLayer.fillColor = (colorScheme.foregroundFillColor * colorRatio).cgColor
        settargetNodesStrokeColor(color: (colorScheme.targetNodeStrokeColor * colorRatio))
    }

    @objc func actionButtonTapped(recognizer: UITapGestureRecognizer) {
        if touchCount == 0 {
            bounceAnimationDelegate.bounceAnimation(self, firstTap: recognizer, at: recognizer.location(in: view))
            simulateBounceAnimation(toVerticalPosition: maxWaveHeight/2, duration: 0.5, withDamping: 1) {
                self.simulateBounceAnimation(toVerticalPosition: 0, duration: 1, withDamping: 0.3, completion: {
                    self.touchCount += 1
                })
            }
        }else {
            bounceAnimationDelegate.bounceAnimation(self, secondTap: recognizer, at: recognizer.location(in: view))
            animating = true
            simulateBounceAnimation(toVerticalPosition: maxWaveHeight, duration: 0.5, withDamping: 1) {
                self.isPhysicsActive = true
                let velocity = CGPoint(x: 0, y: -8 * self.maxWaveHeight)
                let launchPoint = CGPoint(x: self.screenWidth/2, y: self.minimalHeight + self.maxWaveHeight)
                self.bounceAnimationDelegate.bounceAnimation(self, launchedWithVelocity: velocity, from: launchPoint)
                self.launchActionButton(velocity: velocity)
            }
        }
    }
    
    func launchActionButton(velocity: CGPoint){
        actionNode.removeAllRecognizers()
        simulateLaunchPhysics(velocity: velocity)
        animating = true
        UIView.animate(withDuration: 2, delay: 0.0, usingSpringWithDamping: 0.24, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
            self.settargetNodesStrokeColor(color: self.colorScheme.targetNodeStrokeColor)
            self.shapeLayer.fillColor = self.colorScheme.foregroundFillColor.cgColor
            self.centerControlPointView.center.y = self.minimalHeight
            self.centerControlPointView.center.x = self.screenWidth / 2
        }, completion: { _ in
            self.animating = false
        })
    }
    
    func settargetNodesStrokeColor(color: UIColor){
        for targetNode in self.targetNodes where targetNode.type != .action {
            targetNode.strokeColor = color
        }
    }
    
    public func simulateResultAnimation(completion: @escaping () -> ()){
        simulateResultPhysics()
        animating = true
        UIView.animate(withDuration: 2, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
            self.leftControlPointView.center.y = 0
            self.rightControlPointView.center.y = 0
            self.centerControlPointView.center.y = 0
        }, completion: { _ in
            completion()
            self.shapeLayer.fillColor = UIColor.clear.cgColor
            self.animating = false
        })
    }
    
    func simulateBounceAnimation(toVerticalPosition offset: CGFloat, duration: TimeInterval, withDamping damping: CGFloat, completion: (() -> ())?){
        animating = true
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: damping, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
            self.centerControlPointView.center.y = self.minimalHeight + offset
            self.centerControlPointView.center.x = self.screenWidth / 2
            self.updateUI(ratio: max(offset / self.maxWaveHeight,0))
        }, completion: { _ in
            self.animating = false
            guard let completion = completion else {return}
            completion()
        })
    }
    
    // MARK: Physics Methods
    func simulateLaunchPhysics(velocity: CGPoint){
        for collision in collisionBehaivors {
            animator!.addBehavior(collision)
        }
        dynamicItemBehaivor.addLinearVelocity(velocity, for: self.actionNode)
        dynamicItemBehaivor.angularResistance = 0
        dynamicItemBehaivor.resistance = 0
        dynamicItemBehaivor.elasticity = 1
        animator!.addBehavior(dynamicItemBehaivor)
    }
    
    func simulateResultPhysics(){
        animator!.addBehavior(self.gravity)
        dynamicItemBehaivor.elasticity = 0.5
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, err) in
            if let err = err{
                print(err)
                return
            }
            guard let xValue = data?.acceleration.x, let yValue = data?.acceleration.y else {return}
            self.gravity.gravityDirection = CGVector(dx: xValue, dy: -yValue)
            self.gravity.magnitude = 1
        }
    }
}

@available(iOS 9.0, *)
extension BounceAnimationController: UICollisionBehaviorDelegate{
    public func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        guard let node1 = item1 as? Node, let node2 = item2 as? Node else {return}
        
        if node1.type != .action || node2.type != .action {
             bounceAnimationDelegate.bounceAnimation(self, targetNode: node1, collidedTo: node2, with: behavior, at: p)
        }
        if node1.type == .action || node2.type == .action {
            // Delegate Methods
            if node1.type == .action {
                bounceAnimationDelegate.bounceAnimation(self, actionNode: node1, collidedTo: node2, with: behavior, at: p)
            }else{
                bounceAnimationDelegate.bounceAnimation(self, actionNode: node2, collidedTo: node1, with: behavior, at: p)
            }
            for targetNode in self.targetNodes{
                behavior.addItem(targetNode)
            }
            guard hitCount == 0 else {return}
            for (index,targetNode) in self.targetNodes.enumerated() where targetNode.type != .action {
                hitCount += 1
                if targetNode.type == .target {
                    targetNode.addLabel(text: targetInfo[index].info, font: UIFont.boldSystemFont(ofSize: 20))
                }
            }
        }
    }
}

@available(iOS 9.0, *)
extension BounceAnimationController: NodeDelegate{
    public func nodeTapped(to node: Node) {
        bounceAnimationDelegate.bounceAnimation(self, nodeTapped: node)
    }
}

