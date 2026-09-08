import Metamap
import UIKit

final class MapViewController: UIViewController, MetamapMapViewDelegate {
    private var metamapView: MetamapMapView?
    private var isMapReady = false
    var additionalQuery: [String: String] = [:]
    var language: String = "ja"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        let mapView = MetamapMapView(configuration: .init(
            mapSlug: "example",
            language: self.language,
            additionalQuery: self.additionalQuery
        ))
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        metamapView = mapView
    }

    func metamapMapView(_ mapView: MetamapMapView, didReceive event: MetamapMapViewEvent) {
        switch event {
        case .ready:
            isMapReady = true
        case .loadState(.loading):
            isMapReady = false
        case .error(let error):
            // エラー内容をアプリの回復UIへ渡す。
            print(error.localizedDescription)
        default:
            // SDK更新でイベントが追加される可能性があるため、defaultを残します。
            break
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingDismissed || isMovingFromParent || navigationController?.isBeingDismissed == true else {
            return
        }
        metamapView?.dispose()
        metamapView = nil
        isMapReady = false
    }
}