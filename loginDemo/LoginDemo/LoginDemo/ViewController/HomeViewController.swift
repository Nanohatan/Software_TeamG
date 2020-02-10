//
//  HomeViewController.swift
//  LoginDemo
//
//  Created by 本間ののか on 2019/11/16.
//  Copyright © 2019 本間ののか. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var isTodoTask:Bool = true
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let user = Auth.auth().currentUser
    var tasksList = [String]()
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        getUserName()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        print("this is list")
        print(tasksList)
        //画像でデイリータスクにチェックボックスを実装
        if !isTodoTask{
            let image: UIImage = UIImage(named: "checkbox_unchecked.png")!
            cell.imageView!.image = image
            cell.backgroundColor = UIColor(red:0.46, green:0.59, blue:1.00, alpha:0.2)
        }else{
            cell.imageView?.image = nil
            cell.backgroundColor = UIColor(red:0.63, green:0.91, blue:0.63, alpha:0.2)
        }
        
        cell.textLabel!.text = self.tasksList[indexPath.row]
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //削除スワイプ
        let deletButtom = UITableViewRowAction(style: .normal, title: "delet"){(rowAction, indexPath) in
            self.deleteDb(forRowAt: indexPath)
            print("delet called")
            self.tasksList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        //編集項目、まだ中身はからです
        let editButton = UITableViewRowAction(style: .normal, title: "Edit"){
            (rowAction, indexPath) in print("editbuttom clicked")
        }
        editButton.backgroundColor = UIColor.black

        deletButtom.backgroundColor = UIColor.blue
        return [deletButtom,editButton]
    }
    //dbからuserのfirstnameをとってくる
    func getUserName(){
        if let user = user {
            let uid = user.uid
            let docRef = db.collection("users").document(uid)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let name = document.get("firstname")
                    self.userName?.text = name as? String
                } else {
                    self.userName?.text = "Error"
                    print("Document does not exist")
                }
            }
        }
    }
    //dbからタスクの名前ととってきて、リストに入れてる
    func getUserTask(){
        if let user = user {
            let uid = user.uid
            let taskRef = db.collection("tasks").document(uid)
            
            taskRef.getDocument {(document, error) in
                if let document = document, document.exists {
                    let tasks = document.data()?.keys.sorted()
                    for i in tasks!{
                        self.tasksList.append(i)
                    }
                    print("made tastList")
                    self.tableView.reloadData()
                } else {
                    print("Task does not exist")
                }
            }
        }
    }
    func getDailyTasks(){
        if let user = user {
            let uid = user.uid
            let taskRef = db.collection("DailyTasks").document(uid)

            
            taskRef.getDocument {(document, error) in
                if let document = document, document.exists {
                    let tasks = document.data()?.keys.sorted()
                    for i in tasks!{
                        self.tasksList.append(i)
                    }
                    print("made tastList")
                    self.tableView.reloadData()
                } else {
                    print("Task does not exist")
                }
            }
        }
    }
    func deleteDb(forRowAt indexPath: IndexPath){
        if let user = user {
            let uid = user.uid;
            if isTodoTask{            db.collection("tasks").document(uid).updateData([self.tasksList[indexPath.row]:FieldValue.delete()])
            }else {            db.collection("DailyTasks").document(uid).updateData([self.tasksList[indexPath.row]:FieldValue.delete()])
            }
        }
    }
    
    //タスクの種類別の設定
    func setTasks(flag: Bool) {
        if flag{
            taskTypeLabel.text = "todo tasks"
            tasksList.removeAll()
            tableView.separatorColor = UIColor(red:0.63, green:0.91, blue:0.63, alpha:1.0)
            getUserTask()
        }else {
            taskTypeLabel.text = "daily tasks"
            tasksList.removeAll()
            self.tableView.reloadData()
            tableView.separatorColor = UIColor(red:0.46, green:0.59, blue:1.00, alpha:1.0)
            getDailyTasks()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //taskTypeLabel.text = "todo tasks"
        //super.viewWillAppear(animated)
        setTasks(flag: isTodoTask)
    }
    
    @IBAction func todoTaskTapped(_ sender: Any) {
        isTodoTask = true
        setTasks(flag: isTodoTask)    }
    
    @IBAction func dailyTaskTapped(_ sender: Any) {
        isTodoTask = false
        setTasks(flag: isTodoTask)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        if (isTodoTask){
            performSegue(withIdentifier: "todoTask", sender: nil)
        }else{
            performSegue(withIdentifier: "dailyTask", sender: nil)
        }
    }
}
