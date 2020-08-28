import UIKit
//
//  FadingEdgeScrollView.swift
//
//  Created by yokoyamark on 2020/08/27
//  Copyright © 2020 yokoyamark. All rights reserved.
//

@IBDesignable
/// UIScrollView with edge fading
open class FadingEdgeScrollView: UIScrollView {
    @IBInspectable public var isFadeTop: Bool = true
    
    @IBInspectable public var isFadeBottom: Bool = true
    
    @IBInspectable public var fadingEdgeSize: CGFloat = 50.0
    
    private fadeTop: Bool = true
    private fadeBottom: Bool = true
    private fadeSize: CGFloat = 50.0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.fadeSize = self.fadingEdgeSize
        self.fadeTop = self.isFadeTop
        self.fadeBottom = self.isFadeBottom
        self.check()
        self.delegate = self
    }

    private func check() {
        // scroll量が0のとき
        if !self.isFadeTop || self.contentOffset.y == 0 {
            self.fadeTop = false
        } else {
            self.fadeTop = true
        }
        // scroll量 + 画面高さ >= scrollコンテンツ高さ
        if !self.isFadeBottom || (self.contentOffset.y + self.bounds.height) >= self.contentSize.height {
            self.fadeBottom = false
        } else {
            self.fadeBottom = true
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.check()

        if self.fadeTop || self.fadeBottom {
            let maskLayer = CALayer()
            maskLayer.frame = self.bounds
            
            let solidLayer = CALayer()
            solidLayer.backgroundColor = UIColor.black.cgColor
            var solidRect = CGRect.zero
            solidRect.origin.x = self.contentOffset.x
            solidRect.size = self.bounds.size
            if self.fadeTop {
                solidRect.origin.y = fadeSize
            }
            if self.fadeBottom {
                solidRect.size.height = solidRect.size.height - (solidRect.origin.y + fadeSize)
            }
            
            solidLayer.frame = solidRect
            maskLayer.addSublayer(solidLayer)
            
            if self.fadeTop {
                let topLayer = CAGradientLayer()
                topLayer.frame = CGRect(x: self.contentOffset.x, y: 0, width: self.bounds.width, height: fadeSize)
                topLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
                topLayer.startPoint = CGPoint.zero
                topLayer.endPoint = CGPoint(x: 0, y: 1)
                maskLayer.addSublayer(topLayer)
            }
            
            if self.fadeBottom {
                let bottomLayer = CAGradientLayer()
                bottomLayer.frame = CGRect(x: self.contentOffset.x, y: self.bounds.height - fadeSize, width: self.bounds.width, height: fadeSize)
                bottomLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
                bottomLayer.startPoint = CGPoint.zero
                bottomLayer.endPoint = CGPoint(x: 0, y: 1)
                maskLayer.addSublayer(bottomLayer)
            }
            
            self.layer.mask = maskLayer
        } else {
            self.layer.mask = nil
        }
    }
}

extension FadingEdgeScrollView: UIScrollViewDelegate {
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerated: Bool) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}

