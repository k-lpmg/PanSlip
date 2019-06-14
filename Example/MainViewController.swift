//
//  MainViewController.swift
//  Example
//
//  Created by DongHeeKang on 12/06/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import PanSlip

final class MainViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum PresentType {
        case viewController
        case view
    }
    
    // MARK: - UI Components
    
    private let viewControllerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("PanSlip to UIViewController", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 23)
        return button
    }()
    private let viewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("PanSlip to UIView", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 23)
        return button
    }()
    
    // MARK: - Overridden: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProperties()
        setSelector()
        view.addSubview(viewControllerButton)
        view.addSubview(viewButton)
        layout()
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        view.backgroundColor = .white
    }
    
    private func setSelector() {
        viewControllerButton.addTarget(self, action: #selector(viewControllerButtonClicked), for: .touchUpInside)
        viewButton.addTarget(self, action: #selector(viewButtonClicked), for: .touchUpInside)
    }
    
    private func presentAlert(with type: PresentType) {
        let alertController = UIAlertController()
        PanSlipDirection.allCases.forEach({ (direction) in
            var title: String? = nil
            switch direction {
            case .leftToRight:
                title = "left to right"
            case .righTotLeft:
                title = "right to left"
            case .topToBottom:
                title = "top to bottom"
            case .bottomToTop:
                title = "bottom to top"
            }
            
            guard title != nil else {return}
            alertController.addAction(UIAlertAction(title: title, style: .default) { _ in
                switch type {
                case .viewController:
                    self.presentGestureDismissUIViewController(with: direction)
                case .view:
                    self.addSubviewGestureDismissUIView(with: direction)
                }
            })
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func presentGestureDismissUIViewController(with direction: PanSlipDirection) {
        let targetViewController = UIViewController()
        targetViewController.view.backgroundColor = .blue
        
        targetViewController.enablePanSlip(direction: direction, percentThreshold: 0.7) {
            print("PanSlip UIView completion")
        }
        
        present(targetViewController, animated: true)
    }
    
    private func addSubviewGestureDismissUIView(with direction: PanSlipDirection) {
        let targetView = UIView()
        targetView.frame = view.frame
        targetView.backgroundColor = .purple
        
        targetView.enablePanSlip(direction: direction, percentThreshold: 0.7) {
            print("PanSlip UIView completion")
        }
        
        view.addSubview(targetView)
    }
    
    // MARK: - Private selector
    
    @objc private func viewControllerButtonClicked() {
        presentAlert(with: .viewController)
    }
    
    @objc private func viewButtonClicked() {
        presentAlert(with: .view)
    }
    
}

// MARK: - Layout

extension MainViewController {
    
    private func layout() {
        viewControllerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewControllerButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 64).isActive = true
        
        viewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewButton.topAnchor.constraint(equalTo: viewControllerButton.bottomAnchor, constant: 32).isActive = true
    }
    
}
