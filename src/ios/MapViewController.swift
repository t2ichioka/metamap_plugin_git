import Metamap
import UIKit

@objc(MapViewController)
@MainActor
final class MapViewController: UIViewController, MetamapMapViewDelegate {
    private var metamapView: MetamapMapView?
    private var loadTask: Task<Void, Never>?
    private var isMapReady = false
    var additionalQuery: [String: String] = [:]
    var language: String = "ja"
    
    @objc(viewDidLoad)
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

        loadTask = Task {
            do {
                try await mapView.load()
            } catch is CancellationError {
                // 画面終了による正常なキャンセル。
            } catch {
                // エラー内容をアプリの回復UIへ渡す。
            }
        }
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

    @objc(viewDidDisappear:)
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingDismissed || isMovingFromParent || navigationController?.isBeingDismissed == true else {
            return
        }
        loadTask?.cancel()
        metamapView?.dispose()
        metamapView = nil
        isMapReady = false
    }
}
