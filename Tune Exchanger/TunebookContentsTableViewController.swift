//
//  TunebookContentsTableViewController.swift
//  
//
//  Created by I.T. Support on 17/12/2015.
//
//

import UIKit
import CoreData

class TunebookContentsTableViewController: UITableViewController {
    
    var currentTunebook : Tunebook?
    
    var managedContext: NSManagedObjectContext! //link to managed context
    
    var fetchedResultsController : NSFetchedResultsController!
    
    struct Constants {
    static let tunebookEntity = "Set"
    static let SetCellId = "SetCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTunebook?.title
        let fetchRequest = NSFetchRequest(entityName: Constants.tunebookEntity )
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "tunebook == %@", currentTunebook!)
        //fetchRequest.predicate = NSPrededicate(format: "tunebook"
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,managedObjectContext:managedContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.SetCellId, forIndexPath: indexPath) as! TunebookContentsTableViewCell
        
        let set = fetchedResultsController.objectAtIndexPath(indexPath) as! Set
        //cell.currentTunebook = tunebook
        cell.title.text = set.title
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Constants.ShowTunebookContents {
                if let destinationController = segue.destinationViewController as? TunebookContentsTableViewController {
                    destinationController.CurrentTunebook = 
                }
                
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        */
        


        
        
        
        
    }
    


