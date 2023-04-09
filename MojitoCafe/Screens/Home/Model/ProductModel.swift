//
//  ProductModel.swift
//  Mojito Cafe
//
//  Created by Никита Данилович on 08.04.2023.
//
struct Category{
    
    var id:Int
    var name:String
    
    init(name: String, id:Int) {
        self.id = id
        self.name = name
    }

}

struct Product{
    
    var id:Int
    var title:String
    var description:String
    var price:Int
    var imagePath:String
    var categoryID:Int
    
    init(id:Int,title: String, description: String, price: Int, imagePath: String, categoryID:Int) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.imagePath = imagePath
        self.categoryID = categoryID
    }
    
}
