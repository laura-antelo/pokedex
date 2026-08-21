//
//  PokemonCoordinator.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 23/4/26.
//

import UIKit

protocol PokemonCoordinator {
    func start() -> UIViewController
    func goToPokemonDetail(id: Int)
    func goToAdvancedFilters()
}

final class DefaultPokemonCoordinator: PokemonCoordinator {
    
    private let dependencies: PokemonDependencies
    private weak var pokemonViewController: UIViewController?
    
    init(dependencies: PokemonDependencies) {
        self.dependencies = dependencies
    }
    
    func start() -> UIViewController {
        let viewController: PokemonViewController = dependencies.resolve()
        
        pokemonViewController = viewController
        
        return viewController
    }
    
    func goToPokemonDetail(id: Int) {
        let detailCoordinator: PokemonDetailCoordinator = dependencies.resolve()
        let detailViewController = detailCoordinator.start(pokemonId: id)
        pokemonViewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    //Cambiar esto con un coordinador para los filtros, no?
    func goToAdvancedFilters() {
        let viewModel: PokemonViewModel = dependencies.resolve()
        let filtersViewController = FiltersViewController(viewModel: viewModel)
        pokemonViewController?.navigationController?.pushViewController(filtersViewController, animated: true)
        
    }
}
