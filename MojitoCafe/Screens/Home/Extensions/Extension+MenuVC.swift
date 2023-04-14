//
//  Extension + MenuVC.swift
//  Mojito Cafe
//
//  Created by Никита Данилович on 06.04.2023.
//

import UIKit
import SDWebImage


extension MenuViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menuViewModel.categories.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let menuGroupCell = menuGroupCollectionView?.dequeueReusableCell(
                withReuseIdentifier: "menuSection",
                for: indexPath
            ) as? MenuGroupCollectionViewCell
        
            menuGroupCell?.initializeCellView()
        
            let title = menuViewModel.categories[indexPath.row].name
            
            menuGroupCell?.sectionNameLabel.text = title
            
            return menuGroupCell ?? UICollectionViewCell(frame: .zero)
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return CGSize(width: 150, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            if let index = preselectedMenuGroupCellIndexPath{
                collectionView.deselectItem(at: index, animated: true)
            }
            
            collectionView.selectItem(
                at: indexPath,
                animated: true,
                scrollPosition: .centeredHorizontally
            )

            collectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: true
            )
        
            preselectedMenuGroupCellIndexPath = indexPath
        
        let contentXOffset:CGFloat = CGFloat(indexPath.row) * (menuProductsScrollView?.bounds.width ?? 373.0)
        
        menuProductsScrollView?.setContentOffset(
            CGPoint(
                x: contentXOffset,
                y: 0
            ),
            animated: true
        )
    }
    
}

extension MenuViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        for category in menuViewModel.categories{
            if category.name == tableView.restorationIdentifier{
                currentCategory = category
            }
        }
        return currentCategory?.products?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell") as? MenuProductsTableViewCell{
            
            
            guard let products = currentCategory?.products else{
                print("Error! Unrecognized products section")
                return cell
            }
            if let urlImage = URL(string: products[indexPath.row].imagePath){
                cell.productImageView.sd_setImage(with: urlImage)
            }else{
                cell.productImageView.image = UIImage(named: "mojito.jpg")
            }
            cell.titleLabel.text = products[indexPath.row].title
            cell.descriptionLabel.text = products[indexPath.row].description
            cell.currencyLabel.text = products[indexPath.row].currency
            cell.priceLabel.text = String(products[indexPath.row].price)
            
            return cell
        }
        
        
       fatalError("Unexpectendly found nil at dequeue of reusable cell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170
    }
    
}

extension MenuViewController:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == menuProductsScrollView{
            
            let tableViewXoffset:Int = Int(scrollView.contentOffset.x)
            let contentWidth:Int = Int(scrollView.bounds.width)
            
            let menuGrupSection = tableViewXoffset / contentWidth

            menuGroupCollectionView?.selectItem(
                at: IndexPath(item: menuGrupSection, section: 0),
                animated: true,
                scrollPosition: .centeredHorizontally)
        }
    }
    
}
