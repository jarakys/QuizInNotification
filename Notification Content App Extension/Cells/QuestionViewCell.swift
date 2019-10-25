//
//  QuestionViewCell.swift
//  Notification Content App Extension
//
//  Created by Dmitriy Chumakov on 9/6/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import UIKit

class QuestionViewCell: UICollectionViewCell {
    
    lazy var width: NSLayoutConstraint = {
        let content = contentView.widthAnchor
            .constraint(equalToConstant: bounds.size.width)
        content.isActive = true
        return content
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize, withHorizontalFittingPriority
        horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        width.constant = targetSize.width
        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: targetSize.width, height: 1),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: verticalFittingPriority)
        return size
    }
}
