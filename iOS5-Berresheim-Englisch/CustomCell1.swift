//
//  CustomCell1.swift
//  iOS5-Berresheim-Englisch
//
//  Created by Kenneth Englisch on 16.12.20.
//
import UIKit

class CustomCell1: UITableViewCell {
    
    var controller: DetailViewController?
    var indexPath: IndexPath?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UITextField!
    
    @IBAction func detailChanged(_ sender: UITextField) {
        detail.text = sender.text
        controller?.updateCard(indexPath: indexPath, detail: detail.text)
    }
}
