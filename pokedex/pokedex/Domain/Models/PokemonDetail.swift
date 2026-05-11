//
//  PokemonDetails.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 24/4/26.
//

import UIKit

struct PokemonDetail {
    let id: Int
    let name: String
    let images: [UIImage]
    let description: String
    let types: [String]
    let collectionState: PokemonCollectionState
}
