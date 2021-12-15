import Foundation

actor Counter {
    private(set) var count = 0
    
    @discardableResult
    func increment() -> Int {
        count += 1
        return count
    }
}

@MainActor
class ViewModel {
    private var x: Int = 0
    
    func incrementX() {
        x += 1
    }
}


print("Running counter...")


let counter = Counter()
Task {
    let vm = ViewModel()
    await vm.incrementX()
    
    print("Adding tasks...")
    async let group: Void = withTaskGroup(of: Int.self) { group in
        for _ in 1...50_000 {
            group.addTask {
                await counter.increment()
            }
        }
    }
    print("Waiting...")
    await group
    print("The count is: \(await counter.count)")
    exit(0)
}



RunLoop.main.run()
