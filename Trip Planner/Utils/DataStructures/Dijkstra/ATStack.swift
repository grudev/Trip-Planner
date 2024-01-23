//
//  ATStack.swift
//  ATEdgeWeightedDigraph
//
//  Created by Dejan on 17/08/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import Foundation

public class ATStack<StackElement: Equatable> {

    class Node<Element> {
        var item: Element
        var next: Node?
        
        init(withItem item: Element) {
            self.item = item
        }
    }
    
    private var head: Node<StackElement>?
    private var count: Int = 0
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var size: Int {
        return count
    }
    
    public func push(item: StackElement) {
        let oldHead = head
        head = Node(withItem: item)
        head?.next = oldHead
        count += 1
    }
    
    public func pop() -> StackElement? {
        let item = head?.item
        head = head?.next
        count -= 1
        return item
    }
    
    public func peek() -> StackElement? {
        return head?.item
    }
    
    public func contains(_ element: StackElement) -> Bool {
        var current = head
        while (current != nil) {
            if current?.item == element {
                return true
            }
            current = current?.next
        }
        return false
    }
    
    public func allElements() -> [StackElement] {
        var result: [StackElement] = []
        
        var current = head
        while current != nil {
            result.append(current!.item)
            current = current?.next
        }
        
        return result
    }
}
