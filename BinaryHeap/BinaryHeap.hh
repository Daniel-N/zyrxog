//          Copyright Daniel Nielsen 1998 - 2015.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

#ifndef BINARY_HEAP_HH
#define BINARY_HEAP_HH

#include <limits>
#include <vector>
#include <cstdint>
#include <cassert>
#include <type_traits>

// Use 'std::numeric_limits<T>::min()' fallback on 'T::min'.
template<typename T, bool = std::numeric_limits<T>::is_specialized>
struct MinValue;

// Use 'std::numeric_limits<T>::max()' fallback on 'T::max'.
template<typename T, bool = std::numeric_limits<T>::is_specialized>
struct MaxValue;

template<typename T>
class BinaryHeap
{
private:
  std::vector<T> data;
  uint32_t       size = 0;
  const T        tmax = MaxValue<T>();
public:
  explicit BinaryHeap(uint32_t capacity) : data(capacity)
  {
    assert(capacity > 0);

    data[0] = MinValue<T>(); // Use 'MinValue' as a sentinel
  }

  template
  <
    typename U,
    typename = std::enable_if_t
    <
      std::is_same<std::decay_t<U>, std::decay_t<T>>::value
    >
  >
  void Put(U&& val) noexcept
  (
    std::is_nothrow_assignable<T, U>() && std::is_nothrow_assignable<T, T&&>()
  )
  {
    uint32_t gap = ++size;

    if(gap == data.size())
      data.resize(2 * data.size()); // may invoke std::terminate

    // Percolate Up
    for(; val < data[gap / 2]; gap /= 2)
      data[gap] = std::move(data[gap / 2]);

    // Forward universal reference
    data[gap] = std::forward<U>(val);
  }

  T Get() noexcept
  (
    std::is_nothrow_assignable<T, T&&>() && std::is_nothrow_constructible<T, T&&>()
  )
  {
    assert(!Empty());

    T val = std::move(data[1]);
    data[1] = std::move(data[size]);
    data[size--] = tmax; // Use 'MaxValue' as a sentinel

    PercolateDown(1);

    return val;
  }

  uint32_t Size() const noexcept
  {
    return size;
  }

  bool Empty() const noexcept
  {
    return size == 0;
  }

private:
  // PercolateDown(Floyd)
  void PercolateDown(uint32_t gap) noexcept
  (
    std::is_nothrow_assignable<T, T&&>() && std::is_nothrow_constructible<T, T&&>()
  )
  {
    T val = std::move(data[gap]);

    // Percolate Down
    for(uint32_t child; gap * 2 <= size; gap = child)
    {
      child = gap * 2;

      // Safe because data[size + 1] contains 'MaxValue'
      if(data[child + 1] < data[child])
        ++child;

      data[gap] = std::move(data[child]);
    }

    // Percolate Up
    for(; val < data[gap / 2]; gap /= 2)
      data[gap] = std::move(data[gap / 2]);

    data[gap] = std::move(val);
  }
};

template<typename T>
struct MinValue<T, true>
{
  constexpr operator const T() const noexcept { return std::numeric_limits<T>::min(); }
};

template<typename T>
struct MinValue<T, false>
{
  constexpr operator const T() const noexcept { return T::min; }
};

template<typename T>
struct MaxValue<T, true>
{
  constexpr operator const T() const noexcept { return std::numeric_limits<T>::max(); }
};

template<typename T>
struct MaxValue<T, false>
{
  constexpr operator const T() const noexcept { return T::max; }
};

#endif // #ifndef BINARY_HEAP_HH
