//
//  MyAppointments.swift
//  Vollmed
//
//  Created by Maria Clara Dias on 03/07/25.
//

import SwiftUI

struct MyAppointments: View {
    
    let service = WebService()
    
    @State private var appointments: [Appointment] = []
    
    func getAllAppointments() async {
        do {
            if let appointments = try await service.getAllAppointmentsFromPatient(patientID: patientID) {
                self.appointments = appointments
            }
        } catch {
            print("Ocorreu um erro ao obter consultas: \(error)")
        }
    }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                if appointments.isEmpty {
                    Text("Não há nenhuma consulta agendada no momento!")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color.cancel)
                        .multilineTextAlignment(.center)
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(appointments) { appointment in
                            SpecialistCardView(specialist: appointment.specialist, appointment: appointment)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Minhas consultas")
            .navigationBarTitleDisplayMode(.large)
            .padding()
            .onAppear {
                Task {
                    await getAllAppointments()
                }
            }
        }
    }
}
#Preview {
    MyAppointments()
}

