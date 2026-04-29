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
   (Onboarding, Auth, Home, MainTab, …) vive en su propio módulo. Esto se
   mapea directamente:
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
   ni el ViewModel: la decide un `Coordinator` que recibe callbacks
   (`onLogin`, `onSuccess`, `onSignUpTap`, etc.). Esto desacopla los módulos
   entre sí: una feature **no importa otra feature** para navegar a ella.
   - En iOS: `AppCoordinator`, `AuthCoordinator`, `MainTabCoordinator`.
   - En Android: se replicará con `Navigator`/`NavController` y un coordinator
     equivalente por flujo.

5. **Contratos compartidos en módulos transversales.** Modelos de dominio,
   utilidades y feature flags viven en módulos sin dependencias de UI
   (`SharedDomain`, `Core`, `FeatureFlags`) para que cualquier feature los
   pueda consumir sin acoplarse.

6. **Design System como módulo independiente.** Componentes visuales
   reutilizables (botones, cards, inputs) viven en un módulo `DesignSystem`
   sin lógica de negocio. El equivalente Android será otro módulo Compose
   con los mismos componentes y la misma API pública.

7. **Inyección por constructor / closures.** Para evitar singletons y
   facilitar testing, las dependencias se pasan en el `init`. Las features
   reciben callbacks de navegación, no referencias a otras features.

### Patrones de diseño aplicados

| Patrón | Dónde se usa | Propósito |
|--------|--------------|-----------|
| **MVVM** | Todas las vistas | Separar estado/lógica de UI |
| **Coordinator** | `AppCoordinator`, `AuthCoordinator`, `MainTabCoordinator` | Centralizar navegación y desacoplar features |
| **Container / Factory** | `AuthContainer.makeAuthRoot(...)` | Punto de entrada público de un módulo, oculta sus internals |
| **Dependency Injection (constructor)** | ViewModels, Coordinators | Testabilidad y desacople |
| **Repository (planeado)** | Capa `data` por feature | Abstraer fuentes de datos remotas/locales |

---

## 📂 Estructura del repositorio

```
EquiPay/
├── EquiPay.xcodeproj/                    # Proyecto Xcode (workspace, schemes, configs)
│   └── xcshareddata/xcschemes/
│       ├── EquiPay-Dev.xcscheme
│       ├── EquiPay-Stage.xcscheme
│       └── EquiPay-Prod.xcscheme
│
├── EquiPay/                              # App iOS
│   ├── App/                              # Punto de entrada y configuración
│   │   ├── EquiPayApp.swift              # @main (SwiftUI App)
│   │   ├── Application/
│   │   │   ├── AppCoordinator.swift      # Coordinator raíz (UIKit-based)
│   │   │   ├── AppDelegate.swift
│   │   │   └── SceneDelegate.swift
│   │   ├── Config/                       # xcconfig por entorno
│   │   │   ├── Dev.xcconfig
│   │   │   ├── Stage.xcconfig
│   │   │   └── Prod.xcconfig
│   │   ├── Resources/Assets.xcassets/    # Iconos, accent color, launch screen
│   │   ├── LaunchScreen.storyboard
│   │   └── Info.plist
│   │
│   ├── Features/                         # Módulos de feature (SPM locales)
│   │   ├── Onboarding/                   # Carrusel + CTAs (login/signup)
│   │   ├── Auth/                         # Login + SignUp + AuthCoordinator
│   │   ├── Home/                         # Dashboard del usuario
│   │   └── MainTab/                      # TabBar principal (5 tabs)
│   │
│   └── Packages/                         # Módulos transversales (SPM locales)
│       ├── Core/                         # 🟡 Esqueleto, sin código aún
│       ├── SharedDomain/                 # 🟡 Esqueleto, sin código aún
│       ├── FeatureFlags/                 # 🟡 Esqueleto, sin código aún
│       └── DesignSystem/                 # 🟢 Componentes UI reutilizables
│
├── EquiPayTests/                         # Unit tests del target principal
└── EquiPayUITests/                       # UI tests del target principal
```

---

## 🧩 Módulos del proyecto

### Features

| Módulo | Estado | Contenido actual |
|--------|--------|-----------------|
| **Onboarding** | 🟢 Implementado | Carrusel de 6 features con autoplay, indicadores tap-to-go, CTAs `Log in` / `Sign up`. Imágenes empaquetadas como recurso del package. |
| **Auth** | 🟡 UI lista, sin lógica real | `LoginView`, `SignUpView`, `LoginViewModel`, `SignUpViewModel`, `AuthCoordinator`, `AuthContainer`, `AuthRoute`. Login/Signup hacen `print` y simulan éxito. |
| **Home** | 🟡 UI con datos mock | Header con gradiente, saludo en español + subtítulo, botón de notificaciones, tres `SummaryCard` (te deben / debes / grupos activos), sección "Grupos recientes" con `ExpenseCard` (balance direccional verde/rojo, badges de estado en español) y sección "Acciones rápidas" con `QuickActionCard`. Sin datos reales. |
| **MainTab** | 🟡 Estructura básica | `TabView` con 5 pestañas (Home, Expenses, Add, History, Profile). Solo `Home` tiene contenido real; el resto son `Text("…")` placeholder. |

### Packages (transversales)

| Módulo | Estado | Propósito |
|--------|--------|----------|
| **DesignSystem** | 🟢 En uso | Componentes públicos: `PrimaryButton`, `SecondaryButton`, `GhostButton`, `SummaryCard`, `ExpenseCard` (con `ExpenseStatus` y `BalanceDirection`), `QuickActionCard`, `EmailInput`, `TextFields`. |
| **Core** | 🔴 Vacío | Reservado para utilidades transversales (networking, logging, persistencia, extensions). |
| **SharedDomain** | 🔴 Vacío | Reservado para entidades de dominio compartidas (User, Group, Expense, Settlement, …). |
| **FeatureFlags** | 🔴 Vacío | Reservado para flags de funcionalidad y experimentación. |

### Grafo de dependencias actual

```
EquiPayApp
   ├── Onboarding ──► DesignSystem
   ├── Auth       ──► DesignSystem
   └── (futuro) MainTab ──► DesignSystem
                            └── Home ──► DesignSystem
```

> Las features **no se importan entre sí**: la coordinación se hace desde
> `AppCoordinator` (o `EquiPayApp`) vía closures.

---

## ✅ Funcionalidades implementadas

### Implementado y navegable

- ✅ Splash / Launch Screen con icono de la app.
- ✅ Pantalla de **Onboarding** con carrusel automático e indicadores
  tappables.
- ✅ Navegación a **Login** y **Sign Up** desde el Onboarding (via
  `fullScreenCover`).
- ✅ Cambio entre Login ↔ Sign Up dentro del flujo de Auth.
- ✅ Vista **Home** con cards de resumen, grupos recientes y acciones rápidas.
- ✅ **TabBar** principal con 5 secciones definidas.
- ✅ Componentes de Design System reutilizables.
- ✅ Schemes y `.xcconfig` separados para Dev / Stage / Prod.

### Pendiente / no implementado

- ❌ Autenticación real (los VMs solo imprimen y llaman `onSuccess()`).
- ❌ Backend / API (las URLs de `API_BASE_URL` apuntan a dominios aún no
  existentes).
- ❌ Persistencia local (Core Data / SwiftData / Room).
- ❌ Modelo de dominio (`User`, `Group`, `Expense`).
- ❌ Crear / editar / eliminar grupos y gastos.
- ❌ Cálculo de balances ("quién debe a quién").
- ❌ Notificaciones push.
- ❌ Pantallas Expenses, Add, History, Profile.
- ❌ Integración del `AppCoordinator` con `EquiPayApp` y la pantalla MainTab
  tras el flujo de Auth (actualmente `EquiPayApp` cierra el sheet sin navegar
  a MainTab; `AppCoordinator` ya prevé `showMainApp()` pero usa un placeholder
  UIKit).
- ❌ Implementación Android (Kotlin / Jetpack Compose).
- ❌ Tests unitarios y de UI con cobertura significativa.

---

## 🧰 Stack técnico

### iOS (actual)

- **Lenguaje:** Swift 6.1
- **UI:** SwiftUI (con interop puntual de UIKit en `AppCoordinator`)
- **Gestión de paquetes:** Swift Package Manager (SPM) con paquetes locales
- **Min iOS:** 16.0 (`MinimumOSVersion` en `Info.plist`); paquetes apuntan a
  iOS 17 como mínimo
- **Arquitectura:** MVVM + Coordinator + módulos SPM

### Android (planeado, todavía no creado)

- **Lenguaje:** Kotlin
- **UI:** Jetpack Compose + Material 3
- **Gestión de módulos:** Gradle (Kotlin DSL) con módulos por feature
- **Arquitectura:** MVVM (AndroidX `ViewModel` + `StateFlow`) + Coordinator/Navigator
- **DI:** Hilt (a evaluar)
- **Persistencia:** Room (a evaluar)
- **Networking:** Retrofit + OkHttp + kotlinx.serialization (a evaluar)
- **Min SDK:** por definir (probablemente 24)

### Backend (planeado)

- Aún sin definir. Dominios reservados visibles en xcconfigs:
  - `https://dev.api.equipay.app`
  - `https://stage.api.equipay.app`
  - `https://api.equipay.app`

---

## 🧪 Configuración por entornos

El proyecto define tres entornos, cada uno con su `.xcconfig` y su scheme:

| Entorno | Scheme | `API_BASE_URL` | `APP_ENV` |
|---------|--------|---------------|-----------|
| Dev | `EquiPay-Dev` | `https://dev.api.equipay.app` | `DEV` |
| Stage | `EquiPay-Stage` | `https://stage.api.equipay.app` | `STAGE` |
| Prod | `EquiPay-Prod` | `https://api.equipay.app` | `PROD` |

Estas variables se exponen en `Info.plist` como `API_BASE_URL` y `APP_ENV` y
podrán leerse desde el código una vez se implemente la capa de configuración
en el módulo `Core`.

> En Android se replicará el mismo esquema usando **buildTypes** y/o
> **product flavors** de Gradle, exponiendo las mismas variables vía
> `BuildConfig`.

---

## 🧹 Higiene del repositorio

El repo tiene un `.gitignore` raíz que cubre tanto iOS/Xcode como
Android/Gradle (preparado para cuando se agregue el módulo Android), además
de los secretos que nunca deben commitearse.

**Lo que NO se commitea:**

- `xcuserdata/`, `*.xcuserstate`, breakpoints y schemes personales — son
  archivos por usuario que Xcode regenera automáticamente al abrir el
  proyecto.
- `build/`, `DerivedData/`, `.build/`, `.swiftpm/` — artefactos de build de
  Xcode y SPM.
- `Pods/`, `Carthage/Build/` — por si en el futuro se integran (con CocoaPods
  el `Podfile.lock` SÍ se commitea).
- `.gradle/`, `local.properties`, `**/build/`, `*.jks`, `*.keystore`,
  `keystore.properties` — equivalentes para Android.
- `.env`, `.env.*`, `secrets.xcconfig`, `*.private.xcconfig`,
  `GoogleService-Info.plist`, `google-services.json` — credenciales y
  configuración local.

**Lo que SÍ se commitea:**

- `Package.resolved` (cuando exista) — fija las versiones de dependencias
  SPM para builds reproducibles.
- Schemes compartidos bajo `xcshareddata/xcschemes/` — son del proyecto, no
  del usuario.

**Patrón de secretos:** cuando se necesite consumir API keys o credenciales,
se creará un `secrets.xcconfig` local (ignorado) que se incluye desde los
xcconfig por entorno con `#include? "secrets.xcconfig"`. Habrá un
`secrets.example.xcconfig` (sí trackeado) como plantilla. En Android se
seguirá el mismo patrón con `local.properties` + `BuildConfig`.

---

## ▶️ Cómo correr el proyecto (iOS)

### Requisitos

- macOS con **Xcode 16** o superior
- iOS Simulator con iOS 17+ (o un dispositivo físico con iOS 16+)

### Pasos

```bash
git clone https://github.com/VileDruidGG/EquiPay.git
cd EquiPay
open EquiPay.xcodeproj
```

1. En Xcode, selecciona el scheme deseado (`EquiPay-Dev`, `EquiPay-Stage` o
   `EquiPay-Prod`).
2. Elige un simulador o dispositivo.
3. **Run** (⌘R).

> La primera build puede tardar más de lo habitual mientras Xcode resuelve
> los Swift Packages locales.

---

## 🗺️ Roadmap

### Corto plazo

- [ ] Cablear `EquiPayApp` con `AppCoordinator` y mostrar `MainTabView` al
      finalizar Auth.
- [ ] Crear `AuthService` real (mock en memoria primero) en `Core` o módulo
      propio `AuthData`.
- [ ] Definir entidades base en `SharedDomain`: `User`, `Group`, `Expense`,
      `Settlement`.
- [ ] Implementar pantalla **Add Expense** y persistencia local.
- [ ] Cobertura inicial de tests unitarios en ViewModels y reglas de negocio.

### Mediano plazo

- [ ] Crear el repositorio Android con módulos espejo (`features/auth`,
      `features/onboarding`, `features/home`, `core/design-system`,
      `core/shared-domain`, …).
- [ ] Definir el contrato de API (OpenAPI) para que iOS y Android lo
      consuman idénticamente.
- [ ] Implementar backend mínimo (auth + grupos + gastos).
- [ ] Sincronización online/offline.

### Largo plazo

- [ ] Notificaciones push (APNs + FCM).
- [ ] Liquidación inteligente (algoritmo que minimiza número de
      transferencias).
- [ ] Categorías, gráficas y estadísticas.
- [ ] Modo oscuro completo y revisión de accesibilidad.
- [ ] CI/CD (GitHub Actions) para builds, tests y distribución (TestFlight /
      Play Internal).

---

## 📐 Convenciones del repositorio

- **README como fuente de verdad:** cada cambio implementado debe actualizar
  este README (estado de módulos, features, roadmap o stack según
  corresponda).
- **Preview obligatorio:** toda implementación técnica (código, BD,
  configuración, etc.) debe presentarse como preview de los cambios antes de
  publicarse al repo, y requiere autorización explícita para hacer push.
- **Paridad iOS ↔ Android:** cualquier decisión de arquitectura, patrón o
  nombre público de módulo debe poder aplicarse en ambas plataformas. Si una
  decisión solo funciona en una, se documenta el motivo y la alternativa en
  la otra.
- **Una feature = un módulo.** Las features no se importan entre sí; se
  comunican vía coordinators y contratos en `SharedDomain`.
- **Sin secretos en el repo.** API keys, credenciales y archivos `.env`,
  `secrets.xcconfig`, `GoogleService-Info.plist`, `google-services.json` o
  `keystore` están explícitamente ignorados. Si necesitas configuración
  local, sigue el patrón de `secrets.xcconfig` documentado en
  [Higiene del repositorio](#-higiene-del-repositorio).
- **Archivos por usuario fuera del repo.** `xcuserdata/`, breakpoints y
  schemes personales nunca se commitean — Xcode los regenera al abrir el
  proyecto.

---

## 👤 Autor

Christofher Ontiveros Espino — [@VileDruidGG](https://github.com/VileDruidGG)
