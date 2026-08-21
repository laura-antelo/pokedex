//
//  SetPokemonCollectionStateUseCase.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 4/5/26.
//

import UIKit

protocol SetPokemonCollectionStateUseCase {
    func execute(_ state: PokemonCollectionState, for id: Int)
}

final class DefaultSetPokemonCollectionStateUseCase: SetPokemonCollectionStateUseCase {
    private let repository: PokemonCollectionStateRepository
    
    init(repository: PokemonCollectionStateRepository) {
        self.repository = repository
    }
    
    func execute(_ state: PokemonCollectionState, for id: Int) {
        repository.save(state, for: id)
    }
}
