//
//  AddressViewController.swift
//  Paystack iOS Example
//
//  Created by Jubril Olambiwonnu on 6/21/20.
//  Copyright © 2020 Paystack. All rights reserved.
//

import UIKit

@objc public class PSTCKAddressViewController: PSTCKKeyboardHandlingBaseVC, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet var streetField: UITextField!
    @IBOutlet var cityField: UITextField!
    @IBOutlet var stateField: UITextField!
    @IBOutlet var zipField: UITextField!
    let stateInput = UIPickerView()
    let validator = Validator()
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @objc public var states = [PSTCKState]()
    @objc public var didCollectAddress: (([String:Any]) -> Void)?
    @objc public var didTapCancelButton: (() -> Void)?
    @objc public var transaction = ""
    
    
    @IBOutlet var paymentButton: UIButton!
    public override func viewDidLoad() {
        super.viewDidLoad()
        registerTextFields()
        paymentButton.isEnabled = false
        stateInput.dataSource = self
        stateInput.delegate = self
        stateField.inputView = stateInput
        stateField.delegate = self
    }
    
    @IBAction func onCancelButtonTap(_ sender: Any) {
        didTapCancelButton?()
        dismiss(animated: true)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stateInput.reloadAllComponents()
    }
    
    func registerTextFields() {
        validator.registerField(streetField, rules: [RequiredRule()])
        validator.registerField(cityField, rules: [RequiredRule()])
        validator.registerField(stateField, rules: [RequiredRule()])
        validator.registerField(zipField, rules: [RequiredRule()])
        streetField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        cityField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        stateField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        zipField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @IBAction func onButtonTap(_ sender: Any) {
        paymentButton.setTitle(" ", for: .normal)
        paymentButton.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        let address: [String : Any] = [
            "trans" :  transaction,
            "address" : streetField.text!,
            "city" : cityField.text!,
            "zip_code" : zipField.text!,
            "state" : stateField.text!
        ]
        didCollectAddress?(address)
        dismiss(animated: true)
    }
    
    @objc func textFieldChanged() {
        validator.validate(self)
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row].name
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateField.text = states[row].name
        validator.validate(self)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension PSTCKAddressViewController: ValidationDelegate {
    public func validationSuccessful() {
        paymentButton.isEnabled = true
    }
    
    public func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        paymentButton.isEnabled = false
    }
}


