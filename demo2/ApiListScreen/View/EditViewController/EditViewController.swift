//
//  EditViewController.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 20/05/25.
//

import UIKit

protocol EditViewControllerProtocol: AnyObject {
    func detailsIsEdited(_ row: Int, _ editedModel: ApiModel)
}

class EditViewController: BaseViewController {

    var model: ApiModel?
    private let row: Int
    weak var delegate: EditViewControllerProtocol?

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let saveButton = UIButton(type: .system)

    // Hold references to the text fields by label
    private var textFields: [String: UITextField] = [:]
    
    init(_ row: Int) {
        self.row = row
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Details"
        view.backgroundColor = .white
        setupUI()
        populateFields()
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        contentStack.addArrangedSubview(saveButton)
    }

    private func populateFields() {
        guard let model = model else { return }

        func addField(label: String, value: String?) {
            guard let value = value, !value.trimmingCharacters(in: .whitespaces).isEmpty else { return }

            let tf = UITextField()
            tf.placeholder = label
            tf.text = value
            tf.borderStyle = .roundedRect
            tf.autocapitalizationType = .none
            tf.accessibilityIdentifier = label
            contentStack.insertArrangedSubview(tf, at: contentStack.arrangedSubviews.count - 1)

            textFields[label] = tf
        }

        func addNumericField(label: String, value: Any?) {
            if let intVal = value as? Int, intVal > 0 {
                addField(label: label, value: "\(intVal)")
            } else if let doubleVal = value as? Double, doubleVal > 0 {
                addField(label: label, value: "\(doubleVal)")
            }
        }

        addField(label: "Name", value: model.name)
        addField(label: "Color", value: model.data?.dataColor ?? model.data?.color)
        addField(label: "Capacity", value: model.data?.dataCapacity ?? model.data?.capacity)
        addField(label: "Generation", value: model.data?.dataGeneration ?? model.data?.generation)
        addField(label: "CPU Model", value: model.data?.cpuModel)
        addField(label: "Hard Disk Size", value: model.data?.hardDiskSize)
        addField(label: "Strap Colour", value: model.data?.strapColour)
        addField(label: "Case Size", value: model.data?.caseSize)
        addField(label: "Description", value: model.data?.description)
        addField(label: "Price", value: model.data?.price ?? (model.data?.dataPrice != nil ? "\(model.data?.dataPrice!)" : nil))
        addNumericField(label: "Year", value: model.data?.year)
        addNumericField(label: "Screen Size", value: model.data?.screenSize)
        addNumericField(label: "Capacity GB", value: model.data?.capacityGB)
    }

    @objc private func saveTapped() {
        guard var data = model, let oldModel = model else { return }

        var isValid = true

        for (_, tf) in textFields {
            let text = tf.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if text.isEmpty {
                tf.layer.borderColor = UIColor.red.cgColor
                tf.layer.borderWidth = 1
                isValid = false
            } else {
                tf.layer.borderWidth = 0
            }
        }

        if !isValid { return }

        func text(_ label: String) -> String? {
            textFields[label]?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        func intValue(_ label: String) -> Int? {
            if let txt = text(label), let val = Int(txt) { return val }
            return nil
        }

        func doubleValue(_ label: String) -> Double? {
            if let txt = text(label), let val = Double(txt) { return val }
            return nil
        }

        data.name = text("Name") ?? "N/A"
        
        data.data?.dataColor = text("Color")
        data.data?.color = text("Color")

        data.data?.dataCapacity = text("Capacity")
        data.data?.capacity = text("Capacity")

        data.data?.dataGeneration = text("Generation")
        data.data?.generation = text("Generation")

        data.data?.cpuModel = text("CPU Model")
        data.data?.hardDiskSize = text("Hard Disk Size")
        data.data?.strapColour = text("Strap Colour")
        data.data?.caseSize = text("Case Size")
        data.data?.description = text("Description")

        data.data?.dataPrice = doubleValue("Price")
        data.data?.price = text("Price")

        data.data?.year = intValue("Year")
        data.data?.screenSize = doubleValue("Screen Size")
        data.data?.capacityGB = intValue("Capacity GB")

        let updatedModel = ApiModel(id: oldModel.id, name: data.name, data: data.data)
        delegate?.detailsIsEdited(self.row, updatedModel)
        dismiss(animated: true)
    }
}
