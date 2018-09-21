extension UIApplication {

    class var appVersionWithBuildNumber: String {
        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            
            return "\(versionNumber) (\(buildNumber))"
        }
    
        return "No version number found."
    }

    class var appVersion: String {
        if let versionNumber =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            
            return versionNumber
        }
            
        return "No version number found."
    }

    class var buildNumber: String {
        if let buildNumber =  Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return buildNumber
        }
        
        return "No build number found."
    }
    
}
