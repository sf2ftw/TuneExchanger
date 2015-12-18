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
    var currentSet : Set?
    
    var managedContext: NSManagedObjectContext! //link to managed context
    
    var fetchedResultsController : NSFetchedResultsController!
    
    struct Constants {
    static let TunebookEntity = "Tunebook"
    static let SetEntity = "Set"
    static let TuneEntity = "Tune"
    static let SetCellId = "SetCell"
    static let ShowSetContentsId = "Show Set Contents"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTunebook?.title
        let fetchRequest = NSFetchRequest(entityName: Constants.SetEntity )
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "tunebook == %@", currentTunebook!)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,managedObjectContext:managedContext,sectionNameKeyPath: nil, cacheName: nil)
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
        cell.currentSet = set
        cell.title.text = set.title
        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == Constants.ShowSetContentsId {
                if let destinationController = segue.destinationViewController as? SetContentsTableViewController {
                    if let TunebookCell = sender as? TunebookContentsTableViewCell {
                        destinationController.currentSet = TunebookCell.currentSet
                        destinationController.managedContext = managedContext
                    }
                }
            }
        }
    }







    }



