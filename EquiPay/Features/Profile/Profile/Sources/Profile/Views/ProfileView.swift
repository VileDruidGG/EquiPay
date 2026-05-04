//
//  ProfileView.swift
//  Profile
//
//  Created by EquiPay on 04/05/26.
//
import SwiftUI

/// Opción del menú de perfil.
/// Android equivalent: data class ProfileMenuItem
struct ProfileMenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

public struct ProfileView: View {

    private let userName    = "Usuario Demo"
    private let userEmail   = "usuario@equipay.com"
    private let userInitial = "U"
    private let groups      = 8
    private let owedAmount  = "$450"
    private let expenses    = 45

    private let menuItems: [ProfileMenuItem] = [
        ProfileMenuItem(icon: "person",    title: "Editar perfil"),
        ProfileMenuItem(icon: "bell",      title: "Notificaciones"),
        ProfileMenuItem(icon: "shield",    title: "Privacidad y seguridad"),
        ProfileMenuItem(icon: "envelope",  title: "Soporte"),
    ]

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            headerSection

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    statsSection
                    menuSection
                    logoutButton

                    Text("Versión 1.0.0")
                        .font(.caption)
                        .foregroundColor(Color.gray.opacity(0.6))
                        .padding(.top, 4)
                        .padding(.bottom, 32)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
    }

    private var headerSection: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 72, height: 72)
                    .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 1.5))
                Text(userInitial)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(userName)
                    .font(.title2).bold()
                    .foregroundColor(.white)
                Text(userEmail)
                    .font(.subheadline)
                    .foregroundColor(Color.white.opacity(0.85))
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 60)
        .padding(.horizontal, 20)
        .padding(.bottom, 28)
        .background(
            LinearGradient(
                colors: [Color(red: 0.24, green: 0.78, blue: 0.75), Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    private var statsSection: some View {
        HStack(spacing: 12) {
            StatCard(value: "\(groups)", label: "Grupos")
            StatCard(value: owedAmount,  label: "Te deben")
            StatCard(value: "\(expenses)", label: "Gastos")
        }
    }

    private var menuSection: some View {
        VStack(spacing: 0) {
            ForEach(Array(menuItems.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: 0) {
                    MenuRow(item: item)
                    if index < menuItems.count - 1 {
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
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }

    private var logoutButton: some View {
        Button {
            // Sin acción por ahora — solo UI
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.body.bold())
                Text("Cerrar sesión")
                    .font(.body.bold())
            }
            .foregroundColor(Color.red)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
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
}

private struct StatCard: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2).bold()
                .foregroundColor(Color(red: 0.24, green: 0.78, blue: 0.75))
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

private struct MenuRow: View {
    let item: ProfileMenuItem

    var body: some View {
        Button {
            // Sin acción por ahora — solo UI
        } label: {
            HStack(spacing: 14) {
                Image(systemName: item.icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(red: 0.24, green: 0.78, blue: 0.75))
                    .frame(width: 36, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.24, green: 0.78, blue: 0.75).opacity(0.10))
                    )

                Text(item.title)
                    .font(.body)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(Color.gray.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    ProfileView()
}
