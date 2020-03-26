//
//  ContentView.swift
//  SwiftUI TableView
//
//  Created by Noshaid Ali on 22/03/2020.
//  Copyright © 2020 Noshaid Ali. All rights reserved.
//

import SwiftUI

enum SectionType {
    case ceo, peasants
}

struct Contact: Hashable {
    let name: String
}

class ContactViewModel: ObservableObject {
    @Published var name = ""
}

struct ContactRootView: View {
    
    @ObservedObject var viewModel: ContactViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
            Text(viewModel.name)
            Spacer()
            Image(systemName: "star")
        }.padding(20)
    }
}

class ContactCell: UITableViewCell {
    
    var viewModel = ContactViewModel()
    lazy var row = ContactRootView(viewModel: viewModel)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //setup SwiftUI view
        let hostingController = UIHostingController(rootView: row)
        addSubview(hostingController.view)
        hostingController.view.fillSuperview()
        viewModel.name = "ABC"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DiffableTableViewController: UITableViewController {
    
    //UITableViewDiffableDataSource
    
    lazy var source: UITableViewDiffableDataSource<SectionType, Contact> = .init(tableView: self.tableView) {
        (tableView, indexPath, conatct) -> UITableViewCell? in
        
        let cell = ContactCell(style: .default, reuseIdentifier: nil)
        cell.viewModel.name = conatct.name
        return cell
    }
    
    private func setupSource() {
        var snapshot = source.snapshot()
        snapshot.appendSections([.ceo, .peasants])
        snapshot.appendItems([
            .init(name: "Elon Musk"),
            .init(name: "Tim Cook")
        ], toSection: .ceo)
        snapshot.appendItems([.init(name: "Bill Gates")], toSection: .peasants)
        source.apply(snapshot)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = section == 0 ? "CEO" : "Peasant"
        return label
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSource()
    }
}

struct DiffableContainer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DiffableContainer>) -> UIViewController {
        UINavigationController(rootViewController: DiffableTableViewController(style: .insetGrouped))
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DiffableContainer>) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView()
        DiffableContainer()
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}
