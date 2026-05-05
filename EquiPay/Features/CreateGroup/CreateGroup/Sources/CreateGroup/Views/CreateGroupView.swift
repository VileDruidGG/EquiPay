//
//  CreateGroupView.swift
//  CreateGroup
//
//  Created by EquiPay on 04/05/26.
//
import SwiftUI

/// Tipo de grupo que el usuario puede crear.
/// Android equivalent: sealed class GroupType
public enum GroupType: CaseIterable {
    case vacation
    case subscription
    case singleEvent

    var emoji: String {
        switch self {
        case .vacation:     return "🧳"
        case .subscription: return "🔄"
        case .singleEvent:  return "🍽️"
        }
    }

    var title: String {
        switch self {
        case .vacation:     return "Vacaciones"
        case .subscription: return "Suscripción mensual"
        case .singleEvent:  return "Evento único"
        }
    }

    var description: String {
        switch self {
        case .vacation:     return "Múltiples gastos durante un viaje"
        case .subscription: return "Planes familiares como YT Premium, Netflix"
        case .singleEvent:  return "Cenas, salidas, gastos de un solo momento"
        }
    }

    var iconName: String {
        switch self {
        case .vacation:     return "briefcase"
        case .subscription: return "arrow.trianglehead.2.clockwise.rotate.90"
        case .singleEvent:  return "calendar"
        }
    }

    var iconBackground: Color {
        switch self {
        case .vacation:     return Color.teal.opacity(0.12)
        case .subscription: return Color.purple.opacity(0.12)
        case .singleEvent:  return Color.orange.opacity(0.12)
        }
    }

    var iconForeground: Color {
        switch self {
        case .vacation:     return Color.teal
        case .subscription: return Color.purple
        case .singleEvent:  return Color.orange
        }
    }

    var isAvailable: Bool {
        switch self {
        case .vacation, .subscription: return true
        case .singleEvent:             return false
        }
    }
}

public struct CreateGroupView: View {

    @State private var showSubscriptionSheet = false

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            headerSection

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(GroupType.allCases, id: \.title) { type in
                        GroupTypeRow(type: type) {
                            if type == .subscription {
                                showSubscriptionSheet = true
                            }
                        }
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
        .sheet(isPresented: $showSubscriptionSheet) {
            CreateSubscriptionSheet(isPresented: $showSubscriptionSheet)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Crear grupo")
                .font(.largeTitle).bold().foregroundColor(.white)
            Text("Elige el tipo de grupo que quieres crear ✨")
                .font(.subheadline).foregroundColor(Color.white.opacity(0.9))
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
}

// MARK: - Fila de tipo de grupo

private struct GroupTypeRow: View {
    let type: GroupType
    let onTap: () -> Void

    var body: some View {
        Button { onTap() } label: {
            HStack(spacing: 14) {
                Image(systemName: type.iconName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(type.isAvailable ? type.iconForeground : Color.orange.opacity(0.5))
                    .frame(width: 46, height: 46)
                    .background(RoundedRectangle(cornerRadius: 14).fill(type.iconBackground.opacity(type.isAvailable ? 1 : 0.5)))

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("\(type.emoji) \(type.title)")
                            .font(.headline)
                            .foregroundColor(type.isAvailable ? .primary : Color.gray)

                        if !type.isAvailable {
                            Text("Próximamente")
                                .font(.caption).bold().foregroundColor(Color.orange)
                                .padding(.horizontal, 8).padding(.vertical, 3)
                                .background(Capsule().fill(Color.orange.opacity(0.12)))
                        }
                    }
                    Text(type.description)
                        .font(.subheadline)
                        .foregroundColor(type.isAvailable ? .secondary : Color.gray.opacity(0.6))
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                if type.isAvailable {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.bold())
                        .foregroundColor(Color.gray.opacity(0.4))
                }
            }
            .padding(16).frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
            )
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.1), lineWidth: 1))
        }
        .disabled(!type.isAvailable)
    }
}

#Preview {
    CreateGroupView()
}
