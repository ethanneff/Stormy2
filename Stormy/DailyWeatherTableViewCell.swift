//
//  DailyWeatherTableViewCell.swift
//  Stormy
//
//  Created by Ethan Neff on 2/10/16.
//  Copyright © 2016 eneff. All rights reserved.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
