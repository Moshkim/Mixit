//
//  TrackCell.swift


import Foundation
import UIKit
class TrackCell: UITableViewCell {
    @IBOutlet weak var lblAudioName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var sliderVolume: UISlider!
    
    override func awakeFromNib() {
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}