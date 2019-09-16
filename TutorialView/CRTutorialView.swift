//
//  CRTutorialView.swift
//  TutorialView
//
//  Created by Konstantin Nazarenko on 9/4/19.
//  Copyright © 2019 Konstantin Nazarenko. All rights reserved.
//

import UIKit

class CRTutorialView: UIView {

    enum Part {
        case targets([UIView])
        case hints([String])
        case cornerRadius(CGFloat)
        case hintCornerRadius(CGFloat)
        case borderColor(UIColor)
        case borderWidth(CGFloat)
        case animationDuration(CFTimeInterval)
        case textColor(UIColor)
        case titleFont(UIFont)
        case buttonsFont(UIFont)
        case opacity(Float)
        case title(String)
        case closeText(String)
        case backText(String)
        case nextText(String)
        case hintColor(UIColor)
    }
    
    class HintView: UIView {
        enum HintPosition {
            case top
            case right
            case bottom
            case left
        }
        
        public var hintTextView: UITextView!
        private var position: HintPosition = .top {
            didSet {
                setupBezier()
            }
        }
        private var arrowCenter = CGPoint.zero
        public var arrowLength: CGFloat = 6
        
        public var cornerRadius: CGFloat = 4
        
        override class var layerClass: AnyClass {
            return CAShapeLayer.self
        }
        
        override init(frame rect: CGRect) {
            super.init(frame: rect)
            hintTextView = UITextView()
            hintTextView.textAlignment = .center
            hintTextView.isSelectable = false
            hintTextView.backgroundColor = .clear
            hintTextView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(hintTextView)
            NSLayoutConstraint.activate([
                hintTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
                hintTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                hintTextView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
                hintTextView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
                ])
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("required init?(coder aDecoder: NSCoder) must not be used")
        }
        
        public func setupHint(with type: HintPosition, text: String, rect: CGRect, arrowCenter: CGPoint) {
            frame = rect
            self.arrowCenter = arrowCenter
            hintTextView.text = text
            hintTextView.sizeToFit()
            position = type
        }
        
        func setupBezier() {
            guard let layer = layer as? CAShapeLayer else { return }
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: cornerRadius + arrowLength, y: frame.height - arrowLength))
            path.addArc(withCenter: CGPoint(x: cornerRadius + arrowLength, y: frame.height - cornerRadius - arrowLength),
                radius: cornerRadius,
                startAngle: .pi/2,
                endAngle: .pi,
                clockwise: true)
            if position == .right {
                path.addLine(to: CGPoint(x: arrowLength, y: frame.height / 2 - arrowLength))
                path.addLine(to: CGPoint(x: 0, y: frame.height / 2 - 1))
                path.addLine(to: CGPoint(x: 0, y: frame.height / 2 + 1))
                path.addLine(to: CGPoint(x: arrowLength, y: frame.height / 2 + arrowLength))
            }
            path.addLine(to: CGPoint(x: arrowLength, y: cornerRadius + arrowLength))
            path.addArc(withCenter: CGPoint(x: cornerRadius + arrowLength, y: cornerRadius + arrowLength),
                        radius: cornerRadius,
                        startAngle: .pi,
                        endAngle: .pi/2*3,
                        clockwise: true)
            if position == .bottom {
                path.addLine(to: CGPoint(x: arrowCenter.x - arrowLength, y: arrowLength))
                path.addLine(to: CGPoint(x: arrowCenter.x - 1, y: 0))
                path.addLine(to: CGPoint(x: arrowCenter.x + 1, y: 0))
                path.addLine(to: CGPoint(x: arrowCenter.x + arrowLength, y: arrowLength))
            }
            path.addLine(to: CGPoint(x: frame.width - cornerRadius, y: arrowLength))
            path.addArc(withCenter: CGPoint(x: frame.width - cornerRadius - arrowLength, y: cornerRadius + arrowLength),
                        radius: cornerRadius,
                        startAngle: .pi/2*3,
                        endAngle: 0,
                        clockwise: true)
            if position == .left {
                path.addLine(to: CGPoint(x: frame.width - arrowLength, y: frame.height / 2 - arrowLength))
                path.addLine(to: CGPoint(x: frame.width, y: frame.height / 2 - 1))
                path.addLine(to: CGPoint(x: frame.width, y: frame.height / 2 + 1))
                path.addLine(to: CGPoint(x: frame.width - arrowLength, y: frame.height / 2 + arrowLength))
            }
            path.addLine(to: CGPoint(x: frame.width - arrowLength, y: frame.height - cornerRadius - arrowLength))
            path.addArc(withCenter: CGPoint(x: frame.width - cornerRadius - arrowLength, y: frame.height - cornerRadius - arrowLength),
                        radius: cornerRadius,
                        startAngle: 0,
                        endAngle: .pi/2,
                        clockwise: true)
            if position == .top {
                path.addLine(to: CGPoint(x: arrowCenter.x + arrowLength, y: frame.height - arrowLength))
                path.addLine(to: CGPoint(x: arrowCenter.x + 1, y: frame.height))
                path.addLine(to: CGPoint(x: arrowCenter.x - 1, y: frame.height))
                path.addLine(to: CGPoint(x: arrowCenter.x - arrowLength, y: frame.height - arrowLength))
            }
            path.addLine(to: CGPoint(x: cornerRadius + arrowLength, y: frame.height - arrowLength))
            path.close()
            layer.path = path.cgPath
        }
    }
    
    private var currentStep = 0 {
        didSet {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.backButton.alpha = self.currentStep == 0 ? 0 : 1
                self.nextButton.alpha = self.currentStep == self.targets.count - 1 ? 0 : 1
                self.pageControl.currentPage = self.currentStep
            }
        }
    }
    
    // MARK: - Customized properties
    
    private var targets: [CGRect] = []
    private var hints: [String] = []
    private var cornerRadius: CGFloat = 2
    private var hintCornerRadius: CGFloat = 4
    private var borderColor: UIColor = UIColor(red: 84/255.0, green: 167/255.0, blue: 242/255.0, alpha: 1)
    private var borderWidth: CGFloat = 2
    private var animationDuration: CFTimeInterval = 0.5
    private var textColor: UIColor = .white
    private var titleFont: UIFont = UIFont.systemFont(ofSize: 20)
    private var buttonsFont: UIFont = UIFont.systemFont(ofSize: 18)
    private var opacity: Float = 0.95
    private var title: String = "Check In Tour"
    private var closeText: String = "CLOSE"
    private var backText: String = "BACK"
    private var nextText: String = "NEXT"
    private var hintColor: UIColor = UIColor(red: 84/255.0, green: 167/255.0, blue: 242/255.0, alpha: 1)
    
    // MARK: - subviews
    
    var presentationWindow = UIWindow(frame: UIScreen.main.bounds)
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    var vibrancyEffect: UIVibrancyEffect!
    var vibrancyEffectView: UIVisualEffectView!
    var borderView: UIView!
    var hintView: HintView!
    var titleLabel: UILabel!
    var closeButton: UIButton!
    var backButton: UIButton!
    var nextButton: UIButton!
    var pageControl: UIPageControl!
    var stackView: UIStackView!
    
    // MARK: - Life cycle
    override init(frame rect: CGRect) {
        super.init(frame: rect)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) must not be used")
    }
    
    // MARK: - Configure
    func configure(_ parts: Part...) {
        for part in parts {
            updateProperty(part)
        }
    }
    
    func updateProperty(_ part: Part) {
        switch part {
        case let .targets(views):
            for view in views {
                targets.append(CGRect(x: view.frame.origin.x - 5,
                                      y: view.frame.origin.y - 5,
                                      width: view.frame.size.width + 10,
                                      height: view.frame.size.height + 10))
            }
            pageControl.numberOfPages = targets.count
        case let .hints(hints):
            self.hints = hints
        case let .cornerRadius(cornerRadius):
            self.borderView.layer.cornerRadius = cornerRadius
            self.cornerRadius = cornerRadius
        case let .hintCornerRadius(hintCornerRadius):
            hintView.cornerRadius = hintCornerRadius
            self.hintCornerRadius = hintCornerRadius
        case let .borderColor(borderColor):
            self.borderView.layer.borderColor = borderColor.cgColor
            self.borderColor = borderColor
        case let .borderWidth(borderWidth):
            self.borderView.layer.borderWidth = borderWidth
            self.borderWidth = borderWidth
        case let .animationDuration(animationDuration):
            self.animationDuration = animationDuration
        case let .textColor(textColor):
            titleLabel.textColor = textColor
            hintView.hintTextView.textColor = textColor
            closeButton.setTitleColor(textColor, for: UIControl.State.normal)
            nextButton.setTitleColor(textColor, for: UIControl.State.normal)
            backButton.setTitleColor(textColor, for: UIControl.State.normal)
            self.textColor = textColor
        case let .titleFont(titleFont):
            titleLabel.font = titleFont
            self.titleFont = titleFont
        case let .buttonsFont(buttonsFont):
            closeButton.titleLabel?.font = buttonsFont
            nextButton.titleLabel?.font = buttonsFont
            backButton.titleLabel?.font = buttonsFont
            self.buttonsFont = buttonsFont
        case let .opacity(opacity):
            blurEffectView.layer.mask!.opacity = opacity
            self.opacity = opacity
        case let .title(title):
            titleLabel.text = title
            self.title = title
        case let .closeText(closeText):
            closeButton.setTitle(closeText, for: .normal)
            self.closeText = closeText
        case let .nextText(nextText):
            nextButton.setTitle(nextText, for: .normal)
            self.nextText = nextText
        case let .backText(backText):
            backButton.setTitle(backText, for: .normal)
            self.backText = backText
        case let .hintColor(hintColor):
            (hintView.layer as! CAShapeLayer).fillColor = hintColor.cgColor
            self.hintColor = hintColor
        }
    }
    
    func setup() {
        //alpha = 0
        setupTapGesture()
        setupSubviews()
    }
    
    private func setupSubviews() {
        blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = frame
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.opacity = opacity
        blurEffectView.layer.mask = maskLayer
        addSubview(blurEffectView)
        
        blurEffectView.effect = nil
        
        hintView = HintView(frame: CGRect(x: 60, y: 60, width: 300, height: 200))
        hintView.hintTextView.font = buttonsFont
        hintView.hintTextView.textColor = textColor
        hintView.cornerRadius = hintCornerRadius
        (hintView.layer as! CAShapeLayer).fillColor = hintColor.cgColor
        hintView.alpha = 0
        addSubview(hintView)
        
        borderView = UIView()
        borderView.layer.cornerRadius = cornerRadius
        borderView.layer.borderColor = borderColor.cgColor
        borderView.layer.borderWidth = borderWidth
        addSubview(borderView)
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = titleFont
        titleLabel.textColor = textColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        closeButton = makeActionButton(with: closeText, and: #selector(closeTapped(_:)))
        vibrancyEffectView.contentView.addSubview(closeButton)
        
        nextButton = makeActionButton(with: nextText, and: #selector(nextTapped(_:)))
        addSubview(nextButton)
        
        backButton = makeActionButton(with: backText, and: #selector(backTapped(_:)))
        backButton.alpha = 0
        addSubview(backButton)
        
        pageControl = UIPageControl()
        
        
        stackView = UIStackView(arrangedSubviews: [backButton, pageControl, nextButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        setupConstraints()
    }
    
    func makeActionButton(with title: String, and selector: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = buttonsFont
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0),
            closeButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            stackView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 0),
            stackView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: 0),
            ])
        let closeHeightConstraint = NSLayoutConstraint(item: closeButton!, attribute: .height, relatedBy: .equal,
                                                           toItem: nil, attribute: .notAnAttribute,
                                                           multiplier: 1.0, constant: 40.0)
        let closeWidthConstraint = NSLayoutConstraint(item: closeButton!, attribute: .width, relatedBy: .equal,
                                                       toItem: nil, attribute: .notAnAttribute,
                                                       multiplier: 1.0, constant: 120.0)

        let stackHeightConstraint = NSLayoutConstraint(item: stackView!, attribute: .height, relatedBy: .equal,
                                                       toItem: nil, attribute: .notAnAttribute,
                                                       multiplier: 1.0, constant: 50.0)
        addConstraints([closeHeightConstraint, closeWidthConstraint, stackHeightConstraint])
    }
    
    // MARK: - Tap gesture
    private func setupTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHandler)))
    }
    
    @objc func tapHandler(sender: UITapGestureRecognizer) {
        showNextStep()
    }
    
    func showNextStep() {
        if currentStep == targets.count - 1 {
            hide()
        } else {
            currentStep = currentStep + 1
            prepareTutorialStep()
        }
    }
    
    //MARK: - Actions
    
    @objc func closeTapped(_ sender: UIButton) {
        hide()
    }
    
    @objc func nextTapped(_ sender: UIButton) {
        showNextStep()
    }
    
    @objc func backTapped(_ sender: UIButton) {
        currentStep = currentStep - 1
        prepareTutorialStep()
    }
    
    // MARK: - Show/hide
    
    func show(animated: Bool = true) {
        presentationWindow.windowLevel = .alert + 1
        UIView.animate(withDuration: 0.7) {[weak self] in
            guard let self = self else { return }
            self.hintView.alpha = 1
            self.borderView.alpha = 1
            self.titleLabel.alpha = 1
            self.stackView.alpha = 1
            self.closeButton.alpha = 1
            self.blurEffectView.effect = self.blurEffect
        }
        let vc = UIViewController()
        vc.view = self
        presentationWindow.rootViewController = vc
        presentationWindow.isHidden = false
        borderView.layer.frame = targets[currentStep]
        layoutSubviews()
        prepareTutorialStep()
    }
    
    func hide() {
        guard let mask = blurEffectView.layer.mask as? CAShapeLayer else { return }
        
        mask.path = UIBezierPath(rect: frame).cgPath
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            self.hintView.alpha = 0
            self.borderView.alpha = 0
            self.titleLabel.alpha = 0
            self.stackView.alpha = 0
            self.closeButton.alpha = 0
        })
        UIView.animate(withDuration: 0.8, animations: { [weak self] in
            guard let self = self else { return }
            self.blurEffectView.effect = nil
            }, completion: { [weak self] _ in
                guard let self = self else { return }
                self.currentStep = 0
                self.targets = []
                self.hints = []
                self.presentationWindow.rootViewController = nil
                self.presentationWindow.isHidden = true
                guard let mask = self.blurEffectView.layer.mask as? CAShapeLayer else { return }
                mask.path = nil
        })
    }
    
    func prepareTutorialStep() {
        guard let mask = blurEffectView.layer.mask as? CAShapeLayer else { return }
        
        self.hintView.alpha = 0

        let path = makeBorderBezierPath()
        addLayerAnimation(to: mask, with: path.cgPath)
        addBorderAnimation(to: borderView.layer, with: targets[currentStep])
        
        makeHintView()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        borderView.layer.frame = targets[currentStep]
        mask.path = path.cgPath
        CATransaction.commit()
    }
    
    func makeBorderBezierPath() -> UIBezierPath {
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        let selectedFramePath = UIBezierPath(roundedRect: targets[currentStep], cornerRadius: cornerRadius)
        path.append(selectedFramePath)
        path.usesEvenOddFillRule = true
        return path
    }

    func makeHintView() {
        var position: HintView.HintPosition = .top
        var arrowCenter = CGPoint.zero
        var hintFrame = CGRect.zero
        let screenFrame = UIScreen.main.bounds
        let tmpTextView = UITextView()
        tmpTextView.font = buttonsFont
        tmpTextView.textAlignment = .center
        let arrowLength = hintView.arrowLength
        let spaceToTop = targets[currentStep].origin.y - (titleLabel.frame.height + titleLabel.frame.origin.y)
        let spaceToBottom = stackView.frame.origin.y - (targets[currentStep].origin.y + targets[currentStep].size.height)
        let spaceToLeft = targets[currentStep].origin.x
        let spaceToRight = screenFrame.size.width - (targets[currentStep].origin.x + targets[currentStep].size.width)
        let biggestHorizontalSpace = spaceToLeft > spaceToRight ? spaceToLeft : spaceToRight
        let biggestVerticalSpace = spaceToTop > spaceToBottom ? spaceToTop : spaceToBottom
        
        if biggestVerticalSpace > biggestHorizontalSpace + 100 {
            let hintWidth = screenFrame.width - 64
            tmpTextView.frame = CGRect(x: 0, y: 0, width: hintWidth, height: 100)
            tmpTextView.text = hints[currentStep]
            let textFrame = tmpTextView.contentSize
            arrowCenter = CGPoint(x: targets[currentStep].midX - (16 - arrowLength), y: 0)
            if biggestVerticalSpace == spaceToTop {
                hintFrame = CGRect(x: 16 - arrowLength,
                                   y: targets[currentStep].origin.y - 16 - textFrame.height - borderWidth,
                                   width: hintWidth + 32 + arrowLength * 2,
                                   height: textFrame.height + 16)
                position = .top
            } else {
                hintFrame = CGRect(x: 16 - arrowLength,
                                   y: targets[currentStep].origin.y + targets[currentStep].size.height + borderWidth,
                                   width: textFrame.width + 32 + arrowLength * 2,
                                   height: textFrame.height + 16)
                position = .bottom
            }
        } else {
            let hintWidth = screenFrame.width - 64 - targets[currentStep].size.width
            tmpTextView.frame = CGRect(x: 0, y: 0, width: hintWidth, height: 100)
            tmpTextView.text = hints[currentStep]
            let textFrame = tmpTextView.contentSize
            if biggestHorizontalSpace == spaceToLeft {
                hintFrame = CGRect(x: 16 - arrowLength,
                                   y: targets[currentStep].midY - textFrame.height / 2,
                                   width: spaceToLeft + arrowLength - borderWidth - 16,
                                   height: textFrame.height + 24)
                arrowCenter = CGPoint(x: 0, y: 0)
                position = .left
            } else {
                hintFrame = CGRect(x: targets[currentStep].origin.x + targets[currentStep].size.width + borderWidth,
                                   y: targets[currentStep].midY - textFrame.height / 2,
                                   width: spaceToRight + arrowLength - borderWidth - 16,
                                   height: textFrame.height + 24)
                arrowCenter = CGPoint(x: 0, y: 0)
                position = .right
            }
        }
        hintView.setupHint(with: position, text: hints[currentStep], rect: hintFrame, arrowCenter: arrowCenter)
    }
    
    //MARK: - Animations
    
    func addLayerAnimation(to mask: CAShapeLayer, with path: CGPath) {
        let maskAnimation = CABasicAnimation(keyPath: "path")
        maskAnimation.fromValue = mask.path
        maskAnimation.toValue = path
        maskAnimation.duration = currentStep == 0 ? 0 : animationDuration
        maskAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        mask.add(maskAnimation, forKey: nil)
    }
    
    func addBorderAnimation(to layer: CALayer, with frame: CGRect) {
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = layer.value(forKey: "position")
        positionAnimation.toValue = NSValue(cgPoint: CGPoint(x: frame.midX, y: frame.midY))
        let oldBounds = layer.bounds
        let newBounds = CGRect(origin: oldBounds.origin, size: frame.size)
        
        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = NSValue(cgRect: oldBounds)
        boundsAnimation.toValue = NSValue(cgRect: newBounds)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation, boundsAnimation]
        groupAnimation.duration = currentStep == 0 ? 0 : animationDuration
        groupAnimation.delegate = self
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(groupAnimation, forKey: "frame")
    }
}

extension CRTutorialView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let self = self else { return }
            self.hintView.alpha = 1
        })
    }
}
