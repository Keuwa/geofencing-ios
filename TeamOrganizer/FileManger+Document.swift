//extension pour chopper l'endroit ou on peut ecrire la bdd
import Foundation

extension FileManager {
    
    public static func documentUrl() -> URL?{
        return documentURL(childPath: nil)
    }
    
    public static func documentURL(childPath: String?) -> URL?{
        if let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            if let path = childPath {
                return docURL.appendingPathComponent(path)
            }
            return docURL
        }
        return nil
    }
}
