cmake_minimum_required(VERSION 3.22)

project(halo_keyboard VERSION 1.0.0 LANGUAGES CXX)

include(GNUInstallDirs)
include(CTest)
find_package(PkgConfig REQUIRED)

pkg_check_modules(SYSTEMD QUIET systemd)
if(SYSTEMD_FOUND)
	pkg_get_variable(SYSTEMD_SYSTEM_UNIT_DIR systemd systemdsystemunitdir)
else()
	set(SYSTEMD_SYSTEM_UNIT_DIR "${CMAKE_INSTALL_PREFIX}/lib/systemd/system"
		CACHE PATH "systemd system unit directory")
endif()

pkg_check_modules(UDEV QUIET udev)
if(UDEV_FOUND)
	pkg_get_variable(UDEV_DIR udev udevdir)
else()
	set(UDEV_DIR "${CMAKE_INSTALL_PREFIX}/lib/udev"
		CACHE PATH "udev data directory")
endif()

add_executable(halo-keyboard-handler
	main.cc
	evdevsource.cc
	fakekeyboard.cc
	faketouchpad.cc
	uinputdevice.cc
	haptic/ff_driver.cc
	haptic/touch_ff_manager.cc
	statemachine/eventkey.cc
	statemachine/slot.cc
	statemachine/statemachine.cc
	logging.cc
)

target_include_directories(halo-keyboard-handler PRIVATE "${PROJECT_SOURCE_DIR}")
target_compile_features(halo-keyboard-handler PRIVATE cxx_std_17)
target_compile_options(halo-keyboard-handler PRIVATE
	-Wall
	-Wextra
	-Wpedantic
)

install(TARGETS halo-keyboard-handler DESTINATION "${CMAKE_INSTALL_SBINDIR}")
install(DIRECTORY layouts DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/halo-keyboard")
install(FILES hardware.csv touchpad.csv
	DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/halo-keyboard")
install(FILES 60-halo-keyboard.rules DESTINATION "${UDEV_DIR}/rules.d")
install(FILES 61-halo-keyboard.hwdb DESTINATION "${UDEV_DIR}/hwdb.d")
install(FILES halo-keyboard.service DESTINATION "${SYSTEMD_SYSTEM_UNIT_DIR}")
install(FILES docs/halo-keyboard-handler.8
	DESTINATION "${CMAKE_INSTALL_MANDIR}/man8")
install(FILES ATTRIBUTION.md README.md
	DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/doc/halo-keyboard")

if(BUILD_TESTING)
	add_test(
		NAME project-metadata
		COMMAND bash "${PROJECT_SOURCE_DIR}/tests/check-project.sh" "${PROJECT_SOURCE_DIR}"
	)
	add_test(
		NAME input-database
		COMMAND bash "${PROJECT_SOURCE_DIR}/tests/check-input-database.sh" "${PROJECT_SOURCE_DIR}"
	)
	add_test(
		NAME maintainer-scripts
		COMMAND bash "${PROJECT_SOURCE_DIR}/tests/check-maintainer-scripts.sh" "${PROJECT_SOURCE_DIR}"
	)
endif()
