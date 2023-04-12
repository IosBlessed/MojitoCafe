//
//  MenuViewModel.swift
//  MojitoCafe
//
//  Created by Никита Данилович on 09.04.2023.
//

import Combine

final class MenuViewModel{
    
    @Published var groups:[String] = [String]()
    
    func fetchCategories(){
        
        APIDatabase.shared.getCategoriesFromFirestore(collection: "menuCategories"){
           [weak self] categories, error in
            
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let categories = categories else {return}
        
            var menuGroups:[String] = []
            
            for category in categories{
                menuGroups.append(category.name)
            }
            self?.groups = menuGroups
        }
        
    }
    
}
