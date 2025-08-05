# 📸 PermissionsKit

`PermissionsKit` — Swift-пакет для запроса разрешений на **камеру** и **фотобиблиотеку** в iOS. Упрощает работу с системными API (`AVFoundation`, `Photos`) и предоставляет удобный интерфейс для обработки разрешений, отображения кастомных сообщений и открытия настроек приложения.

---

## 🛠 Требования

- iOS 14.0+
- Swift 5.5+
- Xcode 13+

---

## 📦 Установка через Swift Package Manager

1. Открой Xcode → File → Add Packages  
2. Вставь URL-адрес репозитория, например:

```
https://github.com/your-username/PermissionsKit.git
```

3. Добавь `PermissionsKit` как зависимость к своему приложению.

Или вручную в `Package.swift`:

```swift
.package(url: "https://github.com/your-username/PermissionsKit.git", from: "1.0.0")
```

---

## 📥 Импорт

```swift
import PermissionsKit
```

---

## ✅ Быстрое использование

```swift
PermissionManager.shared.handleMediaAccess(
    sourceType: .camera,
    onGranted: {
        // Разрешение получено — запускаем камеру
    },
    onDenied: { message in
        // Показываем Alert или другой UI с сообщением
        self.permissionAlertMessage = message
        self.showPermissionAlert = true
    }
)
```

---

## 🔐 Методы

### 🔸 requestCameraPermission

```swift
PermissionManager.shared.requestCameraPermission { granted, shouldShowSettings in
    if granted {
        // доступ разрешён
    } else if shouldShowSettings {
        // показать пользователю инструкцию с переходом в настройки
    }
}
```

### 🔸 requestPhotoLibraryPermission

```swift
PermissionManager.shared.requestPhotoLibraryPermission { granted, shouldShowSettings in
    if granted {
        // доступ разрешён
    } else if shouldShowSettings {
        // показать инструкцию
    }
}
```

### 🔸 openAppSettings

Открывает настройки приложения, если доступ был явно запрещён пользователем:

```swift
PermissionManager.shared.openAppSettings()
```

---

## 📄 Пример с SwiftUI

```swift
import SwiftUI
import PermissionsKit

struct ContentView: View {
    @State private var showPermissionAlert = false
    @State private var permissionAlertMessage = ""

    var body: some View {
        VStack {
            Button("Открыть камеру") {
                PermissionManager.shared.handleMediaAccess(
                    sourceType: .camera,
                    onGranted: {
                        // например: showCamera = true
                    },
                    onDenied: { message in
                        permissionAlertMessage = message
                        showPermissionAlert = true
                    }
                )
            }
        }
        .alert("Доступ запрещен", isPresented: $showPermissionAlert) {
            Button("Настройки") {
                PermissionManager.shared.openAppSettings()
            }
            Button("Отмена", role: .cancel) { }
        } message: {
            Text(permissionAlertMessage)
        }
    }
}
```

---

## 🌍 Кастомизация сообщений

Можно указать свои тексты:

```swift
PermissionManager.shared.handleMediaAccess(
    sourceType: .photoLibrary,
    onGranted: { },
    onDenied: { message in
        // Покажи кастомный Alert с message
    }
)
```

> Внутри пакета ты можешь доработать метод, если хочешь передавать свои сообщения как параметры (`cameraDeniedMessage`, `photoDeniedMessage` и т.д.)

---

## 📚 Поддерживаемые источники

- `.camera`
- `.photoLibrary`
- `.savedPhotosAlbum`

---

## 🧾 Локализация

Для локализации сообщений создай файл `Localizable.strings`:

```swift
"camera_denied" = "Камера недоступна. Разрешите доступ в Настройках.";
"photo_denied" = "Фотобиблиотека недоступна. Включите доступ в Настройках.";
```
