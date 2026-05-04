# EquiPay 💸

> **Fair splits. Smarter sharing.**

EquiPay es una app multiplataforma (iOS + Android) para dividir gastos compartidos
entre amigos, familia o roommates: cenas, viajes, suscripciones o cualquier gasto
en grupo. Su objetivo es facilitar el registro, división y liquidación de cuentas
de forma justa y sin fricción.

> ⚠️ **Estado actual:** proyecto en desarrollo temprano. Solo existe la
> implementación de **iOS (Swift / SwiftUI)** con UI y navegación. Todavía **no
> hay backend, base de datos, autenticación real ni el módulo de Android**. Ver
> [Roadmap](#-roadmap).

---

## 📑 Tabla de contenido

- [Visión del producto](#-visión-del-producto)
- [Plataformas objetivo](#-plataformas-objetivo)
- [Arquitectura](#-arquitectura)
- [Estructura del repositorio](#-estructura-del-repositorio)
- [Módulos del proyecto](#-módulos-del-proyecto)
- [Funcionalidades implementadas](#-funcionalidades-implementadas)
- [Stack técnico](#-stack-técnico)
- [Configuración por entornos](#-configuración-por-entornos)
- [Higiene del repositorio](#-higiene-del-repositorio)
- [Cómo correr el proyecto (iOS)](#-cómo-correr-el-proyecto-ios)
- [Roadmap](#-roadmap)
- [Convenciones del repositorio](#-convenciones-del-repositorio)

---

## 🎯 Visión del producto

EquiPay quiere ser una app **simple, rápida y justa** para gestionar gastos
compartidos. La experiencia principal del usuario incluye:

- Crear grupos para distintos contextos (viaje, casa, cena, suscripción, etc.).
- Registrar gastos y dividirlos automáticamente.
- Ver de un vistazo cuánto le deben y cuánto debe a cada persona.
- Mantener historial completo de gastos y pagos.
- Recibir recordatorios sin ser invasivos.
- Permitir ajustes manuales para casos especiales.

---

## 📱 Plataformas objetivo

| Plataforma | Lenguaje | UI | Estado |
|-----------|----------|-----|--------|
| iOS | Swift 6.1 | SwiftUI | 🟢 En desarrollo (UI navegable) |
| Android | Kotlin | Jetpack Compose | 🔴 Aún no iniciado |

La arquitectura y los patrones de diseño elegidos están pensados explícitamente
para que ambas implementaciones sean equivalentes en estructura, capas y
responsabilidades. Ver sección [Arquitectura](#-arquitectura).

---

## 🏛️ Arquitectura

El proyecto sigue una **arquitectura modular** ("Modular Monolith") combinada
con **Clean Architecture por capas** y **MVVM + Coordinator** en la capa de
presentación. La elección busca paridad entre iOS y Android.

### Decisiones arquitectónicas clave

1. **Modularización por feature + módulos compartidos.** Cada feature
   (Onboarding, Auth, Home, Groups, CreateGroup, Activity, Profile, MainTab) vive en su propio módulo:
   - **iOS:** Swift Packages locales (SPM) bajo `Features/` y `Packages/`.
   - **Android (planeado):** módulos Gradle bajo `features/` y `core/`.

2. **Capas internas por módulo.** Cada módulo de feature está pensado para
   organizarse internamente en tres capas:
   - `data/` (repositorios, DTOs, fuentes remotas y locales)
   - `domain/` (entidades puras, casos de uso, contratos)
   - `presentation/` (Views + ViewModels + Coordinator/Navigator)

3. **MVVM en presentación.** Toda vista tiene un `ViewModel` que expone estado
   observable y recibe acciones. En iOS se usa `ObservableObject` con
   `@Published` y `@StateObject`; en Android se usará `ViewModel` de
   AndroidX con `StateFlow`.

4. **Coordinator pattern para navegación.** La navegación no la decide la View
   ni el ViewModel: la decide un `Coordinator` que recibe callbacks.
   - En iOS: `AppCoordinator`, `AuthCoordinator`, `MainTabCoordinator`.
   - En Android: se replicará con `Navigator`/`NavController`.

5. **Contratos compartidos en módulos transversales.** Modelos de dominio,
   utilidades y feature flags viven en módulos sin dependencias de UI
   (`SharedDomain`, `Core`, `FeatureFlags`).

6. **Design System como módulo independiente.** Componentes visuales
   reutilizables sin lógica de negocio. El equivalente Android será otro módulo
   Compose con los mismos componentes y la misma API pública.

7. **Inyección por constructor / closures.** Las dependencias se pasan en el
   `init`. Las features reciben callbacks de navegación, no referencias entre sí.

### Patrones de diseño aplicados

| Patrón | Dónde se usa | Propósito |
|--------|--------------|-----------|
| **MVVM** | Todas las vistas | Separar estado/lógica de UI |
| **Coordinator** | `AppCoordinator`, `AuthCoordinator`, `MainTabCoordinator` | Centralizar navegación y desacoplar features |
| **Container / Factory** | `AuthContainer.makeAuthRoot(...)` | Punto de entrada público de un módulo |
| **Dependency Injection (constructor)** | ViewModels, Coordinators | Testabilidad y desacople |
| **Repository (planeado)** | Capa `data` por feature | Abstraer fuentes de datos |

---

## 📂 Estructura del repositorio

```
EquiPay/
├── EquiPay.xcodeproj/
│   └── xcshareddata/xcschemes/
│       ├── EquiPay-Dev.xcscheme
│       ├── EquiPay-Stage.xcscheme
│       └── EquiPay-Prod.xcscheme
│
├── EquiPay/
│   ├── App/
│   │   ├── EquiPayApp.swift
│   │   ├── Application/
│   │   │   ├── AppCoordinator.swift
│   │   │   ├── AppDelegate.swift
│   │   │   └── SceneDelegate.swift
│   │   ├── Config/
│   │   │   ├── Dev.xcconfig
│   │   │   ├── Stage.xcconfig
│   │   │   └── Prod.xcconfig
│   │   ├── Resources/Assets.xcassets/
│   │   ├── LaunchScreen.storyboard
│   │   └── Info.plist
│   │
│   ├── Features/
│   │   ├── Onboarding/
│   │   ├── Auth/
│   │   ├── Home/
│   │   ├── Groups/
│   │   ├── CreateGroup/
│   │   ├── Activity/
│   │   ├── Profile/
│   │   └── MainTab/
│   │
│   └── Packages/
│       ├── Core/
│       ├── SharedDomain/
│       ├── FeatureFlags/
│       └── DesignSystem/
│
├── EquiPayTests/
└── EquiPayUITests/
```

---

## 🧩 Módulos del proyecto

### Features

| Módulo | Estado | Contenido actual |
|--------|--------|-----------------|
| **Onboarding** | 🟢 Implementado | Carrusel de 6 features con autoplay, indicadores tap-to-go, CTAs `Log in` / `Sign up`. |
| **Auth** | 🟡 UI lista, sin lógica real | `LoginView`, `SignUpView`, `LoginViewModel`, `SignUpViewModel`, `AuthCoordinator`, `AuthContainer`, `AuthRoute`. |
| **Home** | 🟡 UI con datos mock | Header gradiente, saludo en español, tres `SummaryCard`, sección "Grupos recientes" con `ExpenseCard` y sección "Acciones rápidas" con `QuickActionCard`. |
| **Groups** | 🟡 UI con datos mock | Pantalla "Mis grupos". Botón "Crear nuevo grupo" que salta al tab Crear vía `Binding<Int>`. Lista de 5 grupos con `ExpenseCard`. |
| **CreateGroup** | 🟡 UI con datos mock | Pantalla "Crear grupo" con selector de tipo: Vacaciones, Suscripción mensual (activos) y Evento único (badge "Próximamente", deshabilitado). `GroupType` enum con ícono, color y disponibilidad. |
| **Activity** | 🟡 UI con datos mock | Pantalla "Actividad" con selector segmentado custom (Notificaciones / Historial) y 3 tarjetas mock. Historial pendiente de definición. |
| **Profile** | 🟡 UI con datos mock | Pantalla "Mi perfil" con avatar+inicial, 3 stat cards, menú de opciones con íconos teal, botón Cerrar sesión (solo UI) y versión. |
| **MainTab** | 🟡 Estructura completa | `TabView` con 5 pestañas en español, todas conectadas a su vista real. `MainTabViewModel` expone `selectedTabIndex: Int` para navegación entre tabs sin acoplamiento. |

### Packages (transversales)

| Módulo | Estado | Propósito |
|--------|--------|----------|
| **DesignSystem** | 🟢 En uso | `PrimaryButton`, `SecondaryButton`, `GhostButton`, `SummaryCard`, `ExpenseCard` (con `ExpenseStatus` y `BalanceDirection`), `QuickActionCard`, `EmailInput`, `TextFields`. |
| **Core** | 🔴 Vacío | Utilidades transversales (networking, logging, persistencia, extensions). |
| **SharedDomain** | 🔴 Vacío | Entidades de dominio compartidas (User, Group, Expense, Settlement). |
| **FeatureFlags** | 🔴 Vacío | Flags de funcionalidad y experimentación. |

### Grafo de dependencias actual

```
EquiPayApp
   ├── Onboarding   ──► DesignSystem
   ├── Auth         ──► DesignSystem
   └── (futuro) MainTab ──► DesignSystem
                            ├── Home        ──► DesignSystem
                            ├── Groups      ──► DesignSystem
                            ├── CreateGroup ──► DesignSystem
                            ├── Activity    ──► DesignSystem
                            └── Profile     ──► DesignSystem
```

> Las features **no se importan entre sí**: la coordinación se hace desde
> `AppCoordinator` / `MainTabCoordinator` vía closures y bindings.

---

## ✅ Funcionalidades implementadas

### Implementado y navegable

- ✅ Splash / Launch Screen con icono de la app.
- ✅ Pantalla de **Onboarding** con carrusel automático e indicadores tappables.
- ✅ Navegación a **Login** y **Sign Up** desde el Onboarding (via `fullScreenCover`).
- ✅ Cambio entre Login ↔ Sign Up dentro del flujo de Auth.
- ✅ Vista **Home** con cards de resumen, grupos recientes y accesos rápidos.
- ✅ Vista **Grupos** con lista completa y botón "Crear nuevo grupo".
- ✅ Vista **Crear grupo** con selector de tipo (Vacaciones, Suscripción mensual, Evento único próximamente).
- ✅ Vista **Actividad** con selector segmentado custom (Notificaciones / Historial) y tarjetas mock.
- ✅ Vista **Perfil** con avatar, stats, menú de opciones y botón de cierre de sesión.
- ✅ **TabBar** principal con 5 secciones en español completamente conectadas.
- ✅ Componentes de Design System reutilizables.
- ✅ Schemes y `.xcconfig` separados para Dev / Stage / Prod.

### Pendiente / no implementado

- ❌ Autenticación real.
- ❌ Backend / API.
- ❌ Persistencia local.
- ❌ Modelo de dominio (`User`, `Group`, `Expense`).
- ❌ Crear / editar / eliminar grupos y gastos.
- ❌ Cálculo de balances.
- ❌ Notificaciones push.
- ❌ Detalle de grupo al tocar una tarjeta.
- ❌ Formulario real de creación de grupo.
- ❌ Historial en la pantalla Actividad (pendiente de definición).
- ❌ Cablear `AppCoordinator` → `MainTabView` tras Auth.
- ❌ Implementación Android (Kotlin / Jetpack Compose).
- ❌ Tests unitarios y de UI con cobertura significativa.

---

## 🧰 Stack técnico

### iOS (actual)

- **Lenguaje:** Swift 6.1
- **UI:** SwiftUI (con interop puntual de UIKit en `AppCoordinator`)
- **Gestión de paquetes:** Swift Package Manager (SPM) con paquetes locales
- **Min iOS:** 16.0; paquetes apuntan a iOS 17 como mínimo
- **Arquitectura:** MVVM + Coordinator + módulos SPM

### Android (planeado)

- **Lenguaje:** Kotlin
- **UI:** Jetpack Compose + Material 3
- **Arquitectura:** MVVM (AndroidX `ViewModel` + `StateFlow`) + Coordinator/Navigator
- **DI:** Hilt · **Persistencia:** Room · **Networking:** Retrofit + OkHttp
- **Min SDK:** por definir (probablemente 24)

### Backend (planeado)

- `https://dev.api.equipay.app` / `https://stage.api.equipay.app` / `https://api.equipay.app`

---

## 🧪 Configuración por entornos

| Entorno | Scheme | `API_BASE_URL` | `APP_ENV` |
|---------|--------|---------------|-----------|
| Dev | `EquiPay-Dev` | `https://dev.api.equipay.app` | `DEV` |
| Stage | `EquiPay-Stage` | `https://stage.api.equipay.app` | `STAGE` |
| Prod | `EquiPay-Prod` | `https://api.equipay.app` | `PROD` |

---

## 🧹 Higiene del repositorio

**No se commitea:** `xcuserdata/`, `*.xcuserstate`, `DerivedData/`, `.build/`, `.swiftpm/`, `.gradle/`, `local.properties`, `*.jks`, `*.keystore`, `.env`, `secrets.xcconfig`, `GoogleService-Info.plist`, `google-services.json`.

**Sí se commitea:** `Package.resolved`, schemes bajo `xcshareddata/xcschemes/`.

---

## ▶️ Cómo correr el proyecto (iOS)

```bash
git clone https://github.com/VileDruidGG/EquiPay.git
cd EquiPay
open EquiPay.xcodeproj
```

1. Selecciona el scheme (`EquiPay-Dev`, `EquiPay-Stage` o `EquiPay-Prod`).
2. Elige un simulador con iOS 17+.
3. **Run** (⌘R).

---

## 🗺️ Roadmap

### Corto plazo

- [ ] Cablear `EquiPayApp` → `MainTabView` al finalizar Auth.
- [ ] Formulario real de creación de grupo (Vacaciones y Suscripción).
- [ ] Detalle de grupo al tocar una tarjeta en Groups.
- [ ] Definir e implementar Historial en pantalla Actividad.
- [ ] Definir entidades base en `SharedDomain`: `User`, `Group`, `Expense`, `Settlement`.
- [ ] Cobertura inicial de tests unitarios en ViewModels.

### Mediano plazo

- [ ] Repositorio Android con módulos espejo.
- [ ] Contrato de API (OpenAPI).
- [ ] Backend mínimo (auth + grupos + gastos).
- [ ] Sincronización online/offline.

### Largo plazo

- [ ] Notificaciones push (APNs + FCM).
- [ ] Liquidación inteligente.
- [ ] Categorías, gráficas y estadísticas.
- [ ] Modo oscuro completo y accesibilidad.
- [ ] CI/CD (GitHub Actions).

---

## 📐 Convenciones del repositorio

- **README como fuente de verdad:** cada cambio implementado actualiza este README.
- **Preview obligatorio:** toda implementación técnica requiere preview y autorización explícita.
- **Paridad iOS ↔ Android:** cada decisión de arquitectura debe poder aplicarse en ambas plataformas.
- **Una feature = un módulo.** Las features no se importan entre sí.
- **Sin secretos en el repo.**
- **Archivos por usuario fuera del repo.**

---

## 👤 Autor

Christofher Ontiveros Espino — [@VileDruidGG](https://github.com/VileDruidGG)
