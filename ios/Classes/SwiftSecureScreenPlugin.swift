import Flutter
import UIKit

public class SwiftSecureScreenPlugin: NSObject, FlutterPlugin {
    var secured = false;
    var backgroundTask: UIBackgroundTaskIdentifier!
    
    internal let registrar: FlutterPluginRegistrar
    
    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
        // registrar.addApplicationDelegate(self)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "secure_screen", binaryMessenger: registrar.messenger())
        let instance = SwiftSecureScreenPlugin(registrar: registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance) //
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    public func goToBackground() {
        if ( secured ) {
            self.registerBackgroundTask()
            UIApplication.shared.ignoreSnapshotOnNextApplicationLaunch()
            if let window = UIApplication.shared.windows.filter({ (w) -> Bool in
                return w.isHidden == false
            }).first {
                
                if let existingView = window.viewWithTag(99697) {
                    window.bringSubviewToFront(existingView)
                    return
                } else {
                    let imageView = UIImageView.init(frame: window.bounds)
                    imageView.tag = 99697
                    imageView.clipsToBounds = true
                    imageView.contentMode = .center
//                    imageView.backgroundColor = UIColor(white: 1, alpha: 0.8)
                    imageView.image = UIImage(named: "SecureScreenImage")
                    imageView.isMultipleTouchEnabled = true
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    
                   
                    
                    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
                    let blurEffectView = UIVisualEffectView(effect: blurEffect)
                    blurEffectView.frame = window.bounds
                    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    
                    blurEffectView.tag = 99698
                    
                    window.addSubview(blurEffectView)
                    window.bringSubviewToFront(blurEffectView)
                    window.addSubview(imageView)
                    window.bringSubviewToFront(imageView)
                    window.snapshotView(afterScreenUpdates: true)
                    RunLoop.current.run(until: Date(timeIntervalSinceNow:0.5))
            
                }
            }
            self.endBackgroundTask()
        }
    }
    
    
    func registerBackgroundTask() {
        self.backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(self.backgroundTask != UIBackgroundTaskIdentifier.invalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "secure") {
            if (secured == false) {
                secured = true;
                goToBackground()
            }
            
        } else if (call.method == "unsecure") {
            secured = false;
            if let window = UIApplication.shared.windows.filter({ (w) -> Bool in
                return w.isHidden == false
            }).first {
                if let view = window.viewWithTag(99697), let blurrView = window.viewWithTag(99698) {
                    view.removeFromSuperview()
                    blurrView.removeFromSuperview()
                }
            }
        }
    }
}
