//
//  GroupsView.swift
//  Groups
//
//  Created by EquiPay on 04/05/26.
//
import SwiftUI
import DesignSystem

/// Tipo de grupo — determina si al tocar navega al detalle.
/// Solo .subscription tiene GroupDetailView implementado.
/// Android equivalent: enum class GroupCategory
public enum GroupCategory {
    case subscription
    case vacation
    case singleEvent
}

/// Modelo mock de un grupo para la UI.
/// Android equivalent: data class GroupItem
struct GroupItem {
    let icon: String
    let iconBackground: Color
    let title: String
    let participants: Int
    let amount: String
    let status: ExpenseStatus
    let direction: BalanceDirection
    let category: GroupCategory
}

public struct GroupsView: View {

    @Binding var selectedTab: Int

    private let groups: [GroupItem] = [
        GroupItem(icon: "arrow.trianglehead.2.clockwise.rotate.90", iconBackground: Color.purple.opacity(0.12),
                  title: "YouTube Premium", participants: 5, amount: "50",
                  status: .pending, direction: .negative, category: .subscription),
        GroupItem(icon: "arrow.trianglehead.2.clockwise.rotate.90", iconBackground: Color.purple.opacity(0.12),
                  title: "Netflix Familiar", participants: 4, amount: "0",
                  status: .completed, direction: .neutral, category: .subscription),
        GroupItem(icon: "briefcase", iconBackground: Color.teal.opacity(0.12),
                  title: "Viaje CDMX", participants: 5, amount: "450",
                  status: .pending, direction: .positive, category: .vacation),
        GroupItem(icon: "briefcase", iconBackground: Color.teal.opacity(0.12),
                  title: "Roomies Casa", participants: 3, amount: "0",
                  status: .completed, direction: .neutral, category: .vacation),
        GroupItem(icon: "briefcase", iconBackground: Color.teal.opacity(0.12),
                  title: "Cena Viernes", participants: 8, amount: "125",
                  status: .pending, direction: .positive, category: .singleEvent),
    ]

    public init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                createGroupButton
                    .padding(.horizontal, 16).padding(.top, 16).padding(.bottom, 8)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(groups.indices, id: \.self) { index in
                            groupRow(groups[index])
                        }
                    }
                    .padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 32)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Mis grupos")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    private func groupRow(_ group: GroupItem) -> some View {
        if group.category == .subscription {
            NavigationLink {
                GroupDetailView(
                    groupName: group.title,
                    monthlyAmount: "$250",
                    nextBillingDate: "15 may",
                    paidCount: "2",
                    totalCount: "\(group.participants)",
                    pendingAmount: "$150"
                )
            } label: {
                ExpenseCard(icon: group.icon, iconBackground: group.iconBackground,
                            title: group.title, participantsAmount: group.participants,
                            amount: group.amount, status: group.status, balanceDirection: group.direction)
            }
            .buttonStyle(.plain)
        } else {
            ExpenseCard(icon: group.icon, iconBackground: group.iconBackground,
                        title: group.title, participantsAmount: group.participants,
                        amount: group.amount, status: group.status, balanceDirection: group.direction)
        }
    }

    private var createGroupButton: some View {
        Button { selectedTab = 2 } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus").font(.body.bold())
                Text("Crear nuevo grupo").font(.body.bold())
            }
            .foregroundColor(.white)
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
}

#Preview {
    GroupsView(selectedTab: .constant(1))
}
