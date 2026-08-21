//
//  PokemonDetailViewController.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 24/4/26.
//

import UIKit
import Combine

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet weak var galleryView: ImageGalleryView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    
    private let viewModel: PokemonDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private var pokemonDetail: PokemonDetail?
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "PokemonDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        startViewModel()
    }
}

private extension PokemonDetailViewController {
    func setupView() {
        self.navigationItem.title = "Detalle del Pokemon"
        
        galleryView.dataSource = self
        galleryView.delegate = self
    }
    
    func startViewModel() {
        viewModel.pokemonDetailPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Pokemon detail loaded")
                    case .failure(let error):
                        print("Error loading pokemon detail: \(error)")
                    }
                }, receiveValue: { [weak self] pokemonDetail in
                    self?.setPokemonDetail(pokemonDetail)
                }
            ).store(in: &cancellables)
        
        viewModel.viewDidLoad()
            
    }

    func setPokemonDetail(_ pokemonDetail: PokemonDetail) {
        self.pokemonDetail = pokemonDetail
        
        nameLabel.text = pokemonDetail.name.capitalized
        idLabel.text = "#\(pokemonDetail.id)"
        descriptionLabel.text = pokemonDetail.description
        typesLabel.text = pokemonDetail.types.joined(separator: ", ")
        
        galleryView.reloadData()
    }
}

extension PokemonDetailViewController: ImageGalleryDataSource {
    func numberOfImages(in galleryView: ImageGalleryView) -> Int {
        pokemonDetail?.images.count ?? 0
    }
    
    func imageGalleryView(_ galleryView: ImageGalleryView, imageAt index: Int) -> UIImage {
        pokemonDetail!.images[index]
    }
}

extension PokemonDetailViewController: ImageGalleryDelegate {
    func imageGalleryView(_ galleryView: ImageGalleryView, didDoubleTapImageAt index: Int) {
        guard let image = pokemonDetail?.images[index] else { return }
        
        let zoomViewController = ImageZoomViewController(image: image)
        navigationController?.pushViewController(zoomViewController, animated: true)
    }
}
