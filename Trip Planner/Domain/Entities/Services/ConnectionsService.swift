//
//  ConnectionsService.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import Foundation

// MARK: - Typealias

typealias City = Vertex<String>

// MARK: - Abstraction

protocol ConnectionServicable {
    init(withVerticesData data: [String], _ connections: [Connection])
    func findCheapestPath(from: String, to: String) throws -> [Connection]
}

// MARK: - Service Errors

enum ConnectionsServiceError: Error {
    case failedToCalculatePath
}

// MARK: - Connections Service Implementation

// Inside this class we use highly efficient algorithm named Dijkstra used to determine the cheapest route
// to distant city even if there's no direct path to it.
final class ConnectionsService: ConnectionServicable {

    private var vertices: [String: City] = [:]
    private let connections: [Connection]
    private let graph = EdgeWeightedDigraph<String>()

    init(
        withVerticesData data: [String],
        _ connections: [Connection]
    ) {

        self.connections = connections
        setupVertices(data)
        setupEdges()
    }

    public func findCheapestPath(from: String, to: String) throws -> [Connection] {

        guard let source = findVertexWith(identifier: from),
              let destination = findVertexWith(identifier: to) else { return [] }

        let calculator = DijkstraShortestPath(graph, source: source)
        guard let path = calculator.pathTo(destination) else { return [] }
        return try convertPathToConnections(path)
    }

}

extension City: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

private extension ConnectionsService {

    func setupVertices(_ data: [String]) {
        data.forEach {
            let vertex = City($0)
            vertices[vertex.value] = vertex
            graph.addVertex(vertex)
        }
    }

    func setupEdges() {
        vertices.values.forEach { source in
            let edges = neighborConnectionsForVertexWith(identifier: source.value)
            edges.forEach { edge in
                guard let destination = findVertexWith(identifier: edge.to.lowercased()) else { return }
                graph.addEdge(source: source, destination: destination, weight: edge.price)
            }
        }
    }

    func neighborConnectionsForVertexWith(identifier: String) -> [Connection] {
        let neighbors = connections.filter { $0.from.lowercased() == identifier }
        return neighbors
    }

    func findConnectionFrom(source: City, destination: City) -> Connection? {
        let result = connections.first(where: {
            $0.from.lowercased() == source.value && $0.to.lowercased() == destination.value
        })
        return result
    }

    func convertPathToConnections(_ path: [City]) throws -> [Connection] {
        var prevVertex: City?
        var connectionsPath: [Connection] = []

        for vertex in path {
            guard let prev = prevVertex else {
                prevVertex = vertex
                continue
            }

            guard let connection = findConnectionFrom(source: prev, destination: vertex) else {
                throw ConnectionsServiceError.failedToCalculatePath
            }

            connectionsPath.append(connection)
            prevVertex = vertex
        }

        return connectionsPath
    }

    func findVertexWith(identifier: String) -> City? {
        vertices[identifier]
    }

}
