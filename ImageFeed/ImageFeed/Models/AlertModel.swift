import Foundation

struct AlertActionModel {
    let title: String
    var completion: () -> Void
    
    init(title: String, completion: @escaping () -> Void) {
        self.title = title
        self.completion = completion
    }
}

struct AlertModel {
    let title: String
    let message: String
    let actions: [AlertActionModel]
    
    init(title: String, message: String, actions: [AlertActionModel]) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}

