//
//  PokemonDetailViewModel.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 24/4/26.
//

import UIKit
import Combine

protocol PokemonDetailViewModel {
    var pokemonDetailPublisher: AnyPublisher<PokemonDetail, Error> { get }
    func viewDidLoad()
}

final class DefaultDetailPokemonViewModel: PokemonDetailViewModel {
    
    private let dependencies: PokemonDependencies
    private let pokemonId: Int
    
    var pokemonDetailPublisher: AnyPublisher<PokemonDetail, Error> {
        let useCase: GetPokemonDetailUseCase = dependencies.resolve()
        return useCase.execute(id: pokemonId)
    }
    
    init(dependencies: PokemonDependencies, pokemonId: Int) {
        self.dependencies = dependencies
        self.pokemonId = pokemonId
    }
    
    func viewDidLoad() {
        // Ya no nos hace falta
    }
}
