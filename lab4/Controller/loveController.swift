//
//  ViewController.swift
//  lab4
//
//  Created by Яна Павлова on 26.06.2023.
//
import CoreData
import UIKit

class loveController: UIViewController,  UITableViewDataSource, UITableViewDelegate , NSFetchedResultsControllerDelegate {
    
    
    

    
    
    lazy var favoriteCharactersFRC: NSFetchedResultsController<Model> = {
        let request = Model.fetchRequest()

        request.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))

        request.sortDescriptors = [
            .init(key: "id", ascending: true),
        ]
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: PersistentContainer.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        frc.delegate = self
        
        return frc
    }()

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = favoriteCharactersFRC.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Character", for: indexPath) as? Character else {
               return UITableViewCell()
           }
           
           let character = favoriteCharactersFRC.object(at: indexPath)
           cell.setUpData(character: character)
           
           cell.likeButtonAction = { [weak self] in
               self?.handleLikeButtonTapped(for: character)
           }
           
           return cell
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Character", for: indexPath) as? Character else {
//            return UITableViewCell()
//        }
//
//        let character = favoriteCharactersFRC.object(at: indexPath)
//        cell.setUpData(character: character)
//
//        return cell
    }
    
    private func handleLikeButtonTapped(for character: Model) {
        character.isFavorite = !character.isFavorite

        let buttonImage = character.isFavorite ? UIImage(named: "free-icon-heart-1550594-2") : UIImage(named: "free-icon-heart-shape-14815-2")

        for cell in favoriteCharacters.visibleCells {
            if let characterCell = cell as? Character, characterCell.characterModel == character {
                characterCell.likeButton.setImage(buttonImage, for: .normal)
                break
            }
        }

        do {
            try PersistentContainer.shared.viewContext.save()
        } catch {
            print("Error saving changes: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let characterInfoView = storyboard?.instantiateViewController(identifier: "characterInfoViewController") as? characterInfoViewController else { return }
        characterInfoView.delegate = self
        present(characterInfoView, animated: true)
        
        // Get the character from the fetched results controller
        let character = favoriteCharactersFRC.object(at: indexPath)
        
        // Pass the character data to the characterInfoView
        characterInfoView.data = character
    }
    
   
    @IBOutlet weak var favoriteCharacters: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCharacters.backgroundColor = .clear
        favoriteCharacters.separatorColor = .white
        favoriteCharacters.dataSource = self
        favoriteCharacters.delegate = self
            
            do {
                try favoriteCharactersFRC.performFetch()
            } catch {
                print("Error performing fetch for favoriteCharactersFRC: \(error)")
            }
      
    }
   
}
extension loveController {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoriteCharacters.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                favoriteCharacters.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                favoriteCharacters.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = favoriteCharacters.cellForRow(at: indexPath) as? Character {
                let character = favoriteCharactersFRC.object(at: indexPath)
                cell.setUpData(character: character)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                favoriteCharacters.moveRow(at: indexPath, to: newIndexPath)
            }
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoriteCharacters.endUpdates()
    }
    
    
    
    
}

extension loveController : characterInfoViewControllerDelegate{

    func changeLocation(with id: Int, and newLocation: String) {
        let fetchRequest: NSFetchRequest<Model> = Model.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try PersistentContainer.shared.viewContext.fetch(fetchRequest)
            if let model = results.first {
                model.location = newLocation
                try PersistentContainer.shared.viewContext.save()
                favoriteCharacters.reloadData()


            }
        } catch {
            print("Error updating location: \(error)")
        }
    }

    func changeSpicices(with id: Int, and newSpecies: String) {
        let fetchRequest: NSFetchRequest<Model> = Model.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try PersistentContainer.shared.viewContext.fetch(fetchRequest)
            if let model = results.first {
                model.species = newSpecies
                try PersistentContainer.shared.viewContext.save()
                favoriteCharacters.reloadData()
            }
        } catch {
            print("Error updating species: \(error)")
        }
    }
}


