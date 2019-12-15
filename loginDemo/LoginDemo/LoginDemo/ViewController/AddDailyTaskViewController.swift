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

class AddDilyTaskViewController: UIViewController{
    
    @IBOutlet weak var taskNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let taskname = taskNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        db.collection("DailyTasks").document(user!.uid).updateData(
            [taskname:
                ["addDay":getDate()]
        ]) { (error) in
            if error != nil {
                print("Error saving task data")
            }
        }
    }
    
    func getDate() -> String {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .month,
            .day,
            .hour,
        ]
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        print(dateTimeComponents.day!)
        let today = String(dateTimeComponents.day!)
        return today
    }
}

