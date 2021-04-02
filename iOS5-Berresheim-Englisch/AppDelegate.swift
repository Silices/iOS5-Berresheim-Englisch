//
//  AppDelegate.swift
//  iOS5-Berresheim-Englisch
//
//  Created by Kenneth Englisch on 09.12.20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var addressBook: AddressBook?
    var filePath = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let urls = FileManager.default.urls(for: .documentDirectory,
        in: .userDomainMask)
        let url = urls.first // first element of array (optional)
        if let path = url?.path {
        // received path as String
            filePath = (path as NSString).appendingPathComponent("book.plist")
            addressBook = AddressBook.addressBook(fromFile: filePath)

            if addressBook ==  nil{
                addressBook = AddressBook()
                
                addressBook?.add(card: AddressCard.init(firstname: "Rainer", lastname: "Zufall", streetAndNumber: "Sackgasse 1", zipcode: 12345, city: "Hier", hobbies:["nein"]))
                
                addressBook?.add(card: AddressCard.init(firstname: "Amanda", lastname: "DerMichKnutscht", streetAndNumber: "Unerreichbar 13", zipcode: 12345, city: "Hier", hobbies:["Reiten", "Ballet", "Kirschkernweitspucken"]))
                
                addressBook?.addressCards[1].add(friend: (addressBook?.addressCards[0])!)
            }
            
            addressBook?.sortAddressCards()
        }
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate.
    // Save data if appropriate. See also
    // applicationDidEnterBackground:.
        addressBook?.save(toFile: filePath)
    }

}

