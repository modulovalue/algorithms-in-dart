/// A node consists of a [value],
///  together with a list of references to nodes (the _children),
///  with the constraints that no reference is duplicated,
///  and none points to the root.
abstract class NodeADT<N extends NodeADT<N, V>, V> {
  /// [value] of the node.
  V? get value;
}

/// A tree data structure can be defined recursively as a collection of nodes
///  (starting at a [root] node).
abstract class TreeADT<N extends NodeADT<N, V>, V> {
  /// Root of tree.
  abstract N? root;

  /// Tests if this tree is empty.
  bool get isEmpty;

  /// Adds [value] to the tree.
  void add(final V value);

  /// Checks if [value] is contained in the tree.
  bool contains(final V value);

  /// Deletes [value] from the tree and updates it's [root].
  void delete(final V value);

  /// Empty the tree.
  void nullify();
}
