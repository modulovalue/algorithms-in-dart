import 'tree_adt.dart';

/// Declares members of a binary node.
abstract class BinaryNodeADT<N extends BinaryNodeADT<N, V>, V> implements NodeADT<N, V> {
  List<N?>? children = List<N?>.filled(2, null,);

  N? get left {
    return children![0];
  }

  set left(final N? node) {
    children![0] = node;
  }

  N? get right {
    return children![1];
  }

  set right(final N? node) {
    children![1] = node;
  }

  @override
  String toString() {
    return '$value';
  }
}

/// A binary tree data structure can be defined recursively as a collection of
///  binary nodes (starting at a [root] node).
abstract class BinaryTreeADT<N extends BinaryNodeADT<N, V>, V> implements TreeADT<N, V> {
  @override
  bool get isEmpty {
    return root == null;
  }

  int Function(V, V) get compare;
  @override
  bool contains(
    final V value,
  ) {
    if (isEmpty) {
      return false;
    } else {
      return _compareAndCheck(root!, value);
    }
  }

  bool _compareAndCheck(
    final N node,
    final V value,
  ) {
    if (node.value == value) {
      return true;
    } else {
      if (compare(node.value!, value) >= 0) {
        if (node.left != null) {
          return _compareAndCheck(node.left!, value);
        } else {
          return false;
        }
      } else {
        if (node.right != null) {
          return _compareAndCheck(node.right!, value);
        } else {
          return false;
        }
      }
    }
  }

  @override
  void nullify() {
    root = null;
  }

  /// In Order Traversal.
  List<V> in_order() {
    final List<V> result = <V>[];
    _inOrder(root, result);
    return result;
  }

  /// PostOrder Traversal.
  List<V> post_order() {
    final List<V> result = <V>[];
    _postOrder(root, result);
    return result;
  }

  /// PreOrder Traversal.
  List<V> pre_order() {
    final List<V> result = <V>[];
    _preOrder(root, result);
    return result;
  }

  void _inOrder(
    final N? node,
    final List<V> list,
  ) {
    if (node == null) {
      return;
    } else {
      _inOrder(node.left, list);
      list.add(node.value!);
      _inOrder(node.right, list);
    }
  }

  void _postOrder(
    final N? node,
    final List<V> list,
  ) {
    if (node == null) {
      return;
    } else {
      _postOrder(node.left, list);
      _postOrder(node.right, list);
      list.add(node.value!);
    }
  }

  void _preOrder(
    final N? node,
    final List<V> list,
  ) {
    if (node == null) {
      return;
    } else {
      list.add(node.value!);
      _preOrder(node.left, list);
      _preOrder(node.right, list);
    }
  }
}
