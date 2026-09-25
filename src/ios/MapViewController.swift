import Metamap
import UIKit

@MainActor
final class MapViewController: UIViewController, MetamapMapViewDelegate {
    private var metamapView: MetamapMapView?
    private var loadTask: Task<Void, Never>?
    private var isMapReady = false
    var additionalQuery: [String: String] = [:]
    var language: String = "ja"
    var isPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        let naviAppeance = UINavigationBarAppearance()
        naviAppeance.titleTextAttributes = [.foregroundColor: UIColor.white]
        naviAppeance.backgroundColor =  UIColor(red: (41.0/255.0), green: (104.0/255.0), blue: (177.0/255.0), alpha: 1.0)
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        naviAppeance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        let barButtonAppearance = UIBarButtonItemAppearance()
        barButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        naviAppeance.backButtonAppearance = barButtonAppearance
        naviAppeance.buttonAppearance = barButtonAppearance
        self.navigationItem.standardAppearance = naviAppeance
        self.navigationItem.compactScrollEdgeAppearance = naviAppeance
        self.navigationItem.compactAppearance = naviAppeance
        self.navigationItem.scrollEdgeAppearance = naviAppeance
        if isPresented {
            let barButton = UIBarButtonItem(title: NSLocalizedString("MetaMapCloseButton",tableName: "MetaMapLocalizable", comment:"Button"), style: .plain, target: self, action: #selector(closeButtonTapped(_:)))
            barButton.tintColor = .white
            self.navigationItem.leftBarButtonItem = barButton
        }
        self.title = NSLocalizedString("MetaMapTitle",tableName: "MetaMapLocalizable",comment: "Title")
        let mapView = MetamapMapView(configuration: .init(
            mapSlug: "miraikan",
            language: self.language,
            additionalQuery: self.additionalQuery
        ))
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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

    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true)
    }
}
