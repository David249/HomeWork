//
//  LoginFormController.swift
//  homeW1-2
//
//  Created by Давид Горзолия on 24.12.2020.
//
import UIKit

class LoginFormController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordInputTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var likeView: RatingControl!
    
    @IBOutlet weak var activityIndicator01: ActivityIndicatorView!
    @IBOutlet weak var activityIndicator02: ActivityIndicatorView!
    @IBOutlet weak var activityIndicator03: ActivityIndicatorView!
    
    var delay: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        // присваиваем его UIScrollView
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let activityIndicatorArray = [activityIndicator01, activityIndicator02, activityIndicator03]
        
        for indicator in activityIndicatorArray {
            if let localIndicator = indicator {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.repeat,.autoreverse], animations: {
                    self.opacityActivityIndicator(localIndicator, delay: CFTimeInterval(self.delay))
                }, completion: nil)
            }
            self.delay += 0.2
        }
        self.delay = 0
    }
    
    
    
    private func opacityActivityIndicator(_ sender: UIView, delay: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.beginTime = CACurrentMediaTime() + delay
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 0.5
        animation.fillMode = .removed
        animation.autoreverses = true
        animation.repeatCount = .infinity
        sender.layer.add(animation, forKey: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Второе - когда она пропадет
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.clearAllTextFields(allTextFields: [self.loginTextField, self.passwordInputTextField])
    }
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    // Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.scrollView.endEditing(true)
    }
    
    // Проверка логина и пароля для перехода перед переходом по segue
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        func CheckUserData() -> Bool {
            let login = loginTextField.text!
            let password = passwordInputTextField.text!
            
            if login == Data.login && password == Data.password {
                return true
            } else {
                return false
            }
        }
        
        // Проверка данных пользователя.
        let checkResult = CheckUserData()
        
        // Если ошибка в веденных данных - отобразим сообщение.
        
        if !checkResult {
            self.showErrorMessage(title: "Ошибка", message: "Введены неверные данные пользователя")
                { self.clearAllTextFields(allTextFields: [self.loginTextField, self.passwordInputTextField]) }
        }
        // Вернем результат
        return checkResult
    }
}

extension LoginFormController {
    // Алерт для сообщения об ошибке
    public func showErrorMessage(title: String, message: String, style: UIAlertController.Style = .alert, closure: () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        // Добавляем кнопку на UIAlertController
        alert.addAction(action)
        
        // Отображаем UIAlertController
        present(alert, animated: true)
        self.clearAllTextFields(allTextFields: [self.loginTextField, self.passwordInputTextField])
    }
    
    public func clearAllTextFields(allTextFields: [UITextField]) {
        for textField in allTextFields {
            textField.text = ""
        }
        DispatchQueue.main.async {
            self.loginTextField.becomeFirstResponder()
        }
        
    }
}


@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
