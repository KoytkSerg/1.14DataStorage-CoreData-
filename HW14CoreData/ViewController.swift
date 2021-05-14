//
//  ViewController.swift
//  HW14CoreData
//
//  Created by Sergii Kotyk on 27/4/21.
//

import UIKit

class ViewController: UIViewController {
    
  
    @IBOutlet weak var Table: UITableView!
    @IBAction func addButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add task", message: "What you need to do?", preferredStyle: .alert)
        alert.addTextField()
        let submitButton = UIAlertAction(title: "Add", style: .default) {(action) in
            let textfield = alert.textFields![0]
            let newTask = Task(context: self.coreData.context)
            newTask.name = textfield.text
            newTask.isComplited = false
            do{
                try! self.coreData.context.save()
            }
            self.fetchTasks()
        }
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks:[Task]?
    let coreData = CoreDataClass()
    func fetchTasks(){
        do {
            self.tasks = try! coreData.context.fetch(Task.fetchRequest())
            DispatchQueue.main.async{
                self.Table.reloadData()
            }
        }
      
    }
    func saveCoredata(){
        do{
            try self.coreData.context.save()
        }catch{}
        self.fetchTasks()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchTasks()
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let data = self.tasks![indexPath.row]
        cell.textLabel?.text = data.name
        if data.isComplited == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let data = self.tasks![indexPath.row]
        var title = ""
        var isComplited = false
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.coreData.context.delete(data)
            self.saveCoredata()
        }
        
        if data.isComplited != true {
            title = "Done"
            isComplited = true
        }else{
            title = "Not done"
            isComplited = false
        }
        
        let done = UITableViewRowAction(style: .normal, title: title) { (action, indexPath) in
            data.isComplited = isComplited
            self.saveCoredata()
            self.Table.reloadData()
        }

        done.backgroundColor = UIColor.blue
        return [delete, done]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.tasks![indexPath.row]
        let alert = UIAlertController(title: "Edit task", message: "Edit what you need to do?", preferredStyle: .alert)
        alert.addTextField()
        let textfield = alert.textFields![0]
        textfield.text = task.name
        
        let submitButton = UIAlertAction(title: "Add", style: .default) {(action) in
            let textfield = alert.textFields![0]
            task.name = textfield.text
            do{
                try self.coreData.context.save()
            }catch{}
            self.fetchTasks()
            
    }
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
   
}
