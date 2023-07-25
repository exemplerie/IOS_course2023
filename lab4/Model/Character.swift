//
//  Character.swift
//  lab4
//
//  Created by Яна Павлова on 28.06.2023.
//
import Foundation
import UIKit

//struct CharacterData {
//    enum Status  {
//        case alive
//        case dead
//        case unknown
//    }
//
//    enum Gender {
//        case female
//        case male
//        case genderless
//        case unknown
//    }
//
//    let id: Int
//    let name: String
//    let status: Status
//    var species: String
//    let gender: Gender
//    var location: String
//    let image: String
//}




class Character: UITableViewCell {
    
    
    
    @IBOutlet weak var characterImage : UIImageView!
    @IBOutlet weak var IDLabel : UILabel!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var speciesLabel : UILabel!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var genderLabel : UILabel!
    @IBOutlet weak var statusLabel : UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let purpleAccentColor = UIColor(red: 0.8, green: 0.6, blue: 1.0, alpha: 0.2)
               
        backgroundColor = purpleAccentColor
        contentView.backgroundColor = purpleAccentColor
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    var characterModel: Model?
    var likeButtonAction: (() -> Void)?

        private func setupButton() {
            likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        }

        @objc private func likeButtonTapped() {
            guard let action = likeButtonAction else {
                return
            }

            action()
        }

//    var likeButtonAction: (() -> Void)?
//
//    private func setupButton() {
//            likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
//        }
//
//    @objc private func likeButtonTapped() {
//        guard let action = likeButtonAction else {
//            return
//        }
//
//        action()
//    }
    
    
    

    
    func setUpData (character : Model){
        characterModel = character
        
        IDLabel.text = String(character.id)
        IDLabel.textColor = .white
       
        nameLabel.text = "~" + character.name + "~"
        nameLabel.textColor = .white
        
        speciesLabel.text = character.species
        speciesLabel.textColor = .white
        
        locationLabel.text = character.location
        locationLabel.textColor = .white
        
        genderLabel.text = String (describing: character.gender)
        genderLabel.textColor = .white
        
        statusLabel.text = String(describing: character.status)
        statusLabel.textColor = .white
        
        characterImage.download(from: character.image)
        let buttonImage = character.isFavorite ? UIImage(named: "free-icon-heart-1550594-2") : UIImage(named: "free-icon-heart-shape-14815-2")
        likeButton.setImage(buttonImage, for: .normal)
            
        setupButton()
        
//        let buttonImage = character.isFavorite ? UIImage(named: "free-icon-heart-1550594-2") : UIImage(named: "free-icon-heart-shape-14815-2")
//        likeButton.setImage(buttonImage, for: .normal)
        
//        characterImage.image = UIImage(named: character.image)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        IDLabel.text = nil
        nameLabel.text = nil
        speciesLabel.text = nil
        locationLabel.text = nil
        genderLabel.text = nil
        statusLabel.text = nil
        characterImage.image = nil
    }

}

