//
//  SearchViewSuggestionsDataProvider.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit

protocol SearchViewSuggestionsDataProviderDelegate: AnyObject {
    func didSelectSuggestion(_ suggestion: String)
}

final class SearchViewSuggestionsDataProvider: NSObject {

    // MARK: - Private Properties

    private let rowHeight: CGFloat = 40

    private lazy var dataSource: UITableViewDiffableDataSource<Section, String> = {
        let dataSource = UITableViewDiffableDataSource<Section, String>(
            tableView: tableView
        ) { tableView, indexPath, suggestion in
            let identifier = UITableViewCell.uniqueIdentifier
            let cell = tableView.dequeueReusableCell(
                withIdentifier: identifier,
                for: indexPath
            )
            cell.textLabel?.text = suggestion
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .gray
            return cell
        }

        return dataSource
    }()

    private weak var tableView: UITableView!

    // MARK: - Delegate

    weak var delegate: SearchViewSuggestionsDataProviderDelegate?

    // MARK: - Lifecycle

    init(_ tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: UITableViewCell.uniqueIdentifier
        )
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        self.tableView.allowsSelection = true
        self.tableView.tableFooterView = UIView()
        self.tableView.isScrollEnabled = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.rowHeight = rowHeight
    }

    // MARK: - Public methods

    func update(_ data: [String], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(data, toSection: .suggestions)
        dataSource.apply(snapshot, animatingDifferences: animate)

        // update frame height to fit the new height of the tableView
        var frame = tableView.frame
        frame.size.height = CGFloat(data.count) * rowHeight
        tableView.frame = frame
    }

}

// MARK: - Private Logic

private extension SearchViewSuggestionsDataProvider {
    enum Section: CaseIterable {
        case suggestions
    }
}

// MARK: - UITableViewDelegate

extension SearchViewSuggestionsDataProvider: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let suggestion = dataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.didSelectSuggestion(suggestion)
    }

}
