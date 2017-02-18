//
//  ExampleTableViewController.swift
//  DAOExample
//
//  Created by n-borzenko on 18.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import UIKit
import DAO

class ExampleTableViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var dataBaseControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var searchController: UISearchController!
    
    private var DAOProvider = PlanetDAOProvider()
    fileprivate var dao: AnyDAO<Planet>!
    
    fileprivate var data = [Planet]()
    fileprivate var filteredData = [Planet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlanetCell")
        tableView.dataSource = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar

        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        let type = DataBaseType(rawValue: dataBaseControl.selectedSegmentIndex)!
        dao = DAOProvider[type]
        executeInBackground { [unowned self] in
            self.requestData()
        }
    }

    @IBAction func clearDB(_ sender: Any) {
        executeInBackground { [unowned self] in
            self.dao.erase()
            self.requestData()
        }
    }
    
    @IBAction func fillDB(_ sender: Any) {
        executeInBackground { [unowned self] in
            self.dao.persist(PlanetCreator.createPlanets())
            self.requestData()
        }
    }
    
    @IBAction func addPluto(_ sender: Any) {
        executeInBackground { [unowned self] in
            self.dao.persist(PlanetCreator.createPluto())
            self.requestData()
        }
    }
    
    @IBAction func deletePluto(_ sender: Any) {
        executeInBackground { [unowned self] in
            self.dao.erase(id: 8)
            self.requestData()
        }
    }

    @IBAction func changeDataBase(_ sender: Any) {
        let type = DataBaseType(rawValue: dataBaseControl.selectedSegmentIndex)!
        dao = DAOProvider[type]
        requestData()
    }
    
    fileprivate func executeInBackground(task: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async {
            task()
        }
    }
    
    private func requestData(completion: (() -> Void)? = nil) {
        data = dao.read()
        DispatchQueue.main.async { [unowned self] in
            if let completion = completion {
                completion()
            }
            self.tableView.reloadData()
        }
    }
    
    @objc private func refreshTable(_ refreshControl: UIRefreshControl) {
        executeInBackground { [unowned self] in
            self.requestData {
                refreshControl.endRefreshing()
            }
        }
    }
}

extension ExampleTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            return 0
        }
        if searchController.isActive {
            return filteredData.count
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetCell", for: indexPath)
        let planet = searchController.isActive ? filteredData[indexPath.row] : data[indexPath.row]
        cell.textLabel?.text = planet.name
        return cell
    }
}

extension ExampleTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        executeInBackground { [unowned self] in
            self.filteredData.removeAll()
            let predicate = NSPredicate(format: "name contains[c] %@", searchController.searchBar.text!)
            self.filteredData = self.dao.read(predicate: predicate)
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }
}
