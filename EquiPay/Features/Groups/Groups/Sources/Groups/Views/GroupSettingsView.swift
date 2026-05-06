//
//  GroupSettingsView.swift
//  Groups
//
//  Created by EquiPay on 06/05/26.
//
import SwiftUI

// MARK: - Opciones de días

/// Días de anticipación antes del cobro.
/// Android equivalent: enum class DaysBefore
enum DaysBefore: String, CaseIterable, Identifiable {
    case one   = "1 día antes"
    case two   = "2 días antes"
    case three = "3 días antes"
    case five  = "5 días antes"
    case seven = "7 días antes"
    var id: String { rawValue }
}

/// Frecuencia de recordatorios después del cobro.
/// Android equivalent: enum class AfterFrequency
enum AfterFrequency: String, CaseIterable, Identifiable {
    case everyDay   = "Cada día"
    case everyTwo   = "Cada 2 días"
    case everyThree = "Cada 3 días"
    case everyFive  = "Cada 5 días"
    var id: String { rawValue }
}

// MARK: - Vista principal

/// Pantalla de ajustes del grupo.
/// Accesible desde el botón "Editar grupo" en GroupDetailView.
/// Diseñada para crecer: notificaciones es la primera sección,
/// se pueden añadir más (nombre, miembros, datos bancarios, etc.)
///
/// Android equivalent: GroupSettingsScreen
public struct GroupSettingsView: View {

    let groupName: String

    // MARK: Estado — Notificaciones

    @State private var beforeBillingEnabled: Bool = true
    @State private var daysBefore: DaysBefore = .three

    @State private var onBillingDayEnabled: Bool = true

    @State private var afterBillingEnabled: Bool = true
    @State private var afterFrequency: AfterFrequency = .everyThree

    @State private var customMessage: String = ""
    @State private var showSavedToast: Bool = false

    // MARK: - Init

    public init(groupName: String) {
        self.groupName = groupName
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    notificationsSection
                    messageSection
                    previewSection
                    saveButton
                        .padding(.bottom, 32)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }

            if showSavedToast {
                toastView
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Notificaciones")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut(duration: 0.3), value: showSavedToast)
    }

    // MARK: - Sección Notificaciones

    private var notificationsSection: some View {
        VStack(spacing: 0) {

            // --- Antes del cobro ---
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Recordatorio antes del cobro")
                            .font(.subheadline.bold())
                        Text("Avisa con anticipación")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    Toggle("", isOn: $beforeBillingEnabled)
                        .labelsHidden()
                        .tint(Color(red: 0.24, green: 0.78, blue: 0.75))
                }
                .padding(.horizontal, 16).padding(.vertical, 14)

                if beforeBillingEnabled {
                    Divider().padding(.horizontal, 16)
                    dropdownRow(selection: $daysBefore, options: DaysBefore.allCases)
                        .padding(.horizontal, 16).padding(.vertical, 12)
                }
            }

            Divider()

            // --- El día del cobro ---
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Recordatorio el día del cobro")
                        .font(.subheadline.bold())
                    Text("Notifica el día exacto")
                        .font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                Toggle("", isOn: $onBillingDayEnabled)
                    .labelsHidden()
                    .tint(Color(red: 0.24, green: 0.78, blue: 0.75))
            }
            .padding(.horizontal, 16).padding(.vertical, 14)

            Divider()

            // --- Después del cobro ---
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Recordatorios después del cobro")
                            .font(.subheadline.bold())
                        Text("Si no han pagado")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    Toggle("", isOn: $afterBillingEnabled)
                        .labelsHidden()
                        .tint(Color(red: 0.24, green: 0.78, blue: 0.75))
                }
                .padding(.horizontal, 16).padding(.vertical, 14)

                if afterBillingEnabled {
                    Divider().padding(.horizontal, 16)
                    dropdownRow(selection: $afterFrequency, options: AfterFrequency.allCases)
                        .padding(.horizontal, 16).padding(.vertical, 12)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.1), lineWidth: 1))
    }

    // MARK: - Dropdown genérico

    /// Menu dropdown reutilizable para cualquier enum RawRepresentable<String>.
    /// Android equivalent: ExposedDropdownMenuBox de Material 3.
    @ViewBuilder
    private func dropdownRow<T: RawRepresentable & Hashable & Identifiable>(
        selection: Binding<T>,
        options: [T]
    ) -> some View where T.RawValue == String {
        Menu {
            ForEach(options) { option in
                Button(option.rawValue) { selection.wrappedValue = option }
            }
        } label: {
            HStack {
                Text(selection.wrappedValue.rawValue)
                    .font(.subheadline).foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.caption.bold()).foregroundColor(.secondary)
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGroupedBackground)))
        }
    }

    // MARK: - Mensaje personalizado

    private var messageSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Mensaje personalizado")
                .font(.subheadline.bold())
                .padding(.horizontal, 16).padding(.top, 14).padding(.bottom, 10)

            ZStack(alignment: .bottomTrailing) {
                TextEditor(text: $customMessage)
                    .frame(minHeight: 80)
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .onChange(of: customMessage) { _, new in
                        if new.count > 200 { customMessage = String(new.prefix(200)) }
                    }
                    .overlay(Group {
                        if customMessage.isEmpty {
                            Text("¡Hola! Recuerda tu pago de \(groupName) 💜")
                                .foregroundColor(Color.gray.opacity(0.4)).font(.body)
                                .padding(.horizontal, 16).padding(.vertical, 16)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .allowsHitTesting(false)
                        }
                    })

                Text("\(customMessage.count)/200")
                    .font(.caption).foregroundColor(.secondary).padding(12)
            }
            .padding(.bottom, 4)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.1), lineWidth: 1))
    }

    // MARK: - Vista previa

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("VISTA PREVIA")
                .font(.caption.bold()).foregroundColor(.secondary)
                .padding(.horizontal, 4)

            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.24, green: 0.78, blue: 0.75), Color.purple],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(spacing: 12) {
                    VStack(spacing: 2) {
                        Text("9:41")
                            .font(.system(size: 48, weight: .thin))
                            .foregroundColor(.white)
                        Text("martes, 12 de mayo")
                            .font(.subheadline)
                            .foregroundColor(Color.white.opacity(0.85))
                    }
                    .padding(.top, 20)

                    HStack(alignment: .top, spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.24, green: 0.78, blue: 0.75))
                                .frame(width: 36, height: 36)
                            Text("E")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text("EQUIPAY").font(.caption.bold()).foregroundColor(.secondary)
                                Spacer()
                                Text("ahora").font(.caption).foregroundColor(.secondary)
                            }
                            Text("EquiPay").font(.subheadline.bold()).foregroundColor(.primary)
                            Text(previewMessage)
                                .font(.subheadline).foregroundColor(.primary).lineLimit(2)
                        }
                    }
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
                    .padding(.horizontal, 12)
                    .padding(.bottom, 16)
                }
            }
        }
    }

    /// Mensaje en tiempo real: usa el texto del usuario o el placeholder con el nombre del grupo.
    private var previewMessage: String {
        customMessage.isEmpty
            ? "¡Hola! Recuerda tu pago de \(groupName) 💜"
            : customMessage
    }

    // MARK: - Botón guardar

    private var saveButton: some View {
        Button {
            withAnimation { showSavedToast = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { showSavedToast = false }
            }
        } label: {
            Text("Guardar cambios")
                .font(.body.bold()).foregroundColor(.white)
                .frame(maxWidth: .infinity).frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(
                            colors: [Color(red: 0.24, green: 0.78, blue: 0.75), Color.purple],
                            startPoint: .leading, endPoint: .trailing
                        ))
                )
        }
    }

    // MARK: - Toast

    /// Overlay temporal visible 2 segundos tras guardar.
    /// Android equivalent: Snackbar de Material 3.
    private var toastView: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(red: 0.24, green: 0.78, blue: 0.75))
            Text("Cambios guardados")
                .font(.subheadline.bold()).foregroundColor(.primary)
        }
        .padding(.horizontal, 20).padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 4)
        )
        .padding(.top, 12)
    }
}

#Preview {
    NavigationStack {
        GroupSettingsView(groupName: "YouTube Premium")
    }
}
