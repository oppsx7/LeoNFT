import UIKit

class RegistrationContoller: UIViewController {
    //MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placehoder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placehoder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnameTextField = CustomTextField(placehoder: "Full Name")
    
    private let usernameTextField = CustomTextField(placehoder: "Username")
    
    private let signUpButton: UIButton = {
        let button = AuthenticationButton(buttonTitle: "Sign Up")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account? ", secondPart: "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return button
    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: - Actions
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let fullname = fullnameTextField.text,
              let username = usernameTextField.text?.lowercased(),
              let profileImage = self.profileImage else {
                  print("DEBUG: \(String(describing: emailTextField.text)), \(String(describing: passwordTextField.text)), \(String(describing: fullnameTextField.text)), \(String(describing: usernameTextField.text)), \(String(describing: profileImage))")
                  return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.registerUser(withCredentials: credentials) { error in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                return
            }
            
            self.delegate?.authenticationComplete()
            
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullName = sender.text
        } else if sender == usernameTextField {
            viewModel.username = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    @objc func handleProfilePhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        setupScrollView()
        contentView.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: contentView)
        plusPhotoButton.setDimensions(height: 140, width: 140)
        plusPhotoButton.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullnameTextField, usernameTextField, signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        contentView.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        contentView.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: contentView)
        alreadyHaveAccountButton.anchor(top: signUpButton.bottomAnchor, paddingTop: 200)
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.isUserInteractionEnabled = true
        scrollView.setDimensions(height: view.frame.height, width: view.frame.width)
        contentView.setDimensions(height: view.frame.height, width: view.frame.width)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

//MARK: - FormViewModel

extension RegistrationContoller: FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel.formIsValid
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationContoller: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        profileImage = selectedImage.withRenderingMode(.alwaysOriginal)
        self.dismiss(animated: true, completion: nil)
    }
}


