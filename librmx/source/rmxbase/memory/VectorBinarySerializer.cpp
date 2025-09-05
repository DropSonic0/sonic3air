/*
*	rmx Library
*	Copyright (C) 2008-2024 by Eukaryot
*
*	Published under the GNU GPLv3 open source software license, see license.txt
*	or https://www.gnu.org/licenses/gpl-3.0.en.html
*/

#include "rmxbase.h"

// Endianness detection
#if (defined(__powerpc__) || defined(__ppc__)) && (defined(__GNUC__) || defined(__xlC__))
    #define RMX_BIG_ENDIAN 1
#else
    #define RMX_LITTLE_ENDIAN 1
#endif

namespace
{
	// Helper for byte swapping
	#ifdef RMX_BIG_ENDIAN
		uint16_t swap_uint16( uint16_t val ) 
		{
    		return (val << 8) | (val >> 8 );
		}

		int16_t swap_int16( int16_t val ) 
		{
    		return (val << 8) | ((val >> 8) & 0xFF);
		}

		uint32_t swap_uint32( uint32_t val )
		{
    		return __builtin_bswap32(val);
		}

		int32_t swap_int32( int32_t val )
		{
    		return __builtin_bswap32(val);
		}

		uint64_t swap_uint64( uint64_t val )
		{
    		return __builtin_bswap64(val);
		}

		int64_t swap_int64( int64_t val )
		{
    		return __builtin_bswap64(val);
		}
	#endif

	template<typename T>
	FORCE_INLINE bool serializePrimitiveDataType(T& value, bool reading, std::vector<uint8>& buffer, size_t& readPosition)
	{
		if (reading)
		{
			if (readPosition + sizeof(T) > buffer.size())
				return false;
			
			memcpy(&value, &buffer[readPosition], sizeof(T));
			readPosition += sizeof(T);
		}
		else
		{
			const size_t oldSize = buffer.size();
			buffer.resize(oldSize + sizeof(T));
			memcpy(&buffer[oldSize], &value, sizeof(T));
		}
		return true;
	}

	template<>
	FORCE_INLINE bool serializePrimitiveDataType<bool>(bool& value, bool reading, std::vector<uint8>& buffer, size_t& readPosition)
	{
		if (reading)
		{
			if (readPosition >= buffer.size())
				return false;
				
			value = buffer[readPosition] != 0;
			++readPosition;
		}
		else
		{
			const size_t oldSize = buffer.size();
			buffer.resize(oldSize + 1);
			buffer[oldSize] = value ? 1 : 0;
		}
		return true;
	}
}


VectorBinarySerializer::VectorBinarySerializer(bool read, std::vector<uint8>& buffer) :
	mReading(read),
	mBuffer(buffer)
{
}

VectorBinarySerializer::VectorBinarySerializer(bool read, const std::vector<uint8>& buffer) :
	mReading(read),
	mBuffer(const_cast<std::vector<uint8>&>(buffer))
{
}

void VectorBinarySerializer::read(void* pointer, size_t size)
{
	const uint8* source = readAccess(size);
	if (nullptr != source)
	{
		memcpy(pointer, source, size);
	}
}

void VectorBinarySerializer::write(const void* pointer, size_t size)
{
	memcpy(writeAccess(size), pointer, size);
}

void VectorBinarySerializer::serialize(void* pointer, size_t size)
{
	if (mReading)
	{
		read(pointer, size);
	}
	else
	{
		write(pointer, size);
	}
}

void VectorBinarySerializer::serialize(bool& value)
{
	mHasError = (mHasError || !serializePrimitiveDataType(value, mReading, mBuffer, mReadPosition));
}

void VectorBinarySerializer::serialize(uint8& value)
{
	mHasError = (mHasError || !serializePrimitiveDataType(value, mReading, mBuffer, mReadPosition));
}

void VectorBinarySerializer::serialize(int8& value)
{
	mHasError = (mHasError || !serializePrimitiveDataType(value, mReading, mBuffer, mReadPosition));
}

void VectorBinarySerializer::serialize(uint16& value)
{
	#ifdef RMX_BIG_ENDIAN
		if (!mReading) value = swap_uint16(value);
	#endif
	mHasError = (mHasError || !serializePrimitiveDataType(value, mReading, mBuffer, mReadPosition));
	#ifdef RMX_BIG_ENDIAN
		value = swap_uint16(value);
	#endif
}

void VectorBinarySerializer::serialize(int16& value)
{
	#ifdef RMX_BIG_ENDIAN
		if (!mReading) value = swap_int16(value);
	#endif
	mHasError = (mHasError || !serializePrimitiveDataType(value, mReading, mBuffer, mReadPosition));
	#ifdef RMX_BIG_ENDIAN
		value = swap_int16(value);
	#endif
}

void VectorBinarySerializer::serialize(uint32& value)
{
	#ifdef RMX_BIG_ENDIAN
		if (!mReading) value = swap_uint32(value);
	#endif
	mHasError = (mHasError || !serializePrimitiveDataType(value, mReading, mBuffer, mReadPosition));
	#ifdef RMX_BIG_ENDIAN
		value = swap_uint32(value);
	#endif
}

void VectorBinarySerializer::serialize(int32& value)
{
	#ifdef RMX_BIG_ENDIAN
		if (!mReading) value = swap_int32(value);
	#endif
	mHasError = (mHasError || !serializePrimitiveDataType(value, mReading, mBuffer, mReadPosition));
	#ifdef RMX_BIG_ENDIAN
		value = swap_int32(value);
	#endif
}

void VectorBinarySerializer::serialize(uint64& value)
{
	#ifdef RMX_BIG_ENDIAN
		if (!mReading) value = swap_uint64(value);
	#endif
	mHasError = (mHasError || !serializePrimitiveDataType(value, mReading, mBuffer, mReadPosition));
	#ifdef RMX_BIG_ENDIAN
		value = swap_uint64(value);
	#endif
}

void VectorBinarySerializer::serialize(int64& value)
{
	#ifdef RMX_BIG_ENDIAN
		if (!mReading) value = swap_int64(value);
	#endif
	mHasError = (mHasError || !serializePrimitiveDataType(value, mReading, mBuffer, mReadPosition));
	#ifdef RMX_BIG_ENDIAN
		value = swap_int64(value);
	#endif
}

void VectorBinarySerializer::serialize(float& value)
{
	mHasError = (mHasError || !serializePrimitiveDataType(value, mReading, mBuffer, mReadPosition));
	#ifdef RMX_BIG_ENDIAN
		uint32_t as_int = swap_uint32(*(uint32_t*)&value);
		value = *(float*)&as_int;
	#endif
}

void VectorBinarySerializer::serialize(double& value)
{
	mHasError = (mHasError || !serializePrimitiveDataType(value, mReading, mBuffer, mReadPosition));
	#ifdef RMX_BIG_ENDIAN
		uint64_t as_int = swap_uint64(*(uint64_t*)&value);
		value = *(double*)&as_int;
	#endif
}

void VectorBinarySerializer::serialize(std::string& value, size_t stringLengthLimit)
{
	if (mReading)
	{
		const size_t length = readSize(stringLengthLimit);
		if (length == 0)
		{
			value.clear();
		}
		else
		{
			value.resize(length);
		}
	}
	else
	{
		writeSize(value.size(), stringLengthLimit);
	}

	if (!value.empty())
	{
		serialize(&value[0], value.length());
	}
}

void VectorBinarySerializer::serialize(std::wstring& value, size_t stringLengthLimit)
{
	if (mReading)
	{
		value.clear();
		const size_t length = readSize(stringLengthLimit);
		if (length > 0)
		{
			// Read UTF-8 encoded string
			const char* pointer = (const char*)readAccess(length);
			if (nullptr != pointer)
			{
				rmx::UTF8Conversion::convertFromUTF8(std::string_view(pointer, length), value);
			}
		}
	}
	else
	{
		write(std::wstring_view(value), stringLengthLimit);
	}
}

void VectorBinarySerializer::serialize(String& value)
{
	if (mReading)
	{
		value.expand((int)read<uint32>());
		read(value.accessData(), value.length());
	}
	else
	{
		writeAs<uint32>(value.length());
		if (!value.empty())
			write(value.accessData(), value.length());
	}
}

void VectorBinarySerializer::serialize(WString& value)
{
	if (mReading)
	{
		value.expand((int)read<uint32>());
		read(value.accessData(), value.length() * sizeof(wchar_t));			// TODO: This is not compatible among different platforms! Use UTF-8 encoding here as well
	}
	else
	{
		writeAs<uint32>(value.length());
		if (!value.empty())
			write(value.accessData(), value.length() * sizeof(wchar_t));	// TODO: This is not compatible among different platforms! Use UTF-8 encoding here as well
	}
}

void VectorBinarySerializer::serializeData(std::vector<uint8>& data, size_t bytesLimit)
{
	if (isReading())
	{
		const size_t numBytes = readSize(bytesLimit);
		if (numBytes == 0)
		{
			data.clear();
		}
		else
		{
			data.resize(numBytes);
			serialize(&data[0], data.size());
		}
	}
	else
	{
		writeSize(data.size(), bytesLimit);
		if (!data.empty())
		{
			serialize(&data[0], data.size());
		}
	}
}

size_t VectorBinarySerializer::readSize(size_t limit)
{
	const size_t size = (limit <= 0xff) ? static_cast<size_t>(read<uint8>()) : (limit <= 0xffff) ? static_cast<size_t>(read<uint16>()) : read<uint32>();
	if (size > limit)
	{
		mHasError = true;
		return 0;
	}
	return size;
}

void VectorBinarySerializer::writeSize(size_t value, size_t limit)
{
	if (limit <= 0xff)
	{
		writeAs<uint8>(value);
	}
	else if (limit <= 0xffff)
	{
		writeAs<uint16>(value);
	}
	else
	{
		writeAs<uint32>(value);
	}
}

std::string_view VectorBinarySerializer::readStringView(size_t stringLengthLimit)
{
	const size_t length = readSize(stringLengthLimit);
	if (length == 0)
	{
		return std::string_view();
	}

	const char* ptr = (const char*)readAccess(length);
	return (nullptr != ptr) ? std::string_view(ptr, length) : std::string_view();
}

void VectorBinarySerializer::write(std::string_view value, size_t stringLengthLimit)
{
	writeSize(value.length(), stringLengthLimit);
	if (!value.empty())
	{
		write(&value[0], value.length());
	}
}

void VectorBinarySerializer::write(std::wstring_view value, size_t stringLengthLimit)
{
	if (value.empty())
	{
		writeSize(value.length(), stringLengthLimit);
	}
	else
	{
		// Write as UTF-8 string
		const size_t encodedLength = rmx::UTF8Conversion::getLengthAsUTF8(value);
		writeSize(encodedLength, stringLengthLimit);

		char* pointer = (char*)writeAccess(encodedLength);
		for (wchar_t ch : value)
		{
			const size_t encodedLength = rmx::UTF8Conversion::writeCharacterAsUTF8((uint32)ch, pointer);
			pointer += encodedLength;
		}
	}
}

void VectorBinarySerializer::skip(size_t bytes)
{
	if (mReading)
	{
		mReadPosition += bytes;
	}
}

const uint8* VectorBinarySerializer::peek() const
{
	if (mReading)
	{
		return &mBuffer[mReadPosition];
	}
	else
	{
		return nullptr;
	}
}

const uint8* VectorBinarySerializer::readAccess(size_t size)
{
	// Don't read more data than there is
	if (mReadPosition + size > mBuffer.size())
	{
		mHasError = true;
		mReadPosition = mBuffer.size();
		return nullptr;
	}

	const uint8* result = &mBuffer[mReadPosition];
	mReadPosition += size;
	return result;
}

uint8* VectorBinarySerializer::writeAccess(size_t size)
{
	const size_t oldSize = mBuffer.size();
	mBuffer.resize(oldSize + size);
	return &mBuffer[oldSize];
}
