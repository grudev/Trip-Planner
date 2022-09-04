//
//  ViewController.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit
import Combine

final class SearchViewController: UIViewController, StoryboardInstantiable {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var fromTextField: UITextField!
    @IBOutlet private weak var toTextField: UITextField!

    private lazy var suggestionsList = UITableView()
    private var suggestionsListDataProvider: SearchViewSuggestionsDataProvider!

    private var textFieldFirstResponder: UITextField?
    private var cancellables = Set<AnyCancellable>()

    var viewModel: SearchViewModelInput?
    var styles: SearchScreenStyles?

    // MARK: - ViewController Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }

}

// MARK: - Private Logic

private extension SearchViewController {

    func setup() {
        setupViews()
        setupBindings()
        setStyles()
        requestData()
    }

    func setupViews() {
        titleLabel.text = viewModel?.title
        fromTextField.delegate = self
        fromTextField.autocorrectionType = .no
        toTextField.delegate = self
        toTextField.autocorrectionType = .no

        suggestionsList.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(suggestionsList)
        suggestionsList.isHidden = true
        suggestionsListDataProvider = SearchViewSuggestionsDataProvider(suggestionsList)
        suggestionsListDataProvider.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func setupBindings() {

        fromTextField.textPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] text in
                guard let self = self else { return }
                self.requestSugestions(for: self.fromTextField, text: text)
            })
            .store(in: &cancellables)

        toTextField.textPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] text in
                guard let self = self else { return }
                self.requestSugestions(for: self.toTextField, text: text)
            })
            .store(in: &cancellables)

        viewModel?.selectionPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] selection in
                guard let self = self,
                      selection.isValid() else { return }
                self.haveValidSelection(selection)
            }
            .store(in: &cancellables)

        viewModel?.errorPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self = self,
                      let error = error else { return }
                self.showError(error)
            }
            .store(in: &cancellables)

    }

    func setStyles() {
        applyDefaultStyle(to: fromTextField)
        applyDefaultStyle(to: toTextField)
    }

    func requestData() {
        viewModel?.loadData()
    }

    func requestSugestions(for textField: UITextField, text: String?) {
        guard let text = text else {
            removeSuggestionsList()
            return
        }

        Task {
            guard let sugesstions = try await viewModel?.getSuggestions(text),
                  !sugesstions.isEmpty else {
                removeSuggestionsList()
                return
            }
            suggestionsListDataProvider.update(sugesstions)
            suggestionsList.isHidden = false

            // update frame position and width to fit under highlighted text field
            suggestionsList.frame.size.width = textField.frame.size.width
            suggestionsList.frame.origin = textField.frame.origin
            suggestionsList.frame.origin.y += textField.frame.height
        }

    }

    func checkTextField(_ textField: UITextField) {
        Task {
            guard let word = textField.text,
                  try await viewModel?.isValidWord(word) == true
            else {
                applyErrorStyle(to: textField)
                return
            }

            applyDefaultStyle(to: textField)

            switch textField {
            case fromTextField:
                viewModel?.updateFromSelection(word)
            case toTextField:
                viewModel?.updateToSelection(word)
            default:
                return
            }
        }
    }

    func haveValidSelection(_ selection: Selection) {
        viewModel?.haveValidSelection(selection)
    }

    func removeSuggestionsList() {
        suggestionsList.isHidden = true
        suggestionsListDataProvider.update([])
    }

    func showError(_ error: Error) {
        print("Error: \(error)")
    }

}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldFirstResponder = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTextField(textField)
    }

}

// MARK: - SearchViewSuggestionsDataProviderDelegate

extension SearchViewController: SearchViewSuggestionsDataProviderDelegate {
    func didSelectSuggestion(_ suggestion: String) {
        guard let textField = textFieldFirstResponder else { return }
        textField.text = suggestion
        checkTextField(textField)
        removeSuggestionsList()
    }
}

// MARK: - Styles

protocol SearchScreenStyles {
    var backgroundColor: UIColor { get }
}

extension SearchViewController {

    struct DefaultSearchScreenStyles: SearchScreenStyles {
        var backgroundColor: UIColor
    }

    func applyErrorStyle(to textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.red.cgColor
    }

    func applyDefaultStyle(to textField: UITextField) {
        textField.layer.borderWidth = 0
    }

}
