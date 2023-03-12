//
//  ViewController.swift
//  TableShuffled
//
//  Created by Эллина Коржова on 12.03.23.
//

import UIKit

final class ViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, CellData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CellData>

    private var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var dataSource = createDiffableDataSource()
    private lazy var shuffleButton = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleTapped))

    private var data = [CellData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...50 {
            data.append(CellData(title: i))
        }
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        reload()
    }
}

private extension ViewController {
    func setupView() {
        view.backgroundColor = .white
        title = "Table"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = shuffleButton
        setupTable()
    }

    func setupTable() {
        tableView.frame = view.frame
        view.addSubview(tableView)
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionId = dataSource.sectionIdentifier(for: indexPath.section) else {
            return
        }

         switch sectionId {
    case .numbers:
        data[indexPath.row].isFavorite.toggle()
           move(to: indexPath)
        }
    }

    private func createDiffableDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
            var config = cell.defaultContentConfiguration()
            config.text = "\(itemIdentifier.title)"
            cell.accessoryType = self.data[indexPath.row].isFavorite ? .checkmark : .none
            cell.contentConfiguration = config

            return cell
        }
        return dataSource
    }
}

private extension ViewController {
    @objc
    func shuffleTapped() {
        data.shuffle()
        reload()
    }

    func reload() {                       
        var snapshot = Snapshot()
        snapshot.appendSections([.numbers])
        snapshot.appendItems(data, toSection: .numbers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func move(to indexPath: IndexPath) {
        let itemToMove = data[indexPath.row]
        reload()

        if itemToMove.isFavorite {
            data.remove(at: indexPath.row)
            data.insert(itemToMove, at: 0)
            reload()
        }
    }
}

