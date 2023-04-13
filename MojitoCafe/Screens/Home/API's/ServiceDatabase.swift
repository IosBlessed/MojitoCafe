//
//  DatabaseDataExtraction.swift
//  MojitoCafe
//
//  Created by Никита Данилович on 11.04.2023.
//

import FirebaseFirestore

class APIDatabase{
    
    static var shared = APIDatabase()
    
    private init(){}
    
    func getCategoriesFromFirestore(collection:String, completion: @escaping([Category]?,Error?) -> Void){
        
        let firestore = Firestore.firestore()
        
        firestore.collection(collection).getDocuments{
            
            QuerySnapshot,error in
            
            guard error == nil else{
                
                return completion(nil,error!)
            }
            var documents = QuerySnapshot?.documents.map{
                document in
                
                document.data()
            }
            
            documents = documents?.sorted{
                firstID,secondID in
                
                (firstID["id"] as? Int ?? -1) < (secondID["id"] as? Int ?? -1)
            }
            
            if let documents = documents{
                
                let categories = documents.map{
                    document in
                    
                    let categoryID = document["id"] as? Int ?? 0
                    let categoryName = document["name"] as? String ?? "Unknown category"
                    
                    return Category(name: categoryName, id: categoryID)
                }
                return completion(categories,nil)
            }
        }
    }
    
    func getProductsFromFirestore(collection:String, completion:@escaping([Product]?,Error?) -> Void){
        
        let firestore = Firestore.firestore()
        
        firestore.collection(collection).getDocuments{
            QuerySnapshot, error in
            
            guard error == nil else {
                completion(nil,error)
                return
            }
            
            let products = QuerySnapshot?.documents.map{
                document in
                
                document.data()
            }
            
            
            if let products = products{
                
                let productsArray:[Product] = products.map{
                    product in
                    let id = product["id"] as? Int ?? -1
                    let title = product["name"] as? String ?? "Unknown"
                    let categoryID = product["categoryID"] as? Int ?? -1
                    let currency = product["currency"] as? String ?? "Unknown"
                    let description = product["description"] as? String ?? "Unknown"
                    let price = product["price"] as? Int ?? -100
                    let imagePath = product["imagePath"] as? String ?? "button.programmable"
                    
                    return Product(
                        id: id,
                        title: title,
                        description: description,
                        price: price,
                        currency: currency,
                        imagePath: imagePath,
                        categoryID: categoryID
                    )
                }
                
                completion(productsArray,nil)
                
            }
            
            
        }
        
    }
    
    
}
