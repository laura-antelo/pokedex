//
//  Pokemons.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 8/5/26.
//

@testable import pokedex
import UIKit

enum TestPokemons {
    static let pikachu = Pokemon(id: 25, name: "Pikachu", images: [], types: ["Electric"], collectionState: .none)
    static let charmander = Pokemon(id: 4, name: "Charmander", images: [], types: ["Fire"], collectionState: .wanted)
    
    static let pikachuDetail = PokemonDetail(id: 25, name: "Pikachu", images: [], description: "Example", types: ["Electric"], collectionState: .none)
    static let charmanderDetail = PokemonDetail(id: 4, name: "Charmander", images: [], description: "Example", types: ["Fire"], collectionState: .wanted)
    
    static let samplePokemons: [Pokemon] = [pikachu, charmander]
}
