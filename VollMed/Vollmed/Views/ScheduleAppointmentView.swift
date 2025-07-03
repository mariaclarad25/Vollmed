//
//  ScheduleAppointmentView.swift
//  Vollmed
//
//  Created by Maria Clara Dias on 02/07/25.
//

import SwiftUI

struct ScheduleAppointmentView: View {
    
    @State private var selectedDate = Date()
    
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
                print(selectedDate.convertToString().convertDateStringToReadebleDate())
            }, label: {
                ButtonView(text: "Agendar Consulta")
            })
        }
        .padding()
        .navigationTitle("Agendar consulta")
        .onAppear{
            UIDatePicker.appearance().minuteInterval = 15
        }
    }
}

#Preview {
    ScheduleAppointmentView()
}
