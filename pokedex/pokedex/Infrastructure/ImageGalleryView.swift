//
//  ImageGalleryView.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 7/5/26.
//

import UIKit

@objc
protocol ImageGalleryDataSource: AnyObject {
    func numberOfImages(in galleryView: ImageGalleryView) -> Int
    func imageGalleryView(_ galleryView: ImageGalleryView, imageAt index: Int) -> UIImage
}

@objc
protocol ImageGalleryDelegate: AnyObject {
    func imageGalleryView(_ galleryView: ImageGalleryView, didDoubleTapImageAt index: Int)
}

class ImageGalleryView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var previusButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    weak var dataSource: ImageGalleryDataSource? {
        didSet {
            reloadData()
        }
    }
    
    weak var delegate: ImageGalleryDelegate?
    
    private var imageViews: [UIImageView] = []
    private var voiceOverObserver: NSObjectProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    deinit {
        if let voiceOverObserver {
            NotificationCenter.default.removeObserver(voiceOverObserver)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutImageViews()
    }
}

private extension ImageGalleryView {
    func commonInit() {
        loadNib()
        configureScrollView()
        configurePageControl()
        configureAccesibilityMode()
    }
    
    func loadNib() {
        Bundle(for: type(of: self)).loadNibNamed("ImageGalleryView", owner: self, options: nil)
        
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
    }
    
    func configurePageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = 0
        pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
        
        pageControl.currentPageIndicatorTintColor = .systemRed
        pageControl.pageIndicatorTintColor = .lightGray
    }
    
    func configureAccesibilityMode() {
        let isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
        
        scrollView.isScrollEnabled = !isVoiceOverRunning
        previusButton.isHidden = !isVoiceOverRunning
        nextButton.isHidden = !isVoiceOverRunning
        
        updateButtonsEnabledState()
    }
    
    func updateButtonsEnabledState() {
        let currentPage = pageControl.currentPage
        let lastPage = max(0, pageControl.numberOfPages - 1)
        
        previusButton.isEnabled = currentPage > 0
        nextButton.isEnabled = currentPage < lastPage
    }
    
    func layoutImageViews() {
        let width = scrollView.bounds.width
        let height = scrollView.bounds.height
        
        guard width > 0, height > 0 else { return }
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame = CGRect(x: CGFloat(index)*width, y: 0, width: width, height: height)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(imageViews.count) * width, height: height)
    }
    
    func clearImages() {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
    }
    
    func makeImageView(image: UIImage, index: Int) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tag = index
        imageView.isUserInteractionEnabled = true
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapImage(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapRecognizer)
        
        return imageView
    }
    
    @objc
    func pageControlDidChange() {
        let width = scrollView.bounds.width
        let x = CGFloat(pageControl.currentPage) * width
        
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    @objc
    func didDoubleTapImage(_ recognizer: UITapGestureRecognizer) {
        guard let imageView = recognizer.view as? UIImageView else { return }
        delegate?.imageGalleryView(self, didDoubleTapImageAt: imageView.tag)
    }
}

extension ImageGalleryView {
    func reloadData() {
        clearImages()
        
        guard let dataSource else {
            pageControl.numberOfPages = 0
            pageControl.currentPage = 0
            scrollView.contentSize = .zero
            return
        }
        
        let numberOfImages = dataSource.numberOfImages(in: self)
        pageControl.numberOfPages = numberOfImages
        pageControl.currentPage = 0
        
        guard numberOfImages > 0 else {
            scrollView.contentSize = .zero
            return
        }
        
        for index in 0..<numberOfImages {
            let image = dataSource.imageGalleryView(self, imageAt: index)
            let imageView = makeImageView(image: image, index: index)
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
        
        scrollView.contentOffset = .zero
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension ImageGalleryView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        guard width > 0, !imageViews.isEmpty else { return }
        
        let rawPage = scrollView.contentOffset.x / width
        let page = Int(rawPage.rounded())
        
        pageControl.currentPage = max(0, min(page, imageViews.count - 1))
        
    }
}
