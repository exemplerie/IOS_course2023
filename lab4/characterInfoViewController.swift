//
//  characterInfoViewController.swift
//  lab4
//
//  Created by Яна Павлова on 30.06.2023.
//

import UIKit

protocol characterInfoViewControllerDelegate : AnyObject{
    func changeSpicices(with id : Int, and newSpicies : String)
    func changeLocation(with id : Int, and newLocation : String)
}

final class characterInfoViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.5, green: 0.6, blue: 1.0, alpha: 0.9)
    }
    
    var delegate : characterInfoViewControllerDelegate?
    
    var data : Model?{
        didSet{
            guard let data else {return }
            setUpData(character: data)
        }
    }
    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var idLabel: UITextView!
    @IBOutlet weak var spiciesLabel: UITextView!
    @IBOutlet weak var locationLabel: UITextView!
    @IBOutlet weak var statusLabel: UITextView!
    @IBOutlet weak var genderLabel: UITextView!
    
    @IBAction func speciesButton(_ sender: Any) {

        let alert = UIAlertController(title: "Enter New Value", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "Spicies"}
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: {_ in if let newSpicies = alert.textFields?.first?.text{self.spiciesLabel.text = newSpicies
            guard let myData =  self.data else {return}
            self.delegate?.changeSpicices(with: Int(myData.id), and: newSpicies)
        }

        })
        alert.addAction(doneAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func locationButtion(_ sender: Any) {
        let alert = UIAlertController(title: "Enter New Value", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "Location"}
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: {_ in if let newLocation = alert.textFields?.first?.text{self.locationLabel.text = newLocation
            guard let myData = self.data else {return}
            self.delegate?.changeLocation(with: Int(myData.id), and: newLocation)
        }})
        alert.addAction(doneAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func setUpData (character : Model){
        idLabel.text = String(character.id)
        idLabel.textColor = .white
        
        nameLabel.text = "~" + character.name + "~"
        nameLabel.textColor = .white
        
        spiciesLabel.text = character.species
        spiciesLabel.textColor = .white
        
        locationLabel.text = character.location
        locationLabel.textColor = .white
        
        genderLabel.text = character.gender
        genderLabel.textColor = .white
        
        statusLabel.text = character.status
        statusLabel.textColor = .white
        
        characterImage.download(from: character.image)
//        characterImage.image = UIImage(named: character.image)
        
    }
}


