import Foundation

// Components - собираем ссылку

enum Paths: String {
    case products = "/products/automation"
    case contracts = "/chainlink-automation/guides/compatible-contracts"
    case vrf = "/vrf"
}

func createURL(paths: Paths, queryItems: [URLQueryItem]? = nil) -> URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "dev.chain.link"
    components.path = paths.rawValue
    components.queryItems = queryItems
    
    return components.url
}

let url = createURL(paths: .products)
let nextUrl = createURL(paths: .vrf, queryItems: [URLQueryItem(name: "userId", value: "1")])

// URLRequest
enum HTTPMethods: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case patch = "PATCH"
}

func createRequest(url: URL?, method: HTTPMethods) -> URLRequest? {
    guard let url else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return request
}

// URLSession - создаем запрос

func getData() {
    guard let url = createURL(paths: .products),
          let request = createRequest(url: url, method: .get) else { return }
    let session = URLSession.shared
    
    session.dataTask(with: request) { data, response, error in
        if error != nil {
            print("Error in session -> \(error?.localizedDescription ?? "unknown")")
        } else {
            guard let response = response as? HTTPURLResponse else { return }
            
            switch response.statusCode {
            case 200:
                print("It's done!")
                guard let data else { return }
                let result = String(data: data, encoding: .utf8)
                print("The data is ---\n\(result)")
            case 400...500:
                print("Error")
            default:
                print("Unexpected error")
            }
        }
    }.resume()
}

getData()
print("")
