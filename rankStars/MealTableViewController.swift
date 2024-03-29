//
//  MealTableViewController.swift
//  rankStars
//
//  Created by 马宝森 on 2019/4/20.
//  Copyright © 2019 马宝森. All rights reserved.
//

import UIKit
import os.log
import Foundation

class MealTableViewController: UITableViewController {
    //MARK: Properties
    var meals = [Meal]()
    var ratingFlag = 0
    var priceFlag = 0
    var timeFlag = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        let savedMeals = loadMeals()
        
        if savedMeals?.count ?? 0 > 0 {
            meals = savedMeals ?? [Meal]()
        } else {
            loadSampleMeals()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]

        // Configure the cell...
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        cell.price.text = String(meal.price)
        cell.neededTime.text = String(meal.neededTime)

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }

            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal

        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealDetailViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                // Add a new meal.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // Save the meals.
            saveMeals()
        }
    }
    @IBAction func sortedByRating(_ sender: UIBarButtonItem) {
        if ratingFlag == 0 {
            meals.sort(by: {$0.rating > $1.rating})
            ratingFlag = 1
        }else {
            meals.sort(by: {$0.rating < $1.rating})
            ratingFlag = 0
        }
        // Save the meals.
        saveMeals()
        viewDidLoad()
        tableView.reloadData()
    }
    @IBAction func sortedByPrice(_ sender: UIBarButtonItem) {
        if priceFlag == 0 {
            meals.sort(by: {$0.price > $1.price})
            priceFlag = 1
        }else {
            meals.sort(by: {$0.price < $1.price})
            priceFlag = 0
        }
        // Save the meals.
        saveMeals()
        viewDidLoad()
        tableView.reloadData()
    }
    @IBAction func sortedByNeededTime(_ sender: UIBarButtonItem) {
        if timeFlag == 0 {
            meals.sort(by: {$0.neededTime > $1.neededTime})
            timeFlag = 1
        }else {
            meals.sort(by: {$0.neededTime < $1.neededTime})
            timeFlag = 0
        }
        // Save the meals.
        saveMeals()
//        viewDidLoad()
        tableView.reloadData()
    }
    
    //MARK: Private Methods
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "红酒牛排", photo: photo1, rating: 4, price: 150, neededTime: 20) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "鸡蛋火腿三明治", photo: photo2, rating: 5, price: 15, neededTime: 8) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "虾仁鸡肉披萨", photo: photo3, rating: 3, price: 70, neededTime: 25) else {
            fatalError("Unable to instantiate meal3")
        }
        
        meals += [meal1, meal2, meal3]
    }
    
    private func saveMeals() {
        
        let fullPath = getDocumentsDirectory().appendingPathComponent("meals")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func loadMeals() -> [Meal]? {
        let fullPath = getDocumentsDirectory().appendingPathComponent("meals")
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                let data = Data(referencing:nsData)
                
                if let loadedMeals = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Meal> {
                    return loadedMeals
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
    

}
