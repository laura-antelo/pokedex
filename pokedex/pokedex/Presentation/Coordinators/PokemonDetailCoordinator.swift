//
//  PokemonDetailCoordinator.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 24/4/26.
//

import UIKit

protocol PokemonDetailCoordinator {
    func start(pokemonId: Int) -> UIViewController
}

final class DefaultPokemonDetailCoordinator: PokemonDetailCoordinator {
    private let dependencies: PokemonDependencies
    
    init(dependencies: PokemonDependencies) {
        self.dependencies = dependencies
    }
    
    func start(pokemonId: Int) -> UIViewController {
        let viewModel = DefaultDetailPokemonViewModel(dependencies: dependencies, pokemonId: pokemonId)
        let viewController = PokemonDetailViewController(viewModel: viewModel)
        
        return viewController
    }
}
