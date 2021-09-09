//
//  MasterViewController.swift
//  Picogram
//
//  Created by Bear Cahill on 1/2/20.
//  Copyright © 2020 Bear Cahill. All rights reserved.
//

import UIKit

class PicogramItem {
    var userName = ""
    var imageName : String?
    var image : UIImage?
}

class PicoCell : UITableViewCell {
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    
    static var df : DateFormatter?
    
    func configCell(item : PicogramItem) {
        if PicoCell.df == nil {
            PicoCell.df = DateFormatter()
            PicoCell.df?.dateStyle = .medium
            PicoCell.df?.timeStyle = .medium
        }
        
        self.ivImage.image = item.image
        self.lblUser.text = item.userName
    }
}

class MasterViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [PicogramItem]()

    let imgPicker = UIImagePickerController()
    var newItem : PicogramItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForPic))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        imgPicker.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPico", for: indexPath) as! PicoCell

        cell.configCell(item: objects[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    // MARK: - Image Picker
    
    @objc
    func promptForPic() {
        let ac = UIAlertController.init(title: "Source",
                                        message: "Where do you want to get your image?",
                                        preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ac.addAction(UIAlertAction.init(title: "Camera",
                                            style: .default, handler: { (aa) in
                                                self.picFromCamera()
            }))
        }
        else {
            picFromLibrary() // bypass prompt
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            ac.addAction(UIAlertAction.init(title: "Photo Library",
                                            style: .default, handler: { (aa) in
                                                self.picFromLibrary()
            }))
        }
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func picFromLibrary() {
        imgPicker.allowsEditing = true
        imgPicker.sourceType = .photoLibrary
        imgPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imgPicker.modalPresentationStyle = .popover
        present(imgPicker, animated: true, completion: nil)
    }
    
    func picFromCamera() {
        imgPicker.allowsEditing = true
        imgPicker.sourceType = UIImagePickerController.SourceType.camera
        imgPicker.cameraCaptureMode = .photo
        imgPicker.modalPresentationStyle = .fullScreen
        present(imgPicker,animated: true,completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated:true, completion: nil)
        if let newImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            ?? info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            insertNewObject(img: newImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func insertNewObject(img : UIImage) {
        newItem = PicogramItem()
        newItem!.userName = "bear"
        newItem!.image = img
        objects.insert(newItem!, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
}

