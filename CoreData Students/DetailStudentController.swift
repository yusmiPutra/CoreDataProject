//
//  DetailStudentController.swift
//  CoreData Students
//
//  Created by Yusmi Putra on 7/27/23.
//

import UIKit
import CoreData

class DetailStudentController: UIViewController {
    
    @IBOutlet weak var tanggalLahirDetail: UILabel!
    @IBOutlet weak var lastnameDetail: UILabel!
    @IBOutlet weak var firstnameDetail: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    var dataDetail: Students?
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tanggalLahirDetail.text = dataDetail?.birthDate
        firstnameDetail.text = dataDetail?.firstName
        lastnameDetail.text = dataDetail?.lastName
        
        if let imageData = dataDetail?.image {
            imageDetail.image = UIImage(data: imageData as Data)
        }

        print("data \(dataDetail)")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func btnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "Apa anda yakin hapus data ini ?", preferredStyle: .actionSheet)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionOk = UIAlertAction(title: "Yes", style: .destructive) { action in
            let studentFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
            studentFetch.fetchLimit = 1
            studentFetch.predicate = NSPredicate(format: "id == \(self.dataDetail?.id ?? 0)")
            
            let result = try! self.context.fetch(studentFetch)
            let studentToDelete = result[0] as! NSManagedObject
            self.context.delete(studentToDelete)
            
            do {
                try self.context.save()
            } catch {
                print(error)
            }
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let editVc = segue.destination as! TambahStudentController
            editVc.studentId = Int(dataDetail?.id ?? 0)
        }
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
