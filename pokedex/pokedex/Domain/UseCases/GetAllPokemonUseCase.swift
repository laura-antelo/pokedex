//
//  GetAllPokemonUseCase.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 22/4/26.
//

import UIKit
import Combine

protocol GetAllPokemonUseCase {
    func execute() -> AnyPublisher<[Pokemon], Error>
}

class DefaultGetAllPokemonUseCase: GetAllPokemonUseCase {
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Pokemon], Error> {
        return repository.getAllPokemonsPublisher()
    }
}
