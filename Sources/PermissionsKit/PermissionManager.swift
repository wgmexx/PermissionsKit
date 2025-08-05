import UIKit
import AVFoundation
import Photos

public final class PermissionManager: ObservableObject {
    
    public enum PermissionStatus {
        case authorized
        case denied
        case notDetermined
    }

    public static let shared = PermissionManager()
    
    private init() {}
    
    public func requestCameraPermission(completion: @escaping (Bool, Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            completion(true, false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted, false)
                }
            }
        case .denied, .restricted, @unknown default:
            DispatchQueue.main.async {
                completion(false, true)
            }
        }
    }
    
    public func requestPhotoLibraryPermission(completion: @escaping (Bool, Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            completion(true, false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited, false)
                }
            }
        case .denied, .restricted, @unknown default:
            DispatchQueue.main.async {
                completion(false, true)
            }
        }
    }
    
    public func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else { return }
        
        UIApplication.shared.open(settingsUrl)
    }
    
    public func handleMediaAccess(
        sourceType: UIImagePickerController.SourceType,
        onGranted: @escaping () -> Void,
        onDenied: @escaping (_ message: String) -> Void
    ) {
        switch sourceType {
        case .camera:
            requestCameraPermission { granted, shouldShowSettings in
                if granted {
                    onGranted()
                } else if shouldShowSettings {
                    onDenied("Camera access is required to take photos. Please enable it in Settings.")
                }
            }
        case .photoLibrary, .savedPhotosAlbum:
            requestPhotoLibraryPermission { granted, shouldShowSettings in
                if granted {
                    onGranted()
                } else if shouldShowSettings {
                    onDenied("Photo library access is required. Please enable it in Settings.")
                }
            }
        @unknown default:
            onDenied("Unsupported media source.")
        }
    }
}