//
//  RootViewController.swift
//  iOS5-Berresheim-Englisch
//
//  Created by Kenneth Englisch on 09.12.20.
//

import UIKit

class RootViewController : UITableViewController {
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var contacts = [AddressCard]()
    var contactName: String = ""
    var cellNames = ["First Name", "Last Name", "Street", "Number", "Zip Code", "City"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let del = UIApplication.shared.delegate as? AppDelegate {
            contacts = del.addressBook?.addressCards ?? [AddressCard]()
        }
        
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "Segue1", sender: self)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if !self.tableView.isEditing {
            self.tableView.setEditing(true, animated: true)
            editButton.title = "DONE"
        }
        else {
            self.tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let del = UIApplication.shared.delegate as? AppDelegate {
            contacts = del.addressBook?.addressCards ?? [AddressCard]()
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            contacts.remove(at: indexPath.row)
            saveAddressBook()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func saveAddressBook(){
        if let del = UIApplication.shared.delegate as? AppDelegate {
            del.addressBook?.addressCards = contacts //?? [AddressCard]()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = contacts[indexPath.row].firstname + " " + contacts[indexPath.row].lastname
        
        cell.detailTextLabel?.text = String (contacts[indexPath.row].zipcode) + " " + contacts[indexPath.row].city + ", " + contacts[indexPath.row].streetAndNumber
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue1" {
//            print("yas")
            if let cont = segue.destination as? DetailViewController {
                if let send = sender as? UITableViewCell {
                    cont.contactName = send.textLabel?.text ?? ""
                    cont.parentController = self
                    cont.isNew = false
                }
                if (sender as? UIBarButtonItem) != nil {
//                    print("test1")
                    cont.parentController = self
                }
            }
        }
    }
    
}
