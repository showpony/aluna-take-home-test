/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A base table view controller that presents health data.
*/

import UIKit

class WalkingSpeedDataViewController: UITableViewController {
    
    static let cellIdentifier = "DataTypeTableViewCell"
    
    let dateFormatter = DateFormatter()
    
    var dataTypeIdentifier: String
    var dataValues: [HealthDataTypeValue] = []
    
    public var showGroupedTableViewTitle: Bool = false
    
    // MARK: Initializers
    
    init(dataTypeIdentifier: String) {
        self.dataTypeIdentifier = dataTypeIdentifier
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
        setUpViewController()
        setUpTableView()
    }
    
    func setUpNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setUpViewController() {
        title = tabBarItem.title
        dateFormatter.dateStyle = .medium
    }
    
    func setUpTableView() {
        tableView.register(DataTypeTableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
    }
    
    private var emptyDataView: EmptyDataBackgroundView {
        return EmptyDataBackgroundView(message: "No Data")
    }
    
    // MARK: - Data Life Cycle
    
    func reloadData() {
        self.dataValues.isEmpty ? self.setEmptyDataView() : self.removeEmptyDataView()
        self.dataValues.sort { $0.startDate > $1.startDate }
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }
    
    private func setEmptyDataView() {
        tableView.backgroundView = emptyDataView
    }
    
    private func removeEmptyDataView() {
        tableView.backgroundView = nil
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataValues.count
        return dataValues.count > 0 ? 3 : 0 // Daily, Weekly, Monthly
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) as? DataTypeTableViewCell else {
            return DataTypeTableViewCell()
        }
        
        var detailLabel = ""
        switch indexPath.row {
        case 0: //daily
            let newValues = dataValues.map { $0.value }
            let sum = newValues.reduce(0, +)
            let result = sum/Double(newValues.count)
            detailLabel = String(format: "%.2f m/day", result)
            
            cell.textLabel?.text = "Daily Average:"
            cell.detailTextLabel?.text = detailLabel
        case 1: //weekly
            let newValues = dataValues.map { $0.value }
            let sum = newValues.reduce(0, +)
            let result = sum
            detailLabel = String(format: "%.2f m/week", result)
            
            cell.textLabel?.text = "Weekly Average:"
            cell.detailTextLabel?.text = detailLabel
        case 2: //monthly
            let newValues = dataValues.map { $0.value }
            let sum = newValues.reduce(0, +)
            let result = sum
            detailLabel = String(format: "%.2f m/month", result)
            
            cell.textLabel?.text = "Monthly Average:"
            cell.detailTextLabel?.text = detailLabel
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard
            let dataTypeTitle = getDataTypeName(for: dataTypeIdentifier),
            showGroupedTableViewTitle, !dataValues.isEmpty
        else {
            return nil
        }
        
        return String(format: "%@ %@", dataTypeTitle, "Samples")
    }
}
