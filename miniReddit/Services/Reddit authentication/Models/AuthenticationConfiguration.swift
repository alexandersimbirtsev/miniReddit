
import Foundation

struct AuthenticationConfiguration {
    let apiState:          String
    let redirectURI:       String
    let callbackURLScheme: String
    let scheme:            String
    let host:              String
    let clientID:          String
    let responseType:      String
    let duration:          String
    let scope:             String
}

extension  AuthenticationConfiguration {
    static let `default`: Self = .init(
        apiState:          UUID().uuidString,
        redirectURI:       "broforreddit://oauth-callback",
        callbackURLScheme: "broforreddit",
        scheme:            "https",
        host:              "www.reddit.com",
        clientID:          Bundle.main.infoDictionary?["CLIENT_ID"] as? String ?? "Failed to get CLIENT_ID. Add it to Config.xcconfig file",
        responseType:      "code",
        duration:          "permanent",
        scope:             ["identity", "read"].joined(separator: ",")
    )
}
