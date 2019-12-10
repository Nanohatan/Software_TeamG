//
//  AddTaskViewController.swift
//  LoginDemo
//
//  Created by 本間ののか on 2019/12/03.
//  Copyright © 2019 本間ののか. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddTaskViewController: UIViewController{
    
    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBOutlet weak var memoTextField: UITextView!
    @IBOutlet weak var errorLablel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLablel.alpha = 0
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if taskNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || memoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        return nil
    }
    
    func showError(_ message:String) {
        errorLablel.text = message
        errorLablel.alpha = 1
    }
    
    @IBAction func addTaskTapped(_ sender: Any) {
        let err = validateFields()
        //let calendar = Calendar.current
        if err != nil{
            showError(err!)
        }
        let taskname = taskNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let memo = memoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        db.collection("tasks").document(user!.uid).updateData(
        [taskname://[
            ["memo":memo],
            //["lastupdate":FieldValue.serverTimestamp()]
            //]
        ]) { (error) in
            if error != nil {
                // Show error message
                self.showError("Error saving task data")
            }
        }
        errorLablel.text = "保存しました"
        errorLablel.alpha = 1
    }

}

