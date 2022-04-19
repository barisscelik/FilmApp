//
//  FilmTableViewCell.swift
//  FilmApp
//
//  Created by barış çelik on 19.04.2022.
//

import UIKit

class FilmTableViewCell: UITableViewCell {
    
    static let identifier = "FilmTableViewCell"

    let image = UIImageView()
    let title = UILabel()
    let directorAndTime = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        image.backgroundColor = UIColor.blue

        image.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        directorAndTime.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(directorAndTime)
        
        image.frame = CGRect(x: 5, y: 5,
                             width: contentView.frame.width - 10 / 3,
                             height: contentView.frame.height - 10)
        
        title.frame = CGRect(x: contentView.frame.width / 2 - 5, y: 5,
                             width: contentView.frame.width / 2 - 10,
                             height: contentView.frame.height / 2 - 10)
        
        directorAndTime.frame = CGRect(x: contentView.frame.width / 2 - 5,
                                y: contentView.frame.height / 2,
                                width: contentView.frame.width / 2 - 10,
                                height: contentView.frame.height / 2 - 10)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: String, title: String, director: String, year: String) {
        
        OMDBAPICalller.shared.getImage(urlString: image) { [weak self] image in
            if let image = image {
                DispatchQueue.main.async {
                    self?.image.image = image
                }
                
            }
        }
        self.title.text = title
        self.directorAndTime.text = "\(director) // \(year)"
        
    }
    
}
