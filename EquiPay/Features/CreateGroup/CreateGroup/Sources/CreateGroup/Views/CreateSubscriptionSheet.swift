//
//  CreateSubscriptionSheet.swift
//  CreateGroup
//
//  Created by EquiPay on 05/05/26.
//
import SwiftUI

// MARK: - Modelos del formulario

/// Modo de división del costo entre miembros.
/// Android equivalent: enum class SplitMode
enum SplitMode {
    case equal
    case manual
}

/// Días de anticipación para enviar el recordatorio.
/// Android equivalent: enum class ReminderDays
enum ReminderDays: Int, CaseIterable {
    case one   = 1
    case two   = 2
    case three = 3
    case five  = 5
    case seven = 7

    var label: String { "\(rawValue) \(rawValue == 1 ? "día" : "días")" }
}

// MARK: - Sheet principal

/// Sheet de creación de suscripción en 5 pasos.
/// Se presenta desde CreateGroupView al tocar "Suscripción mensual".
/// Android equivalent: ModalBottomSheet con un NavHost interno de 5 destinos.
public struct CreateSubscriptionSheet: View {

    @Binding var isPresented: Bool

    // MARK: Estado de navegación
    @State private var currentStep: Int = 1
    private let totalSteps = 5

    // MARK: Paso 1 — Servicio
    @State private var serviceName: String = ""
    @State private var monthlyCost: String = ""
    @State private var billingDay: Int = 1

    // MARK: Paso 2 — Miembros
    @State private var memberEmail: String = ""
    @State private var members: [String] = []
    @State private var emailError: String? = nil

    // MARK: Paso 3 — División
    @State private var splitMode: SplitMode = .equal
    @State private var manualAmounts: [String: String] = [:]

    // MARK: Paso 4 — Datos bancarios
    @State private var bankName: String = ""
    @State private var accountHolder: String = ""
    @State private var clabe: String = ""
    @State private var cardNumber: String = ""

    // MARK: Paso 5 — Recordatorios
    @State private var reminderMessage: String = ""
    @State private var selectedReminderDays: ReminderDays = .three

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            sheetHeader
            progressBar
            Divider()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    switch currentStep {
                    case 1: step1Service
                    case 2: step2Members
                    case 3: step3Split
                    case 4: step4Banking
                    case 5: step5Reminders
                    default: EmptyView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 120)
            }
        }
        .background(Color(.systemBackground))
        .overlay(alignment: .bottom) { bottomButtons }
    }

    // MARK: - Header

    private var sheetHeader: some View {
        HStack {
            Button {
                if currentStep > 1 {
                    withAnimation(.easeInOut(duration: 0.2)) { currentStep -= 1 }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.body.bold())
                    .foregroundColor(currentStep > 1 ? .primary : .clear)
            }
            .disabled(currentStep == 1)

            Spacer()
            Text(stepTitle).font(.headline)
            Spacer()

            Button { isPresented = false } label: {
                Image(systemName: "xmark")
                    .font(.body.bold())
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 12)
    }

    private var stepTitle: String {
        switch currentStep {
        case 1: return "Suscripción · Servicio"
        case 2: return "Suscripción · Miembros"
        case 3: return "Suscripción · División"
        case 4: return "Suscripción · Datos bancarios"
        case 5: return "Suscripción · Recordatorios"
        default: return ""
        }
    }

    // MARK: - Barra de progreso

    private var progressBar: some View {
        VStack(alignment: .trailing, spacing: 6) {
            Text("Paso \(currentStep) de \(totalSteps)")
                .font(.caption).foregroundColor(.secondary)
                .padding(.horizontal, 20)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color.gray.opacity(0.12)).frame(height: 3)
                    Rectangle()
                        .fill(Color(red: 0.24, green: 0.78, blue: 0.75))
                        .frame(width: geo.size.width * CGFloat(currentStep) / CGFloat(totalSteps), height: 3)
                        .animation(.easeInOut(duration: 0.25), value: currentStep)
                }
            }
            .frame(height: 3)
        }
        .padding(.bottom, 8)
    }

    // MARK: - Botones inferiores

    private var bottomButtons: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 12) {
                if currentStep > 1 {
                    Button("Atrás") {
                        withAnimation(.easeInOut(duration: 0.2)) { currentStep -= 1 }
                    }
                    .font(.body.bold())
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity).frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.systemGroupedBackground))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gray.opacity(0.25), lineWidth: 1))
                    )
                }

                Button {
                    if currentStep < totalSteps {
                        withAnimation(.easeInOut(duration: 0.2)) { currentStep += 1 }
                    } else {
                        isPresented = false
                    }
                } label: {
                    HStack(spacing: 6) {
                        if currentStep == totalSteps {
                            Image(systemName: "checkmark").font(.body.bold())
                        }
                        Text(currentStep == totalSteps ? "Crear grupo" : "Continuar")
                            .font(.body.bold())
                    }
                    .foregroundColor(currentStepIsValid ? .white : Color.white.opacity(0.5))
                    .frame(maxWidth: .infinity).frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(
                                colors: currentStepIsValid
                                    ? [Color(red: 0.24, green: 0.78, blue: 0.75), Color.purple]
                                    : [Color.gray.opacity(0.4), Color.gray.opacity(0.4)],
                                startPoint: .leading, endPoint: .trailing
                            ))
                    )
                }
                .disabled(!currentStepIsValid)
            }
            .padding(.horizontal, 16).padding(.vertical, 16)
            .background(Color(.systemBackground))
        }
    }

    // MARK: - Validación por paso

    private var currentStepIsValid: Bool {
        switch currentStep {
        case 1:
            let cost = Double(monthlyCost.replacingOccurrences(of: ",", with: ".")) ?? 0
            return !serviceName.trimmingCharacters(in: .whitespaces).isEmpty && cost > 0
        case 2:
            return !members.isEmpty
        case 3:
            if splitMode == .equal { return true }
            let total = members.compactMap {
                Double(manualAmounts[$0, default: ""].replacingOccurrences(of: ",", with: "."))
            }.reduce(0, +)
            let cost = Double(monthlyCost.replacingOccurrences(of: ",", with: ".")) ?? 0
            return abs(total - cost) < 0.01
        case 4:
            return !bankName.trimmingCharacters(in: .whitespaces).isEmpty
                && !accountHolder.trimmingCharacters(in: .whitespaces).isEmpty
                && !clabe.trimmingCharacters(in: .whitespaces).isEmpty
        case 5:
            return true
        default:
            return false
        }
    }

    // MARK: - Paso 1: Servicio

    private var step1Service: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Nombre del servicio").font(.subheadline.bold())
                TextField("Ej. YouTube Premium Familiar", text: $serviceName)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                serviceName.isEmpty
                                    ? Color.gray.opacity(0.25)
                                    : Color(red: 0.24, green: 0.78, blue: 0.75),
                                lineWidth: 1.5
                            )
                    )
            }

            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Costo mensual").font(.subheadline.bold())
                    HStack {
                        Text("$").foregroundColor(.secondary)
                        TextField("0.00", text: $monthlyCost).keyboardType(.decimalPad)
                    }
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1.5))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Día del cobro").font(.subheadline.bold())
                    Menu {
                        ForEach(1...31, id: \.self) { day in
                            Button("Día \(day)") { billingDay = day }
                        }
                    } label: {
                        HStack {
                            Text("Día \(billingDay)").foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down").font(.caption.bold()).foregroundColor(.secondary)
                        }
                        .padding(14)
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1.5))
                    }
                }
                .frame(maxWidth: 140)
            }
        }
    }

    // MARK: - Paso 2: Miembros

    private var step2Members: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Miembros").font(.subheadline.bold())

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 10) {
                    TextField("Nombre o correo", text: $memberEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(emailError != nil ? Color.red.opacity(0.6) : Color.gray.opacity(0.25), lineWidth: 1.5)
                        )
                    Button { addMember() } label: {
                        Image(systemName: "plus").font(.body.bold()).foregroundColor(.white)
                            .frame(width: 46, height: 46)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.24, green: 0.78, blue: 0.75)))
                    }
                }
                if let error = emailError {
                    Text(error).font(.caption).foregroundColor(.red)
                }
            }

            if !members.isEmpty {
                VStack(spacing: 0) {
                    ForEach(Array(members.enumerated()), id: \.element) { index, email in
                        HStack {
                            ZStack {
                                Circle().fill(Color(red: 0.24, green: 0.78, blue: 0.75).opacity(0.12)).frame(width: 36, height: 36)
                                Text(String(email.prefix(1)).uppercased())
                                    .font(.subheadline.bold())
                                    .foregroundColor(Color(red: 0.24, green: 0.78, blue: 0.75))
                            }
                            Text(email).font(.subheadline).foregroundColor(.primary)
                            Spacer()
                            Button {
                                members.remove(at: index)
                                manualAmounts.removeValue(forKey: email)
                            } label: {
                                Image(systemName: "xmark").font(.caption.bold()).foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 14).padding(.vertical, 12)
                        if index < members.count - 1 { Divider().padding(.leading, 56) }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGroupedBackground)))
            }

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "info.circle")
                    .foregroundColor(Color(red: 0.24, green: 0.78, blue: 0.75)).font(.subheadline)
                Text("Tú administras este grupo. Los miembros agregados pagan su parte; tú no apareces en la división.")
                    .font(.caption).foregroundColor(.secondary)
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.24, green: 0.78, blue: 0.75).opacity(0.08)))
        }
    }

    // MARK: - Paso 3: División

    private var step3Split: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Modo de división").font(.subheadline.bold())

            HStack(spacing: 0) {
                splitToggleButton(title: "Partes iguales", mode: .equal)
                splitToggleButton(title: "Asignar manualmente", mode: .manual)
            }
            .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGroupedBackground)))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            if splitMode == .equal {
                let cost = Double(monthlyCost.replacingOccurrences(of: ",", with: ".")) ?? 0
                let perPerson = members.isEmpty ? 0 : cost / Double(members.count)
                // String(format:) evita depender de Foundation explícito en SPM
                Text("Cada miembro paga $\(String(format: "%.2f", perPerson))")
                    .font(.subheadline).foregroundColor(.secondary)
            } else {
                let cost = Double(monthlyCost.replacingOccurrences(of: ",", with: ".")) ?? 0
                let total = members.compactMap {
                    Double(manualAmounts[$0, default: ""].replacingOccurrences(of: ",", with: "."))
                }.reduce(0, +)
                let isComplete = abs(total - cost) < 0.01

                VStack(spacing: 12) {
                    ForEach(members, id: \.self) { email in
                        HStack {
                            Text(email).font(.subheadline).foregroundColor(.primary)
                            Spacer()
                            HStack(spacing: 4) {
                                Text("$").foregroundColor(.secondary).font(.subheadline)
                                TextField("0", text: Binding(
                                    get: { manualAmounts[email, default: ""] },
                                    set: { manualAmounts[email] = $0 }
                                ))
                                .keyboardType(.decimalPad).multilineTextAlignment(.trailing).frame(width: 70)
                            }
                            .padding(.horizontal, 12).padding(.vertical, 10)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.25), lineWidth: 1))
                        }
                    }
                    HStack {
                        Text("Suma: $\(String(format: "%.2f", total)) / $\(String(format: "%.2f", cost))")
                            .font(.caption.bold())
                            .foregroundColor(isComplete ? Color(red: 0.24, green: 0.78, blue: 0.75) : .red)
                        Spacer()
                    }
                }
            }
        }
    }

    // MARK: - Paso 4: Datos bancarios

    private var step4Banking: some View {
        VStack(alignment: .leading, spacing: 16) {
            bankingField(label: "Banco",                        placeholder: "BBVA",         text: $bankName)
            bankingField(label: "Titular de la cuenta",         placeholder: "Diego Flores", text: $accountHolder)
            bankingField(label: "CLABE / Nº de cuenta",         placeholder: "18 dígitos",   text: $clabe,      keyboard: .numberPad)
            bankingField(label: "Número de tarjeta (opcional)", placeholder: "16 dígitos",   text: $cardNumber, keyboard: .numberPad, isOptional: true)
        }
    }

    // MARK: - Paso 5: Recordatorios

    private var step5Reminders: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Mensaje personalizado").font(.subheadline.bold())
                ZStack(alignment: .bottomTrailing) {
                    TextEditor(text: $reminderMessage)
                        .frame(minHeight: 100).padding(10)
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1.5))
                        .onChange(of: reminderMessage) { _, new in
                            if new.count > 200 { reminderMessage = String(new.prefix(200)) }
                        }
                        .overlay(Group {
                            if reminderMessage.isEmpty {
                                Text("Ej. ¡Hola! Recuerda tu pago de Netflix 💜")
                                    .foregroundColor(Color.gray.opacity(0.5)).font(.body).padding(16)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .allowsHitTesting(false)
                            }
                        })
                    Text("\(reminderMessage.count)/200").font(.caption).foregroundColor(.secondary).padding(10)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Días de anticipación").font(.subheadline.bold())
                FlowLayout(spacing: 10) {
                    ForEach(ReminderDays.allCases, id: \.rawValue) { days in
                        Button(days.label) { selectedReminderDays = days }
                            .font(.subheadline.bold())
                            .foregroundColor(selectedReminderDays == days ? .white : .primary)
                            .padding(.horizontal, 16).padding(.vertical, 10)
                            .background(Capsule().fill(
                                selectedReminderDays == days
                                    ? Color(red: 0.24, green: 0.78, blue: 0.75)
                                    : Color(.systemGroupedBackground)
                            ))
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func splitToggleButton(title: String, mode: SplitMode) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) { splitMode = mode }
        } label: {
            Text(title).font(.subheadline.bold())
                .foregroundColor(splitMode == mode ? .primary : Color.gray)
                .frame(maxWidth: .infinity).padding(.vertical, 10)
                .background(Group {
                    if splitMode == mode {
                        Capsule().fill(Color.white)
                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                })
        }
        .padding(4)
    }

    @ViewBuilder
    private func bankingField(
        label: String,
        placeholder: String,
        text: Binding<String>,
        keyboard: UIKeyboardType = .default,
        isOptional: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.subheadline.bold())
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.25), lineWidth: 1.5)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    text.wrappedValue.isEmpty ? Color.clear : Color(red: 0.24, green: 0.78, blue: 0.75),
                                    lineWidth: 1.5
                                )
                        )
                )
        }
    }

    private func addMember() {
        let email = memberEmail.trimmingCharacters(in: .whitespaces)
        guard !email.isEmpty else { emailError = "Ingresa un correo electrónico"; return }
        guard email.contains("@") && email.contains(".") else {
            emailError = "Ingresa un correo válido (ej. usuario@correo.com)"; return
        }
        guard !members.contains(email) else { emailError = "Este correo ya fue agregado"; return }
        emailError = nil
        members.append(email)
        memberEmail = ""
    }
}

// MARK: - FlowLayout

/// Distribuye hijos en filas con salto de línea automático.
/// Android equivalent: FlowRow de Jetpack Compose.
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var x: CGFloat = 0; var y: CGFloat = 0; var maxH: CGFloat = 0
        for sub in subviews {
            let s = sub.sizeThatFits(.unspecified)
            if x + s.width > width, x > 0 { x = 0; y += maxH + spacing; maxH = 0 }
            maxH = max(maxH, s.height); x += s.width + spacing
        }
        return CGSize(width: width, height: y + maxH)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX; var y = bounds.minY; var maxH: CGFloat = 0
        for sub in subviews {
            let s = sub.sizeThatFits(.unspecified)
            if x + s.width > bounds.maxX, x > bounds.minX { x = bounds.minX; y += maxH + spacing; maxH = 0 }
            sub.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            maxH = max(maxH, s.height); x += s.width + spacing
        }
    }
}

#Preview {
    CreateSubscriptionSheet(isPresented: .constant(true))
}
