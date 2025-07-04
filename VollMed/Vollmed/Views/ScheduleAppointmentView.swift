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
    
    @State private var selectedDate = Date()
    @State private var showAlert = false
    @State private var isAppointmentSchedule = false
    
    /*func scheduleAppointment() async {
        do {
            if let _ = try await service.scheduleAppointment(specialistID: specialistID, patientID: patientID, date: selectedDate.convertToString()) {
                isAppointmentSchedule = true
            } else {
                isAppointmentSchedule = false
            }
        } catch {
            isAppointmentSchedule = false
            print ("Ocorreu em erro ao agendar consulta: \(error)")
        }
        showAlert = true
    }*/
    func scheduleAppointment() async {
        do {
            if let appointment = try await  service.scheduleAppointment(specialistID: specialistID, patientID: patientID, date: selectedDate.convertToString()) {
                print(appointment)
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
                    await scheduleAppointment()
                }
            }, label: {
                ButtonView(text: "Agendar Consulta")
            })
        }
        .padding()
        .navigationTitle("Agendar consulta")
        .onAppear{
            UIDatePicker.appearance().minuteInterval = 15
        }
        .alert(isAppointmentSchedule ? "Sucesso!" : "Ops, algo deu errado!", isPresented: $showAlert, presenting: isAppointmentSchedule) { _ in
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Ok")
            })
        } message: { isScheduled in
            if isScheduled {
                Text ("A consulta foi agendada com sucesso!")
            } else {
                Text ("Houve um erro ao agendar sua consulta. Por favor tente novamente ou entre em contato via telefone.")
            }
        }

    }
}

#Preview {
    ScheduleAppointmentView(specialistID: "123")
}
