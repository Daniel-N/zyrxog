﻿//          Copyright Daniel Nielsen 1998 - 2017.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

import std.traits;

struct BinaryHeap(T)
{
  import std.conv : emplace;

  static if(is(T == struct) && (hasElaborateCopyConstructor!T || hasElaborateDestructor!T))
    alias T_POD=POD!T;
  else
    alias T_POD=T;
private:
  T_POD[] data;
  T_POD   tmax;
  uint    size = 0;
public:
  this(uint capacity)
  {
    assert(capacity > 0);
    data = new T_POD[capacity];

    static assert(is(Unqual!(typeof(T.min)) == Unqual!T));
    static assert(is(Unqual!(typeof(T.max)) == Unqual!T));
    data[0] = cast(T_POD)T.min; // Use 'T.min' as a sentinel
    tmax    = cast(T_POD)T.max;
  }

  void Put(ref const(T) val) nothrow
  {
    uint gap = ++size;

    if(gap == data.length)
    {
      auto grow = data;
      grow.length *= 2u;
      data = grow;
    }

    // Percolate Up
    for(; val < data[gap / 2]; gap /= 2)
      data[gap] = data[gap / 2];

    // PostBlit
    emplace(cast(T*)&data[gap], val);
  }

  T Get() nothrow @nogc
  {
    assert(!Empty());

    auto val = cast(T)data[1]; // NRVO elides the destructor!
    data[1] = data[size];
    data[size--] = tmax; // Use 'T.max' as a sentinel

    PercolateDown(1);

    return val;
  }

  uint Size()  const nothrow pure @nogc @property { return size; }
  bool Empty() const nothrow pure @nogc @property { return size == 0; }

private:
  // PercolateDown(Floyd)
  void PercolateDown(uint gap) nothrow @nogc
  {
    T_POD val = data[gap];

    // Percolate Down
    for(uint child; gap * 2 <= size; gap = child)
    {
      child = gap * 2;

      // Safe because data[size + 1] contains 'MaxValue'
      if(data[child + 1] < data[child])
        ++child;

      data[gap] = data[child];
    }

    // Percolate Up
    for(; val < data[gap / 2]; gap /= 2)
      data[gap] = data[gap / 2];

    data[gap] = val;
  }
}

// POD avoids calling PostBlit and Destructor
union POD(T)
{
  private T payload;

  this(T) @disable;

  ref const(T) get() const nothrow pure @nogc @property
  {
    return payload;
  }

  alias get this;
}
