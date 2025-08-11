//
//  ShapeCell.swift
//  MapplsSDKDemo
//
//  Created by rento on 24/01/25.
//

import UIKit

class ShapeCell: UITableViewCell {

    @IBOutlet weak var ShapeSwitch: UISwitch!
    @IBOutlet weak var lblGeofenceName: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Task {
            await themeProvider.register(observer: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension ShapeCell: AppThemeChangeable {
    func appThemeChanged(theme: ThemeColors) {
        DispatchQueue.main.async {
            self.contentView.backgroundColor = theme.backgroundPrimary
            self.ShapeSwitch.onTintColor = theme.accentBrandPrimary
            self.lblGeofenceName.textColor = theme.textPrimary
        }
    }
}
