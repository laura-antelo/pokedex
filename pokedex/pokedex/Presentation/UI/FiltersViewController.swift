//
//  FiltersViewController.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 6/5/26.
//

import UIKit

class FiltersViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var wantedButton: UIButton!
    @IBOutlet private weak var ownedButton: UIButton!
    
    private let viewModel: PokemonViewModel
    private let types = PokemonTypeCatalog.all
    
    private var currentFilter: PokemonAdvancedFilter
    
    init(viewModel: PokemonViewModel) {
        self.viewModel = viewModel
        self.currentFilter = viewModel.currentAdvancedFilters()
        super.init(nibName: "FiltersViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentFilter = viewModel.currentAdvancedFilters()
        applyFilterToUI()
    }
}

private extension FiltersViewController {
    func setupView() {
        title = "Filtros de Búsqueda avanzada"
        
        collectionView.register(UINib(nibName: "TypeFilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TypeFilterCollectionViewCell")
        
        nameTextField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
        idTextField.addTarget(self, action: #selector(idDidChange), for: .editingChanged)
    }
    
    func applyFilterToUI() {
        nameTextField.text = currentFilter.nameText
        idTextField.text = currentFilter.numberText
        configure(button: wantedButton, title: "Lo Quiero", isSelected: currentFilter.selectedCollectionStates.contains(.wanted))
        configure(button: ownedButton, title: "Lo Tengo", isSelected: currentFilter.selectedCollectionStates.contains(.owned))
        collectionView.reloadData()
    }
    
    func configure(button: UIButton, title: String, isSelected: Bool) {
        var configuration = isSelected ? UIButton.Configuration.filled() : UIButton.Configuration.tinted()
        configuration.title = title
        button.configuration = configuration
    }
    
    func pushCurrentFilter() {
        viewModel.applyAdvancedFilters(currentFilter)
    }
    
    @objc func nameDidChange() {
        currentFilter.nameText = nameTextField.text ?? ""
        pushCurrentFilter()
    }
    
    @objc func idDidChange() {
        currentFilter.numberText = idTextField.text ?? ""
        pushCurrentFilter()
    }
    
    func toggleType(_ type: String) {
        if currentFilter.selectedTypes.contains(type) {
            currentFilter.selectedTypes.remove(type)
        } else {
            currentFilter.selectedTypes.insert(type)
        }
        
        collectionView.reloadData()
        pushCurrentFilter()
    }
    
    @IBAction func didTapWantedButton() {
        toggleCollectionState(.wanted)
    }
    
    @IBAction func didTapOwnedButton() {
        toggleCollectionState(.owned)
    }
    
    func toggleCollectionState(_ state: PokemonCollectionState) {
        if currentFilter.selectedCollectionStates.contains(state) {
            currentFilter.selectedCollectionStates.remove(state)
        } else {
            currentFilter.selectedCollectionStates.insert(state)
        }
        
        configure(button: wantedButton, title: "Lo Quiero", isSelected: currentFilter.selectedCollectionStates.contains(.wanted))
        configure(button: ownedButton, title: "Lo Tengo", isSelected: currentFilter.selectedCollectionStates.contains(.owned))
        pushCurrentFilter()
    }
}

extension FiltersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = types[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeFilterCollectionViewCell", for: indexPath) as? TypeFilterCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(type: type, isSelectedType: currentFilter.selectedTypes.contains(type))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggleType(types[indexPath.item])
    }
}
