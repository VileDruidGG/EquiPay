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

---

## 🏛️ Arquitectura

El proyecto sigue una **arquitectura modular** ("Modular Monolith") combinada
con **Clean Architecture por capas** y **MVVM + Coordinator** en la capa de
presentación. La elección busca paridad entre iOS y Android.

### Decisiones arquitectónicas clave

1. **Modularización por feature + módulos compartidos.**
2. **Capas internas:** `data/` · `domain/` · `presentation/`.
3. **MVVM:** iOS usa `ObservableObject` + `@Published`; Android usará `ViewModel` + `StateFlow`.
4. **Coordinator pattern:** la navegación la decide el Coordinator, no la View.
5. **Design System independiente:** componentes sin lógica de negocio.
6. **Inyección por constructor:** dependencias en el `init`.

> **⚠️ Deuda técnica documentada:** `Home` importa `Groups` directamente para acceder a `GroupDetailView`. Se resolverá cuando `GroupDetailView` se mueva a `SharedDomain`.

### Patrones de diseño aplicados

| Patrón | Dónde se usa | Propósito |
|--------|--------------|-----------|
| **MVVM** | Todas las vistas | Separar estado/lógica de UI |
| **Coordinator** | `AppCoordinator`, `AuthCoordinator`, `MainTabCoordinator` | Centralizar navegación |
| **Container / Factory** | `AuthContainer` | Punto de entrada público de un módulo |
| **Dependency Injection** | ViewModels, Coordinators | Testabilidad y desacople |
| **Repository (planeado)** | Capa `data` por feature | Abstraer fuentes de datos |

---

## 📂 Estructura del repositorio

```
EquiPay/
├── EquiPay.xcodeproj/
│   └── xcshareddata/xcschemes/ (Dev, Stage, Prod)
├── EquiPay/
│   ├── App/  (EquiPayApp, AppCoordinator, xcconfigs, Assets)
│   ├── Features/
│   │   ├── Onboarding/
│   │   ├── Auth/
│   │   ├── Home/          ← importa Groups (deuda técnica temporal)
│   │   ├── Groups/        ← incluye GroupDetailView + GroupSettingsView
│   │   ├── CreateGroup/   ← incluye CreateSubscriptionSheet (5 pasos)
│   │   ├── Activity/
│   │   ├── Profile/
│   │   └── MainTab/
│   └── Packages/
│       ├── DesignSystem/  🟢 En uso
│       ├── Core/          🔴 Vacío
│       ├── SharedDomain/  🔴 Vacío
│       └── FeatureFlags/  🔴 Vacío
├── EquiPayTests/
└── EquiPayUITests/
```

---

## 🧩 Módulos del proyecto

### Features

| Módulo | Estado | Contenido actual |
|--------|--------|-----------------|
| **Onboarding** | 🟢 Implementado | Carrusel de 6 features con autoplay, indicadores tap-to-go, CTAs `Log in` / `Sign up`. |
| **Auth** | 🟡 UI lista, sin lógica real | `LoginView`, `SignUpView`, ViewModels, `AuthCoordinator`, `AuthContainer`. |
| **Home** | 🟡 UI con datos mock | Header gradiente, `SummaryCard`, `ExpenseCard`, `QuickActionCard`. YouTube Premium navega a `GroupDetailView`. |
| **Groups** | 🟡 UI con datos mock | `GroupsView`: lista con `GroupCategory` enum, suscripciones → `GroupDetailView`. `GroupDetailView`: stat cards, miembros con badges (Pagado/Pendiente/Atrasado), pagos por confirmar (Confirmar/Rechazar), acciones rápidas. Botón "Editar grupo" → `GroupSettingsView`. `GroupSettingsView`: toggles de notificaciones con dropdowns animados, mensaje personalizado 0/200, vista previa en tiempo real, toast de confirmación. |
| **CreateGroup** | 🟡 UI funcional (sin backend) | Selector de tipo. Suscripción mensual abre `CreateSubscriptionSheet`: 5 pasos con navegación real y validación por paso (Servicio → Miembros → División → Datos bancarios → Recordatorios). |
| **Activity** | 🟡 UI con datos mock | Selector segmentado custom. Notificaciones: 3 tarjetas. Historial: `HistorySection` por mes con `HistoryItem` (saliente=rojo, entrante=verde, evento=purple). |
| **Profile** | 🟡 UI con datos mock | Avatar+inicial, 3 stat cards, menú teal, Cerrar sesión (solo UI), versión. |
| **MainTab** | 🟡 Estructura completa | 5 pestañas en español conectadas. `selectedTabIndex: Int` para navegación entre tabs. |

### Packages (transversales)

| Módulo | Estado | Propósito |
|--------|--------|----------|
| **DesignSystem** | 🟢 En uso | `SummaryCard`, `ExpenseCard` (`ExpenseStatus`, `BalanceDirection`), `QuickActionCard`, botones, inputs. |
| **Core** | 🔴 Vacío | Utilidades transversales. |
| **SharedDomain** | 🔴 Vacío | Entidades de dominio (User, Group, Expense, Settlement). |
| **FeatureFlags** | 🔴 Vacío | Flags de funcionalidad. |

### Grafo de dependencias actual

```
EquiPayApp
   ├── Onboarding   ──► DesignSystem
   ├── Auth         ──► DesignSystem
   └── MainTab      ──► DesignSystem
                         ├── Home        ──► DesignSystem
                         │               └── Groups (*) ──► DesignSystem
                         ├── Groups      ──► DesignSystem
                         ├── CreateGroup ──► DesignSystem
                         ├── Activity    ──► DesignSystem
                         └── Profile     ──► DesignSystem

(*) Deuda técnica: Home importa Groups para GroupDetailView.
    Se resolverá moviendo GroupDetailView a SharedDomain.
```

---

## ✅ Funcionalidades implementadas

- ✅ Splash / Launch Screen.
- ✅ Onboarding con carrusel automático.
- ✅ Navegación Login ↔ Sign Up.
- ✅ Home con resumen, grupos recientes y acciones rápidas.
- ✅ Grupos recientes de tipo suscripción navegan al detalle desde Home.
- ✅ **Mis grupos**: lista completa, botón crear grupo, navegación al detalle para suscripciones.
- ✅ **Detalle de grupo** (`GroupDetailView`): stat cards, estado de miembros, pagos por confirmar, acciones rápidas.
- ✅ **Ajustes de grupo** (`GroupSettingsView`): notificaciones con toggles y dropdowns animados, mensaje personalizado, vista previa en tiempo real, toast de confirmación.
- ✅ **Crear grupo**: selector de tipo con Próximamente en Evento único.
- ✅ **Flujo de creación de suscripción** en 5 pasos con navegación real y validación por paso.
- ✅ Actividad: Notificaciones y Historial agrupado por mes.
- ✅ Perfil: avatar, stats, menú, cerrar sesión.
- ✅ TabBar con 5 secciones en español completamente conectadas.
- ✅ Design System reutilizable.
- ✅ Schemes Dev / Stage / Prod.

## ❌ Pendiente

- Autenticación real y cablear AppCoordinator → MainTabView.
- Backend / API / persistencia local.
- Modelo de dominio en SharedDomain.
- Resolver deuda técnica Home → Groups.
- Crear / editar / eliminar grupos y gastos.
- Cálculo de balances.
- Notificaciones push reales.
- Android (Kotlin / Jetpack Compose).
- Tests unitarios y de UI.

---

## 🧰 Stack técnico

### iOS
- Swift 6.1 · SwiftUI · SPM (paquetes locales) · Min iOS 17 · MVVM + Coordinator

### Android (planeado)
- Kotlin · Jetpack Compose + Material 3 · Gradle (Kotlin DSL) · MVVM + StateFlow · Hilt · Room · Retrofit

### Backend (planeado)
- `dev.api.equipay.app` / `stage.api.equipay.app` / `api.equipay.app`

---

## 🧪 Configuración por entornos

| Entorno | Scheme | `API_BASE_URL` | `APP_ENV` |
|---------|--------|---------------|-----------|
| Dev | `EquiPay-Dev` | `https://dev.api.equipay.app` | `DEV` |
| Stage | `EquiPay-Stage` | `https://stage.api.equipay.app` | `STAGE` |
| Prod | `EquiPay-Prod` | `https://api.equipay.app` | `PROD` |

---

## 🧹 Higiene del repositorio

**No se commitea:** `xcuserdata/`, `DerivedData/`, `.build/`, `.swiftpm/`, `.gradle/`, `local.properties`, `*.jks`, `.env`, `secrets.xcconfig`, `GoogleService-Info.plist`, `google-services.json`.

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
- [ ] Cablear `AppCoordinator` → `MainTabView` al finalizar Auth.
- [ ] Mover `GroupDetailView` a `SharedDomain` (resolver deuda técnica).
- [ ] Conectar flujos de creación y edición con el modelo de dominio.
- [ ] Definir entidades base en `SharedDomain`.
- [ ] Tests unitarios en ViewModels y validaciones.

### Mediano plazo
- [ ] Repositorio Android con módulos espejo.
- [ ] Contrato de API (OpenAPI).
- [ ] Backend mínimo (auth + grupos + gastos).

### Largo plazo
- [ ] Notificaciones push (APNs + FCM).
- [ ] Liquidación inteligente.
- [ ] Categorías, gráficas y estadísticas.
- [ ] Modo oscuro y accesibilidad.
- [ ] CI/CD (GitHub Actions).

---

## 📐 Convenciones del repositorio

- **README como fuente de verdad.**
- **Preview obligatorio** antes de cualquier push, con autorización explícita.
- **Paridad iOS ↔ Android** en arquitectura, patrones y nombres públicos.
- **Una feature = un módulo.** Sin importaciones cruzadas (salvo deuda documentada).
- **Sin secretos en el repo.**

---

## 👤 Autor

Christofher Ontiveros Espino — [@VileDruidGG](https://github.com/VileDruidGG)
