//
//  ViewController.swift
//  lab4
//
//  Created by Яна Павлова on 26.06.2023.
//
import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    lazy var frc: NSFetchedResultsController<Model> = {
        let request = Model.fetchRequest()
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
    
    
    @IBOutlet weak var CharacterView: UITableView!
    
    private var characters : [CharacterModel] = []
    private let networkManager: NetworkManager = NetworkManager()
    
    var model: Model?
    
    func printNumberOfElementsInCoreData() {
        let fetchRequest: NSFetchRequest<Model> = Model.fetchRequest()
        
        do {
            let count = try PersistentContainer.shared.viewContext.count(for: fetchRequest)
            print("Количество сохраненных элементов: \(count)")
        } catch {
            print("у тебя ошибка: \(error)")
        }
    }
    
    func printAllElementsInCoreData() {
        let fetchRequest: NSFetchRequest<Model> = Model.fetchRequest()
        
        do {
            let results = try PersistentContainer.shared.viewContext.fetch(fetchRequest)
            
            for model in results {
                // Access and print the properties of each model object
                print("ID: \(model.id), имя: \(String(describing: model.name)), Gender: \(String(describing: model.gender)), Species: \(String(describing: model.species)), Location: \(String(describing: model.location)), Status: \(String(describing: model.status)), image: \(String(describing: model.image))")
            }
        } catch {
            print("Error fetching objects: \(error)")
        }
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Model")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try PersistentContainer.shared.persistentStoreCoordinator.execute(deleteRequest, with: PersistentContainer.shared.viewContext)
            print("All elements deleted from Core Data.")
        } catch {
            print("Error deleting objects: \(error)")
        }
    }

    private func loadCharacter(byId: Int) {
        networkManager.fetchCharacter(characterID : byId, completion: { [weak self]
            result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let characterResponse):
                weakSelf.characters.append(characterResponse)
                weakSelf.CharacterView.reloadData()
                PersistentContainer.shared.performBackgroundTask { [weak self] backgroundContext in
                    guard let self else { return }
                    let fetchRequest: NSFetchRequest<Model> = Model.fetchRequest()
                        fetchRequest.predicate = NSPredicate(format: "id == %d", byId)
                        
                        do {
                            let count = try PersistentContainer.shared.viewContext.count(for: fetchRequest)
                            if count > 0 {
                                return
                            }
                        } catch {
                            print("Error fetching objects: \(error)")
                            return
                        }
                    let newModel = self.model ?? Model(context: backgroundContext)

                    
                    newModel.name = characterResponse.name
                    newModel.id = Int16(characterResponse.id)
                    newModel.gender = characterResponse.gender
                    newModel.image = characterResponse.image
                    newModel.location = characterResponse.location.name
                    newModel.status = characterResponse.status
                    newModel.species = characterResponse.species
                    PersistentContainer.shared.saveContext(backgroundContext: backgroundContext)
                    
                }
                
            case let .failure(error):
                print(error)
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CharacterView.delegate = self
        CharacterView.dataSource = self
        CharacterView.backgroundColor = .clear
        CharacterView.separatorColor = .white
        
        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        
//        deleteAllData()
        
        for currentID in 70 ... 80{
            loadCharacter(byId: currentID)
        }

//        printAllElementsInCoreData()
//        printNumberOfElementsInCoreData()
    }
    //MARK: - tableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let characterInfoView = storyboard?.instantiateViewController(identifier: "characterInfoViewController") as? characterInfoViewController else {return }
        characterInfoView.delegate = self
        present(characterInfoView, animated: true)
        characterInfoView.data = frc.object(at: indexPath)
    }
    
    //MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = frc.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let characterCell = tableView.dequeueReusableCell(withIdentifier: "Character") as? Character else {return UITableViewCell()}
        let character = frc.object(at: indexPath)
        characterCell.setUpData(character: character)
        return characterCell
    }


}

extension ViewController: characterInfoViewControllerDelegate {
    
    func changeLocation(with id: Int, and newLocation: String) {
        let fetchRequest: NSFetchRequest<Model> = Model.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try PersistentContainer.shared.viewContext.fetch(fetchRequest)
            if let model = results.first {
                model.location = newLocation
                try PersistentContainer.shared.viewContext.save()
                CharacterView.reloadData()
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
                CharacterView.reloadData()
            }
        } catch {
            print("Error updating species: \(error)")
        }
    }
}


