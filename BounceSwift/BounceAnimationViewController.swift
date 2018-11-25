//
//  MainViewController.swift
//  SwiftBounce
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

@available(iOS 9.0, *)
class BounceAnimationViewController: UIViewController, BounceAnimationDelegate{

    let targetInfo : [TargetInfo] = [TargetInfo(name: "Rihanna", info: "\(309.34)", image: #imageLiteral(resourceName: "rihanna")),
                                     TargetInfo(name: "Leonardo", info: "\(23)", image: #imageLiteral(resourceName: "dicaprio")),
                                     TargetInfo(name: "Orlando", info: "\(332.24)", image: #imageLiteral(resourceName: "orlando")),
                                     TargetInfo(name: "Nick", info: "\(332.24)", image: #imageLiteral(resourceName: "icon_contactbook")),
                                     TargetInfo(name: "Levis", info: "\(332.24)", image: #imageLiteral(resourceName: "icon_contactbook")),
                                     TargetInfo(name: "Michael", info: "\(332.24)", image: #imageLiteral(resourceName: "icon_contactbook")),
                                     TargetInfo(name: "Sam", info: "\(332.24)", image: #imageLiteral(resourceName: "icon_contactbook")),
                                     TargetInfo(name: "Deniz", info: "\(332.24)", image: #imageLiteral(resourceName: "icon_contactbook"))]
    
    
    let colorScheme = ColorScheme(backgroundFillColor: .bounceLightBlue,
                                  foregroundFillColor: .bounceMidBlue,
                                  actionNodeFillColor: .bounceOrange,
                                  actionNodeStrokeColor: .bounceLightBlue,
                                  targetNodeFillColor: .bounceBlue,
                                  targetNodeStrokeColor: .bounceDarkBlue,
                                  targetNodeTextColor: .bounceDarkBlue)
    
    @objc func popBack(){
        self.navigationController?.popViewController(animated: true)
    }
    var isActive = false
    var fadeInDuration: TimeInterval = 1
    var delegate: BounceAnimationDelegate!
    
    private var bounceAnimationController: BounceAnimationController!
    private var bottomConstraint: NSLayoutConstraint!
    
    lazy var completionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Completed", for: .normal)
        button.backgroundColor = colorScheme.foregroundFillColor
        button.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        return button
    }()
    
    lazy var resultImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_swift")?.withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    lazy var resultHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.text = "Done!"
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var resultDetail: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var resultView: UIStackView = {
        let resultStack = UIStackView(arrangedSubviews: [resultImageView, resultHeader, resultDetail])
        resultStack.alignment = .center
        resultStack.axis = .vertical
        resultStack.distribution = .equalSpacing
        resultStack.spacing = 18
        view.addSubview(resultStack)
        resultStack.translatesAutoresizingMaskIntoConstraints = false
        resultStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        resultStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        resultImageView.translatesAutoresizingMaskIntoConstraints = false
        resultImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        resultImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        resultDetail.text = "Congratulations! Your Bounce Swift animation is done! "
        resultImageView.tintColor = colorScheme.foregroundFillColor
        return resultStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        view.backgroundColor = .bounceLightBlue
        setupBounceAnimationViewController()
        setupConfirmationButton()
        resultView.alpha = 0
        completionButton.alpha = 0
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = colorScheme.foregroundFillColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        completionButton.backgroundColor  = .bounceDarkBlue
        navigationController?.isNavigationBarHidden = true
    }

    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showResultView(duration: TimeInterval, completion: (() -> ())?){
        bounceAnimationController.simulateResultAnimation {
            self.fadeInResultViews(duration: self.fadeInDuration)
            self.showBottomCompletionView(duration: self.fadeInDuration )
            guard let completion = completion else {return}
            completion()
        }
    }
    
    fileprivate func showBottomCompletionView(duration: TimeInterval){
        self.bottomConstraint.constant = -60
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func fadeInResultViews(duration: TimeInterval){
        UIView.animate(withDuration: 1) {
            self.resultView.alpha = 1
            self.completionButton.alpha = 1
        }
    }

    fileprivate func setupConfirmationButton(){
        view.addSubview(completionButton)
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        completionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        completionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        completionButton.topAnchor.constraint(equalTo: bounceAnimationController.view.bottomAnchor, constant: 0).isActive = true
        completionButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    fileprivate func setupBounceAnimationViewController(){
        let margins = view.layoutMarginsGuide
        bounceAnimationController = BounceAnimationController(colorScheme: colorScheme, targetInfo: targetInfo, delegate: delegate, actionNodeTitle: "Bounce", transactionSummary: NSAttributedString(string:"Summary"), transactionDescription: NSAttributedString(string: "Header"))
        addChild(bounceAnimationController)
        view.addSubview(bounceAnimationController.view)
        bounceAnimationController.view.translatesAutoresizingMaskIntoConstraints = false
        bounceAnimationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bounceAnimationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bounceAnimationController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        bottomConstraint = bounceAnimationController.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0)
        bottomConstraint.isActive = true
        bounceAnimationController.didMove(toParent: self)
        
    }
    
    func bounceAnimation(_ controller: BounceAnimationController, nodeTapped node: Node) {
        print(node.description)
    }
    
    func bounceAnimation(_ controller: BounceAnimationController, launchedWithVelocity velocity: CGPoint, from point: CGPoint) {
        self.isActive = true
        print("Action Node launched with velocity: \(velocity) from: \(point) ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.isActive = false
            self.showResultView(duration: 1, completion: {
                print("Done")
            })
        }
    }
    
    func bounceAnimation(_ controller: BounceAnimationController, actionNode: Node, collidedTo targetNode: Node, with behaivor: UICollisionBehavior, at point: CGPoint) {
        guard isActive else {return}
        targetNode.increaseCollisionCount()
    }
}
