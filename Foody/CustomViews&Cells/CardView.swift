//
//  CardView.swift
//  Foody
//
//  Created by Khater on 5/13/23.
//

import UIKit


class CardView: UIView {
    
    private let opacity: Float
    
    init(opacity: Float = 0.1) {
        self.opacity = opacity
        super.init()
    }
    
    override init(frame: CGRect) {
        opacity = 0.1
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        opacity = 0.1
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup() {
        backgroundColor = .white // IMPORTANT line
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = opacity
        layer.cornerRadius = 10
    }
    
    
}
