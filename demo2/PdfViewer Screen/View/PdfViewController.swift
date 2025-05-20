//
//  PdfViewController.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 18/05/25.
//

import UIKit
import PDFKit
import SnapKit

class PdfViewController: BaseViewController {
    
    var pdfView: PDFView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setuUI()
    }
}

extension PdfViewController {
    private func setuUI() {
        setupPdfView()
        addPdfViewConstraints()
    }
}

extension PdfViewController {
    private func setupPdfView() {
        pdfView = PDFView()
        guard let pdfView = pdfView else { return }
        view.addSubview(pdfView)
        guard let pdfURL = URL(string: StringConstants.pdfUrl) else { return }
        
        if let pdfDocument = PDFDocument(url: pdfURL) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.displayDirection = .vertical
            pdfView.document = pdfDocument
        }
    }
    
    private func addPdfViewConstraints() {
        guard let pdfView = pdfView else { return }
        pdfView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
}
