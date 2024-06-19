import UIKit

final class AlertPresenter {
    static func showError(delegate: UIViewController?) {
        let alertAction = AlertActionModel(title: "Ок") {}
        let alertModel = AlertModel(title: "Что-то пошло не так(",
                                    message: "Не удалось войти в систему",
                                    actions: [alertAction])
        show(alertModel: alertModel, delegate: delegate)
    }
    
    static func show(alertModel: AlertModel, delegate: UIViewController?) {
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "ApplicationAlert"
        for item in alertModel.actions {
            let action = UIAlertAction(title: item.title, style: .default) { _ in
                item.completion()
            }
            alert.addAction(action)
        }
        delegate?.present(alert, animated: true, completion: nil)
    }
}
