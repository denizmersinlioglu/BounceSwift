//
//  TargetListViewController.swift
//  SwiftBounce
//
//  Created by Deniz Mersinlioğlu on 25.11.2018.
//

import UIKit

@available(iOS 9.0, *)
public class TargetListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    let cellId = "cellId"
    public var buttonColor: UIColor = .blue
    public var targetInfoArray = [TargetInfo]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kapat", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .white
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(dismissFormSheet), for: .touchUpInside)
        return button
    }()
    
    let tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .plain)
        return tv
    }()
   
    override public func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outsideTap))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        let maximumHeight = 510 * heightRatio
        let height = (CGFloat(targetInfoArray.count * 68) + CGFloat(60))
        let expectedHeight:CGFloat = min(height,maximumHeight)
        let constraintLenght = (UIScreen.main.bounds.height - expectedHeight) / 2
        let constraintWidth = widthRatio * 48
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.isOpaque = false
    
        tableView.sectionHeaderHeight = 1
        tableView.sectionFooterHeight = 1
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TargetListCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        view.addSubview(closeButton)
        closeButton.backgroundColor = buttonColor
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: constraintWidth).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constraintLenght).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -constraintWidth).isActive = true
        
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: constraintWidth).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: constraintLenght).isActive = true
        tableView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -constraintWidth).isActive = true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    @objc func outsideTap(){
        dismissFormSheet()
    }
    
    @objc func dismissFormSheet(){
        dismiss(animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetInfoArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TargetListCell
        cell!.targetInfo = targetInfoArray[indexPath.row]
        return cell!
    }
    
    override public var modalTransitionStyle: UIModalTransitionStyle{
        get { return .crossDissolve }
        set { super.modalTransitionStyle = newValue }
    }
    
    override public var modalPresentationStyle: UIModalPresentationStyle{
        get { return .overCurrentContext }
        set { super.modalPresentationStyle = newValue }
    }
}
