//
//  TunebookTableViewController.swift
//  Tune Exchanger
//
//  Created by I.T. Support on 07/12/2015.
//  Copyright © 2015 STV. All rights reserved.
//

import UIKit
import CoreData

class TunebookTableViewController: UITableViewController {
    //Mark: - Variables
    
    var managedContext: NSManagedObjectContext! //link to managed context
    
    var fetchedResultsController : NSFetchedResultsController!
    
    //var selectedTunebook : Tunebook?
    
    //MARK: - Lifecycle
    
    struct Constants {
    static let titleText = "Tunebooks"
    static let tunebookEntity = "Tunebook"
    static let tunebookCellID = "Tunebook Cell"
    static let ShowTunebookContents = "Show Tunebook Contents"
    }

    override func viewDidLoad() {
    super.viewDidLoad()
    let fetchRequest = NSFetchRequest(entityName: Constants.tunebookEntity)
    let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,managedObjectContext:managedContext, sectionNameKeyPath: nil, cacheName: nil)
    do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let sectionInfo = fetchedResultsController.sections![section]
            return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.tunebookCellID, forIndexPath: indexPath) as! TunebookTableViewCell
        let tunebook = fetchedResultsController.objectAtIndexPath(indexPath) as! Tunebook
        cell.currentTunebook = tunebook
        cell.titleLabel.text = tunebook.title
        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }*/


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Constants.ShowTunebookContents {
                if let destinationController = segue.destinationViewController as? TunebookContentsTableViewController {
                    if let TunebookCell = sender as? TunebookTableViewCell {
                        destinationController.currentTunebook = TunebookCell.currentTunebook
                        destinationController.managedContext = managedContext
                    }
                }
            }
        }
    }
}
