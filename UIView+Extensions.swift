
extension UIView {
    
    /// Configure a UIView to completely fill its parent, minus any edge insets
    ///
    /// - Parameters:
    ///   - parent: the UIView that the view should fill
    ///   - edgeInsets: the amounts around each edge to inset the view by
    func autolayoutFill(parent: UIView, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: edgeInsets.left),
            self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -edgeInsets.right),
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: edgeInsets.top),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -edgeInsets.bottom)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    /// Configure a UIView to be centered in its parent
    ///
    /// - Parameter parent: the parent to center it in
    func autolayoutCenter(in parent: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
    }
    
    
    /// Configure a UIView to completely fill a layout guide, minus any edge insets
    ///
    /// - Parameters:
    ///   - parent: the UIView that the view should fill
    ///   - edgeInsets: the amounts around each edge to inset the view by
    func autolayoutFill(layoutGuide: UILayoutGuide, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: edgeInsets.left),
            self.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: -edgeInsets.right),
            self.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: edgeInsets.top),
            self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -edgeInsets.bottom)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    /// Configure a UIView to be centered in a layout guide
    ///
    /// - Parameter parent: the parent to center it in
    func autolayoutCenter(in layoutGuide: UILayoutGuide) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
    }
    
    
    /// Moves the view to fill a different layout guide, animating (with a cross fade) if requested
    ///
    /// - Parameters:
    ///   - layoutGuide: The layout guide to appear in
    ///   - edgeInsets: the edge insets to use for the layout (default .zero)
    ///   - animationDuration: The duration (default nil, no animation)
    func moveToFill(layoutGuide:UILayoutGuide, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero, animationDuration: TimeInterval? = nil) {
        
        if let animationDuration = animationDuration {
            
            let animator = UIViewPropertyAnimator(duration: animationDuration / 2.0, curve: .easeIn, animations: {
                self.alpha = 0
            })
            animator.addCompletion({ _ in
                let parent = self.superview
                self.removeFromSuperview()
                parent?.addSubview(self)
                self.autolayoutFill(layoutGuide: layoutGuide, edgeInsets: edgeInsets)
                let secondAnimator = UIViewPropertyAnimator(duration: animationDuration / 2.0, curve: .easeOut, animations: {
                    self.alpha = 1.0
                })
                secondAnimator.startAnimation()
            })
            animator.startAnimation()
            
        } else {
            let parent = self.superview
            removeFromSuperview()
            parent?.addSubview(self)
            self.autolayoutFill(layoutGuide: layoutGuide, edgeInsets: edgeInsets)
        }
        
    }
    
    /// Fade out, then remove from superview
    ///
    /// - Parameter animationDuration: the duration of the animation
    func fadeOutAndRemoveFromSuperview(animationDuration: TimeInterval?, completion: (() -> ())? = nil){
        
        guard animationDuration != nil else {
            removeFromSuperview()
            return
        }
        
        let animator = UIViewPropertyAnimator(duration: animationDuration ?? 0, curve: .easeIn, animations:{ self.alpha = 0})
        animator.addCompletion({_ in
            self.removeFromSuperview()
            completion?()
        })
        animator.startAnimation()
    }
    
    /// Sets the alpha of this view to 0, then fades it in while having it fill the specified layout guide
    ///
    /// - Parameters:
    ///   - parent: the UIView to add this as a subview of
    ///   - layoutGuide: the layout guide to fill
    ///   - edgeInsets: the edge insets to use for filling
    ///   - animationDuration: the duration of the fade
    func fadeInto(parent: UIView, layoutGuide: UILayoutGuide, edgeInsets: UIEdgeInsets = .zero, animationDuration:TimeInterval?, completion: (() -> ())? = nil) {
        
        parent.addSubview(self)
        autolayoutFill(layoutGuide: layoutGuide, edgeInsets: edgeInsets)
        
        guard animationDuration != nil else {
            return
        }
        
        alpha = 0
        let animator = UIViewPropertyAnimator(duration: 0.15, curve: .easeIn, animations: {
            self.alpha = 1
        })
        animator.addCompletion({ _ in
            completion?()
        })
        animator.startAnimation()
    }
    
}

extension UIView {
    
    func roundCorners(_ corner: UIRectCorner,_ radii: CGFloat) {
        if corner.isEmpty {
            self.layer.mask = nil
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.layer.bounds
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii)).cgPath
        
        self.layer.mask = maskLayer
        layer.masksToBounds = true
    }
    
}




//  Created by Austin Fitzpatrick on 3/31/18.

struct Shadow {
    var color: CGColor?
    var radius: CGFloat
    var offset: CGSize
    var opacity: Float
}

extension Shadow {
    static let faintBottomRight = Shadow(color: UIColor.black.cgColor, radius: 0, offset: CGSize(width: 1, height: 1), opacity: 0.15)
    static let bottomRight = Shadow(color: UIColor.black.cgColor, radius: 0, offset: CGSize(width: 1, height: 0.5), opacity: 0.5)
    static let boldBottom = Shadow(color: UIColor.black.cgColor, radius: 4, offset: CGSize(width: 0, height: 2), opacity: 0.5)
    static let greenGlow = Shadow(color: UIColor(sketch: (85, 254, 219)).cgColor, radius: 16, offset: CGSize(width: 0, height: 9), opacity: 0.3)
    static let purpleGlow = Shadow(color: UIColor(sketch:(104, 0, 255)).cgColor, radius: 4, offset: CGSize(width:0, height:2), opacity:0.3)
}

extension UIView {
    
    var shadow:Shadow {
        get {
            return Shadow(color: layer.shadowColor, radius: layer.shadowRadius, offset: layer.shadowOffset, opacity: layer.shadowOpacity)
        }
        set {
            layer.shadowColor = newValue.color
            layer.shadowRadius = newValue.radius
            layer.shadowOffset = newValue.offset
            layer.shadowOpacity = newValue.opacity
        }
    }
    
}
