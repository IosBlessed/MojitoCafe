//
//  Configuration.swift
//  Myata Cafe
//
//  Created by Никита Данилович on 06.04.2023.
//
import UIKit
import FirebaseCore
import FirebaseFirestore

final class Configuration{

    static var configure = Configuration()
    
    private init(){}
    
    func inititalizeMainScreen(for window:UIWindow){
        
        let mainVC = MenuViewController()
        
        let mainNavigationVC = UINavigationController(rootViewController: mainVC)
        
        window.rootViewController = mainNavigationVC
        
        window.makeKeyAndVisible()
        
    }
    
}
