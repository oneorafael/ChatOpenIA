//
//  ViewController.swift
//  ChatOpenIA
//
//  Created by Rafael Oliveira on 04/06/23.
//

import UIKit

class ViewController: UIViewController {
    private let responseLabel: UILabel = {
        let responseLabel = UILabel()
        responseLabel.translatesAutoresizingMaskIntoConstraints = false
        responseLabel.font = .systemFont(ofSize: 20, weight: .bold)
        responseLabel.numberOfLines = 0
        responseLabel.textColor = .secondaryLabel
        return responseLabel
    }()
    let progressIndicator = UIActivityIndicatorView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private let inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.placeholder = "Faça a sua pergunta"
        inputTextField.returnKeyType = .done
        return inputTextField
    }()
    
    private let connection = Connection.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
        setupConstraints()
        responseLabel.text = ""
        inputTextField.delegate = self
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: responseLabel.frame.size.height)
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setup(){
        view.addSubview(progressIndicator)
        view.addSubview(scrollView)
        scrollView.addSubview(responseLabel)
        view.addSubview(inputTextField)
        title = "OpenIA Chat"
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor),
            
            responseLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            responseLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            responseLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            responseLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            responseLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
                    
            progressIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            progressIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            inputTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            inputTextField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20),
            inputTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        responseLabel.text = ""
        progressIndicator.isHidden = false
        progressIndicator.startAnimating()
        self.responseLabel.text = "..."
        self.inputTextField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            connection.getResponse(input: text) { response in
                switch response {
                    
                case .success(let responseText):
                    DispatchQueue.main.async {
                        self.responseLabel.text = responseText
                        self.inputTextField.text = ""
                        self.progressIndicator.stopAnimating()
                        self.progressIndicator.isHidden = true
                    }
                case .failure:
                    print("Erro ao buscar na API")
                }
            }
        }
        return true
    }
}
