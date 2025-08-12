#pragma once

#if defined(__PS3__)
#include <sstream>
#include <string>

// This helper function is needed because std::to_string is not available on the PS3 toolchain.
// It is marked 'inline' to be safely included in multiple source files.
template <typename T>
inline std::string to_string_ps3(T value)
{
    std::stringstream ss;
    ss << value;
    return ss.str();
}

#endif // defined(__PS3__)