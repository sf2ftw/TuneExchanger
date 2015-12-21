//
//  TuneTableViewCell.swift
//  Tune Exchanger
//
//  Created by I.T. Support on 08/12/2015.
//  Copyright © 2015 STV. All rights reserved.
//

import UIKit

class TuneTableViewCell: UITableViewCell {

    var currentTune : Tune? {
        didSet{
            if currentTune!.title != nil {
                titleLabel.text = currentTune!.title
            }
            if currentTune!.tuneKey != nil {
                keyLabel.text = currentTune!.tuneKey
            }
            else {
            keyLabel.text = nil
            }
            if currentTune!.tuneType != nil {
                typeLabel.text = currentTune!.tuneType
            } else {
                typeLabel.text = nil
            }
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
