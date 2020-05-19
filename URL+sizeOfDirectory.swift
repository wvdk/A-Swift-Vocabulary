import Foundation

// Adapted from https://gist.github.com/nstein/8ba93dcd9a39556f312f9380ebb4effa

extension URL {
    
    /// Recursively calculates the size of the current directory and every subdirectory. Return value is in bytes.
    func calculateSizeOfDirectory() -> Int64? {
        guard self.isFileURL else {
            return nil
        }
        
        let contents: [URL]
        do {
            contents = try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey])
        } catch {
            return nil
        }
        
        var size: Int64 = 0
        
        for url in contents {
            let isDirectoryResourceValue: URLResourceValues
            
            do {
                isDirectoryResourceValue = try url.resourceValues(forKeys: [.isDirectoryKey])
            } catch {
                continue
            }
            
            if isDirectoryResourceValue.isDirectory == true {
                size += url.calculateSizeOfDirectory() ?? 0
            } else {
                let fileSizeResourceValue: URLResourceValues
                do {
                    fileSizeResourceValue = try url.resourceValues(forKeys: [.fileSizeKey])
                } catch {
                    continue
                }
                
                size += Int64(fileSizeResourceValue.fileSize ?? 0)
            }
        }
        
        return size
    }
    
}
