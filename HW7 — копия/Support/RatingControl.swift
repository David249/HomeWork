//
//  RatingControl.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 16.12.2020.
//

import UIKit

@IBDesignable class RatingControl: UIControl {

    private let width: CGFloat = 32.0
    private let height: CGFloat = 32.0
    private let margin: CGFloat = 2.0
    
    private var counter: Int = 0
    private var sceneView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 32)))
    
    private var buttonLike = UIButton(type: .custom)
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32.0)
        label.text = String(counter)
        return label
    }()
    
    private var isLiked = false {
        didSet {
            counterLabel.text = String(counter)
            if oldValue == false {
                counterLabel.textColor = UIColor.red
            } else {
                counterLabel.textColor = UIColor.darkGray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        buttonLike.setImage(UIImage(named: isLiked == true ? "liked" : "notLiked"), for: .normal)
        buttonLike.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        
        sceneView.backgroundColor = .yellow
        
        self.addSubview(sceneView)
        
        self.sceneView.addSubview(buttonLike)
        self.sceneView.addSubview(counterLabel)
    }
    
    @objc func likeAction() {
        if (counter == 0 && !isLiked) {
            counter += 1
            self.isLiked = true
        } else if (counter > 0 && isLiked){
            counter -= 1
            self.isLiked = false
        } else {
            counter = isLiked == true ? counter + 1 : counter - 1
        }
        self.setupView()
        print("Counter == \(counter) status = \(isLiked)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sceneView.frame = bounds
        buttonLike.frame = CGRect(origin: .zero, size: CGSize(width: self.width + margin * 2, height: self.height))
        counterLabel.frame = CGRect(x: buttonLike.frame.width, y: 0, width: self.width + margin, height: self.height)
    }
    
    
}
