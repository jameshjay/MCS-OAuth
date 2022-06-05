//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Zhaolong Zhong on 10/19/16.
//  
//

import UIKit

protocol FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [Filter])
}
class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    static let TAG = NSStringFromClass(FiltersViewController.self)
    
    @IBOutlet var tableView: UITableView!
    
    let switchCell = "SwitchCell"
    var categories: [[String: String]]?
    var filters: [Filter] = []
    var switchStates = [Int: Bool]()
    var delegate: FiltersViewControllerDelegate?
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Yelp"
        queue.qualityOfService = .background
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filters = YelpFilters.sharedInstance.filters
        
        let getCategoriesOperation = BlockOperation {
            let data = YelpHelper.readFileFrom("Categories", ofType: "json")
            
            guard let categoriesDict = try! JSONSerialization.jsonObject(with: data!, options: []) as? [[String: String]] else {
                print("Error in getting categories.")
                return
            }
            
            OperationQueue.main.addOperation {
                var options = [Option]()
                for category in categoriesDict {
                    let option = Option(label: category["name"], name: "categories_filter", value: category["code"], isSelected: false)
                    options.append(option)
                }
                
                let filter = Filter(label: "Category", name: "category_filter", options: options, type: .multiple, visibleItems: 3)
                self.filters.append(filter)
                self.invalidateViews()
            }
        }
        
        self.operationQueue.addOperation(getCategoriesOperation)
        
        // Set up table view
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: self.switchCell, bundle: nil), forCellReuseIdentifier: self.switchCell)

    }
    
    func invalidateViews() {
        for filter in self.filters {
            filter.isOpen = false
        }
        
        if self.isViewLoaded {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        self.delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: self.filters)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filter = self.filters[section] as Filter
        if !filter.isOpen {
            if filter.type == .single {
                return 1
            } else if filter.visibleItems! > 0 && filter.visibleItems! < filter.options.count {
                return filter.visibleItems! + 1
            }
        }
        
        return filter.options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filter = self.filters[section] as Filter
        return filter.label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.switchCell) as! SwitchCell
        
        cell.delegate = self
        cell.textLabel!.textAlignment = .left
        cell.textLabel!.textColor = .black

        let filter = self.filters[indexPath.section] as Filter
        
        switch filter.type {
        case .single:
            if filter.isOpen {
                let option = filter.options[indexPath.row]
                cell.textLabel!.text = option.label
                if option.isSelected {
                    cell.accessoryView = UIImageView(image: UIImage(named: "check"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "uncheck"))
                }
            } else {
                cell.textLabel!.text = filter.options[filter.selectedIndex].label
                cell.accessoryView = UIImageView(image: UIImage(named: "dropdown"))
            }
            break
        case .multiple:
            if filter.isOpen || indexPath.row < filter.visibleItems! {
                let option = filter.options[indexPath.row]
                cell.textLabel!.text = option.label
                cell.selectionStyle = .none
                let switchView = UISwitch(frame: .zero)
                switchView.isOn = option.isSelected
                switchView.addTarget(self, action: #selector(switchButtonValueChanged(switchView:)), for: .valueChanged)
                cell.accessoryView = switchView
            } else {
                cell.textLabel!.text = "See All"
                cell.textLabel!.textAlignment = .center
                cell.textLabel!.textColor = .darkGray
                cell.accessoryView = nil
            }
            break
        default:
            let option = filter.options[indexPath.row]
            cell.textLabel!.text = option.label
            cell.selectionStyle = .none
            let switchView = UISwitch(frame: .zero)
            switchView.isOn = option.isSelected
            switchView.addTarget(self, action: #selector(switchButtonValueChanged(switchView:)), for: .valueChanged)
            cell.accessoryView = switchView
        }
        
        return cell
    }
    
    func switchButtonValueChanged(switchView: UISwitch) -> Void {
        let cell = switchView.superview as! UITableViewCell
        if let indexPath = self.tableView.indexPath(for: cell) {
            let filter = self.filters[indexPath.section] as Filter
            let option = filter.options[indexPath.row]
            option.isSelected = switchView.isOn
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = self.filters[indexPath.section]
        switch filter.type {
        case .single:
            if filter.isOpen {
                let previousIndex = filter.selectedIndex
                if previousIndex != indexPath.row {
                    filter.selectedIndex = indexPath.row
                    let previousIndexPath = IndexPath(row: previousIndex, section: indexPath.section)
                    self.tableView.reloadRows(at: [indexPath, previousIndexPath], with: .automatic)
                }
            }
            
            let isOpen = filter.isOpen
            filter.isOpen = !isOpen
            
            if isOpen {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                }
            } else {
                self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
            }
            break
        case .multiple:
            if !filter.isOpen && indexPath.row == filter.visibleItems {
                filter.isOpen = true
                self.filters[indexPath.section].isOpen = true
//                let sectionIndexSet = NSMutableIndexSet(index: indexPath.section) as IndexSet
//                self.tableView.reloadSections(sectionIndexSet, with: .none)
                self.tableView.reloadData()
            } else {
                let option = filter.options[indexPath.row]
                option.isSelected = !option.isSelected
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break
        default:
            break
        }
    }
    
    // MARK: - SwitchCellDelegate
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = self.tableView.indexPath(for: switchCell)!
        self.switchStates[indexPath.row] = value
    }
}
