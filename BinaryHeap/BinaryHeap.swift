//          Copyright Daniel Nielsen 1998 - 2015.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

public typealias int  = Int
public typealias uint = UInt
public typealias bool = Bool

public protocol MinMaxZero
{
  static var min:      Self { get }
  static var max:      Self { get }
  static var allZeros: Self { get }
}

public struct BinaryHeap<T where T : Comparable, T : MinMaxZero>
{
    private var data : [T]
    private var size : uint = 0
    private let tmax : T    = T.max

    public init(capacity : uint)
    {
      data = [T](count: int(capacity), repeatedValue: T.allZeros)
      data[0] = T.min // Use 'T.min' as a sentinel
    }

    public mutating func Put(val : T)
    {
      var gap = ++size

      if(gap == uint(data.count))
      {
        data.appendContentsOf(data)
      }

      // Percolate Up
      for(; val < data[gap / 2]; gap /= 2)
      {
        data[gap] = data[gap / 2]
      }

      data[gap] = val;
    }
    
    public mutating func Get() -> T
    {
      assert(!Empty)

      let val = data[1];
      data[1] = data[size];
      data[size--] = tmax; // Use 'T.max' as a sentinel

      PercolateDown(1);

      return val;
    }
    
    public var Size  : uint  { get { return size      } }
    public var Empty : bool  { get { return size == 0 } }

    // PercolateDown(Floyd)
    private mutating func PercolateDown(gap : uint)
    {
      var gap = gap
      let val = data[gap]

      // Percolate Down
      for(var child : uint; gap * 2 <= size; gap = child)
      {
        child = gap * 2

        // Safe because data[size + 1] contains 'MaxValue'
        if(data[child + 1] < data[child])
        {
          ++child
        }

        data[gap] = data[child]
      }

      // Percolate Up
      for(; val < data[gap / 2]; gap /= 2)
      {
        data[gap] = data[gap / 2]
      }

      data[gap] = val
    }
}

extension Int    : MinMaxZero {}
extension Int8   : MinMaxZero {}
extension Int16  : MinMaxZero {}
extension Int32  : MinMaxZero {}
extension Int64  : MinMaxZero {}
extension UInt   : MinMaxZero {}
extension UInt8  : MinMaxZero {}
extension UInt16 : MinMaxZero {}
extension UInt32 : MinMaxZero {}
extension UInt64 : MinMaxZero {}

private extension Array
{
  subscript (index: uint) -> Element 
  {
    get { return self[int(index)] }
    set { self[int(index)] = newValue }
  }
}
