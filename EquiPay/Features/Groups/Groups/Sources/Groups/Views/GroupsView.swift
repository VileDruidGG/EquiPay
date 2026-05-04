//
//  GroupsView.swift
//  Groups
//
//  Created by EquiPay on 04/05/26.
//
import SwiftUI
import DesignSystem

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
}

public struct GroupsView: View {

    /// Binding al tab seleccionado del TabBar.
    /// Permite que el botón "Crear nuevo grupo" salte al tab .add
    /// sin que GroupsView necesite saber nada del resto de la app.
    ///
    /// Android equivalent: un callback/lambda onCreateTap: () -> Unit
    @Binding var selectedTab: Int

    private let groups: [GroupItem] = [
        GroupItem(
            icon: "arrow.trianglehead.2.clockwise.rotate.90",
            iconBackground: Color.purple.opacity(0.12),
            title: "YouTube Premium",
            participants: 5,
            amount: "50",
            status: .pending,
            direction: .negative
        ),
        GroupItem(
            icon: "arrow.trianglehead.2.clockwise.rotate.90",
            iconBackground: Color.purple.opacity(0.12),
            title: "Netflix Familiar",
            participants: 4,
            amount: "0",
            status: .completed,
            direction: .neutral
        ),
        GroupItem(
            icon: "briefcase",
            iconBackground: Color.teal.opacity(0.12),
            title: "Viaje CDMX",
            participants: 5,
            amount: "450",
            status: .pending,
            direction: .positive
        ),
        GroupItem(
            icon: "briefcase",
            iconBackground: Color.teal.opacity(0.12),
            title: "Roomies Casa",
            participants: 3,
            amount: "0",
            status: .completed,
            direction: .neutral
        ),
        GroupItem(
            icon: "briefcase",
            iconBackground: Color.teal.opacity(0.12),
            title: "Cena Viernes",
            participants: 8,
            amount: "125",
            status: .pending,
            direction: .positive
        ),
    ]

    public init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: Botón crear nuevo grupo
                createGroupButton
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                // MARK: Lista de grupos
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(groups.indices, id: \.self) { index in
                            let group = groups[index]
                            ExpenseCard(
                                icon: group.icon,
                                iconBackground: group.iconBackground,
                                title: group.title,
                                participantsAmount: group.participants,
                                amount: group.amount,
                                status: group.status,
                                balanceDirection: group.direction
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Mis grupos")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Subviews

    private var createGroupButton: some View {
        Button {
            selectedTab = 2 // índice del tab "Crear"
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.body.bold())
                Text("Crear nuevo grupo")
                    .font(.body.bold())
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.24, green: 0.78, blue: 0.75), Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
        }
    }
}

#Preview {
    GroupsView(selectedTab: .constant(1))
}
