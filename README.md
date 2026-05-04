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
   (Onboarding, Auth, Home, Groups, MainTab, …) vive en su propio módulo. Esto se
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
| **Onboarding** | 🟢 Implementado | Carrusel de 6 features con autoplay, indicadores tap-to-go, CTAs `Log in` / `Sign up`. Imágenes empaquetadas como recurso del package. |
| **Auth** | 🟡 UI lista, sin lógica real | `LoginView`, `SignUpView`, `LoginViewModel`, `SignUpViewModel`, `AuthCoordinator`, `AuthContainer`, `AuthRoute`. Login/Signup hacen `print` y simulan éxito. |
| **Home** | 🟡 UI con datos mock | Header con gradiente, saludo en español + subtítulo, botón de notificaciones, tres `SummaryCard` (te deben / debes / grupos activos), sección "Grupos recientes" con `ExpenseCard` (balance direccional verde/rojo, badges de estado en español) y sección "Acciones rápidas" con `QuickActionCard`. Sin datos reales. |
| **Groups** | 🟡 UI con datos mock | Pantalla "Mis grupos" accesible desde el tab Grupos. Botón "Crear nuevo grupo" (gradiente teal→purple) que salta al tab Crear vía `Binding<Int>`. Lista de 5 grupos con `ExpenseCard`. Sin datos reales. |
| **MainTab** | 🟡 Estructura conectada | `TabView` con 5 pestañas en español (Inicio, Grupos, Crear, Actividad, Perfil). Tab Grupos conectado a `GroupsView`. `MainTabViewModel` expone `selectedTabIndex: Int` para navegación entre tabs desde features hijas sin acoplamiento. |

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
                            ├── Home   ──► DesignSystem
                            └── Groups ──► DesignSystem
```

> Las features **no se importan entre sí**: la coordinación se hace desde
> `AppCoordinator` (o `EquiPayApp`) vía closures.

---

## ✅ Funcionalidades implementadas

### Implementado y navegable

- ✅ Splash / Launch Screen con icono de la app.
- ✅ Pantalla de **Onboarding** con carrusel automático e indicadores tappables.
- ✅ Navegación a **Login** y **Sign Up** desde el Onboarding (via `fullScreenCover`).
- ✅ Cambio entre Login ↔ Sign Up dentro del flujo de Auth.
- ✅ Vista **Home** con cards de resumen, grupos recientes y accesos rápidos.
- ✅ Vista **Grupos** con lista completa, botón "Crear nuevo grupo" y navegación al tab Crear.
- ✅ **TabBar** principal con 5 secciones en español (Inicio, Grupos, Crear, Actividad, Perfil).
- ✅ Componentes de Design System reutilizables.
- ✅ Schemes y `.xcconfig` separados para Dev / Stage / Prod.

### Pendiente / no implementado

- ❌ Autenticación real (los VMs solo imprimen y llaman `onSuccess()`).
- ❌ Backend / API.
- ❌ Persistencia local (Core Data / SwiftData / Room).
- ❌ Modelo de dominio (`User`, `Group`, `Expense`).
- ❌ Crear / editar / eliminar grupos y gastos.
- ❌ Cálculo de balances ("quién debe a quién").
- ❌ Notificaciones push.
- ❌ Pantallas Add, Actividad, Perfil.
- ❌ Detalle de grupo al tocar una tarjeta.
- ❌ Integración del `AppCoordinator` con `EquiPayApp` y la pantalla MainTab tras el flujo de Auth.
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

- Aún sin definir. Dominios reservados:
  - `https://dev.api.equipay.app`
  - `https://stage.api.equipay.app`
  - `https://api.equipay.app`

---

## 🧪 Configuración por entornos

| Entorno | Scheme | `API_BASE_URL` | `APP_ENV` |
|---------|--------|---------------|-----------|
| Dev | `EquiPay-Dev` | `https://dev.api.equipay.app` | `DEV` |
| Stage | `EquiPay-Stage` | `https://stage.api.equipay.app` | `STAGE` |
| Prod | `EquiPay-Prod` | `https://api.equipay.app` | `PROD` |

---

## 🧹 Higiene del repositorio

**Lo que NO se commitea:** `xcuserdata/`, `*.xcuserstate`, `build/`, `DerivedData/`, `.build/`, `.swiftpm/`, `.gradle/`, `local.properties`, `*.jks`, `*.keystore`, `.env`, `secrets.xcconfig`, `GoogleService-Info.plist`, `google-services.json`.

**Lo que SÍ se commitea:** `Package.resolved`, schemes compartidos bajo `xcshareddata/xcschemes/`.

---

## ▶️ Cómo correr el proyecto (iOS)

```bash
git clone https://github.com/VileDruidGG/EquiPay.git
cd EquiPay
open EquiPay.xcodeproj
```

1. Selecciona el scheme deseado (`EquiPay-Dev`, `EquiPay-Stage` o `EquiPay-Prod`).
2. Elige un simulador o dispositivo con iOS 17+.
3. **Run** (⌘R).

---

## 🗺️ Roadmap

### Corto plazo

- [ ] Cablear `EquiPayApp` con `AppCoordinator` y mostrar `MainTabView` al finalizar Auth.
- [ ] Pantalla de detalle de grupo al tocar una tarjeta en Groups.
- [ ] Implementar pantalla **Add / Crear grupo** con formulario.
- [ ] Definir entidades base en `SharedDomain`: `User`, `Group`, `Expense`, `Settlement`.
- [ ] Cobertura inicial de tests unitarios en ViewModels.

### Mediano plazo

- [ ] Crear el repositorio Android con módulos espejo.
- [ ] Definir el contrato de API (OpenAPI).
- [ ] Implementar backend mínimo (auth + grupos + gastos).
- [ ] Sincronización online/offline.

### Largo plazo

- [ ] Notificaciones push (APNs + FCM).
- [ ] Liquidación inteligente.
- [ ] Categorías, gráficas y estadísticas.
- [ ] Modo oscuro completo y accesibilidad.
- [ ] CI/CD (GitHub Actions) para builds, tests y distribución.

---

## 📐 Convenciones del repositorio

- **README como fuente de verdad:** cada cambio implementado debe actualizar este README.
- **Preview obligatorio:** toda implementación técnica debe presentarse como preview y requiere autorización explícita para hacer push.
- **Paridad iOS ↔ Android:** cualquier decisión de arquitectura debe poder aplicarse en ambas plataformas.
- **Una feature = un módulo.** Las features no se importan entre sí.
- **Sin secretos en el repo.**
- **Archivos por usuario fuera del repo.**

---

## 👤 Autor

Christofher Ontiveros Espino — [@VileDruidGG](https://github.com/VileDruidGG)
