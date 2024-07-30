//
//  UIViewExtension.swift
//  synex
//
//  Created by Ritesh chopra on 01/09/23.
//

import Foundation
import UIKit

//MARK: - IBInspectable

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIView {
    
    //MARK: - add Shadow

    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) -> CAShapeLayer {

           let shadowLayer = CAShapeLayer()
           let size = CGSize(width: cornerRadius, height: cornerRadius)
           let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
           shadowLayer.path = cgPath //2
           shadowLayer.fillColor = fillColor.cgColor //3
           shadowLayer.shadowColor = shadowColor.cgColor //4
           shadowLayer.shadowPath = cgPath
           shadowLayer.shadowOffset = offSet //5
           shadowLayer.shadowOpacity = opacity
           shadowLayer.shadowRadius = shadowRadius
           self.layer.insertSublayer(shadowLayer, at: 0)
           return shadowLayer
       }
    
    //MARK: - Height half

    var half: CGFloat {
        return self.frame.height/2
    }
    
    //MARK: - set corner , borderColor, borderWidth

    func set(radius: CGFloat, borderColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0.0) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    //MARK: - fade In Animation

    func fadeIn(duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    //MARK: - fade Out Animation

    func fadeOut(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}


extension UIView
{

    func roundSelectedCornerss(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
  
    
    func applyGradientLayer(colors:Array<CGColor>, startPoint:CGPoint = CGPoint(x: 0, y: 0), endPoint:CGPoint = CGPoint(x: 1, y: 1), locations: [NSNumber]? = nil) -> CAGradientLayer{
        
        let layer0 = CAGradientLayer()
        layer0.colors = colors
        layer0.startPoint = startPoint
        layer0.endPoint = endPoint
        layer0.locations = locations
        layer0.frame = self.bounds
        self.layer.insertSublayer(layer0, at: 0)
        return layer0
    }

}


