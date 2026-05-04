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

/// Modelo mock de una notificación/actividad.
/// Android equivalent: data class ActivityItem
struct ActivityItem: Identifiable {
    let id = UUID()
    let icon: String
    let iconBackground: Color
    let iconForeground: Color
    let title: String
    let subtitle: String
    let timeAgo: String
}

public struct ActivityView: View {

    @State private var selectedTab: ActivityTab = .notifications

    private let notifications: [ActivityItem] = [
        ActivityItem(
            icon: "bell",
            iconBackground: Color.orange.opacity(0.12),
            iconForeground: Color.orange,
            title: "Recordatorio de pago",
            subtitle: "Tu pago de Netflix Familiar vence en 3 días",
            timeAgo: "hace 2h"
        ),
        ActivityItem(
            icon: "checkmark.circle",
            iconBackground: Color.teal.opacity(0.12),
            iconForeground: Color.teal,
            title: "Pago confirmado",
            subtitle: "Andrea confirmó tu pago de $50",
            timeAgo: "ayer"
        ),
        ActivityItem(
            icon: "person.2",
            iconBackground: Color.purple.opacity(0.12),
            iconForeground: Color.purple,
            title: "Nuevo grupo",
            subtitle: "Te agregaron a 'YouTube Premium Familiar'",
            timeAgo: "hace 3 d"
        ),
    ]

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            headerSection

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(notifications) { item in
                        ActivityRow(item: item)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }

            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Actividad")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)

            segmentedPicker
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 60)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .background(
            LinearGradient(
                colors: [Color(red: 0.24, green: 0.78, blue: 0.75), Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    /// Selector segmentado custom. En Android: TabRow de Material 3.
    private var segmentedPicker: some View {
        HStack(spacing: 0) {
            ForEach(ActivityTab.allCases, id: \.title) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    Text(tab.title)
                        .font(.subheadline.bold())
                        .foregroundColor(selectedTab == tab ? .primary : Color.white.opacity(0.75))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Group {
                                if selectedTab == tab {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white)
                                }
                            }
                        )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.2))
        )
    }
}

private struct ActivityRow: View {
    let item: ActivityItem

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: item.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(item.iconForeground)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(item.iconBackground)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Text(item.timeAgo)
                .font(.caption)
                .foregroundColor(Color.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    ActivityView()
}
