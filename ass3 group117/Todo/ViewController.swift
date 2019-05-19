//
//  ViewController.swift
//  Todo
//
//  Copyright © 2016 YiGu. All rights reserved.
//

import UIKit

var todos: [ToDoItem] = []

class ViewController: UIViewController {
  
@IBOutlet weak var todoTableView: UITableView!
  

    override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = editButtonItem
    
    todos = [ToDoItem(id: "1", image: "001-shocked", title: "Group meeting", date: dateFromString("2019-4-20")!, course: "IOS"),
             ToDoItem(id: "2", image: "002-smile", title: "ass2 due date", date: dateFromString("2019-4-28")!,course: "IOS"),
             ToDoItem(id: "3", image: "003-happy", title: "quiz", date: dateFromString("2019-4-30")!,course: "IOS"),
             ToDoItem(id: "4", image: "004-happy", title: "ass1 due date", date: dateFromString("2019-4-30")!,course: "IOS")]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    todoTableView.reloadData()
  }
  
  // MARK - helper func
  func setMessageLabel(_ messageLabel: UILabel, frame: CGRect, text: String, textColor: UIColor, numberOfLines: Int, textAlignment: NSTextAlignment, font: UIFont) {
    messageLabel.frame = frame
    messageLabel.text = text
    messageLabel.textColor = textColor
    messageLabel.numberOfLines = numberOfLines
    messageLabel.textAlignment = textAlignment
    messageLabel.font = font
    messageLabel.sizeToFit()
  }
  
  func setCellWithTodoItem(_ cell: UITableViewCell, todo: ToDoItem) {
    let imageView: UIImageView = cell.viewWithTag(11) as! UIImageView
    let titleLabel: UILabel = cell.viewWithTag(12) as! UILabel
    let dateLabel: UILabel = cell.viewWithTag(13) as! UILabel
    
    imageView.image = UIImage(named: todo.image)
    titleLabel.text = todo.title
    dateLabel.text = stringFromDate(todo.date)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "editTodo" {
      let vc = segue.destination as! DetailViewController
      let indexPath = todoTableView.indexPathForSelectedRow
      if let indexPath = indexPath {
        vc.todo = todos[(indexPath as NSIndexPath).row]
      }
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if todos.count != 0 {
      return todos.count
    } else {
      let messageLabel: UILabel = UILabel()
      
      setMessageLabel(messageLabel, frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), text: "No data is currently available.", textColor: UIColor.black, numberOfLines: 0, textAlignment: NSTextAlignment.center, font: UIFont(name:"Palatino-Italic", size: 20)!)
      
      self.todoTableView.backgroundView = messageLabel
      self.todoTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
      
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier: String = "todoCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    
    setCellWithTodoItem(cell, todo: todos[(indexPath as NSIndexPath).row])
    
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  // Edit mode
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    todoTableView.setEditing(editing, animated: true)
  }
  
  // Delete the cell
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCell.EditingStyle.delete {
      todos.remove(at: (indexPath as NSIndexPath).row)
      todoTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
  }
  
  // Move the cell
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return self.isEditing
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let todo = todos.remove(at: (sourceIndexPath as NSIndexPath).row)
    todos.insert(todo, at: (destinationIndexPath as NSIndexPath).row)
  }
}
