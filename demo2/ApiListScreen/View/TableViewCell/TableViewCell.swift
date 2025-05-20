//
//  TableViewCell.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//

import UIKit

import UIKit

class TableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = UIColor.black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onEditTapped: (() -> Void)?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        contentView.addSubview(editButton)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailsLabel)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editButton.widthAnchor.constraint(equalToConstant: 20),
            
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -16),
        ])
    }
}

extension TableViewCell {
    // Configure cell with title and data dictionary
    func configure(with name: String, data: DataClass?) {
        titleLabel.text = name
        
        guard let data = data else {
            detailsLabel.text = "No additional info"
            return
        }
        
        var details: [String: Any] = [:]
        
        if let v = data.dataColor { details["Color"] = v }
        if let v = data.dataCapacity { details["Capacity"] = v }
        if let v = data.capacityGB, v > 0 { details["Capacity GB"] = v }
        if let v = data.dataPrice, v > 0.0 { details["Price"] = v }
        if let v = data.dataGeneration { details["Generation"] = v }
        if let v = data.year, v > 0 { details["Year"] = v }
        if let v = data.cpuModel { details["CPU Model"] = v }
        if let v = data.hardDiskSize { details["Hard Disk Size"] = v }
        if let v = data.strapColour { details["Strap Colour"] = v }
        if let v = data.caseSize { details["Case Size"] = v }
        if let v = data.color { details["Color"] = v }
        if let v = data.description { details["Description"] = v }
        if let v = data.capacity { details["Capacity"] = v }
        if let v = data.screenSize, v > 0.0 { details["Screen Size"] = v }
        if let v = data.generation { details["Generation"] = v }
        if let v = data.price { details["Price"] = v }
        
        let detailText = details.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
        detailsLabel.text = detailText
    }
}

extension TableViewCell {
    @objc private func editButtonTapped() {
        self.onEditTapped?()
    }
}
