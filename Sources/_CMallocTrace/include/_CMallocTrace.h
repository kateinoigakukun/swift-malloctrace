#ifndef _CMALLOCTRACE_H
#define _CMALLOCTRACE_H

#include <stdlib.h>

extern void *dlmalloc(size_t size);
extern void dlfree(void *ptr);
extern void *dlcalloc(size_t nmemb, size_t size);
extern void *dlrealloc(void *ptr, size_t size);
extern int dlposix_memalign(void **memptr, size_t alignment, size_t size);
extern void* dlmemalign(size_t alignment, size_t bytes);
extern size_t dlmalloc_usable_size(void *ptr);

#endif
