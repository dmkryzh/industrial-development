//
//  UrlViewController.swift
//  Navigation
//

import UIKit
import SnapKit

class UrlViewController: UIViewController {
    
    var viewModel: UrlViewModel
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    let statusHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = StringsForLocale.httpStatus.localaized
        return label
    }()
    
    let responseHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = StringsForLocale.httpResp.localaized
        return label
    }()
    
    let headerHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = StringsForLocale.httpHeader.localaized
        return label
    }()
    
    let formatedHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = StringsForLocale.httpTitle.localaized
        return label
    }()
    
    let orbitalHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = StringsForLocale.httpOrbital.localaized
        return label
    }()
    
    lazy var statusCodeLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.contentMode = .scaleAspectFill
        return label
    }()
    
    lazy var htmlHeadersLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.contentMode = .scaleAspectFill
        return label
    }()
    
    lazy var responseLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.contentMode = .scaleAspectFill
        
        return label
    }()
    
    lazy var formatedLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.contentMode = .scaleAspectFill
        return label
    }()
    
    lazy var orbitalLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.contentMode = .scaleAspectFill
        return label
    }()
    
    lazy var tableViewNames: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorColor = .separator
        tableView.tintColor = .label
        tableView.sectionIndexColor = .label
        return tableView
    }()
    
    lazy var constraintsSetup = { [self] in
        
        scrollView.snp.makeConstraints() { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints() { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(view.safeAreaLayoutGuide)
        }
        
        statusHeader.snp.makeConstraints() { make in
            make.top.equalTo(containerView.snp.top).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        
        statusCodeLabel.snp.makeConstraints() { make in
            make.top.equalTo(statusHeader.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        
        headerHeader.snp.makeConstraints() { make in
            make.top.equalTo(statusCodeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        
        htmlHeadersLabel.snp.makeConstraints() { make in
            make.top.equalTo(headerHeader.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        
        responseHeader.snp.makeConstraints() { make in
            make.top.equalTo(htmlHeadersLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        
        responseLabel.snp.makeConstraints() { make in
            make.top.equalTo(responseHeader.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        
        formatedHeader.snp.makeConstraints() { make in
            make.top.equalTo(responseLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        
        formatedLabel.snp.makeConstraints() { make in
            make.top.equalTo(formatedHeader.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        
        orbitalHeader.snp.makeConstraints() { make in
            make.top.equalTo(formatedLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        
        orbitalLabel.snp.makeConstraints() { make in
            make.top.equalTo(orbitalHeader.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
        }
        
        tableViewNames.snp.makeConstraints() { make in
            make.height.equalTo(300)
            make.top.equalTo(orbitalLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(containerView).inset(10)
            make.bottom.equalTo(containerView.snp.bottom).inset(10)
        }
    }
    
    // Сделано для примера работы с EH для try?
    func optionalTry() throws {
        if title == "Пост" {
            print("Author is \(String(describing: title))")
        } else {
            throw AppErrors.internalError
        }
    }
    

    init(viewModel: UrlViewModel) {
   
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.reloadData = self
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.createColor(lightMode: .systemOrange, darkMode: .systemGray6)
        title = viewModel.post.title
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(statusHeader, statusCodeLabel, headerHeader, htmlHeadersLabel, responseHeader, responseLabel, formatedHeader, formatedLabel, orbitalHeader, orbitalLabel, tableViewNames)
        
        
        if let _ = try? optionalTry() {
            print("No issues")
        } else {
            print("Some error")
        }
        
        constraintsSetup()
        
        self.viewModel.udateLabels()
    }
}

extension UrlViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        header.textLabel?.textColor = .label
        header.textLabel?.textAlignment = .center
    }

}

extension UrlViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let persons = self.viewModel.persons else { return 0 }
        return persons.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        guard let persons = self.viewModel.persons else { return UITableViewCell.init(frame: .zero) }
        
        cell.textLabel?.text = "№\(indexPath.item + 1) - \(persons[indexPath.item].name)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        StringsForLocale.httpResidents.localaized
    }
    
    
}

extension UrlViewController: PostInput {
    func reloadLabels() {
        DispatchQueue.main.async { [self] in
            htmlHeadersLabel.text = viewModel.htmlHeaders
            orbitalLabel.text = viewModel.orbital
            statusCodeLabel.text = viewModel.statusCode
            formatedLabel.text = viewModel.title
            responseLabel.text = viewModel.response
        }
    }
    
    func reloadTables() {
        DispatchQueue.main.async { [self] in
            self.tableViewNames.reloadData()
        }
    }

}


