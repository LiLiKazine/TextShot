//
//  ListCollectionLayout.swift
//  TextShot
//
//  Created by yingkelei on 2020/10/19.
//

import UIKit

enum Option: String, CaseIterable {
    case width, foregroundColor, backgroundColor, fontSize
}

enum Section: Hashable {
    case main
}

class Item: Hashable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    var key: Option
    var title: String
    var defaultValue: String?
    var value: String?
    init(_ key: Option, _ title: String, _ defaultValue: String? = nil, _ value: String? = nil) {
        self.key = key
        self.title = title
        self.defaultValue = defaultValue
        self.value = value
    }
}

class ListProvider {
    
    var listLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            
            configuration.backgroundColor = COLOR2
            configuration.footerMode = .supplementary
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
            return section
        }
        return layout
    }()

    private(set) var configurations: [Item]
    
    var count: Int {
        return configurations.count
    }
    
    init() {
        configurations = Option.allCases.map { option -> Item in
            let model = Item(option, option.rawValue)
            return model
        }
    }
    
    func model(at index: Int) -> Item? {
        guard index < configurations.count else {
            return nil
        }
        let model = configurations[index]
        return model
    }

}
