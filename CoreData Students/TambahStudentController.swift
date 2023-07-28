//
//  TambahStudentController.swift
//  CoreData Students
//
//  Created by Yusmi Putra on 7/26/23.
//

import UIKit
import CoreData

class TambahStudentController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pickImage: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    var studentId = 0
    let imagePicker = UIImagePickerController()
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        if studentId != 0 {
            let studentFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
            studentFetch.fetchLimit = 1
            
            studentFetch.predicate = NSPredicate(format:  "id == \(studentId)")
            
            let result = try! context.fetch(studentFetch)
            let student: Students = result.first as! Students
            
            
            firstName.text = student.firstName
            lastName.text = student.lastName
            email.text = student.email
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd-MM-yyyy"
            
            let date = dateFormater.date(from: student.birthDate!)
            datePicker.date = date!
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ambilGambar(_ sender: Any) {
        self.selectInage()
    }
    
    func selectInage() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickImage.contentMode = .scaleToFill
            self.pickImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSimpan(_ sender: Any) {
        guard let firstName = firstName.text, firstName != "" else {
            let alert = UIAlertController(title: "message", message: "FirstName is required", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        guard let lastName = lastName.text, lastName != "" else {
            let alert = UIAlertController(title: "message", message: "LastName is required", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        guard let email = email.text, email != "" else {
            let alert = UIAlertController(title: "message", message: "Email is required", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let birthDate = dateFormatter.string(from: datePicker.date)
        
        if studentId > 0 {
            let studentFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
            studentFetch.fetchLimit = 1
            
            studentFetch.predicate = NSPredicate(format: "id == \(studentId)")
            
            let result = try! context.fetch(studentFetch)
            let studentToEdit:Students = result.first as! Students
            
            studentToEdit.firstName = firstName
            studentToEdit.lastName = lastName
            studentToEdit.email = email
            
            let stringDate = dateFormatter.string(from: datePicker.date)
            studentToEdit.birthDate = stringDate
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        } else {
            let student = Students(context: context)
            let request: NSFetchRequest = Students.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
            request.sortDescriptors = [sortDescriptor]
            request.fetchLimit = 1
            
            var maxId = 0
            
            do {
                let lastStudent = try context.fetch(request)
                maxId = Int(lastStudent.first?.id ?? 0)
            } catch {
                print(error)
            }
            
            student.id = Int32(maxId) + 1
            student.firstName = firstName
            student.lastName = lastName
            student.email = email
            student.birthDate = birthDate
            
            if let img = pickImage.image {
                let data = img.pngData() as NSData?
                student.image = data as Data?
            }
            
            do {
                try context.save()
                print(student)
            } catch {
                print(error)
            }
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.present(vc, animated: true, completion: nil)

        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
