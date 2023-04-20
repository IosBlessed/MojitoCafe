//
//  ProductDetailsView.swift
//  MojitoCafe
//
//  Created by Никита Данилович on 18.04.2023.
//

import UIKit

class ProductDetailsView: UIView {
    
   private lazy var viewForScrollView:UIView = {
        
        let view = UIView(frame: .zero)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .clear
        
        view.layer.cornerRadius = 20
        view.layer.shadowOffset = .zero
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 1.0
        
        return view
    }()
    
    
    private lazy var scrollView:UIScrollView = {
        
        let scrollView = UIScrollView(frame: .zero)
        
        scrollView.delegate = self
        
        scrollView.translatesAutoresizingMaskIntoConstraints = true
    
        scrollView.autoresizingMask = .flexibleWidth
        
        scrollView.backgroundColor = .gray
        
        scrollView.indicatorStyle = .black
        scrollView.contentSize = CGSize(width: 192.0, height: 1200)
        scrollView.showsVerticalScrollIndicator = true
        
        scrollView.layer.cornerRadius = 20.0
        
        
        return scrollView
    }()
    
   private lazy var contentView:UIView = {
        
        let contentView = UIView(frame: .zero)
        
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        contentView.autoresizingMask = .flexibleWidth
        
        contentView.layer.masksToBounds = false
        
        contentView.backgroundColor = .red
        
        return contentView
    }()
    
    lazy var productTitleLabel:UILabel = {
        
        let label = UILabel(frame: .zero)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        //label.autoresizingMask = .flexibleWidth
        
        label.backgroundColor = .white
        label.textAlignment = .center
        label.tintColor = .black
        
        label.text = "Солянка"
        
        label.attributedText = NSAttributedString(string: label.text ?? "" ,attributes: [
            NSAttributedString.Key.font:UIFont.systemFont(ofSize: 22, weight: .bold)
        ])
        
        
        return label
    }()
    
    
    private func initialSetup(){
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeView))
        
        self.addGestureRecognizer(tapRecognizer)
        
        self.addSubview(viewForScrollView)
        viewForScrollView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(productTitleLabel)
                
    }
    
    @objc func removeView(){
        
        self.removeFromSuperview()
        
    }
    
    private func setupConstraints(){
        
        viewForScrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        viewForScrollView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        viewForScrollView.widthAnchor.constraint(equalToConstant: self.bounds.width/1.2).isActive = true

        viewForScrollView.heightAnchor.constraint(equalToConstant: self.bounds.height/2.5).isActive = true

       
        //For view's inside content view bounds
      
        productTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20).isActive = true

        productTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true

        productTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true

        productTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
       
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.3){
                self.scrollView.frame = self.viewForScrollView.bounds
            }
            self.contentView.frame = self.scrollView.bounds
            
        }
        
    }
   

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    init(){
        super.init(frame: .zero)
        initialSetup()
        
        DispatchQueue.main.async {
            self.setupConstraints()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProductDetailsView:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("yes")
    }
}
