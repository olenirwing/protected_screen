import Flutter
import UIKit

public class SwiftProtectedScreenPlugin: NSObject, FlutterPlugin {
    var backgroundTask: UIBackgroundTaskIdentifier!
    
    internal let registrar: FlutterPluginRegistrar
    var protectOnPause = false;

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
        registrar.addApplicationDelegate(self)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "protected_screen", binaryMessenger: registrar.messenger())
        let instance = SwiftProtectedScreenPlugin(registrar: registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
        // registrar.addApplicationDelegate(instance) //
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        if (protectOnPause) {
            addOverlayView()
        }
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        removeOverlayView();
    }
        
    public func addOverlayView() {
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
                    imageView.image = UIImage(named: "ProtectedScreenImage")
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
            self.endBackgroundTask()
        }
    }
    

    private func removeOverlayView() {
        if let window = UIApplication.shared.windows.filter({ (w) -> Bool in
                return w.isHidden == false
            }).first {
                if let view = window.viewWithTag(99697), let blurrView = window.viewWithTag(99698) {
                    view.removeFromSuperview()
                    blurrView.removeFromSuperview()
                }
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
        if (call.method == "addProtection") {
            protectOnPause = true
        } else if (call.method == "removeProtection") {
            protectOnPause = false
        }
    }
}
