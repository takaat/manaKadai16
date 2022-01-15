//
//  ContentView.swift
//  Kadai16
//
//  Created by mana on 2022/01/15.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    var name: String
    var isChecked: Bool
}

struct ContentView: View {
    @State private var isShowAddItemView = false
    @State private var isShowEditItemView = false
    @State private var editId = UUID()
    @State private var editName = ""
    @State private var items: [Item] = [.init(name: "りんご", isChecked: false),
                                        .init(name: "みかん", isChecked: true),
                                        .init(name: "バナナ", isChecked: false),
                                        .init(name: "パイナップル", isChecked: true)]

    var body: some View {
        NavigationView {
            List($items) { $item in
                HStack {
                    ItemView(item: $item)
                        .onTapGesture {
                            item.isChecked.toggle()
                    }
                    Spacer()
                    Label("", systemImage: "info.circle")
                        .onTapGesture {
                            editId = item.id
                            editName = item.name
                            isShowEditItemView = true
                        }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowAddItemView = true },
                           label: { Image(systemName: "plus") })
                }
            }
        }
        .fullScreenCover(isPresented: $isShowAddItemView) {
            AddItemView(isShowView: $isShowAddItemView) {
                items.append($0)
            }
        }
        .fullScreenCover(isPresented: $isShowEditItemView) {
            EditItemView(isShowView: $isShowEditItemView, name: $editName) { name in
                guard let targetIndex = items.firstIndex(where: { $0.id == editId }) else {
                    return
                }
                items[targetIndex].name = name
            }
        }
    }
}

struct EditItemView: View {
    @Binding var isShowView: Bool
    @Binding var name: String
    let didSave: (String) -> Void

    var body: some View {
        NavigationView {
            HStack(spacing: 30) {
                Text("名前")
                    .padding(.leading)

                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.trailing)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isShowView = false
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        didSave(name)
                        isShowView = false
                    }
                }
            }
        }
    }
}

struct AddItemView: View {
    @Binding var isShowView: Bool
    @State private var name = ""
    let didSave: (Item) -> Void

    var body: some View {
        NavigationView {
            HStack(spacing: 30) {
                Text("名前")
                    .padding(.leading)

                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.trailing)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isShowView = false
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        didSave(.init(name: name, isChecked: false))
                        isShowView = false
                    }
                }
            }
        }
    }
}

struct ItemView: View {
    @Binding var item: Item
    private let checkMark = Image(systemName: "checkmark")

    var body: some View {
        HStack {
            if item.isChecked {
                checkMark.foregroundColor(.orange)
            } else {
                checkMark.hidden()
            }

            Text(item.name)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(isShowView: .constant(true), name: .constant("パイナップル"), didSave: { _ in })
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(isShowView: .constant(true), didSave: { _ in  })
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: .constant(.init(name: "みかん", isChecked: true)))
    }
}
