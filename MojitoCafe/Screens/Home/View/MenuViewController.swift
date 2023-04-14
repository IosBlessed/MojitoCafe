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
       
       self.backgroundColor = .clear
       sectionNameLabel.textColor = .white
       self.layer.sublayers?.first?.backgroundColor = UIColor.clear.cgColor
       
    }
    
    private func selectedCellView(){
        
        self.backgroundColor = .init(white: 1.0, alpha: 0.9)
        sectionNameLabel.textColor = .black
        self.layer.sublayers?.first?.backgroundColor = UIColor.white.cgColor
        
    }
    
    //MARK: - SHOULD BE REFACTORED
    private lazy var backgroundLayer:CALayer = {
        
        let layer = CALayer()
        
        layer.frame = CGRect(x: -5, y: 40, width: 160, height: 10)
        layer.backgroundColor = UIColor.clear.cgColor
        layer.cornerRadius = 5
        
        return layer
    }()
   
    lazy var sectionNameLabel:UILabel = {
        
        let name = UILabel(frame: .zero)
        
        name.textColor = .black
        
        name.frame = self.bounds
        
        name.textAlignment = .center
        
        return name
    }()
    
}

//MARK: - TableView Product Cell class
final class MenuProductsTableViewCell:UITableViewCell{
    
    lazy var cellView:UIView = {
        
        let cellView = UIView(frame: .zero)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        let gradientLayer = CAGradientLayer()
        
        let upperColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 0.0/255.0, green: 160.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [upperColor,bottomColor]

        gradientLayer.locations = [0.1,1.0]
        
        DispatchQueue.main.async {
            
            gradientLayer.frame = self.bounds
            
        }
        
        cellView.layer.addSublayer(gradientLayer)
        
        cellView.layer.masksToBounds = true
        cellView.layer.cornerRadius = 10
        
        DispatchQueue.main.async {
            self.layer.shadowOffset = .zero
            self.layer.shadowOpacity = 1.0
            self.layer.shadowColor = UIColor.init(white: 1.0, alpha: 0.9).cgColor
            self.layer.shadowRadius = 2
            
        }
        
        
        
        return cellView
    }()
    
    lazy var productImageView:UIImageView = {
        
        let imageView = UIImageView(frame: .zero)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        return imageView
    }()
    
    lazy var titleLabel:UILabel = {
        
        let label = UILabel(frame: .zero)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.textColor = .init(white: 1.0, alpha: 0.9)
        
        label.attributedText = NSAttributedString(
            string: label.text ?? " ",
            attributes: [
                NSAttributedString.Key.font:UIFont.systemFont(ofSize: 19, weight: .bold)
            ])
        
        return label
    }()
    
    lazy var descriptionLabel:UILabel = {
        
        let label = UILabel(frame: .zero)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .natural
        label.textColor = .init(white: 1.0, alpha: 0.9)
        label.numberOfLines = 3
        label.textAlignment = .center
        
        label.attributedText = NSAttributedString(
            string: label.text ?? " ",
            attributes: [
            NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)
        ])
        
        return label
    }()
    
    lazy var currencyLabel:UILabel = {
        
        let label = UILabel(frame: .zero)
        
        label.translatesAutoresizingMaskIntoConstraints = false
    
        label.textAlignment = .left
        label.textColor = .init(white: 1.0, alpha: 0.9)
    
        return label
    }()
    
    lazy var priceLabel:UILabel = {
        
        let label = UILabel(frame: .zero)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .right
        label.textColor = .init(white: 1.0, alpha: 0.9)
        
        return label
    }()
    
    fileprivate func setupViews(){
        
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        
        cellView.addSubview(productImageView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(descriptionLabel)
        cellView.addSubview(priceLabel)
        cellView.addSubview(currencyLabel)
        
        self.addSubview(cellView)
        
        DispatchQueue.main.async {

            self.setupConstraints()

        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder:NSCoder){
        fatalError()
    }
    
    //MARK: - Table View's Product's Cell Constraints Section
    private func setupConstraints(){
        
        // Cell's View Constraints Section
        cellView.topAnchor.constraint(
            equalTo:self.topAnchor,
            constant: 15
        ).isActive = true
        
        cellView.leftAnchor.constraint(
            equalTo: self.leftAnchor,
            constant: 5
        ).isActive = true
        
        cellView.rightAnchor.constraint(
            equalTo: self.rightAnchor,
            constant: -5
        ).isActive = true
        
        cellView.bottomAnchor.constraint(
            equalTo: self.bottomAnchor,
            constant: -15
        ).isActive = true
        
        
        // ProductImage Constraints Section
        productImageView.topAnchor.constraint(
            equalTo: cellView.topAnchor,
            constant: 5
        ).isActive = true
        
        productImageView.leftAnchor.constraint(
            equalTo: cellView.leftAnchor,
            constant: 5
        ).isActive = true
        
        productImageView.widthAnchor.constraint(
            equalToConstant: 120
        ).isActive = true
        
        productImageView.bottomAnchor.constraint(
            equalTo: cellView.bottomAnchor,
            constant: -5
        ).isActive = true
        
        // Product Title Constraints Section
        titleLabel.topAnchor.constraint(
            equalTo: cellView.topAnchor,
            constant: 5
        ).isActive = true
        
        titleLabel.leftAnchor.constraint(
            equalTo: productImageView.rightAnchor,
            constant: 10
        ).isActive = true
        
        titleLabel.rightAnchor.constraint(
            equalTo: cellView.rightAnchor,
            constant: -10
        ).isActive = true
        
        titleLabel.heightAnchor.constraint(
            equalToConstant: 35
        ).isActive = true
        
        // Description Label Constraints Section
        descriptionLabel.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: 10
        ).isActive = true
        
        descriptionLabel.leftAnchor.constraint(
            equalTo: titleLabel.leftAnchor
        ).isActive = true
        
        descriptionLabel.rightAnchor.constraint(
            equalTo: titleLabel.rightAnchor
        ).isActive = true
        
        descriptionLabel.heightAnchor.constraint(
            equalToConstant: 45
        ).isActive = true
        
        // Price Label Constraints Section
        priceLabel.topAnchor.constraint(
            equalTo: currencyLabel.topAnchor
        ).isActive = true

        priceLabel.rightAnchor.constraint(
            equalTo: descriptionLabel.centerXAnchor,
            constant: -2
        ).isActive = true
        
        priceLabel.widthAnchor.constraint(
            equalToConstant: 50
        ).isActive = true
        
        priceLabel.bottomAnchor.constraint(
            equalTo: cellView.bottomAnchor,constant: -5
        ).isActive = true
        
        // Currency Label Constraints Section
        currencyLabel.topAnchor.constraint(
            equalTo: descriptionLabel.bottomAnchor,
            constant: 5
        ).isActive = true
        
        currencyLabel.leftAnchor.constraint(
            equalTo: descriptionLabel.centerXAnchor,
            constant: 2
        ).isActive = true
        
        currencyLabel.widthAnchor.constraint(
            equalToConstant: 40
        ).isActive = true
        
        currencyLabel.bottomAnchor.constraint(
            equalTo: cellView.bottomAnchor,
            constant: -5
        ).isActive = true
        
    }
    
}

//MARK: - MenuViewController class
final class MenuViewController: UIViewController,UINavigationControllerDelegate {
    
    fileprivate var subscriberCategories:AnyCancellable?
    
    fileprivate var subscriberProducts:AnyCancellable?
    
    var menuViewModel = MenuViewModel()
    
    var menuGroupCollectionView:UICollectionView?
    
    var menuProductsScrollView:UIScrollView?
    
    var menuProductsTableViews:[UITableView] = []
    
    var preselectedMenuGroupCellIndexPath:IndexPath?
    
    var currentCategory:Category? = nil
    
    private func initializeBackgroundView(){
        
        let bgImageView = UIImageView(frame: view.bounds)
        
        bgImageView.image = UIImage(named: "mojito.jpg")
        bgImageView.contentMode = .scaleAspectFill
        
        let blurEffect = UIBlurEffect(style: .dark)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = bgImageView.bounds
        
        bgImageView.addSubview(blurEffectView)
        
        
        view.addSubview(bgImageView)
        
    }
    
    private func inititalizeNavigationBarView(){
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.layoutIfNeeded()
        
        let titleTextAttributes:[NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font:UIFont.systemFont(ofSize: 21, weight: .bold),
            NSAttributedString.Key.foregroundColor:UIColor.init(white: 1.0, alpha: 0.9)
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
        
//        menuProductsScrollView?.layer.borderColor = UIColor.green.cgColor
//        menuProductsScrollView?.layer.borderWidth = 2
        
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
        
        for category in menuViewModel.categories{
            
            let tableView = createProductsTableView()
            tableView.restorationIdentifier = String(category.name)
            
            tableView.estimatedRowHeight = 150

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
        
        menuProductsTableView.delegate = self
        menuProductsTableView.dataSource = self
        
        menuProductsTableView.backgroundColor = .clear
        
        menuProductsTableView.layer.cornerRadius = 10
        menuProductsTableView.layer.masksToBounds = true
        
        menuProductsTableView.estimatedRowHeight = 150
        menuProductsTableView.separatorStyle = .none
        
        menuProductsTableView.register(
            MenuProductsTableViewCell.self,
            forCellReuseIdentifier: "productTableViewCell"
        )
        
        return menuProductsTableView
    }
    
    private func initializeMenuGroupSubscriber(){
        
        menuViewModel.fetchMenuFromDatabase()
 
            subscriberCategories = menuViewModel.$categories.sink{
                
                [weak self] categories in
                
                if categories.count != 0 {
                    
                    DispatchQueue.main.async {
                        
                        self?.menuGroupCollectionView?.reloadData()
                        
                        self?.menuGroupCollectionView?.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                        
                        self?.initializeMenuProductsTableViews()
                        
                        
                    }
                    
                }
                
            }
        
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

