//
//  ListViewController.swift
//  TravelBook
//
//  Created by Ashish Sharma on 12/24/2022.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var placesidArray = [UUID]()
    var chosenName = ""
    var chosenID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlaceAdded"), object: nil)
        
    }
    
    @objc func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                
                self.nameArray.removeAll(keepingCapacity: false)
                self.placesidArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "name") as? String {
                        self.nameArray.append(title)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.placesidArray.append(id)
                    }
                    self.tableView.reloadData()
                }
            }
        } catch  {
            fatalError("Error retrieving data from Core Data! \(error)")
        }
        
        
    }
    
    @objc func addButtonClicked() {
        chosenName = ""
        performSegue(withIdentifier: "toViewController", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
//        print(placesidArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosenName = nameArray[indexPath.row]
        self.chosenID = placesidArray[indexPath.row]
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = self.chosenName
            destinationVC.selectedID = self.chosenID
        }
    }
 

}
