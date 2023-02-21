include_guard()

set(common_options
	-fdiagnostics-color=always
	-fno-builtin
	-fno-strict-aliasing
	-fomit-frame-pointer
	-fno-short-enums
)
add_compile_options(
	${common_options}

	-ffunction-sections
	-fdata-sections
	-fmerge-all-constants
	-fno-common

	-Wall
	-Wextra
	-Wno-unused-parameter
	-Wno-error=unused-variable

	# Failed to compile on g++ (Raspbian 8.3.0-6+rpi1) 8.3.0 otherwise.
	-Wno-error=type-limits
)

add_link_options(
	-Wl,--gc-sections
	${common_options}
)
