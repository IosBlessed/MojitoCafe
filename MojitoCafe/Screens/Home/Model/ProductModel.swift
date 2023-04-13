//
//  ProductModel.swift
//  Mojito Cafe
//
//  Created by Никита Данилович on 08.04.2023.
//


struct Category{
    
    var id:Int
    var name:String
    
    var products:[Product]?
    
    init(name: String, id:Int, products:[Product]? = nil) {
        self.id = id
        self.name = name
        self.products = products
    }

}

struct Product{
    
    var id:Int
    var title:String
    var description:String
    var price:Int
    var currency:String
    var imagePath:String
    var categoryID:Int
    
    init(id:Int,title: String, description: String, price: Int, currency:String, imagePath: String, categoryID:Int) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.currency = currency
        self.imagePath = imagePath
        self.categoryID = categoryID
    }
    
}
