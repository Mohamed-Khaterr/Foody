//
//  OnboardingViewController.swift
//  Foody
//
//  Created by Khater on 5/3/23.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    
    // MARK: - UIComponents
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .red
        return pageControl
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - Variables
    private var slides = [OnboardingSlide]()
    
    private var selectedSlide: Int = 0 {
        didSet {
            if selectedSlide == slides.count - 1 {
                button.setTitle("Get Started", for: .normal)
                
            } else {
                button.setTitle("Next", for: .normal)
            }
        }
    }
    
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [
            .init(title: "Delicious Dishes", description: "Experience a variety of amazing dishes from different cultures around the world.", image: UIImage(named: "slide1")),
            .init(title: "World-Class Chefs", description: "Our dishes are prepared by oonly the best.", image: UIImage(named: "slide2")),
            .init(title: "Instant World-Wide Delivery", description: "Your orders will be delivered instantly irrespective of your location around the world.", image: UIImage(named: "slide3")),
        ]
        
        pageControl.numberOfPages = slides.count
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        [collectionView, pageControl, button].forEach({ view.addSubview($0) })
        setupCollectionViewConstraints()
        setupPageConrolConstraints()
        setupButtonConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
    }
    
    private func setupPageConrolConstraints() {
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8)
        ])
    }

    private func setupButtonConstraints() {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 24),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    // MARK: - Functions
    @objc private func buttonPressed() {
        selectedSlide += 1
        
        if selectedSlide == slides.count {
            let nav = UINavigationController(rootViewController: HomeCollectionViewController())
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .flipHorizontal
            present(nav, animated: true) {
                UserDefaults.standard.set(true, forKey: "isSeeOnboardingPage")
            }
        }
        
        let indexPath = IndexPath(item: selectedSlide, section: 0)
        if let rect = collectionView.layoutAttributesForItem(at: indexPath)?.frame{
            collectionView.scrollRectToVisible(rect, animated: true)
        }
    }
}



// MARK: - UICollectionView DataSource
extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
}


// MARK: - UICollectionView Delegate
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x)/Int(view.frame.width)
        selectedSlide = index
        pageControl.currentPage = index
    }
}
