//
//  DataTableViewCell.swift
//  ChiragDemo
//
//  
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblOpen: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var lblLow: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
