//
//  GroupDetailView.swift
//  Groups
//
//  Created by EquiPay on 04/05/26.
//
import SwiftUI

/// Estado de pago de un miembro dentro del grupo.
/// Android equivalent: enum class MemberPaymentStatus
public enum MemberPaymentStatus {
    case paid
    case pending
    case overdue

    var label: String {
        switch self {
        case .paid:    return "Pagado"
        case .pending: return "Pendiente"
        case .overdue: return "Atrasado"
        }
    }

    var badgeColor: Color {
        switch self {
        case .paid:    return Color.green.opacity(0.12)
        case .pending: return Color.orange.opacity(0.12)
        case .overdue: return Color.red.opacity(0.12)
        }
    }

    var textColor: Color {
        switch self {
        case .paid:    return Color.green
        case .pending: return Color.orange
        case .overdue: return Color.red
        }
    }

    var icon: String {
        switch self {
        case .paid:    return "checkmark.circle"
        case .pending: return "clock"
        case .overdue: return "exclamationmark.circle"
        }
    }
}

/// Miembro de un grupo de suscripción.
/// Android equivalent: data class GroupMember
public struct GroupMember: Identifiable {
    public let id = UUID()
    public let initial: String
    public let name: String
    public let amount: String
    public let status: MemberPaymentStatus
    public let note: String?

    public init(initial: String, name: String, amount: String,
                status: MemberPaymentStatus, note: String? = nil) {
        self.initial = initial
        self.name = name
        self.amount = amount
        self.status = status
        self.note = note
    }
}

/// Pago pendiente de confirmación por parte del dueño del grupo.
/// Android equivalent: data class PendingPayment
public struct PendingPayment: Identifiable {
    public let id = UUID()
    public let initial: String
    public let name: String
    public let amount: String
    public let period: String
    public let date: String

    public init(initial: String, name: String, amount: String,
                period: String, date: String) {
        self.initial = initial
        self.name = name
        self.amount = amount
        self.period = period
        self.date = date
    }
}

/// Pantalla de detalle de un grupo de suscripción mensual.
/// Solo se accede desde GroupsView o HomeView cuando el grupo es de tipo .subscription.
/// Android equivalent: SubscriptionGroupDetailScreen
public struct GroupDetailView: View {

    // MARK: - Props

    let groupName: String
    let monthlyAmount: String
    let nextBillingDate: String
    let paidCount: String
    let totalCount: String
    let pendingAmount: String

    @State private var members: [GroupMember]
    @State private var pendingPayments: [PendingPayment]

    // MARK: - Init (mock)

    public init(
        groupName: String = "YouTube Premium Familiar",
        monthlyAmount: String = "$250",
        nextBillingDate: String = "15 may",
        paidCount: String = "2",
        totalCount: String = "5",
        pendingAmount: String = "$150",
        members: [GroupMember] = GroupDetailView.defaultMembers,
        pendingPayments: [PendingPayment] = GroupDetailView.defaultPendingPayments
    ) {
        self.groupName = groupName
        self.monthlyAmount = monthlyAmount
        self.nextBillingDate = nextBillingDate
        self.paidCount = paidCount
        self.totalCount = totalCount
        self.pendingAmount = pendingAmount
        self._members = State(initialValue: members)
        self._pendingPayments = State(initialValue: pendingPayments)
    }

    // MARK: - Body

    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                headerSection
                contentSection
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Sin acción por ahora — solo UI
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(Color.white.opacity(0.2)))
                }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text(groupName)
                    .font(.title2).bold()
                    .foregroundColor(.white)
                Text("Suscripción mensual · \(monthlyAmount)/mes")
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.85))
            }
            HStack(spacing: 10) {
                DetailStatCard(label: "Próximo cobro", value: nextBillingDate)
                DetailStatCard(label: "Pagaron",       value: "\(paidCount)/\(totalCount)")
                DetailStatCard(label: "Pendiente",     value: pendingAmount)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 60).padding(.horizontal, 20).padding(.bottom, 28)
        .background(
            LinearGradient(
                colors: [Color(red: 0.24, green: 0.78, blue: 0.75), Color.purple],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
    }

    // MARK: - Content

    private var contentSection: some View {
        VStack(spacing: 16) {
            membersSection
            pendingPaymentsSection
            quickActionsSection
            historialLink
        }
    }

    // MARK: Estado de los miembros

    private var membersSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Estado de los miembros")
                .font(.headline)
                .padding(.horizontal, 16).padding(.top, 16).padding(.bottom, 12)
            ForEach(Array(members.enumerated()), id: \.element.id) { index, member in
                VStack(spacing: 0) {
                    MemberRow(member: member)
                    if index < members.count - 1 {
                        Divider().padding(.leading, 62)
                    }
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

    // MARK: Pagos por confirmar

    private var pendingPaymentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Pagos por confirmar").font(.headline)
                Spacer()
                Text("\(pendingPayments.count) nuevos")
                    .font(.caption).bold().foregroundColor(Color.orange)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(Capsule().fill(Color.orange.opacity(0.12)))
            }
            ForEach(pendingPayments) { payment in
                PendingPaymentCard(payment: payment)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.1), lineWidth: 1))
    }

    // MARK: Acciones rápidas

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Acciones rápidas").font(.headline)

            Button {
                // Sin acción por ahora — solo UI
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "bell").font(.body.bold())
                    Text("Enviar recordatorio ahora").font(.body.bold())
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity).frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(
                            colors: [Color(red: 0.24, green: 0.78, blue: 0.75), Color.purple],
                            startPoint: .leading, endPoint: .trailing
                        ))
                )
            }

            // Navega a GroupSettingsView
            NavigationLink {
                GroupSettingsView(groupName: groupName)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "slider.horizontal.3").font(.body)
                    Text("Editar grupo").font(.body)
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity).frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemBackground))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.1), lineWidth: 1))
    }

    // MARK: Link historial

    private var historialLink: some View {
        Button {
            // Sin acción por ahora — solo UI
        } label: {
            HStack {
                Text("Ver historial completo").font(.subheadline.bold())
                Spacer()
                Image(systemName: "arrow.right").font(.subheadline.bold())
            }
            .foregroundColor(Color(red: 0.24, green: 0.78, blue: 0.75))
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Mock data

    public static let defaultMembers: [GroupMember] = [
        GroupMember(initial: "A", name: "Ana",   amount: "$50", status: .paid,    note: "+3 meses adelantados"),
        GroupMember(initial: "C", name: "Carlos", amount: "$50", status: .paid,    note: nil),
        GroupMember(initial: "M", name: "María",  amount: "$50", status: .pending, note: nil),
        GroupMember(initial: "L", name: "Luis",   amount: "$50", status: .pending, note: nil),
        GroupMember(initial: "S", name: "Sofía",  amount: "$50", status: .overdue, note: nil),
    ]

    public static let defaultPendingPayments: [PendingPayment] = [
        PendingPayment(initial: "M", name: "María", amount: "$50",  period: "1 mes",  date: "10 may"),
        PendingPayment(initial: "L", name: "Luis",  amount: "$100", period: "2 meses", date: "9 may"),
    ]
}

// MARK: - DetailStatCard

private struct DetailStatCard: View {
    let label: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).foregroundColor(Color.white.opacity(0.75))
            Text(value).font(.headline).bold().foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.18))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.3), lineWidth: 1))
        )
    }
}

// MARK: - MemberRow

private struct MemberRow: View {
    let member: GroupMember
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color.purple.opacity(0.15)).frame(width: 40, height: 40)
                Text(member.initial).font(.subheadline.bold()).foregroundColor(Color.purple)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(member.name).font(.subheadline.bold()).foregroundColor(.primary)
                HStack(spacing: 4) {
                    Text(member.amount).font(.caption).foregroundColor(.secondary)
                    if let note = member.note {
                        Text("· \(note)").font(.caption).foregroundColor(.secondary)
                    }
                }
            }
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: member.status.icon).font(.caption.bold())
                Text(member.status.label).font(.caption.bold())
            }
            .foregroundColor(member.status.textColor)
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(Capsule().fill(member.status.badgeColor))
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
    }
}

// MARK: - PendingPaymentCard

private struct PendingPaymentCard: View {
    let payment: PendingPayment

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)).frame(width: 42, height: 42)
                    Image(systemName: "dollarsign.square").font(.system(size: 18)).foregroundColor(.secondary)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(payment.name).font(.subheadline.bold())
                    Text("\(payment.amount) · \(payment.period) · \(payment.date)")
                        .font(.caption).foregroundColor(.secondary)
                }
                Spacer()
            }
            HStack(spacing: 12) {
                Button { } label: {
                    Text("Confirmar").font(.subheadline.bold()).foregroundColor(.white)
                        .frame(maxWidth: .infinity).frame(height: 40)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.24, green: 0.78, blue: 0.75)))
                }
                Button { } label: {
                    Text("Rechazar").font(.subheadline.bold()).foregroundColor(.primary)
                        .frame(maxWidth: .infinity).frame(height: 40)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemBackground))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1)))
                }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGroupedBackground)))
    }
}

#Preview {
    NavigationStack { GroupDetailView() }
}
