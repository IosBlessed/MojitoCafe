//
//  Extension + MenuVC.swift
//  Mojito Cafe
//
//  Created by Никита Данилович on 06.04.2023.
//

import UIKit


extension MenuViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return groups.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let menuGroupCell = menuGroupCollectionView?.dequeueReusableCell(
                withReuseIdentifier: "menuSection",
                for: indexPath
            ) as? MenuGroupCollectionViewCell
        
            menuGroupCell?.initializeCellView()
            
            menuGroupCell?.sectionNameLabel.text = groups[indexPath.row]
            
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let
        
        return UITableViewCell(frame: .zero)
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
