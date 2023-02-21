include_guard()

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
	if(DEFINED PROJECT_IS_STANDALONE)
		message(FATAL_ERROR "It looks like CMake has PROJECT_IS_STANDALONE defined which is unexpected in this context")
	endif()
	set(PROJECT_IS_STANDALONE TRUE)
endif()

function(print_standalone)
	include(print_separator)
	message(STATUS "STANDALONE")
endfunction()
