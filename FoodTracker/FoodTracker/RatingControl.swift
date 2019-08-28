//
//  RatingControl.swift
//  FoodTracker
//
//  Created by zsp on 2019/8/21.
//  Copyright © 2019 woop. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5  {
        didSet {
            setupButtons()
        }
    }

    //MARK: Initialization
    //load by code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    //load by storyboard
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    //MARK: Private Methods
    private func setupButtons() {
        
        let bundle = Bundle(for: type(of: self))
        
        let emptyStar = UIImage(named: "star-empty", in: bundle, compatibleWith: self.traitCollection)
        
        let highStar = UIImage(named: "star-high", in: bundle, compatibleWith: self.traitCollection)
        
        let filledStar = UIImage(named: "star-filled", in: bundle, compatibleWith: self.traitCollection)
        
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        for index in 0 ..< starCount {
        
            // Create the button
            let button = UIButton()

            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highStar, for: .highlighted)
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        print("Button pressed 👍")
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        let selectedRating = index + 1
        
        if (selectedRating > 0) && (rating != selectedRating) {
            rating = selectedRating
        }
        
        
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
