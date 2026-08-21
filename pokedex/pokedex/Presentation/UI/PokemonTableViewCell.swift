//
//  PokemonTableViewCell.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 23/4/26.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with pokemon: Pokemon) {
        pokemonNameLabel.text = pokemon.name
        pokemonImageView.image = pokemon.images.first ?? UIImage(systemName: "foto")
        accessoryView = makeAccessoryView(for: pokemon.collectionState)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse( )
        accessoryView = nil
    }
    
    private func makeAccessoryView(for state: PokemonCollectionState) -> UIView? {
        let imageName: String?
        let tintColor: UIColor
        
        switch state {
        case .none:
            return nil
        case .wanted:
            imageName = "heart.fill"
            tintColor = .systemRed
        case .owned:
            imageName = "bookmark.fill"
            tintColor = .systemBlue
        }
        
        guard let imageName, let image = UIImage(systemName: imageName) else {
            return nil
        }
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = tintColor
        return imageView
    }
}
