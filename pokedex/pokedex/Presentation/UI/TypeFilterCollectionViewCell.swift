//
//  TypeFilterCollectionViewCell.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 6/5/26.
//

import UIKit

class TypeFilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var closeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        closeLabel.isHidden = true
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    func configure(type: String, isSelectedType: Bool) {
        titleLabel.text = type
        closeLabel.text = "x"
        closeLabel.isHidden = !isSelectedType
        
        if isSelectedType {
            contentView.layer.borderColor = UIColor.systemRed.cgColor
            contentView.layer.borderWidth = 2
        } else {
            contentView.layer.borderColor = UIColor.systemGray4.cgColor
            contentView.layer.borderWidth = 1
        }
    }

}
