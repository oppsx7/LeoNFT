//
//  UserProfileViewController.swift
//  LeoNFT
//
//  Created by Edis Hasanov on 25/02/2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

protocol UserProfileViewInput: HasLoadingState {
    func updateView(user: User, favoritedCollectionString: String)
    func showEditProfileModal()
}

protocol UserProfileViewOutput: AnyObject {
    func viewIsReady()
    func didTapEditProfile()
    func didSelectEditUsername()
    func didSelectChangeProfilePickture()
}

final class UserProfileViewController: UIViewController {
    var output: UserProfileViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewIsReady()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = nil
    }

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var personalNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var favoritedCollectionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return button
    }()

    @objc func didTapEditButton() {
        output?.didTapEditProfile()
    }

    private func configureView(user: User, favoritedCollectionString: String) {
        let viewElements = [
            profileImageView,
            personalNameLabel,
            favoritedCollectionsLabel,
            editProfileButton
        ]
        for viewElement in viewElements {
            view.addSubview(viewElement)
        }

        title = user.username

        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))

        personalNameLabel.text = user.fullname
        personalNameLabel.textAlignment = .center
        personalNameLabel.font = UIFont.boldSystemFont(ofSize: 16)

        favoritedCollectionsLabel.text = favoritedCollectionString
        favoritedCollectionsLabel.textAlignment = .center

        editProfileButton.setTitle("Edit profile", for: .normal)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            personalNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            personalNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            personalNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            favoritedCollectionsLabel.topAnchor.constraint(equalTo: personalNameLabel.bottomAnchor, constant: 8),
            favoritedCollectionsLabel.leadingAnchor.constraint(equalTo: personalNameLabel.leadingAnchor),
            favoritedCollectionsLabel.trailingAnchor.constraint(equalTo: personalNameLabel.trailingAnchor),

            editProfileButton.topAnchor.constraint(equalTo: favoritedCollectionsLabel.bottomAnchor, constant: 8),
            editProfileButton.leadingAnchor.constraint(equalTo: personalNameLabel.leadingAnchor, constant: 16),
            editProfileButton.trailingAnchor.constraint(equalTo: personalNameLabel.trailingAnchor, constant: -16)
        ])
    }
}

extension UserProfileViewController: UserProfileViewInput {
    func updateView(user: User, favoritedCollectionString: String) {
        configureView(user: user,
                      favoritedCollectionString: favoritedCollectionString)
    }

    func showEditProfileModal() {
        let actionSheet = UIAlertController(title: "Edit profile",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let changeUsernameAction = UIAlertAction(title: "Change username",
                                                 style: .default,
                                                 handler: { [weak output] _ in
            output?.didSelectEditUsername()
        })
        let changeProfilePicture = UIAlertAction(title: "Change profile picture",
                                                 style: .default,
                                                 handler: { [weak output] _ in
            output?.didSelectChangeProfilePickture()
        })
        actionSheet.addAction(changeUsernameAction)
        actionSheet.addAction(changeProfilePicture)
        present(actionSheet,
                animated: true)
    }
}
