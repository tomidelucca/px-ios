//
//  MPLayout.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/18/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class MPLayout: NSObject {

    //Altura fija
    static func setHeight(owner: UIView, height: CGFloat ) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: owner, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
    }

    //Ancho fijo
    static func setWidth(owner: UIView, width: CGFloat ) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: owner, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
    }

    // Pin Left
    static func pinLeft(view: UIView, to otherView: UIView, withMargin margin: CGFloat = 0 ) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: otherView, attribute: .leading, multiplier: 1, constant: margin)
    }
    //Pin Right
    static func pinRight(view: UIView, to otherView: UIView, withMargin margin: CGFloat = 0 ) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: otherView, attribute: .trailing, multiplier: 1, constant: -margin)
    }
    //Pin Top
    static func pinTop(view: UIView, to otherView: UIView, withMargin margin: CGFloat = 0 ) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: otherView, attribute: .top, multiplier: 1, constant: margin)
    }
    //Pin Bottom
    static func pinBottom(view: UIView, to otherView: UIView, withMargin margin: CGFloat = 0 ) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: otherView, attribute: .bottom, multiplier: 1, constant: -margin)
    }

    //Vista 1 abajo de vista 2
    static func put(view: UIView, onBottomOf view2: UIView, withMargin margin: CGFloat = 0) -> NSLayoutConstraint {
        return  NSLayoutConstraint(
            item: view,
            attribute: .top,
            relatedBy: .equal,
            toItem: view2,
            attribute: .bottom,
            multiplier: 1.0,
            constant: margin
        )
    }
    //Vista 1 arriba de vista 2
    static func put(view: UIView, aboveOf view2: UIView, withMargin margin: CGFloat = 0) -> NSLayoutConstraint {
        return  NSLayoutConstraint(
            item: view,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view2,
            attribute: .top,
            multiplier: 1.0,
            constant: margin
        )
    }

    //Centrado horizontal
    static func centerHorizontally(view: UIView, to container: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0)
    }

    //Centrado Vertical
    static func centerVertically(view: UIView, into container: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
    }

    static func equalizeHeight(view: UIView, to otherView: UIView) -> NSLayoutConstraint {
         return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: otherView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0)
    }

    static func equalizeWidth(view: UIView, to otherView: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: otherView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0)
    }

    static func setHeight(ofView view: UIView, asHeightOfView otherView: UIView, percent: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: otherView, attribute: NSLayoutAttribute.height, multiplier: percent / 100, constant: 0)
    }

    static func setWidth(ofView view: UIView, asWidthOfView otherView: UIView, percent: CGFloat = 100) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: otherView, attribute: NSLayoutAttribute.width, multiplier: percent / 100, constant: 0)
    }

}

class ClosureSleeve {
    let closure: ()->Void

    init (_ closure: @escaping ()->Void) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func add (for controlEvents: UIControlEvents, _ closure: @escaping ()->Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
