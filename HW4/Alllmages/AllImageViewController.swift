//
//  AllImageViewController.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 24.12.2020.
//

import UIKit
import SwiftyJSON
import Kingfisher

class AllImageViewController: UIViewController {
    
    private let vkService = VKServices()
    public var photos = [Photo]()
    
    @IBOutlet weak var friendImageView: UIImageView!
    
//    var imageNames = [String](Friends.allFriends.keys)
    var index = 0
    var swImg = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vkService.getPhotos() { [weak self] photos, error in
            if let error = error {
                print(error)
                return
            } else if let photos = photos, let self = self {
                self.photos = photos
                
                DispatchQueue.main.async {
                    self.swImg.frame = UIScreen.main.bounds
                    self.swImg.contentMode = .scaleAspectFit
                    self.swImg.kf.setImage(with: URL(string: photos[self.index].url))
                    self.view.addSubview(self.swImg)
                    self.view.backgroundColor = UIColor.darkGray
                    self.friendImageView.contentMode = .scaleAspectFit
                    self.friendImageView.backgroundColor = Data.background
                }
                
            }
        }
    }
    
    @IBAction func back() {
        Data.clearCookies()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
//                if index == imageNames.count - 1 {
                if index == photos.count - 1 {
                    index = 0
                } else {
                    index += 1
                }
//                friendImageView.image = UIImage(named: imageNames[index])
                friendImageView.kf.setImage(with: URL(string: photos[index].url))
                swipeLeft()
                
            case UISwipeGestureRecognizer.Direction.right:
                if index == 0 {
                    index = photos.count - 1
                } else {
                    index -= 1
                }
//                friendImageView.image = UIImage(named: imageNames[index])
                friendImageView.kf.setImage(with: URL(string: photos[index].url))
//                print(imageNames[index])
                swipeRight()
                
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func swipeLeft() {
        UIView.animateKeyframes(withDuration: 0.8,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                                        self.swImg.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                                        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                                        opacityAnimation.fromValue = 1
                                        opacityAnimation.toValue = 0
                                        opacityAnimation.duration = 0.8
                                        self.swImg.layer.add(opacityAnimation, forKey: nil)
                                        
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.4,
                                                       relativeDuration: 0.8, animations: {
                                                        self.swImg.alpha = 0
                                                        let animation = CABasicAnimation(keyPath: "position.x")
                                                        animation.fromValue = self.friendImageView.layer.bounds.origin.x + 800
                                                        animation.toValue =  self.friendImageView.layer.bounds.origin.x
                                                        animation.duration = 0.8
                                                        self.friendImageView.layer.add(animation, forKey: nil)
                                                        
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 1,
                                                       relativeDuration: 0.04,
                                                       animations: {
                                                        
                                    })
                                    
        }, completion: {[weak self] finished in
//            self!.swImg.image = UIImage(named: self!.imageNames[self!.index])
            self!.swImg.kf.setImage(with: URL(string: self!.photos[self!.index].url))
            self!.swImg.transform = .identity})
    }
    
    private func swipeRight() {
        UIView.animateKeyframes(withDuration: 0.8,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        
                                                        let animation = CABasicAnimation(keyPath: "position.x")
                                                        animation.fromValue = self.swImg.layer.bounds.origin.x
                                                        animation.toValue = self.swImg.layer.bounds.origin.x + 800
                                                        animation.duration = 0.6
                                                        self.swImg.layer.add(animation, forKey: nil)
                                                        
                                                        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                                                        opacityAnimation.fromValue = 0
                                                        opacityAnimation.toValue = 1
                                                        opacityAnimation.duration = 0.6
                                                        self.swImg.layer.add(opacityAnimation, forKey: nil)
                                                        
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.4,
                                                       relativeDuration: 0.8,
                                                       animations: {
                                                        //
                                                        let animation = CABasicAnimation(keyPath: "transform.scale")
                                                        animation.fromValue = 0.4
                                                        animation.toValue = 1
                                                        animation.duration = 0.8
                                                        self.friendImageView.layer.add(animation, forKey: nil)
                                                        
                                    })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 1,
                                                       relativeDuration: 0.04,
                                                       animations: {
                                                        
                                    })
                                    
        }, completion: {[weak self] finished in
            var counter: Int {
                if self!.index == self!.photos.count - 1 {return 0}
                else {return self!.index + 1}
            }
            self!.swImg.kf.setImage(with: URL(string: self!.photos[counter].url))
//            self!.swImg.image = UIImage(named: self!.photos[counter])
            self!.swImg.transform = .identity
            
        })
    }
}

