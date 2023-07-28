//
//  ViewController.swift
//  CoreData Students
//
//  Created by Yusmi Putra on 7/26/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableViewStudent: UITableView!
    var student: [Students] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let searchController = UISearchController(searchResultsController: nil)
    var filterStudents: [Students] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.placeholder = "Cari Student"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        tableViewStudent.tableHeaderView = searchController.searchBar
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let studentFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
            student = try context.fetch(studentFetch) as! [Students]
            
        } catch {
            print(error)
        }
        
        tableViewStudent.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && !((searchController.searchBar.text?.isEmpty)!) {
            return filterStudents.count
        } else {
            return student.count
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewStudent.dequeueReusableCell(withIdentifier: "StudentsCell", for: indexPath) as! StudentsCell
        let student1: Students
        
        if searchController.isActive && !((searchController.searchBar.text?.isEmpty)!) {
            student1 = filterStudents[indexPath.row]
        } else {
            student1 = student[indexPath.row]
        }
        
        
        cell.firstNameStudent.text = student1.firstName
        cell.lastNameStudent.text = student1.lastName
        if let imageData = student1.image {
            cell.imageStudent.image = UIImage(data: imageData as Data)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = student[indexPath.row]
        
        print("student \(student.id)")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detaiVc = storyBoard.instantiateViewController(withIdentifier: "DetailStudentController") as! DetailStudentController
        detaiVc.dataDetail = student
        self.present(detaiVc, animated: true, completion: nil)
        
        
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let keyword = searchController.searchBar.text!
        
        if keyword.count > 0 {
            let studentSearch = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
            let predicat1 = NSPredicate(format: "firstName CONTAINS[c] %@", keyword)
            let predicat2 = NSPredicate(format: "lastName CONTAINS[c] %@", keyword)
            
            let predicateCompound = NSCompoundPredicate(type: .or, subpredicates: [predicat1, predicat2])
            studentSearch.predicate = predicateCompound
            
            do {
                let studentFilter = try context.fetch(studentSearch) as! [NSManagedObject]
                filterStudents = studentFilter as! [Students]
            } catch {
                print(error)
            }
            
            self.tableViewStudent.reloadData()
        } else {
            self.tableViewStudent.reloadData()
        }
    }
}

