//
//  ActivityView.swift
//  Activity
//
//  Created by EquiPay on 04/05/26.
//
import SwiftUI

/// Pestaña activa del selector de Actividad.
/// Android equivalent: enum class ActivityTab
public enum ActivityTab: CaseIterable {
    case notifications
    case history

    var title: String {
        switch self {
        case .notifications: return "Notificaciones"
        case .history:       return "Historial"
        }
    }
}

struct ActivityItem: Identifiable {
    let id = UUID()
    let icon: String
    let iconBackground: Color
    let iconForeground: Color
    let title: String
    let subtitle: String
    let timeAgo: String
}

/// Tipo de movimiento en el historial.
/// Android equivalent: enum class HistoryItemType
enum HistoryItemType {
    case outgoing   // Pagaste a alguien — rojo
    case incoming   // Alguien te pagó — verde
    case event      // Evento sin monto (grupo creado, etc.) — purple
}

/// Movimiento individual del historial.
/// Android equivalent: data class HistoryItem
struct HistoryItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let amount: String?
    let type: HistoryItemType

    var amountColor: Color {
        switch type {
        case .outgoing: return Color.red
        case .incoming: return Color.green
        case .event:    return Color.clear
        }
    }
    var iconBackground: Color {
        switch type {
        case .outgoing: return Color.red.opacity(0.10)
        case .incoming: return Color.green.opacity(0.10)
        case .event:    return Color.purple.opacity(0.10)
        }
    }
    var iconForeground: Color {
        switch type {
        case .outgoing: return Color.red
        case .incoming: return Color.green
        case .event:    return Color.purple
        }
    }
    var icon: String {
        switch type {
        case .outgoing: return "dollarsign.circle"
        case .incoming: return "dollarsign.circle.fill"
        case .event:    return "person.2.badge.plus"
        }
    }
}

/// Grupo de items del historial bajo un mes.
/// Android equivalent: data class HistorySection
struct HistorySection: Identifiable {
    let id = UUID()
    let month: String
    let items: [HistoryItem]
}

public struct ActivityView: View {

    @State private var selectedTab: ActivityTab = .notifications

    private let notifications: [ActivityItem] = [
        ActivityItem(icon: "bell",
                     iconBackground: Color.orange.opacity(0.12), iconForeground: Color.orange,
                     title: "Recordatorio de pago",
                     subtitle: "Tu pago de Netflix Familiar vence en 3 días",
                     timeAgo: "hace 2h"),
        ActivityItem(icon: "checkmark.circle",
                     iconBackground: Color.teal.opacity(0.12), iconForeground: Color.teal,
                     title: "Pago confirmado",
                     subtitle: "Andrea confirmó tu pago de $50",
                     timeAgo: "ayer"),
        ActivityItem(icon: "person.2",
                     iconBackground: Color.purple.opacity(0.12), iconForeground: Color.purple,
                     title: "Nuevo grupo",
                     subtitle: "Te agregaron a 'YouTube Premium Familiar'",
                     timeAgo: "hace 3 d"),
    ]

    private let historySections: [HistorySection] = [
        HistorySection(month: "MAYO", items: [
            HistoryItem(title: "Pagaste a Andrea",  subtitle: "YouTube Premium · 10 may", amount: "-$50",  type: .outgoing),
            HistoryItem(title: "Carlos te pagó",    subtitle: "Viaje CDMX · 8 may",        amount: "+$450", type: .incoming),
        ]),
        HistorySection(month: "ABRIL", items: [
            HistoryItem(title: "Grupo creado",       subtitle: "Roomies Casa · 28 abr",     amount: nil,     type: .event),
            HistoryItem(title: "Pagaste a Ana",      subtitle: "Gym Mensual · 12 abr",      amount: "-$250", type: .outgoing),
        ]),
    ]

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            headerSection
            ScrollView(showsIndicators: false) {
                if selectedTab == .notifications {
                    notificationsContent
                } else {
                    historyContent
                }
            }
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Actividad").font(.largeTitle).bold().foregroundColor(.white)
            segmentedPicker
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 60).padding(.horizontal, 20).padding(.bottom, 24)
        .background(
            LinearGradient(
                colors: [Color(red: 0.24, green: 0.78, blue: 0.75), Color.purple],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
    }

    private var segmentedPicker: some View {
        HStack(spacing: 0) {
            ForEach(ActivityTab.allCases, id: \.title) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
                } label: {
                    Text(tab.title)
                        .font(.subheadline.bold())
                        .foregroundColor(selectedTab == tab ? .primary : Color.white.opacity(0.75))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Group {
                            if selectedTab == tab {
                                RoundedRectangle(cornerRadius: 20).fill(Color.white)
                            }
                        })
                }
            }
        }
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.2)))
    }

    private var notificationsContent: some View {
        VStack(spacing: 12) {
            ForEach(notifications) { item in ActivityRow(item: item) }
        }
        .padding(.horizontal, 16).padding(.top, 20).padding(.bottom, 32)
    }

    private var historyContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(historySections) { section in
                Text(section.month)
                    .font(.caption.bold()).foregroundColor(.secondary)
                    .padding(.horizontal, 16).padding(.top, 20).padding(.bottom, 8)

                VStack(spacing: 0) {
                    ForEach(Array(section.items.enumerated()), id: \.element.id) { index, item in
                        VStack(spacing: 0) {
                            HistoryRow(item: item)
                            if index < section.items.count - 1 {
                                Divider().padding(.leading, 70)
                            }
                        }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.1), lineWidth: 1))
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 32)
    }
}

private struct ActivityRow: View {
    let item: ActivityItem
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: item.icon).font(.system(size: 16, weight: .medium))
                .foregroundColor(item.iconForeground)
                .frame(width: 44, height: 44)
                .background(RoundedRectangle(cornerRadius: 14).fill(item.iconBackground))
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(.headline).foregroundColor(.primary)
                Text(item.subtitle).font(.subheadline).foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Text(item.timeAgo).font(.caption).foregroundColor(Color.gray)
        }
        .padding(16).frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.1), lineWidth: 1))
    }
}

private struct HistoryRow: View {
    let item: HistoryItem
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: item.icon).font(.system(size: 16, weight: .medium))
                .foregroundColor(item.iconForeground)
                .frame(width: 44, height: 44)
                .background(Circle().fill(item.iconBackground))
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title).font(.subheadline.bold()).foregroundColor(.primary)
                Text(item.subtitle).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            if let amount = item.amount {
                Text(amount).font(.subheadline.bold()).foregroundColor(item.amountColor)
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 14)
    }
}

#Preview {
    ActivityView()
}
