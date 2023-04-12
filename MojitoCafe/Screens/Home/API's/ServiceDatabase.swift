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
                    
                    return Category(name: categoryName, id: categoryID )
                }
                return completion(categories,nil)
            }
        }
    }
    
    
}
