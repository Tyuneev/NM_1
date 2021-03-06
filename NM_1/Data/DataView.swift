//
//  DataView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 10.07.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct DataView: View {
    let realmeManager = RealmManager()
    @State var matrix: [SavedMatrix] = []
    var body: some View {
        List {
            ForEach(self.matrix) { m in
                Section(header: Text(m.name)) {
                    UnchangeableMatrixView(matrix: m.matrix)
                }
            }
            .onDelete{
                realmeManager.deleteMatrix(atOffsets: $0)
                self.matrix.remove(atOffsets: $0)
            }
        }.listStyle(GroupedListStyle())
        .onAppear(){
            matrix = realmeManager.getMatrix()
        }
    }
}

struct DataForChoosView: View {
    let realmeManager = RealmManager()
    @EnvironmentObject var matrix: ObservableMatrix
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
       List {
        ForEach(self.realmeManager.getMatrix().reversed()) { item in
                Section(header: Text(item.name)) {
                    ChoosMatrixView(matrix: item.matrix)
                }.onTapGesture {
                    self.matrix.WarpedMatrix = item.matrix
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }.listStyle(GroupedListStyle())
    }
}

struct SaveMatrixView: View {
    let realmeManager = RealmManager()
    let matrix: Matrix
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var name = ""
    var body: some View {
        VStack{
            Text("Имя матрицы:").padding()
            TextField("Имя матрицы", text: $name).padding()
            Button(action: {
                self.realmeManager.addMatrix(matrix: self.matrix, withName: self.name)
                self.presentationMode.wrappedValue.dismiss()
            },
             label: { Text("Готово")}).padding()
        }
    }
}


struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView() //data: MatrixArr)
    }
}
