import Foundation
import UIKit

@MainActor
@objc(CallMetaMap) class CallMetaMap : CDVPlugin {
    // JSから呼び出されるメソッド
    @objc(callMetaMap:)
    func callMetaMap(command: CDVInvokedUrlCommand) {
        var result: String = " additionalQuery = "
        // JSから渡された引数を取得
        let additionalQuery = command.arguments[0] as? Dictionary<String, String> ?? [:]
        additionalQuery.forEach { key, value in
            result += "[\(key): \(value)]"
        }
        let language = command.arguments[1] as? String ?? ""
        result += " language = \(language)"
        Task {
            await showMap(additionalQuery: additionalQuery, language: language)
            var pluginResult: CDVPluginResult
            if !result.isEmpty {
                 // JS側に成功データを返す
                 pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result)
            } else {
                 // JS側にエラーを返す
                 pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "なぜゆえかエラー")
            }
             // 結果を送信
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }

    private func showMap(additionalQuery: [String: String], language: String) async {
        let mapController: MapViewController = MapViewController()
        mapController.additionalQuery = additionalQuery
        mapController.language = language
        if let navigationController = self.viewController.navigationController {
            navigationController.pushViewController(mapController, animated: true)
        } else {
            self.viewController.present(mapController, animated: true)
        }
    }
}
