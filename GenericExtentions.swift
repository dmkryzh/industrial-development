//
//  GenericExtentions.swift
//  Navigation
//
//  Created by Dmitrii KRY on 15.05.2021.
//

import Foundation
import UIKit
import CoreData

extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}

extension UITextField {
    func addInternalPaddings(left: CGFloat, right: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: left, height: self.frame.height))
        self.rightView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: right, height: self.frame.height))
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
}

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension NSManagedObjectContext {
    /// Only performs a save if there are changes to commit.
    public func saveIfNeeded() throws {
        guard hasChanges else { return }
        try save()
    }
}

extension UIColor {
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
        
    }
}
