//
//  FileManager.swift
//  Rumpel
//
//  Created by Harel Avikasis on 05/07/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation

class RumpelFileManager{
    static let manager = RumpelFileManager()
    
    func isFileExist()->(Bool){
        let fileSuffix = "/image/" +  "background" + ".png"
        var directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        directoryURL.appendPathComponent(fileSuffix)
        return (FileManager.default.fileExists(atPath: directoryURL.path))
    }
    
    func saveFile(file : Any?)
    {
        if let image = file as? UIImage
        {
//            let fileSuffix = "background.png"
//            var directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            directoryURL.appendPathComponent(fileSuffix)
//            
//            do {
//                try UIImagePNGRepresentation(image)?.write(to: directoryURL, options: .atomic)
//            } catch {
//                return
//            }
            
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath          = paths.first
            {
                do {
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("background.png")
                    try UIImagePNGRepresentation(image)?.write(to: imageURL, options: .atomic)
                } catch {
                    return
                }

            }
            
        }
    }
    func loadImgae()->UIImage?
    {
//        let fileSuffix = "/image/" +  "background" + ".png"
//        var directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        directoryURL.appendPathComponent(fileSuffix)
//        
//        let image    = UIImage(contentsOfFile: directoryURL.absoluteString)
//        return image
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("background.png")
            return UIImage(contentsOfFile: imageURL.path)
            // Do whatever you want with the image
        }
        return nil
    }
    
    func deleteFile(at path: String){
        do{
            try FileManager.default.removeItem(atPath: path)
        }catch let error{
            print(error.localizedDescription)
        }
    }
}
