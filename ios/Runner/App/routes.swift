import Vapor
import SwiftyJSON

private var pubsCache = JSON()
//private var pubs = JSON()

private var pubs: [String: [WebSocket]] = [:]
//private var pubsCache: [String: Any] = [:]

func routes(_ app: Application) throws {
    app.get { req in
        // Check things from the request.
        return req.webSocket { req, ws in
            // Handle WebSocket lifecycle here
            // Connected WebSocket.
            print(ws)
            ws.onText { ws, text in
                // String received by this WebSocket.
                print(text)
                let msg = JSON(text)
                let type = msg["type"].stringValue
                let topic = msg["topic"].stringValue
                switch (type) {
                case "pub":
                    var sendMessage = false
                    if let websockets = pubs[topic] {
                        for web in websockets {
                            web.send(text)
                            sendMessage = true
                        }
                    }
                    if (!sendMessage) {
                        print("#####", "Cache message: $message")
                        pubsCache[topic].stringValue = text
                    }
                  break
                case "sub":
                    pubs[topic, default: []].append(ws)
                    ws.send(pubsCache[topic].stringValue)
                  break
                default: break
                    
                }
            }

            ws.onBinary { ws, binary in
                // [UInt8] received by this WebSocket.
                print(binary)
            }
        }
    }
}
