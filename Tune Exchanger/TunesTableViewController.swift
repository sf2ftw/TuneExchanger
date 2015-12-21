//
//  TunesTableViewController.swift
//  Tune Exchanger
//
//  Created by I.T. Support on 08/12/2015.
//  Copyright © 2015 STV. All rights reserved.
//

import UIKit
import CoreData

class TunesTableViewController: UITableViewController {

    var managedContext: NSManagedObjectContext! //link to managed context
    
    var fetchedResultsController : NSFetchedResultsController!
    
    var currentIndexPath : NSIndexPath?
    
    @IBOutlet weak var headerUIView: UIView!
    
    @IBOutlet weak var TableHeaderUIView: UIView!
    
    struct Constants {
        static let tuneEntity = "Tune"
        static let tuneCellID = "Tune Cell"
    }

    
    override func awakeFromNib() {
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.tableHeaderView = "Header Cell"
        let fetchRequest = NSFetchRequest(entityName: Constants.tuneEntity)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,managedObjectContext:managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }

    }


    

    @IBAction func touchOnHeader(sender: UITapGestureRecognizer) {
        print("My header has been touched up!")
    }
    
    @IBAction func showTuneActionSheet(sender: AnyObject) {
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        currentIndexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        print("currentIndexPath = \(currentIndexPath!)")
        
        let optionMenu = UIAlertController(title: nil, message: "tune", preferredStyle: .ActionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Share")
        })
        let deleteAction = UIAlertAction(title: "Delete Tune", style: .Default, handler: deleteTune)
        
        let addLearningListAction = UIAlertAction(title: "Add to Learning List", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Add to learning list")
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
    
        optionMenu.addAction(shareAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(addLearningListAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func deleteTune(alert: UIAlertAction!)
    {
        //let cell = view.superview as! TuneTableViewCell
        //let indexPath = fetchedResultsController.indexPathForObject(cell)
        let tuneToDelete = fetchedResultsController.objectAtIndexPath(currentIndexPath!) as! Tune
        //Tune.deleteTune(tuneToDelete, managedContext: managedContext)
        //fetchedResultsController.selector(
        fetchedResultsController.delete(tuneToDelete)
        managedContext.deleteObject(tuneToDelete)
        do {
                try managedContext.save()
        } catch let error as NSError {
            print ("Done fucked up")
        }
        
        
        
        //tableView.deleteRowsAtIndexPaths([currentIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        
                print("fuck me, did it delete?")
        

    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        
        return UITableViewAutomaticDimension
        }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.tuneCellID, forIndexPath: indexPath) as! TuneTableViewCell
        
        let tune = fetchedResultsController.objectAtIndexPath(indexPath)
            as! Tune
        cell.currentTune = tune
        return cell
    }
    
    override func tableView(tableView: UITableView,
        viewForHeaderInSection section: Int) -> UIView {
        return headerUIView
    }
   
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
