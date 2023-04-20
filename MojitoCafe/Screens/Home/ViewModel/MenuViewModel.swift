//
//  MenuViewModel.swift
//  MojitoCafe
//
//  Created by Никита Данилович on 09.04.2023.
//

import Combine

protocol ProductViewProtocol:ObservableObject{
    
    var productPublished:Published<Product?>.Publisher {get}
    var productViewPublished:Published<ProductDetailsView?>.Publisher {get}
    
    var productView:ProductDetailsView?{get set}
    var product:Product?{get set}
    
    func setup() -> Void
}

protocol MenuViewControllerProtocol:ObservableObject{
    
    var categoriesPublished:Published<[Category]>.Publisher {get}
    var productsPublshed:Published<[Product]>.Publisher {get}
    
    var categories:[Category]{get set}
    var products:[Product] {get set}
    
    func fetchMenuFromDatabase() -> Void
    
}

final class MenuViewModel:MenuViewControllerProtocol,ProductViewProtocol{
    
    var categoriesPublished: Published<[Category]>.Publisher {$categories}
    
    var productsPublshed: Published<[Product]>.Publisher {$products}
    
    var productPublished:Published<Product?>.Publisher {$product}
    
    var productViewPublished: Published<ProductDetailsView?>.Publisher {$productView}
    
    
    @Published var categories: [Category] = [Category]()
    @Published var products: [Product] = [Product]()
    
    @Published var productView:ProductDetailsView?
    @Published var product:Product?
    
    func setup(){
        
        productView = ProductDetailsView()
        
        productView?.productDetails = self
        
        productView?.setupConstraints()
        
        productView?.setupProductDetailsSubscriber()
    
    }
    
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
