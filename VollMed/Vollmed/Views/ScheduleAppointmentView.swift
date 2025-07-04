//
//  ScheduleAppointmentView.swift
//  Vollmed
//
//  Created by Maria Clara Dias on 02/07/25.
//

import SwiftUI

struct ScheduleAppointmentView: View {
    
    let service = WebService()
    
    var specialistID: String
    var isRescheduleView: Bool
    var appointmentID: String?
    
    @State private var selectedDate = Date()
    @State private var showAlert = false
    @State private var isAppointmentScheduled = false
    
    init(specialistID: String, isRescheduleView: Bool = false, appointmentID: String? = nil) {
        self.specialistID = specialistID
        self.isRescheduleView = isRescheduleView
        self.appointmentID = appointmentID
    }
    
    func rescheduleAppointment() async {
        guard let appointmentID else {
            print("Houve um erro ao obter o ID da consulta")
            return
        }
        do {
            if let _ = try await service.rescheduleAppointment(appointmentID: appointmentID, date: selectedDate.convertToString()) {
                isAppointmentScheduled = true
            } else {
                isAppointmentScheduled = false
            }
        } catch {
            print("Ocorreu um erro ao remarcar consulta: \(error)")
            isAppointmentScheduled = false
        }
        showAlert = true
    }
    
    func scheduleAppointment() async {
        do {
            if let appointment = try await  service.scheduleAppointment(specialistID: specialistID, patientID: patientID, date: selectedDate.convertToString()) {
                print(appointment)
                isAppointmentScheduled = true
            }
        } catch {
            print("Ocorreu um erro ao agendar consulta: \(error)")
        }
        showAlert = true
    }
    
    var body: some View {
        VStack {
            Text("Selecione a data e o horário da consulta")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            DatePicker("Escolha a data da consulta", selection: $selectedDate, in: Date()...)
            //in: Date()... para bloquear datas passadas
                .datePickerStyle(.graphical)
            
            Button(action: {
                Task {
                    if isRescheduleView {
                        await rescheduleAppointment()
                    } else {
                        await scheduleAppointment()
                    }
                }
            }, label: {
                ButtonView(text: isRescheduleView ? "Reagendar Consulta" : "Agendar Consulta")
            })
        }
        .padding()
        .navigationTitle(isRescheduleView ? "Reagendar Consulta" : "Agendar Consulta")
        .onAppear{
            UIDatePicker.appearance().minuteInterval = 15
        }
        .alert(isAppointmentScheduled ? "Sucesso!" : "Ops, algo deu errado!", isPresented: $showAlert, presenting: isAppointmentScheduled) { _ in
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Ok")
            })
        } message: { isScheduled in
            if isScheduled {
                Text ("A consulta foi \(isRescheduleView ? "reagendada" : "agendada") com sucesso!")
            } else {
                Text ("Houve um erro ao \(isRescheduleView ? "reagendar" : "agendar") sua consulta. Por favor tente novamente ou entre em contato via telefone.")
            }
        }
        
    }
}

#Preview {
    ScheduleAppointmentView(specialistID: "123")
}
