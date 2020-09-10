
//  Created by Valeriy Kovalevskiy on 9/9/20.
//  Copyright © 2019 Valeriy Kovalevskiy. All rights reserved.
//

import UIKit

final class CountryPicker: UIPickerView {
    //MARK: - Properties
    
    ///Show / Hide Country codes
    var showPhoneNumbers: Bool
    
    ///Select row delegate method
    var didSelect: ((String) -> Void)?
    
    fileprivate var localCountriesList: [Country] = []

    //MARK: - Init
    ///Init with backend country list
    public init(showPhoneNumbers: Bool = true) {
        self.showPhoneNumbers = showPhoneNumbers
        
        super.init(frame: .zero)

        setupLocalCountries()
        dataSource = self
        delegate = self
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Fileprivate methods ( Grab locally saved countries from json )
    fileprivate func setupLocalCountries() {
        if let mainUrl = Bundle.main.url(forResource: "CountryCodes", withExtension: "json") {
            do {
                let fileManager = FileManager.default
                let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)
                let subUrl = documentDirectory.appendingPathComponent("CountryCodes.json")
                fileManager.fileExists(atPath: subUrl.path) ? decodeData(pathName: subUrl) : decodeData(pathName: mainUrl)
            }
            catch {
                print(error)
            }
        }
    }
    
    fileprivate func decodeData(pathName: URL) {
        do {
            let jsonData = try Data(contentsOf: pathName)
            let decoder = JSONDecoder()
            localCountriesList = try decoder.decode([Country].self, from: jsonData)
        }
        catch {
            print(error)
        }
    }
    
    
}

//MARK: - Delegate / DataSource methods
extension CountryPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        localCountriesList.count
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelect?(localCountriesList[row].name)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let width = pickerView.rowSize(forComponent: component).width
        let height = pickerView.rowSize(forComponent: component).height
        let componentView = UIView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: width,
                                                 height: height))
        
        let textLabel = UILabel(frame: CGRect(x: 50,
                                              y: componentView.center.y / 3,
                                              width: componentView.bounds.width - 50,
                                              height: 20))
        
        let imageView = UIImageView(frame: CGRect(x: 10,
                                                  y: componentView.center.y / 3,
                                                  width: 30,
                                                  height: 20))
        
        let countryLabelCode = UILabel(frame: CGRect(x: componentView.bounds.width - 70,
                                                     y: componentView.center.y / 3,
                                                     width: 60,
                                                     height: 20))
        
        if !showPhoneNumbers {
            countryLabelCode.isHidden = true
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let unwrappedSelf = self else { return }
            let country = unwrappedSelf.localCountriesList[row]
            
            imageView.image = UIImage(named: country.code)
            textLabel.text = country.name
            countryLabelCode.text = country.dial_code
        }
        
        componentView.addSubview(imageView)
        componentView.addSubview(textLabel)
        componentView.addSubview(countryLabelCode)
        
        return componentView
    }
}
