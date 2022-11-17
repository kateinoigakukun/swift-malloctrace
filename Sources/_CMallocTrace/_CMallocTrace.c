// Taken from https://github.com/WebAssembly/wasi-libc/blob/main/dlmalloc/src/dlmalloc.c

#include <stddef.h>
#include <malloc.h>

// Define configuration macros for dlmalloc.

// WebAssembly doesn't have mmap-style memory allocation.
#define HAVE_MMAP 0

// WebAssembly doesn't support shrinking linear memory.
#define MORECORE_CANNOT_TRIM 1

// Disable sanity checks to reduce code size.
#define ABORT __builtin_unreachable()

// If threads are enabled, enable support for threads.
#ifdef _REENTRANT
#define USE_LOCKS 1
#endif

// Make malloc deterministic.
#define LACKS_TIME_H 1

// Disable malloc statistics generation to reduce code size.
#define NO_MALLINFO 1
#define NO_MALLOC_STATS 1

// Align malloc regions to 16, to avoid unaligned SIMD accesses.
#define MALLOC_ALIGNMENT 16

// Declare errno values used by dlmalloc. We define them like this to avoid
// putting specific errno values in the ABI.
extern const int __ENOMEM;
#define ENOMEM __ENOMEM
extern const int __EINVAL;
#define EINVAL __EINVAL

// Define USE_DL_PREFIX so that we leave dlmalloc's names prefixed with 'dl'.
// We define them as "static", and we wrap them with public names below. This
// serves two purposes:
//
// One is to make it easy to control which symbols are exported; dlmalloc
// defines several non-standard functions and we wish to explicitly control
// which functions are part of our public-facing interface.
//
// The other is to protect against compilers optimizing based on the assumption
// that they know what functions with names like "malloc" do. Code in the
// implementation will call functions like "dlmalloc" and assume it can use
// the resulting pointers to access the metadata outside of the nominally
// allocated objects. However, if the function were named "malloc", compilers
// might see code like that and assume it has undefined behavior and can be
// optimized away. By using "dlmalloc" in the implementation, we don't need
// -fno-builtin to avoid this problem.
#define USE_DL_PREFIX 1

// Include the upstream dlmalloc's malloc.c.
#include "dlmalloc.c"
