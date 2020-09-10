
//  Created by Valeriy Kovalevskiy on 9/9/20.
//  Copyright © 2019 Valeriy Kovalevskiy. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    //MARK: - Layout
    fileprivate let fromCountryTextField: UITextField = {
        let field = UITextField()
        let fromCountryPicker = CountryPicker(showPhoneNumbers: false)
        fromCountryPicker.didSelect = { country in
            field.text = country
        }
        
        field.inputView = fromCountryPicker
        field.placeholder = "Picker without phone code"
        field.backgroundColor = .clear
        return field
    }()
    
    fileprivate let toCountryTextField: UITextField = {
        let field = UITextField()
        let toCountryPicker = CountryPicker(showPhoneNumbers: true)
        toCountryPicker.didSelect = { country in
            field.text = country
        }
        
        field.inputView = toCountryPicker
        field.placeholder = "Picker with phone code"
        field.backgroundColor = .clear
        return field
    }()
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        
        view.addSubview(fromCountryTextField)
        view.addSubview(toCountryTextField)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        fromCountryTextField.frame = CGRect(x: view.center.x - view.frame.size.width * 0.4,
                                            y: view.center.y - 54,
                                            width: view.frame.size.width * 0.8,
                                            height: 44)
        
        toCountryTextField.frame = CGRect(x: view.center.x - view.frame.size.width * 0.4,
                                          y: view.center.y,
                                          width: view.frame.size.width * 0.8,
                                          height: 44)
    }
    
    //MARK: - Override methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Fileprivate methods
    fileprivate func setupTextFields() {
        fromCountryTextField.inputAccessoryView = getToolBar(with: getCountryListBarButtonItems())
        toCountryTextField.inputAccessoryView = getToolBar(with: getCountryListBarButtonItems())
    }
    
    fileprivate func getToolBar(with items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.items = items
        toolbar.sizeToFit()
        
        return toolbar
    }
    fileprivate func getCountryListBarButtonItems() -> [UIBarButtonItem] {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissCountries))
        doneButton.accessibilityLabel = "doneButton"
        
        return [space, doneButton]
    }
    
    //MARK: - Actions
    @objc fileprivate func dismissCountries() {
        fromCountryTextField.resignFirstResponder()
        toCountryTextField.resignFirstResponder()
    }
}

