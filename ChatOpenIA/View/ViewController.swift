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
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    private func setup(){
        view.addSubview(scrollView)
        scrollView.addSubview(responseLabel)
        view.addSubview(inputTextField)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            scrollView.bottomAnchor.constraint(equalTo:inputTextField.topAnchor, constant: -5),
            
            responseLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            responseLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            responseLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            responseLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
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
        if let text = textField.text, !text.isEmpty {
            connection.getResponse(input: text) { response in
                switch response {
                case .success(let responseText):
                    DispatchQueue.main.async {
                        self.responseLabel.text = responseText
                        self.inputTextField.text = ""
                    }
                case .failure:
                    print("Erro ao buscar na API")
                }
            }
        }
        return true
    }
}
