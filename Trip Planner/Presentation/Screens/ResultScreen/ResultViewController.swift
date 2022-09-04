//
//  ResultViewController.swift
//  Trip Planner
//
//  Created by Dimitar Grudev on 5.09.22.
//

import UIKit
import MapKit
import Combine

final class ResultViewController: UIViewController, StoryboardInstantiable {

    // MARK: - IBOutlets

    @IBOutlet weak var map: MKMapView!

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Properties

    var viewModel: ResultViewModelInput?
    var styles: ResultScreenStyles?

    // MARK: - ViewController Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private ViewController

private extension ResultViewController {

    func setup() {
        setupViews()
        setupBindings()
        setStyles()
    }

    func setupViews() {
        title = viewModel?.title
        map.delegate = self
    }

    func setupBindings() {

        viewModel?.routePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] route in
                guard let self = self else { return }
                self.setupMap(with: route)
            })
            .store(in: &cancellables)

    }

    func setupMap(with route: [Connection]) {

        var annotationsArr = [MKPointAnnotation]()

        route.forEach {
            let annotations = createAnnotations($0)
            let line = MKPolyline(
                coordinates: [
                    $0.coordinates.from.coordinate,
                    $0.coordinates.to.coordinate
                ],
                count: 2
            )
            map.addAnnotations(annotations)
            map.addOverlay(line)
            annotationsArr.append(contentsOf: annotations)
        }

        map.showAnnotations(annotationsArr, animated: true)

    }

    func createMapItem(_ coordinate: CLLocationCoordinate2D) -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        return MKMapItem(placemark: placemark)
    }


    func createAnnotations(_ connection: Connection) -> [MKPointAnnotation] {
        let startLoc = connection.coordinates.from.coordinate
        let endLoc = connection.coordinates.to.coordinate

        let start = MKPointAnnotation()
        start.title = connection.from.uppercased()
        start.coordinate = startLoc

        let end = MKPointAnnotation()
        end.title = connection.to.uppercased()
        end.coordinate = endLoc

        return [start, end]
    }

    func setStyles() { }

}

// MARK: - MKMapViewDelegate

extension ResultViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 4.0
        renderer.lineDashPhase = 2
        renderer.lineDashPattern = [NSNumber(value: 1),NSNumber(value:5)]
        return renderer
    }

}

// MARK: - Styles

protocol ResultScreenStyles {
    var backgroundColor: UIColor { get }
}

extension ResultViewController {

    struct DefaultResultViewStyles: ResultScreenStyles {
        var backgroundColor: UIColor
    }

}

fileprivate extension Coordinate {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
