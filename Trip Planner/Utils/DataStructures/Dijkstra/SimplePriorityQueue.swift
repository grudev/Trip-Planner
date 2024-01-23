//
//  SimplePriorityQueue.swift
//  ATEdgeWeightedDigraph
//
//  Created by Dejan on 31/07/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import Foundation

public class SimplePriorityQueue<QueueElement: Equatable> {

    private class QueueItem<Element: Equatable>: Comparable {
        
        let value: Element
        var priority: Double
        
        init(_ value: Element, priority: Double) {
            self.value = value
            self.priority = priority
        }
        
        static func < (lhs: QueueItem<Element>, rhs: QueueItem<Element>) -> Bool {
            return lhs.priority < rhs.priority
        }
        
        static func == (lhs: QueueItem<Element>, rhs: QueueItem<Element>) -> Bool {
            return lhs.priority == rhs.priority
        }
    }
    
    private var items: [QueueItem<QueueElement>] = []

    public var isEmpty: Bool {
        return items.isEmpty
    }
    
    public func contains(_ item: QueueElement) -> Bool {
        return items.contains { $0.value == item }
    }
    
    public func insert(_ item: QueueElement, priority: Double) {
        if contains(item) {
            update(item, priority: priority)
        } else {
            let newItem = QueueItem<QueueElement>(item, priority: priority)
            items.append(newItem)
            sortItems()
        }
    }
    
    public func update(_ item: QueueElement, priority: Double) {
        if let existingItem = items.filter({ $0.value == item }).first {
            existingItem.priority = priority
            sortItems()
        }
    }
    
    public func deleteMin() -> QueueElement? {
        guard isEmpty == false else {
            return nil
        }
        
        let item = items.removeFirst()
        return item.value
    }
    
    private func sortItems() {
        items = items.sorted(by: < )
    }
}
