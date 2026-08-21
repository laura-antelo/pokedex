//
//  SearchTableViewCell.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 6/5/26.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    
    var onTextChanged: ((String) -> Void)?
    var onFiltersbuttonTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onTextChanged = nil
        onFiltersbuttonTapped = nil
    }
    
    @IBAction func didTapSearchButton() {
        onFiltersbuttonTapped?()
    }
    
    @IBAction func didChangeSearchTextField(_ sender: UITextField) {
        onTextChanged?(sender.text ?? "")
    }
}
