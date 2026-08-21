//
//  MainCoordinator.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 23/4/26.
//

import UIKit

protocol MainCoordinator {
    func start() -> UIViewController
}

final class DefaultMainCoordinator: MainCoordinator {
    
    let window: UIWindow
    let dependencies: PokemonDependencies
    
    init(window: UIWindow, dependencies: PokemonDependencies) {
        self.window = window
        self.dependencies = dependencies
    }
    
    func start() -> UIViewController {
        let pokemonCoordinator: PokemonCoordinator = dependencies.resolve()
        let pokemonViewController = pokemonCoordinator.start()
        let navigationController = UINavigationController(rootViewController: pokemonViewController)
        return navigationController
    }
}
