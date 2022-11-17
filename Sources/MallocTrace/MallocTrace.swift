import _CMallocTrace
public struct MallocTrace {
    public enum Event {
        case malloc(size: Int, pointer: UnsafeMutableRawPointer?)
        case free(pointer: UnsafeMutableRawPointer?)
        case calloc(count: Int, size: Int, pointer: UnsafeMutableRawPointer?)
        case realloc(size: Int, pointer: UnsafeMutableRawPointer?, newPointer: UnsafeMutableRawPointer?)
        case alignedAlloc(size: Int, alignment: Int, pointer: UnsafeMutableRawPointer?)
    }
    public typealias EventHandler = (Event) -> Void

    private static var handler: EventHandler?
    private static var isHandling: Bool = false

    public static func installHook(_ handler: @escaping EventHandler) {
        self.handler = handler
    }

    fileprivate static func handle(_ event: Event) {
        // Skip events triggered during handler
        guard !isHandling else { return }
        self.isHandling = true
        defer { self.isHandling = false }
        self.handler?(event)
    }
}

@_cdecl("malloc")
func tracingMalloc(size: size_t) -> UnsafeMutableRawPointer? {
    let ptr = dlmalloc(size)
    MallocTrace.handle(.malloc(size: size, pointer: ptr))
    return ptr
}

@_cdecl("free")
func tracingFree(ptr: UnsafeMutableRawPointer?) {
    dlfree(ptr)
    MallocTrace.handle(.free(pointer: ptr))
}


@_cdecl("calloc")
func tracingCalloc(nmemb: size_t, size: size_t) -> UnsafeMutableRawPointer? {
    let ptr = dlcalloc(nmemb, size)
    MallocTrace.handle(.calloc(count: nmemb, size: size, pointer: ptr))
    return ptr
}

@_cdecl("realloc")
func tracingRealloc(ptr: UnsafeMutableRawPointer?, size: size_t) -> UnsafeMutableRawPointer? {
    let newPtr = dlrealloc(ptr, size)
    MallocTrace.handle(.realloc(size: size, pointer: ptr, newPointer: newPtr))
    return newPtr
}

@_cdecl("posix_memalign")
func tracingPosixMemalign(memptr: UnsafeMutablePointer<UnsafeMutableRawPointer?>?, alignment: size_t , size: size_t) -> Int32 {
    return dlposix_memalign(memptr, alignment, size);
}

@_cdecl("aligned_alloc")
func tracingAlignedAlloc(alignment: size_t, bytes: size_t) -> UnsafeMutableRawPointer? {
    let ptr = dlmemalign(alignment, bytes);
    MallocTrace.handle(.alignedAlloc(size: bytes, alignment: alignment, pointer: ptr))
    return ptr
}

@_cdecl("malloc_usable_size")
func tracingMallocUsableSize(ptr: UnsafeMutableRawPointer?) -> size_t {
    return dlmalloc_usable_size(ptr);
}


// Define these to satisfy musl references.
@_cdecl("__libc_malloc")
func __libc_malloc(size: size_t) -> UnsafeMutableRawPointer? {
    tracingMalloc(size: size)
}

@_cdecl("__libc_free")
func __libc_free(ptr: UnsafeMutableRawPointer?) {
    tracingFree(ptr: ptr)
}

@_cdecl("__libc_calloc")
func __libc_calloc(nmemb: size_t, size: size_t) -> UnsafeMutableRawPointer? {
    tracingCalloc(nmemb: nmemb, size: size)
}
