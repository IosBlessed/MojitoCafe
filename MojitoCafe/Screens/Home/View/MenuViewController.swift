//
//  ViewController.swift
//  Myata Cafe
//
//  Created by Никита Данилович on 06.04.2023.
//
import UIKit
import Combine
import FirebaseCore
import FirebaseFirestore


//MARK: - MenuGroupCollectionViewCell class
final class MenuGroupCollectionViewCell:UICollectionViewCell{
    
    override var isSelected: Bool{

        didSet{
            if isSelected{
                selectedCellView()
            }else{
                unselectedCellView()
            }
        }
        
    }
    
    func initializeCellView(){
        
        self.layer.cornerRadius = 10
        self.layer.insertSublayer(backgroundLayer, above: self.layer)
        self.addSubview(sectionNameLabel)
        
        self.isSelected ? selectedCellView() : unselectedCellView()
        
    }
    
   private func unselectedCellView(){
       
        self.backgroundColor = .green
        self.layer.sublayers?.first?.backgroundColor = UIColor.clear.cgColor
       
    }
    
    private func selectedCellView(){
        
        self.backgroundColor = .yellow
        self.layer.sublayers?.first?.backgroundColor = UIColor.yellow.cgColor
        
    }
    
    private lazy var backgroundLayer:CALayer = {
        
        let layer = CALayer()
        
        layer.frame = CGRect(x: -5, y: 40, width: 160, height: 10)
        layer.backgroundColor = UIColor.clear.cgColor
        layer.cornerRadius = 5
        
        return layer
    }()
   
    lazy var sectionNameLabel:UILabel = {
        
        let name = UILabel(frame: .zero)
        
        name.frame = self.bounds
        
        name.textAlignment = .center
        
        return name
    }()
    
}

//MARK: - TableViewCell class
final class MenuProductsTableViewCell:UITableViewCell{
    
    lazy var productImageView:UIImageView = {
        
        let imageView = UIImageView(frame: .zero)
        
        imageView.frame = CGRect(
            x: 0,
            y: 0,
            width: 100,
            height: self.bounds.height
        )
        
        imageView.backgroundColor = .clear
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        return imageView
    }()
    lazy var titleLabel:UILabel = {
        
        let label = UILabel(frame: .zero)
        
        label.backgroundColor = .clear
        
        label.textAlignment = .center
        label.textColor = .black
        
        
        return label
    }()
    lazy var descriptionLabel:UILabel = {
        
        let label = UILabel(frame: .zero)
        
        label.backgroundColor = .clear
        
        label.textAlignment = .center
        label.textColor = .black
        
        
        return label
    }()
    lazy var priceLabel:UILabel = {
        
        let label = UILabel(frame: .zero)
        
        label.backgroundColor = .clear
        
        label.textAlignment = .center
        label.textColor = .black
        
        
        return label
    }()
    
    
    private func setupViews(){
        
        self.addSubview(productImageView)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(priceLabel)
        
    }
    
    init(){
        super.init(style: .default, reuseIdentifier: "productTableViewCell")
        
        setupViews()
        
    }
    
    required init?(coder:NSCoder){
        fatalError()
    }
}


//MARK: - MenuViewController class
final class MenuViewController: UIViewController,UINavigationControllerDelegate {
    
    fileprivate var subscriberMenuGroup:AnyCancellable?
    
    fileprivate var menuViewModel = MenuViewModel()
    
    var menuGroupCollectionView:UICollectionView?
    
    var menuProductsScrollView:UIScrollView?
    
    var menuProductsTableViews:[UITableView] = []
    
    var preselectedMenuGroupCellIndexPath:IndexPath?
    
    var groups:[String] = []
    
    private func initializeBackgroundView(){
        
        view.backgroundColor = .lightGray
        
    }
    
    private func inititalizeNavigationBarView(){
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.layoutIfNeeded()
        
        let titleTextAttributes:[NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font:UIFont.systemFont(ofSize: 21, weight: .bold)
        ]
        
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        
        let title = "Company name"
        
        self.title = title
      
    }
    //MARK: - MenuGroupCollectionView
    private func inititalizeMenuGroupCollectionView(){
        
        let menuGroupFlowLayout = UICollectionViewFlowLayout()
        
        let sectionInset = UIEdgeInsets(
            top: 5,
            left: 5,
            bottom: 5,
            right: 5
        )
        
        menuGroupFlowLayout.scrollDirection = .horizontal
        menuGroupFlowLayout.sectionInset = sectionInset

        menuGroupCollectionView = UICollectionView(frame: .zero,collectionViewLayout:menuGroupFlowLayout)
        
        menuGroupCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        menuGroupCollectionView?.backgroundColor = .clear
        
        menuGroupCollectionView?.allowsSelection = true
        menuGroupCollectionView?.isScrollEnabled = true
        menuGroupCollectionView?.showsVerticalScrollIndicator = false
        menuGroupCollectionView?.showsHorizontalScrollIndicator = false
        
        menuGroupCollectionView?.allowsSelection = true

        
        menuGroupCollectionView?.register(
            MenuGroupCollectionViewCell.self,
            forCellWithReuseIdentifier: "menuSection"
        )
        
        menuGroupCollectionView?.delegate = self
        menuGroupCollectionView?.dataSource = self
        
        
        view.addSubview(menuGroupCollectionView ?? UIView())
    }
    
    //MARK: - MenuProductsScrollView section
    
    private func initializeMenuProductsScrollView(){
        
        menuProductsScrollView = UIScrollView(frame: .zero)
        
        menuProductsScrollView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        menuProductsScrollView?.layer.borderColor = UIColor.green.cgColor
        menuProductsScrollView?.layer.borderWidth = 2
        
        menuProductsScrollView?.isPagingEnabled = true
        menuProductsScrollView?.alwaysBounceHorizontal = false
        menuProductsScrollView?.alwaysBounceVertical = false
        menuProductsScrollView?.showsVerticalScrollIndicator = false
        menuProductsScrollView?.showsHorizontalScrollIndicator = false
        
        menuProductsScrollView?.delegate = self
        
        view.addSubview(menuProductsScrollView ?? UIScrollView(frame: .zero))
    }
    
    //MARK: - MenuProductsTableView section
    
    private func initializeMenuProductsTableViews(){
        
        for _ in 0..<groups.count{
            
            let tableView = createProductsTableView()
            menuProductsTableViews.append(tableView)
            
        }
        
        guard let productsScrollViewBounds = menuProductsScrollView?.bounds else {
            
            return
        }
        
        menuProductsScrollView?.contentMode = .center
        
        var frameTableViewXcoordinate:CGFloat = 10.0
        let leftInsetSpace:CGFloat = 10.0
        
        let scrollViewSizeWidth:CGFloat = productsScrollViewBounds.width * CGFloat(menuProductsTableViews.count)
        
        for tableView in menuProductsTableViews {
            
            tableView.frame = CGRect(
                x: frameTableViewXcoordinate,
                y: 10,
                width: productsScrollViewBounds.width - 20,
                height: productsScrollViewBounds.height - 20
            )
            
            menuProductsScrollView?.addSubview(tableView)
            
            frameTableViewXcoordinate += leftInsetSpace * 2 + tableView.bounds.width
        }
        
        menuProductsScrollView?.contentSize = CGSize(
            width: scrollViewSizeWidth,
            height: productsScrollViewBounds.height
        )
        
    }
    
    private func createProductsTableView() -> UITableView {
        
        let menuProductsTableView = UITableView(frame: .zero)
        
        menuProductsTableView.layer.cornerRadius = 10
        menuProductsTableView.layer.masksToBounds = true
        
        menuProductsTableView.delegate = self
        menuProductsTableView.dataSource = self
        
        menuProductsTableView.register(
            MenuProductsTableViewCell.self,
            forCellReuseIdentifier: "productTableViewCell"
        )
        
        return menuProductsTableView
    }
    
    private func initializeMenuGroupSubscriber(){
        
        subscriberMenuGroup = menuViewModel.$groups.sink{
            
           [weak self] menuGroups in
            
            self?.groups = menuGroups
            
            self?.menuGroupCollectionView?.reloadData()
            
            if menuGroups.count != 0{
                
                let defaultRowIndexPath = IndexPath(row: 0, section: 0)
                
                self?.menuGroupCollectionView?.selectItem(
                    at: defaultRowIndexPath,
                    animated: true,
                    scrollPosition: .centeredHorizontally
                )
                
                self?.initializeMenuProductsTableViews()
                
            }
            
        }
        
        menuViewModel.fetchCategories()
    }
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initializeBackgroundView()
        
        inititalizeNavigationBarView()
        
        inititalizeMenuGroupCollectionView()
        
        initializeMenuProductsScrollView()
        
        initializeMenuGroupSubscriber()
    
    }
    
    private func setupConstraints(){
        
        //Constraints structure -> top,left,right,height/bottom
        
        let safeArea = view.safeAreaLayoutGuide
        
        if let menuGroupConstraint = menuGroupCollectionView{
            
            menuGroupConstraint.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: 10
            ).isActive = true
            
            menuGroupConstraint.leftAnchor.constraint(
                equalTo: safeArea.leftAnchor,
                constant: 10
            ).isActive = true
            
            menuGroupConstraint.rightAnchor.constraint(
                equalTo: safeArea.rightAnchor,
                constant: -10
            ).isActive = true
            
            menuGroupConstraint.heightAnchor.constraint(
                equalToConstant: 70
            ).isActive = true
            
            if let productsScrollView = menuProductsScrollView{
                
                productsScrollView.topAnchor.constraint(
                    equalTo: menuGroupConstraint.bottomAnchor,
                    constant: 10
                ).isActive = true
                
                productsScrollView.leftAnchor.constraint(
                    equalTo: menuGroupConstraint.leftAnchor
                ).isActive = true
                
                productsScrollView.rightAnchor.constraint(
                    equalTo: menuGroupConstraint.rightAnchor
                ).isActive = true
                
                productsScrollView.bottomAnchor.constraint(
                    equalTo: safeArea.bottomAnchor,
                    constant: -100
                ).isActive = true
                
             
                
            }
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        setupConstraints()
        
    }

}

