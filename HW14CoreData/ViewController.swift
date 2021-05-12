//
//  ViewController.swift
//  HW14CoreData
//
//  Created by Sergii Kotyk on 27/4/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
  
    @IBOutlet weak var Table: UITableView!
    @IBAction func addButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add task", message: "What you need to do?", preferredStyle: .alert)
        alert.addTextField()
        let submitButton = UIAlertAction(title: "Add", style: .default) {(action) in
            let textfield = alert.textFields![0]
            let newTask = Task(context: self.context)
            newTask.name = textfield.text
            
            do{
                try! self.context.save()
            }
            self.fetchTasks()
        }
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks:[Task]?
    
    func fetchTasks(){
        do {
            self.tasks = try! context.fetch(Task.fetchRequest())
            DispatchQueue.main.async{
                self.Table.reloadData()
            }
        }
      
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            let removeTask = self.tasks![indexPath.row]
            self.context.delete(removeTask)
            do{
                try self.context.save()
            }catch{}
            self.fetchTasks()
        }
        return UISwipeActionsConfiguration(actions: [action])
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
                try self.context.save()
            }catch{}
            self.fetchTasks()
            
    }
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
}
