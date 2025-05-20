//
//  ApiListViewController.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//

import UIKit
import Combine

class ApiListViewController: BaseViewController {
    
    private let viewModel = ApiListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    private let loader = UIActivityIndicatorView(style: .large)
    private let fetchDataFromApiButton = UIButton()
    private let notificationToggleSwitch = UISwitch()
    private let bottomControlsContainer = UIView()
    
    private let notificationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Send Notification on Delete"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        showLoader(true)
        viewModel.fetchApiIfNeeded()
    }
    
    private func setupUI() {
        setupBottomControls()
        setupTableView()
        addTableViewConstraints()
        setupLoader()
    }
    
    private func bindViewModel() {
        viewModel.$apiData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] apiData in
                guard let welf = self else { return }
                
                welf.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let welf = self else { return }
                
                if value {
                    welf.showLoader(true)
                } else {
                    welf.showLoader(false)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isNotificationEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let welf = self else { return }
                
                welf.notificationToggleSwitch.isOn = value
            }
            .store(in: &cancellables)
    }
}

extension ApiListViewController {
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.isHidden = true
    }
    
    private func addTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomControlsContainer.topAnchor)
        ])
    }
    
    private func setupLoader() {
        view.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBottomControls() {
        setupBottmContainer()
        
        setupNotificationTitleLabel()
        
        setupNotificationSwitch()
        
        setupResetButton()
        
        addBottomContainerConstraints()
        
        addNotificationTitleLabelConstraints()
        
        addNotificationToggleSwitchConstraints()
        
        addResetButtonConstraints()
    }
    
    @objc private func apiCallButtonTapped() {
        AppUserDefaults.isApiCalled = false
        viewModel.fetchApiIfNeeded()
    }
    
    @objc private func notificationToggleChanged(_ sender: UISwitch) {
        viewModel.isNotificationEnabled = sender.isOn
        viewModel.permissionForNotification()
    }
    
}

// Adding Constraints
extension ApiListViewController {
    private func setupBottmContainer() {
        view.addSubview(bottomControlsContainer)
        bottomControlsContainer.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addBottomContainerConstraints() {
        NSLayoutConstraint.activate([
            bottomControlsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomControlsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomControlsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsContainer.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupNotificationTitleLabel() {
        bottomControlsContainer.addSubview(notificationTitleLabel)
        notificationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationTitleLabel.text = "Send Notification on Delete"
        notificationTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private func addNotificationTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            notificationTitleLabel.topAnchor.constraint(equalTo: bottomControlsContainer.topAnchor, constant: 10),
            notificationTitleLabel.leadingAnchor.constraint(equalTo: bottomControlsContainer.leadingAnchor, constant: 20)
        ])
    }
    
    private func setupNotificationSwitch() {
        bottomControlsContainer.addSubview(notificationToggleSwitch)
        notificationToggleSwitch.addTarget(self, action: #selector(notificationToggleChanged), for: .valueChanged)
        notificationToggleSwitch.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addNotificationToggleSwitchConstraints() {
        NSLayoutConstraint.activate([
            notificationToggleSwitch.centerYAnchor.constraint(equalTo: notificationTitleLabel.centerYAnchor),
            notificationToggleSwitch.trailingAnchor.constraint(equalTo: bottomControlsContainer.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupResetButton() {
        bottomControlsContainer.addSubview(fetchDataFromApiButton)
        fetchDataFromApiButton.setTitle("Reset", for: .normal)
        fetchDataFromApiButton.backgroundColor = .systemBlue
        fetchDataFromApiButton.setTitleColor(.white, for: .normal)
        fetchDataFromApiButton.layer.cornerRadius = 25
        fetchDataFromApiButton.translatesAutoresizingMaskIntoConstraints = false
        fetchDataFromApiButton.addTarget(self, action: #selector(apiCallButtonTapped), for: .touchUpInside)
    }
    
    private func addResetButtonConstraints() {
        NSLayoutConstraint.activate([
            fetchDataFromApiButton.topAnchor.constraint(equalTo: notificationTitleLabel.bottomAnchor, constant: 20),
            fetchDataFromApiButton.centerXAnchor.constraint(equalTo: bottomControlsContainer.centerXAnchor),
            fetchDataFromApiButton.widthAnchor.constraint(equalToConstant: 100),
            fetchDataFromApiButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension ApiListViewController {
    private func showLoader(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.loader.startAnimating()
                self.tableView.isHidden = true
            } else {
                self.loader.stopAnimating()
                self.tableView.isHidden = false
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ApiListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.apiData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        if let model = viewModel.apiData?[indexPath.row] {
            cell.configure(with: model.name, data: model.data)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.deleteCell(index: indexPath.row)
        }
    }
}
