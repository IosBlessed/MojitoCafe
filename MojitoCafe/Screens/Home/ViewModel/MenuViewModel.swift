//
//  MenuViewModel.swift
//  MojitoCafe
//
//  Created by Никита Данилович on 09.04.2023.
//

import Combine
import UIKit

final class MenuViewModel{
    
    @Published var categories:[Category] = [Category]()
    @Published var products:[Product] = [Product]()
    
    func fetchMenuFromDatabase(){
        
        APIDatabase.shared.getCategoriesFromFirestore(collection: "menuCategories"){
           [weak self] categories, error in
            
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            
            if let self = self{
                
                if let categories = categories{
                    
                    var categoriesArray:[Category] = []
                    
                    for category in categories {
                        
                        var productsInCategory:[Product] = []
                        
                        for product in self.products{
                           
                            if category.id == product.categoryID{
                                productsInCategory.append(product)
                            }
                        }
                        let category = Category(name: category.name, id: category.id,products: productsInCategory)
                        
                        categoriesArray.append(category)
                    }

                    
                    self.categories = categoriesArray
                }
            
            }
           
        }
        
        APIDatabase.shared.getProductsFromFirestore(collection: "menuProducts"){
            [weak self] products, error in
            
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            
            if let products = products{
                
                self?.products = products
                            
            }
            
            
        }
        
        
    }
    
}
