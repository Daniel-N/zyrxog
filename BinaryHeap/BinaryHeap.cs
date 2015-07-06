//          Copyright Daniel Nielsen 1998 - 2015.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Runtime.CompilerServices;

public class BinaryHeap<T> where T : IComparable<T>
{
  private T[]  data;
  private uint size = 0;
  private T    tmax;

  public BinaryHeap(uint capacity)
  {
    Debug.Assert(capacity > 0);
    data = new T[capacity];

    var MinValueField = typeof(T).GetField("MinValue");
    if(MinValueField == null)
      throw new Exception("BinaryHeap<T>.MinValue");

    // Use 'MinValue' as a sentinel
    if(MinValueField.IsLiteral) // public const T MinValue
      data[0] = (T)MinValueField.GetRawConstantValue();
    else // public static readonly T MinValue
      data[0] = (T)MinValueField.GetValue(typeof(T));

    var MaxValueField = typeof(T).GetField("MaxValue");
    if(MaxValueField == null)
      throw new Exception("BinaryHeap<T>.MaxValue");

    if(MaxValueField.IsLiteral) // public const T MaxValue
      tmax = (T)MaxValueField.GetRawConstantValue();
    else // public static readonly T MaxValue
      tmax = (T)MaxValueField.GetValue(typeof(T));
  }

  [MethodImpl(MethodImplOptions.AggressiveInlining)]
  public void Put(T val)
  {
    uint gap = ++size;

    if(gap == data.Length)
      Array.Resize(ref data, (int)(2 * data.Length));

    // Percolate Up
    for(; val.CompareTo(data[gap / 2]) < 0; gap /= 2)
      data[gap] = data[gap / 2];

    data[gap] = val;
  }

  public T Get()
  {
    Debug.Assert(!Empty);

    T val = data[1];
    data[1] = data[size];
    data[size--] = tmax; // Use 'MaxValue' as a sentinel

    PercolateDown(1);

    return val;
  }

  public uint Size  { get { return size; } }
  public bool Empty { get { return size == 0; } }

  // PercolateDown(Floyd)
  private void PercolateDown(uint gap)
  {
    T val = data[gap];

    // Percolate Down
    for(uint child; gap * 2 <= size; gap = child)
    {
      child = gap * 2;

      // Safe because data[size + 1] contains 'MaxValue'
      if(data[child + 1].CompareTo(data[child]) < 0)
        ++child;

      data[gap] = data[child];
    }

    // Percolate Up
    for(; val.CompareTo(data[gap / 2]) < 0; gap /= 2)
      data[gap] = data[gap / 2];

    data[gap] = val;
  }
}
