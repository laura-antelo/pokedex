//
//  GetPokemonDetailsUseCase.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 24/4/26.
//

import UIKit
import Combine

protocol GetPokemonDetailUseCase {
    func execute(id: Int) -> AnyPublisher<PokemonDetail, Error>
}

final class DefaultGetPokemonDetailUseCase: GetPokemonDetailUseCase {
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) -> AnyPublisher<PokemonDetail, Error> {
        return repository.getPokemonDetailByIdPublisher(id)
    }
}
