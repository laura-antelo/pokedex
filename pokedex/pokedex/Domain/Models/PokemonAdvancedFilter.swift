//
//  PokemonListFilter.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 4/5/26.
//

import Foundation

struct PokemonAdvancedFilter: Equatable {
    var nameText: String = ""
    var numberText: String = ""
    var selectedTypes: Set<String> = []
    var selectedCollectionStates: Set<PokemonCollectionState> = []
    
    static let empty = PokemonAdvancedFilter()
    
    var hasAdvancedFilters: Bool {
        !nameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !numberText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !selectedTypes.isEmpty ||
        !selectedCollectionStates.isEmpty
    }
}

enum PokemonTypeCatalog {
    static let all: [String] = [
        "Bug",
        "Dark",
        "Dragon",
        "Electric",
        "Fairy",
        "Fighting",
        "Fire",
        "Flying",
        "Ghost",
        "Grass",
        "Ground",
        "Ice",
        "Poison",
        "Psychic",
        "Rock",
        "Steel",
        "Water"
    ]
}
