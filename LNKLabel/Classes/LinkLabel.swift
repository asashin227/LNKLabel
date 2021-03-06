//
//  LinkLabel.swift
//  LinkLabel
//
//  Created by Asakura Shinsuke on 2017/09/13.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import UIKit

public protocol LNKLabelDelegate: NSObjectProtocol {
    func didTaped(label: LNKLabel, pattern: Pattern, matchText: String, range: NSRange)
} 

public class LNKLabel: UILabel {
    fileprivate var matcher = Matcher()
    public var delegate: LNKLabelDelegate?
    override public var text: String? {
        didSet { reloadAttribute() }
    }
    public var linkPatterns: [Pattern]? {
        didSet { reloadAttribute() }
    }
    public var linkColor: UIColor = .blue {
        didSet { reloadAttribute() }
    }
    
    convenience public init() {
        self.init(frame: .zero)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.addTouchGesture()
       
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addTouchGesture() {
        self.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(LNKLabel.didTaped(gesture:)))
        gesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(gesture)
    }
}

extension LNKLabel {
    public func hitLink(at point: CGPoint) -> (touchedText: String, textRange: NSRange, pattern: Pattern)? {
        guard let text = text else { return nil }
        for match in matcher.matches {
            for link in match.value {
                let glyphRect = rect(of: link.0, in: text, range: link.1)
                if glyphRect == .zero {
                    continue
                }
                if glyphRect.contains(point) {
                    return (link.0, link.1, match.key)
                }
            }
        }
        return nil
    }
}

extension LNKLabel {
    
    private func reloadAttribute() {
        guard let text = text, let linkPatterns = linkPatterns else { return }
        self.attributedText = linkAttribute(for: text, patterns: linkPatterns)
    }
    
    private func linkAttribute(for text: String, patterns: [Pattern]) -> NSAttributedString? {
        matcher.text = text
        matcher.patterms = linkPatterns
        var attribute = NSMutableAttributedString(string: text)
        for match in matcher.matches {
            for link in match.value {
                addLinkAttribute(for: &attribute, plainText: text, targetText: link.0, range: link.1)
            }
        }
        return attribute
    }
    
    private func addLinkAttribute(for attributes: inout NSMutableAttributedString, plainText: String, targetText: String, range: NSRange) {
        attributes.addAttributes([NSAttributedStringKey.font : self.font], range: NSMakeRange(0, plainText.count))
        attributes.addAttributes([NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
                                  NSAttributedStringKey.underlineColor : linkColor,
                                  NSAttributedStringKey.foregroundColor : linkColor], range: range)
    }
    
}

extension LNKLabel {

    @objc
    private func didTaped(gesture: UIGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        guard let res = hitLink(at: touchPoint) else { return }
        self.didTaped(touchedText: res.touchedText, touchedRange: res.textRange, pattern: res.pattern)
    }
    
    private func rect(of text: String, in plainText: String, range: NSRange) -> CGRect {
        guard let attributedText = self.attributedText else { return .zero }
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: self.frame.size)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        let toRange = range
        let glyphRange = layoutManager.glyphRange(forCharacterRange: toRange, actualCharacterRange: nil)
        let glyphRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        return glyphRect
    }
    
    private func didTaped(touchedText: String, touchedRange: NSRange, pattern: Pattern) {
        guard let delegate = delegate else { return }
        delegate.didTaped(label: self, pattern: pattern, matchText: touchedText, range: touchedRange)
    }
}

