//
//  BounceAnimationViewControllerDelegate.swift
//  SwiftBounce
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

@available(iOS 9.0, *)
protocol BounceAnimationDelegate {

    /// Notify delegate that: The action node launched and physics activated
    ///
    /// - Parameters:
    ///   - controller: AnimationController controls all physics and layer animations
    ///   - velocity: Action Node Launching Velocity
    ///   - startingPoint: Action Node Launch Motion Starting Point
    func bounceAnimation(_ controller: BounceAnimationController, launchedWithVelocity velocity: CGPoint, from point: CGPoint)

    /// Notify delegate that: Action Node collides to an Target Node
    ///
    /// - Parameters:
    ///   - controller: AnimationController controls all physics and layer animations
    ///   - actionNode: Action Node on the AnimationController
    ///   - targetNode: Target Node on the AnimationController
    ///   - behaivor: Collision behaivor of the collided node
    ///   - point: Collision location point of two nodes
   
    func bounceAnimation(_ controller: BounceAnimationController, actionNode: Node, collidedTo targetNode: Node, with behaivor: UICollisionBehavior, at point: CGPoint)
 
    /// Notify delegate that: TargetNode collides to an Target Node
    ///
    /// - Parameters:
    ///   - controller: AnimationController controls all physics and layer animations
    ///   - targetNode: First target Node on the AnimationController
    ///   - targetNode2: Second target Node on the AnimationController
    ///   - behaivor: Collision behaivor of the collided node
    ///   - point: Collision location point of two nodes
    func bounceAnimation(_ controller: BounceAnimationController, targetNode: Node, collidedTo targetNode2: Node, with behaivor: UICollisionBehavior, at point: CGPoint)
    
    /// Notify delegate that: Pan gesture stated to move
    ///
    /// - Parameters:
    ///   - controller: AnimationController controls all physics and layer animations
    ///   - recognizer: Pan gesture recognizer on action node in AnimationControllers view.
    func bounceAnimation(_ controller: BounceAnimationController, startedToMove recognizer: UIPanGestureRecognizer)
    
    
    /// Notify delegate that: Pan gesture end its motion
    ///
    /// - Parameters:
    ///   - controller: AnimationController controls all physics and layer animations
    ///   - recognizer: Pan gesture recognizer on action node in AnimationControllers view.
    func bounceAnimation(_ controller: BounceAnimationController, endMove recognizer: UIPanGestureRecognizer)

    
    /// Notify delegate that: Pan gesture did move to a specific position
    ///
    /// - Parameters:
    ///   - controller: AnimationController controls all physics and layer animations
    ///   - recognizer: Pan gesture recognizer on action node in AnimationControllers view.
    ///   - positon: Position of the pan gesture recognizer on action node in AnimationControllers view.
    func bounceAnimation(_ controller: BounceAnimationController, recognizer: UIPanGestureRecognizer, didMoveTo positon: CGPoint)
    
    
    /// Notify delegate that: Tap gesture activated for the first time
    ///
    /// - Parameters:
    ///   - controller: AnimationController controls all physics and layer animations
    ///   - recognizer: Tap gesture recognizer on action node in AnimationControllers view.
    ///   - position: Position of the Tap gesture recognizer on action node in AnimationControllers view.
    func bounceAnimation(_ controller:BounceAnimationController, firstTap recognizer: UITapGestureRecognizer, at position: CGPoint)
    
    /// Notify delegate that: Tap gesture activated for the second time
    ///
    /// - Parameters:
    ///   - controller: AnimationController controls all physics and layer animations
    ///   - recognizer: Tap gesture recognizer on action node in AnimationControllers view.
    ///   - position:  Position of the Tap gesture recognizer on action node in AnimationControllers view.
    func bounceAnimation(_ controller:BounceAnimationController,secondTap recognizer: UITapGestureRecognizer,  at position: CGPoint)

    
    /// Notify delegate that: An target node clicked by the target
    ///
    /// - Parameters:
    ///   - controller: AnimationController controls all physics and layer animations
    ///   - type: Node type that .action .target .leftOver
    func bounceAnimation(_ controller:BounceAnimationController,nodeTapped node: Node)
}

extension BounceAnimationDelegate{
    func bounceAnimation(_ controller: BounceAnimationController, launchedWithVelocity velocity: CGPoint, from point: CGPoint){}
    
    func bounceAnimation(_ controller: BounceAnimationController, actionNode: Node, collidedTo targetNode: Node, with behaivor: UICollisionBehavior, at point: CGPoint){}
    
    func bounceAnimation(_ controller: BounceAnimationController, targetNode: Node, collidedTo targetNode2: Node, with behaivor: UICollisionBehavior, at point: CGPoint){}

    func bounceAnimation(_ controller: BounceAnimationController, startedToMove recognizer: UIPanGestureRecognizer){}
    
    func bounceAnimation(_ controller: BounceAnimationController, endMove recognizer: UIPanGestureRecognizer){}
    
    func bounceAnimation(_ controller: BounceAnimationController, recognizer: UIPanGestureRecognizer, didMoveTo positon: CGPoint){}
    
    func bounceAnimation(_ controller:BounceAnimationController, firstTap recognizer: UITapGestureRecognizer, at position: CGPoint){}
 
    func bounceAnimation(_ controller:BounceAnimationController,secondTap recognizer: UITapGestureRecognizer,  at position: CGPoint){}
    
    func bounceAnimation(_ controller:BounceAnimationController,nodeTapped node: Node){}
}
