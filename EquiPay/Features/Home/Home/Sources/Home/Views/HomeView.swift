//
//  HomeView.swift
//  Home
//
//  Created by Christofher Ontiveros Espino on 15/10/25.
//
import SwiftUI
import DesignSystem
import Groups

public struct HomeView: View {

    @State public var username = "Usuario"

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.24, green: 0.78, blue: 0.75), Color.purple],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .padding(.bottom, 16)

                    contentSection
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .background(Color(.systemBackground))
                }
            }
            .background(Color(.systemBackground))
            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(true)
        }
    }

    @MainActor
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hola, \(username) 👋")
                        .font(.largeTitle).bold().foregroundColor(.white)
                    Text("Administra tus gastos compartidos")
                        .font(.subheadline).foregroundColor(Color.white.opacity(0.85))
                }
                Spacer()
                Button(action: { print("notificaciones pressed") }) {
                    Image(systemName: "bell").font(.body.bold()).foregroundColor(.white)
                        .padding(15)
                        .background(
                            RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.2))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.4), lineWidth: 1))
                        )
                }
            }
            HStack(spacing: 10) {
                SummaryCard(title: "Te deben", amount: "$450", icon: "arrow.up.right")
                SummaryCard(title: "Debes",    amount: "$125", icon: "dollarsign")
                SummaryCard(title: "Grupos activos", amount: "3", icon: "person.2")
            }
        }
        .padding(.top, 60).padding(.horizontal, 20).padding(.bottom, 24)
    }

    @MainActor
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Grupos recientes").font(.title2).bold()
                    Spacer()
                    Button {
                        print("Ver todos pressed")
                    } label: {
                        HStack(spacing: 4) {
                            Text("Ver todos").font(.subheadline)
                            Image(systemName: "arrow.right").font(.subheadline)
                        }
                        .foregroundColor(.secondary)
                    }
                }

                VStack(spacing: 12) {
                    // Suscripción → navega al detalle
                    NavigationLink {
                        GroupDetailView(
                            groupName: "YouTube Premium",
                            monthlyAmount: "$250",
                            nextBillingDate: "15 may",
                            paidCount: "2",
                            totalCount: "5",
                            pendingAmount: "$150"
                        )
                    } label: {
                        ExpenseCard(
                            icon: "arrow.trianglehead.2.clockwise.rotate.90",
                            iconBackground: Color.purple.opacity(0.12),
                            title: "YouTube Premium",
                            participantsAmount: 5, amount: "50",
                            status: .pending, balanceDirection: .negative
                        )
                    }
                    .buttonStyle(.plain)

                    ExpenseCard(icon: "briefcase", iconBackground: Color.teal.opacity(0.12),
                                title: "Viaje CDMX", participantsAmount: 5, amount: "450",
                                status: .pending, balanceDirection: .positive)

                    ExpenseCard(icon: "briefcase", iconBackground: Color.teal.opacity(0.12),
                                title: "Roomies Casa", participantsAmount: 3, amount: "0",
                                status: .completed, balanceDirection: .neutral)
                }
            }

            VStack(alignment: .leading, spacing: 14) {
                Text("Acciones rápidas").font(.title2).bold()
                HStack(spacing: 12) {
                    QuickActionCard(title: "Crear grupo", icon: "plus", isPrincipal: true)
                    QuickActionCard(title: "Actividad",   icon: "bell", isPrincipal: false)
                }
            }

            Spacer(minLength: 40)
        }
    }
}

#Preview {
    HomeView()
}
