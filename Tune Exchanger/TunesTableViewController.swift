//
//  TunesTableViewController.swift
//  Tune Exchanger
//
//  Created by I.T. Support on 08/12/2015.
//  Copyright © 2015 STV. All rights reserved.
//

import UIKit
import CoreData

class TunesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating{

    var managedContext: NSManagedObjectContext! //link to managed context
    
    var fetchedResultsController : NSFetchedResultsController!
    var searchControllerfetchedResultsController : NSFetchedResultsController!
    
    var currentIndexPath : NSIndexPath?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //@IBOutlet weak var headerUIView: UIView!
    
    //@IBOutlet weak var TableHeaderUIView: UIView!
    
    struct Constants {
        static let tuneEntity = "Tune"
        static let tuneCellID = "Tune Cell"
    }

    override func awakeFromNib() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up searchController
                //finish setting up the searchController
        let fetchRequest = NSFetchRequest(entityName: Constants.tuneEntity)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,managedObjectContext:managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        } //set up the search bar
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar

    }
    
    @IBAction func showTuneActionSheet(sender: AnyObject) {
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        currentIndexPath = self.tableView.indexPathForRowAtPoint(buttonPosition)
        let tuneSelected = fetchedResultsController.objectAtIndexPath(currentIndexPath!) as! Tune
        print("currentIndexPath = \(currentIndexPath!)")
        let optionMenu = UIAlertController(title: nil, message: tuneSelected.title, preferredStyle: .ActionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Share")
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: deleteTune)
        let addLearningListAction = UIAlertAction(title: "Add to Learning List", style: .Default, handler: addToLearningList)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        optionMenu.addAction(addLearningListAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func deleteTune(alert: UIAlertAction!)
    {
        let tuneToDelete = fetchedResultsController.objectAtIndexPath(currentIndexPath!) as! Tune
        Tune.deleteTune(tuneToDelete, managedContext: managedContext)
        print("Deleted tune")
    }
    
    func addToLearningList(alert: UIAlertAction!)
    {
        let tuneToAddToLearningList = fetchedResultsController.objectAtIndexPath(currentIndexPath!) as! Tune
        if Tune.addTuneToLearningList(tuneToAddToLearningList, managedContext: managedContext) == true {
            print("Added \(tuneToAddToLearningList.title!) to the learning list")
        } else {
            print("\(tuneToAddToLearningList.title!) not added to the learning list")
        }
    }
    
    // MARK:- Search delegate stuff

    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 40
        return UITableViewAutomaticDimension
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.searchController.active) {
            return searchControllerfetchedResultsController.sections!.count
        }
        else {
            return fetchedResultsController.sections!.count
        }
        //return fetchedResultsController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedResultsController.sections![section]
        if searchControllerfetchedResultsController != nil {
        let searchSectionInfo = searchControllerfetchedResultsController.sections![section]
            if (self.searchController.active) {
                return searchSectionInfo.numberOfObjects
            }
        }
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.tuneCellID, forIndexPath: indexPath) as! TuneTableViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: TuneTableViewCell, indexPath: NSIndexPath) {
        if (self.searchController.active) {
            let tune = searchControllerfetchedResultsController.objectAtIndexPath(indexPath) as! Tune
            cell.currentTune = tune

        }
        else {
            let tune = fetchedResultsController.objectAtIndexPath(indexPath) as! Tune
            cell.currentTune = tune
        }
        
        
        
    }
    
    /*override func tableView(tableView: UITableView,
        viewForHeaderInSection section: Int) -> UIView {
        return headerUIView
    }*/

//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?)
    {
        switch(type) {
            
        case .Insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath],
                    withRowAnimation:UITableViewRowAnimation.Fade)
            }
            
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
        case .Update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TuneTableViewCell {
                        configureCell(cell, indexPath: indexPath)
                }
            }
            
        case .Move:
            if let indexPath = indexPath {
                if let newIndexPath = newIndexPath {
                    tableView.deleteRowsAtIndexPaths([indexPath],
                        withRowAnimation: UITableViewRowAnimation.Fade)
                    tableView.insertRowsAtIndexPaths([newIndexPath],
                        withRowAnimation: UITableViewRowAnimation.Fade)
                }
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)
    {
        switch(type) {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex),
                withRowAnimation: UITableViewRowAnimation.Fade)
            
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex),
                withRowAnimation: UITableViewRowAnimation.Fade)
            
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        //filteredTableData.removeAll(keepCapacity: false)
        if searchController.searchBar.text != nil {
            //let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
            let searchPredicate = NSPredicate(format: "title CONTAINS[c] %@", searchController.searchBar.text!)
            print("predicate: \(searchPredicate)")
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            let fetchRequest = NSFetchRequest(entityName: Constants.tuneEntity)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.predicate = searchPredicate
            searchControllerfetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,managedObjectContext:managedContext, sectionNameKeyPath: nil, cacheName: nil)
    //        searchControllerfetchedResultsController = self
            do {
                try searchControllerfetchedResultsController.performFetch()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
            self.tableView.reloadData()
        
        }
    }
}
