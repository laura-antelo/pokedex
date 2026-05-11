//
//  ViewController.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 20/4/26.
//

import UIKit
import Combine

class PokemonViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    private let dependencies: PokemonDependencies
    private var pokemons: [Pokemon] = []
    private var cancellales = Set<AnyCancellable>()
    private var searchText: String = ""
    private var hasActiveAdvancedFilters: Bool = false
    
    init(dependencies: PokemonDependencies) {
        self.dependencies = dependencies
        super.init(nibName: "PokemonViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        startViewModel()
    }
    
    func setPokemon(_ pokemon: [Pokemon]) {
        self.pokemons = pokemon
        self.tableView.reloadData()
    }
}

private extension PokemonViewController {
    func setupView() {
        self.navigationItem.title = "Pokédex"
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonTableViewCell")
    }
    
    func startViewModel() {
        let viewModel: PokemonViewModel = dependencies.resolve()
        
        viewModel.pokemonsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pokemons in
                self?.setPokemons(pokemons)
                
            }
            .store(in: &cancellales)
        
        viewModel.hasActiveAdvancedFiltersPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasActiveAdvancedFilters in
                self?.hasActiveAdvancedFilters = hasActiveAdvancedFilters
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
            .store(in: &cancellales)
        
        viewModel.viewDidLoad()
    }
    
    func setPokemons(_ pokemons: [Pokemon]) {
        self.pokemons = pokemons
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        let viewModel: PokemonViewModel = dependencies.resolve()
        viewModel.updateSearchText(text)
    }
    
    func openFilters() {
        let coordinator: PokemonCoordinator = dependencies.resolve()
        coordinator.goToAdvancedFilters()
    }
}

extension PokemonViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return pokemons.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            
            cell.onTextChanged = { [weak self] text in
                self?.updateSearchText(text)
            }
            
            cell.onFiltersbuttonTapped = { [weak self] in
                self?.openFilters()
            }
            
            return cell
        }
        
        let pokemon = pokemons[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell", for: indexPath) as? PokemonTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: pokemon)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        
        let pokemon = pokemons[indexPath.row]
        let viewModel: PokemonViewModel = dependencies.resolve()
        
        viewModel.didSelectedPokemon(id: pokemon.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1 else { return nil }
        
        let pokemon = pokemons[indexPath.row]
        
        let wantedAction = UIContextualAction(style: .normal, title: "Quiero") { [weak self] _, _, completion in
            let newState: PokemonCollectionState = (pokemon.collectionState == .wanted) ? .none : .wanted
            self?.updateCollectionState(for: pokemon.id, to: newState)
            completion(true)
        }
        wantedAction.image = UIImage(systemName: "heart.fill")
        wantedAction.backgroundColor = .systemRed
        
        let ownedAction = UIContextualAction(style: .normal, title: "Tengo") { [weak self] _, _, completion in
            let newState: PokemonCollectionState = (pokemon.collectionState == .owned) ? .none : .owned
            self?.updateCollectionState(for: pokemon.id, to: newState)
            completion(true)
        }
        ownedAction.image = UIImage(systemName: "bookmark.fill")
        ownedAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [wantedAction, ownedAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    private func updateCollectionState(for id: Int, to state: PokemonCollectionState) {
        let viewModel: PokemonViewModel = dependencies.resolve()
        viewModel.didChangeCollectionState(id: id, to: state)
    }
}


