//
//  ratingControl.swift
//  rankStars
//
//  Created by 马宝森 on 2019/3/25.
//  Copyright © 2019 马宝森. All rights reserved.
//

import UIKit

@IBDesignable class ratingControl: UIStackView {
    //MARKS: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0{
        didSet {
            updateButtonStates()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            createButton()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            createButton()
        }
    }

    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        createButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        createButton()
    }
    
    //MARKS: Button Action
    @objc func ratingButtonTapped(button: UIButton){
        guard let index = ratingButtons.index(of: button) else{
            fatalError("The button, \(button), is not in the ratingButtons arry: \(ratingButtons)")
        }
        
        //计算被选择的评分
        let selectedRating = index + 1
        
        if selectedRating == rating {
            //如果被选中的星星代表当前的评级，将b评级重置为0
            rating = 0
        } else {
            //否则将评级设为当前选中的星星
            rating = selectedRating
        }
        
    }
    
    //MARK: Private Methods
    private func createButton(){
        //清除旧按钮
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //加载按钮图片
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount{
            //创建按钮
            let button = UIButton()
            button.backgroundColor = UIColor.red
            
            //设置按钮的图片
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            //添加按钮的约束
            button.translatesAutoresizingMaskIntoConstraints = false //禁用按钮自动生成的约束
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //设置辅助功能标签
            button.accessibilityLabel = "Set \(index+1) star rating"
            
            //创建按钮对应的相应
            button.addTarget(self, action: #selector(ratingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            //将按钮添加到堆栈中
            addArrangedSubview(button)
            
            //把按钮添加到n按钮数组中
            ratingButtons.append(button)
        }
        updateButtonStates()
    }
    
    private func updateButtonStates(){
        for (index, button) in ratingButtons.enumerated(){
            //如果按钮的index小于评级，那么这个按钮要是被选中的状态
            button.isSelected = index < rating
            
            //设置辅助功能提示和值
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            }else {
                hintString = nil
            }
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) star set."
            }
            
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
    
}
