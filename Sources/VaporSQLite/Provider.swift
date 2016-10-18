import Vapor
import FluentSQLite

public final class Provider: Vapor.Provider {

    
    public enum Error:Swift.Error {
        case noSQLiteConfig
        case pathMissing
    }
    
    private let configuredPath: String
    
    public init(config: Config) throws {
        guard let sqlite = config["sqlite"]?.object else {
            throw Error.noSQLiteConfig
        }
        
        guard let configuredPath = sqlite["path"]?.string else {
            throw Error.pathMissing
        }
        
        self.configuredPath = configuredPath
        
    }
    
    public func boot(_ drop: Droplet) {
        
        let path: String
        if configuredPath.hasPrefix("/") {
            path = configuredPath
        } else {
            path = drop.workDir + configuredPath
        }
        
        guard let driver = try? SQLiteDriver(path: path) else {
            return
        }
        
        drop.database = Database(driver)
    }
    
    public func afterInit(_: Droplet) {
        //
    }
    
    public func beforeRun(_: Droplet) {
        //
    }


}
