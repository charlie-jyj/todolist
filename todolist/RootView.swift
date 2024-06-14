//
//  RootView.swift
//  todolist
//
//  Created by 정유진 on 6/10/24.
//

import SwiftUI
import Combine

struct todoItem: Equatable {
    let id = UUID()
    let title: String
    let content: String
    let date: Date
    
    init(title: String, content: String, date: Date) {
        self.title = title
        self.content = content
        self.date = date
//        print("id: \(id) for : \(title)")
    }
}

struct todoList: Equatable {
    let id = UUID()
    let value: [todoItem]
}

class TodoManager: ObservableObject {
    static let shared = TodoManager()
//    @Published var toDoList: [todoItem] = [
//        todoItem(title: "sample", content: "sample content", date: Date())
//    ]
//    @Published var toDoList: [todoItem] = [
//        todoItem(title: "Sample1", content: "First Content", date: Date()),
//        todoItem(title: "Sample2", content: "Second Content", date: Date()),
//        todoItem(title: "Sample3", content: "Third Content", date: Date())
//    ]
    @Published var toDoList: [todoItem] = []
    @Published var sampleText: String = ""
}


struct RootView: View {
    
    let sampleData1: [todoItem]
    let sampleData2: [todoItem]
//    let sampleData1: [todoItem] = [
//        todoItem(title: "First", content: "First Content", date: Date()),
//        todoItem(title: "Second", content: "Second Content", date: Date()),
//        todoItem(title: "Third", content: "Third Content", date: Date())
//    ]
//    
//    let sampleData2: [todoItem] = [
//        todoItem(title: "Fourth", content: "Fourth Content", date: Date()),
//        todoItem(title: "Fifth", content: "Fifth Content", date: Date()),
//        todoItem(title: "Sixth", content: "Sixth Content", date: Date())
//    ]
  
    @State var todos: [todoItem]
//    @State var todos: [todoItem] = [
//        todoItem(title: "First", content: "First Content", date: Date()),
//        todoItem(title: "Second", content: "Second Content", date: Date()),
//        todoItem(title: "Third", content: "Third Content", date: Date())
//    ]
    
    init() {
        print("init() called")
        self.sampleData1 = [
            todoItem(title: "First", content: "First Content", date: Date()),
            todoItem(title: "Second", content: "Second Content", date: Date()),
            todoItem(title: "Third", content: "Third Content", date: Date())
        ]
        
        self.sampleData2 =  [
            todoItem(title: "Fourth", content: "Fourth Content", date: Date()),
            todoItem(title: "Fifth", content: "Fifth Content", date: Date()),
            todoItem(title: "Sixth", content: "Sixth Content", date: Date())
        ]
        
//        self.todos = self.sampleData1 // init button 클릭 시 onChange를 trigger 하지 않음
        self.todos = [] // init button 클릭 시 onChange를 trigger 함
    }
    
//    @State var todos: [todoItem] = []
//    @State var todos: todoList = todoList(value: [])
    
    /*
     가설 1> @State로 선언된 todoList는 값이 변경될 때마다 TodoListView가 다시 그려진다.
     결과 > 최초 init을 []로 하고 initialize button을 클릭하여 onChange가 trigger 되었지만 TodoListView가 다시 그려지지 않았다.
     왜? > [todoItem] 의 address를 찍어보니 변경되지 않았다. 즉, 값이 변경되었지만 메모리 주소가 변경되지 않아서 뷰가 다시 그려지지 않았다. -> 추측
     수정 > 최초 init을 [sampleData1] 로 넣은 후에 다시 시도해보았다.
     결과 > initialize button은 onchnage를 trigger 하지 않는다. change data button은 onchange를 trigger하고 todolist가 다시 그려졌지만 주소가 바뀌지는 않았다. ..? -> 주소가 바뀌는 것이 중요한 것은 아니구나.
     
     [] -> 3 일 때 onChange가 trigger 되었지만 왜 리스트가 새로 그려지지는 않을까?
     
     가설 1-2> array는 이래도 String은 다를 것이다.
     결과 > string은 값이 바뀌면 항상 다시 그려진다.
     
     
     
     가설 2> todoList를 struct로 만든다. @State로 선언된 todoList는 값이 변경될 때마다 TodoListView가 다시 그려진다.
     결과 > 최초 init을 []로 하고 initialize button을 클릭하여 onChange가 trigger 되었지만 TodoListView가 다시 그려지지 않았다.
     
     [채택]
     가설 3> TodoListView에 id를 modifer로 추가하고, struct가 변경될 때 뷰가 다시 그려지는 지 확인한다.
     결과 > id를 추가하고 item이 바뀔 때 id가 변경되는 것을 확인했다. id modifier를 달자 TodoListView가 다시 그려졌다.
     
     다시 가설 1번으로 돌아가서 메모리 address를 확인해본다.
     
     가설 4> id를 주지 않더라도 처음에 [] 가 아니라 다른 값으로 초기화를 한 상태에서 다시 그리면 될 것 같다.
     결과 > 초기화 값이 문제가 아니라 indice인게 문제인 것 같다..?
     
     모든 가설을 뒤엎고.. indice로 리스트를 그린 것에 문제를 제기한다.
     가설 5> list의 length가 변화한 것을 if flag로 넣으면 다시 그려질 것이다. if range.count > 0
     결과 > 최초 0 -> 3 일 때도 바로 그려졌다.
     
     가설 6> 최초 3 -> 3 이면 다시 그려지지 않을 것이다.
     결과 > 그려진다.
     
     가설 7> 자식 뷰에 넘긴다면 다를 지도? (예전의 장애를 재현하기 위해)
     
     가설 8 > 이전 프로젝트에서 뷰가 갱신되지 않은 이유는 menuList는 @State 이지만 menuItem을 넘길 때 @Binding이 아니었기 때문이다.
     -> 재현해보도록 하자. todoItemView를 만들고 item을 todos[i] 로 넘긴다.
     결과 > 재현에 성공했다 detail item으로 바뀌지 않음.
     해결 방안 > @Binding으로 넘긴다
     
     의문 > 이전 프로젝트에서 3 -> 0 -> 3 이렇게 했을 때에는 제대로 그려진 이유가 뭐지? @State로 넘기면 다시 안 그려져야 할거 같은데
     -> List로 감싸지 않으면 다시 그려진다. 이전 프로젝트는 리스트를 쓰지 않고 내가 손수 그림..
     3 -> 0 되면서 if count > 0 에 의해 뷰가 지워지고 0 -> 3 되면서 뷰가 다시 그려지기 때문에 갱신됩니다.
     하지만 3 -> 3 에서는 다시 그려지지 않습니다..
     
     -> 그러나 List로 감싸면.. 다시 그려지지 않는다! 이런..
     -> List를 if 문으로 감싸면.. 난 될 것이라고 생각한다.
     하지만 역시 3 -> 3 에서는 다시 그려지지 않는다. 그렸던 것을 다시 그린다.
     if count > 0 조건이 달라지지 않았기 때문에 다시 그리지 않는 것
     
     결론 > 
     1. List를 쓰든, 내가 손수 그리든 @Binding으로 넘겨주면 변경 사항이 잘 반영된다.
     2. Binding으로 안 넘길거면 If 조건문을 잘 사용해서 true -> false || false -> true일 때 업데이트 되는 것을 이용한다.
     3. View에 id를 주어서 data인 list의 id가 변경되면 다시 그려지도록 유도한다.
     
     */
    
//    @ObservedObject var todoManager = TodoManager.shared
//    @StateObject var todoManager = TodoManager.shared
    
    @State var sampleText: String = ""
    
    var body: some View {

        VStack {
            HStack {
                NavigationLink(destination: TodoListView(todos: $todos)) {
                    Text("go todolist")
                }
                .padding()
            }
            
//                Spacer()
            
            HStack {
                Button(action: {
                    //                    todoManager.toDoList = []
                    TodoManager.shared.toDoList = []
                    //                    todoManager.sampleText = "empty button tapped"
                    TodoManager.shared.sampleText = "empty button tapped"
                }) {
                    Text("empty")
                        .padding()
                        .border(.black)
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    //                    self.todos = todoList(value: sampleData1)
                    //                    self.todos = sampleData1
                    
                    TodoManager.shared.toDoList = sampleData1
                    //                    todoManager.toDoList = sampleData1
                    
                    //                    sampleText = "initialize button tapped"
                    //                    todoManager.sampleText = "initialize button tapped"
                    TodoManager.shared.sampleText = "initialize button tapped"
                    
                    //                    for todo in self.todos {
                    //                        print("initialize button tapped: item \(todo.id) from: \(todo.title)")
                    //                    }
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    //                        todoManager.toDoList = sampleData2
                    //                    }
                    
                }) {
                    Text("initialize")
                        .padding()
                        .border(.black)
                    
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    //                    self.todos = todoList(value: sampleData2)
                    //                    self.todos = sampleData2
                    //                    todoManager.toDoList = sampleData2
                    TodoManager.shared.toDoList = sampleData2
                    TodoManager.shared.sampleText = "change button tapped"
                }) {
                    Text("change")
                        .padding()
                        .border(.black)
                }
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                
                //                Text(sampleText)
                //                    .padding()
                Text(sampleText)
                    .padding()
                    .onReceive(TodoManager.shared.$sampleText, perform: { text in
                        sampleText = text
                    })
                
                
                //                TodoListView(todos: $todos)
                //                    .onReceive(todoManager.$toDoList, perform: { todos in
                //                        self.todos = todos
                //                        print("received todos: \(todos.count) from: \(todos.first?.title)")
                //                    })
                //                    .id(todos.id)
                
                //                ForEach(todos.indices) { i in
                //                    VStack {
                //                        HStack {
                //                            Text(todos[i].title)
                //                            Spacer()
                //                        }
                //
                //                        HStack {
                //                            Text(todos[i].content)
                //                            Spacer()
                //                            Text(todos[i].date, style: .date)
                //                        }
                //
                //                    }
                //                }
                
                //                List {
                //                    ForEach(todoManager.toDoList) { item in
                //                        VStack {
                //                            HStack {
                //                                Text(item.title)
                //                                Spacer()
                //                            }
                //
                //                            HStack {
                //                                Text(item.content)
                //                                Spacer()
                //                                Text(item.date, style: .date)
                //                            }
                //
                //                        }
                //                    }
                //                    .onReceive(todoManager.$toDoList, perform: { todos in
                //                        print("received todos: \(todos.count) from: \(todos.first?.title)")
                //                    })
                //                    .onChange(of: todoManager.toDoList) { oldValue, newValue in
                //                        print("todoManager toDoList changed \(oldValue.count) -> \(newValue.count)")
                //                    }
                //                }
                
                //                List {
                //                    let range = TodoManager.shared.toDoList.indices
                //                    if range.count > 0 {
                //                        ForEach(range) { i in
                //                            VStack {
                //                                HStack {
                //                                    Text(todoManager.toDoList[i].title)
                //                                    Spacer()
                //                                }
                //
                //                                HStack {
                //                                    Text(todoManager.toDoList[i].content)
                //                                    Spacer()
                //                                    Text(todoManager.toDoList[i].date, style: .date)
                //                                }
                //
                //                            }
                //                        }
                //                        .onChange(of: range) { oldValue, newValue in
                //                            print("range changed \(oldValue.count) -> \(newValue.count)")
                //                        }
                //                    }
                //                }
                
//                    TodoListView(todos: $todos)
                  
                
            } // vstack end
        }
        .frame(maxWidth: .infinity)
        .onChange(of: todos) { newValue in
            //            print("todoList changed: \(oldValue.value.count) from: \(oldValue.id) -> \(newValue.value.count) from: \(newValue.id)")
            print("todoList changed:  -> \(newValue.count)")
        }
        .onAppear {
            self.todos = TodoManager.shared.toDoList
        }
        .onReceive(TodoManager.shared.$toDoList, perform: { todos in
            self.todos = todos
            print("received todos: \(todos.count) from: \(todos.first?.title)")
        })
        
    }
    
    func fetchPointer(to: [todoItem]) {
        let result = withUnsafePointer(to: to) { pointer in
            return pointer
        }

        print("result: \(result) from todolist: \(to.first?.title)")
    }
}

struct TodoListView: View {
    
    @Binding var todos: [todoItem]
//    @Binding var todos: todoList
    @State var toggleDetailView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    NavigationLink(destination: DetailView()) {
                        Text("go detail view")
                    }
                    .padding(.trailing)
//                    Button(action: { toggleDetailView.toggle()}) {
//                        Text("go detail view")
//                    }
                }
                
                // if 문이 true <-> false 여야 view가 update된다. true -> true는 의미 없음
//                if todos.count > 0 {
//                    List {
//                            ForEach(todos.value.indices) { i in
               
                        ForEach(todos.indices) { i in
                            let todo = todos[i]
//                            TodoItemView(todo: $todos[i])
                            TodoItemView(todos: $todos,
                                         todo: todo)
                        }
                    
//                    } // end of list
//                } // end of if
            }
            .onAppear {
                print("TodoListView appeared")
            }
            
//            if toggleDetailView {
//                ZStack {
//                    Color.yellow
//                    DetailView(backToList: $toggleDetailView)
//                }
//                .ignoresSafeArea()
//            }
        }
    }
    
}

struct TodoItemView: View {
    @Binding var todos: [todoItem] // 내려받은 item으로 갱신됨
    @State var todo: todoItem // 옛날 item을 물고있음
//    @Binding var todo: todoItem // 이렇게 하면 됨
    var body: some View {
        VStack {
            HStack {
                Text(todo.title)
                Spacer()
            }
            
            TodoContentView(todos: $todos,
                            todo: todo)
        }
    }
}

struct TodoContentView: View {
    @Binding var todos: [todoItem]
    @State var todo: todoItem
    
    var body: some View {
        HStack {
            Text(todo.content)
            Spacer()
            Text(todo.date, style: .date)
        }
    }
}

struct DetailView: View {
//    @Binding var backToList: Bool
    var body: some View {
            VStack {
                Button(action: {
//                    backToList.toggle()
                }) {
                    Text("Back to List")
                }
                HStack {
                    Button(action: {
                        //                    todoManager.toDoList = []
                        TodoManager.shared.toDoList = []
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                            TodoManager.shared.toDoList = [
//                                todoItem(title: "AfterEmpty1", content: "Detail1 Content", date: Date()),
//                                todoItem(title: "AfterEmpty2", content: "Detail2 Content", date: Date()),
//                                todoItem(title: "AfterEmpty3", content: "Detail3 Content", date: Date())
//                            ]
//                        }
                        //                    todoManager.sampleText = "empty button tapped"
                    }) {
                        Text("empty")
                            .padding()
                            .border(.black)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        //                    self.todos = todoList(value: sampleData2)
                        //                    self.todos = sampleData2
                        TodoManager.shared.toDoList = [
                            todoItem(title: "Detail1", content: "Detail1 Content", date: Date()),
                            todoItem(title: "Detail2", content: "Detail2 Content", date: Date()),
                            todoItem(title: "Detail3", content: "Detail3 Content", date: Date())
                        ]
                    }) {
                        Text("change")
                            .padding()
                            .border(.black)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    
}

#Preview {
    RootView()
}
