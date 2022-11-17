import MallocTrace

@main
public struct Main {
    public private(set) var text = "Hello, World!"

    public static func main() {
        MallocTrace.installHook { event in
            print(event)
        }
        print(Main().text)
    }
}
