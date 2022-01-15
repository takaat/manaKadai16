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
    @State private var newName = ""
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
            AddOrEditItemView(isShowView: $isShowAddItemView, name: $newName) { (item, _) in
                items.append(item)
            }
        }
        .fullScreenCover(isPresented: $isShowEditItemView) {
            AddOrEditItemView(isShowView: $isShowEditItemView, name: $editName) { (_, name) in
                guard let targetIndex = items.firstIndex(where: { $0.id == editId }) else {
                    return
                }
                items[targetIndex].name = name
            }
        }
    }
}
// MARK: - newNameとeditNameに分けて処理するやり方とBinding<String>に空文字を代入する方法が思いつかない。
struct AddOrEditItemView: View {
    @Binding var isShowView: Bool
    @Binding var name: String
//    @State private var addName = ""
    let didSave: (Item, String) -> Void

//    init(isShowView: Binding<Bool>, didSave: (Item, String) -> Void) {
//        // add
//        _isShowView = isShowView
//        _name = Binding(String)
//        self.didSave = {(item, _) in  }
//    }
//
//    init(isShowView: Binding<Bool>, name: Binding<String>, didSave: (Item, String) -> Void) {
//        // edit
//        _isShowView = isShowView
//        _name = name
//        self.didSave = {(_, name) in }
//    }

//    init(isShowView: Binding<Bool>, name: Binding<String>) {
//        _isShowView = isShowView
//        _name = name
////        self.didSave = {(item, name) in }
//    }

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
                        didSave(.init(name: name, isChecked: false), name)
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

//struct AddOrEditItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddOrEditItemView(isShowView: .constant(true), didSave: {(_, _) in })
//    }
//}

//struct EditItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditItemView(isShowView: .constant(true), name: .constant("パイナップル"), didSave: { _ in })
//    }
//}
//
//struct AddItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemView(isShowView: .constant(true), didSave: { _ in  })
//    }
//}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: .constant(.init(name: "みかん", isChecked: true)))
    }
}
