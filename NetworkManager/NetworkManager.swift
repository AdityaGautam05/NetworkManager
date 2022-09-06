//
//  NetworkManager.swift
//  Songs App
//
//  Created by Aditya Gautam on 12/05/21.
//

import Foundation

public class NetworkManager {
    public static let shared : NetworkManager = NetworkManager()
    private let session = URLSession.shared
    init(){
        //
    }
    
    public func fetchAPIData<T:Decodable>(apiCall : APIRequest, completionHandler : @escaping (T?, APIRequestError?) -> Void) {
        guard let url = URL(string: apiCall.url) else {
            completionHandler(nil, nil)
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            var decodedResponse : T?
            var apiCallError : APIRequestError?
            if let data = data {
                do {
                    decodedResponse =  try JSONDecoder().decode(T.self, from: data)
                } catch {
                    apiCallError = .jsonDecodingFailed
                }
            } else {
                apiCallError = .responseNotReceived
            }
            DispatchQueue.main.async {
                completionHandler(decodedResponse,apiCallError)
            }
        })
        task.resume()
    }
    
    public func downloadFile(request : DownloadRequest, completionHandler : @escaping (DownloadFileStatus?) -> Void) {
        
        guard let download = request.fileURL,
              let downloadUrl = URL(string: download),
              let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completionHandler(.unsuccessful)
            return
        }
        
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(downloadUrl.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
            do {
                try FileManager.default.removeItem(at: destinationUrl)
            } catch {
                print(error)
            }
        }
        
        URLSession.shared.downloadTask(with: downloadUrl, completionHandler: { (location, response, error) -> Void in
            guard let location = location, error == nil else { return }
            do {
                // after downloading your file you need to move it to your destination url
                try FileManager.default.moveItem(at: location, to: destinationUrl)
                print("File moved to documents folder")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                completionHandler(.successful)
            }
        }).resume()
    }
}
