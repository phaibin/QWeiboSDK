

#define _NIF_LOG(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
 
#ifdef DEBUG
	#define NIF_TRACE(fmt, ...) _NIF_LOG(@"- %s [LINE:%d] " fmt,__FUNCTION__,__LINE__, ##__VA_ARGS__)
#else
	#define NIF_TRACE(fmt, ...)
#endif

#define NIF_INFO(fmt, ...)  _NIF_LOG(@"- %s [LINE:%d] " fmt,__FUNCTION__,__LINE__, ##__VA_ARGS__)
