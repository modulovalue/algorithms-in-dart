// region public
RedBlackTree<V> red_black_tree_from_list<V extends Object>({
  required final List<V> list,
  required final int Function(V a, V? b) order,
}) {
  final tree = red_black_tree_empty<V>(
    order: order,
  );
  for (final x in list) {
    tree.append(x);
  }
  return tree;
}

RedBlackTree<V> red_black_tree_empty<V extends Object>({
  required final int Function(V a, V? b) order,
}) {
  return _RedBlackTreeImpl<V>(
    order,
  );
}

// TODO remove this once the dsl is being used.
abstract class RedBlackNode<V> {
  abstract RedBlackNodeColor color;

  abstract RedBlackNode<V>? parent;

  abstract RedBlackNode<V>? left;

  abstract RedBlackNode<V>? right;

  abstract V? value;
}

abstract class RedBlackTree<V> {
  RedBlackNode<V>? get root;

  int Function(V, V) get order;

  // TODO remove this once the dsl is being used.
  RedBlackNode<V> get nil;

  // TODO rename to append.
  // TODO replace with a method on -the head of a path- or a node.
  void append(
    final V value,
  );

  // TODO replace with a find method that can return null.
  bool contains(
    final V value,
  );

  // TODO replace with a delete method on -the head of a path- or a node.
  void delete(
    final V value,
  );

  bool get is_empty;
}

// TODO generalize to take a left/right delegate and move out.
extension RedBlackTreeExtension<V> on RedBlackTree<V> {
  List<V> red_black_tree_in_order() {
    final result = <V>[];
    void _in_order(
      final RedBlackNode<V> node,
      final List<V> list,
    ) {
      if (node == nil) {
        return;
      } else {
        _in_order(node.left!, list);
        list.add(node.value!);
        _in_order(node.right!, list);
      }
    }

    if (!is_empty) {
      _in_order(root!, result);
    }
    return result;
  }

  List<V> red_black_tree_post_order() {
    final result = <V>[];
    void _post_order(
      final RedBlackNode<V> node,
      final List<V> list,
    ) {
      if (node == nil) {
        return;
      } else {
        _post_order(node.left!, list);
        _post_order(node.right!, list);
        list.add(node.value!);
      }
    }

    if (!is_empty) {
      _post_order(root!, result);
    }
    return result;
  }

  List<V> red_black_tree_pre_order() {
    final result = <V>[];
    void _pre_order(
      final RedBlackNode<V> node,
      final List<V> list,
    ) {
      if (node == nil) {
        return;
      } else {
        list.add(node.value!);
        _pre_order(node.left!, list);
        _pre_order(node.right!, list);
      }
    }

    if (!is_empty) {
      _pre_order(root!, result);
    }
    return result;
  }
}
// endregion

// TODO * node dsl:
// TODO          node
// TODO         /    \
// TODO      red     black
// TODO             /     \
// TODO      nonleaf      leaf
// TODO * can we prove correctness using simulated hkts in dart?
// TODO * fix: leaf guaranteed to have parents.
// TODO * fix: children never null.
// TODO * fix: leaf no children.
// TODO * fix: value not nullable.
// TODO * move rotations out.
// TODO * grok insert.
// TODO * grok delete.
// TODO * need bulk split (logn possible like with treaps?).
// TODO * need bulk join (logn possible like with treaps?).
// TODO * need linear time construction. (see that one stack overflow answer).
// TODO * auto augmentation maintenance for all ops if they walk up somewhere towards the end.
// TODO * generalize to not depend on a single pointer based mutable tree.
// TODO * have reforested path based ops?
// TODO * performance test.
// region internal
class _RedBlackNodeImpl<V> implements RedBlackNode<V> {
  @override
  RedBlackNodeColor color;
  @override
  RedBlackNode<V>? parent;
  @override
  RedBlackNode<V>? left;
  @override
  RedBlackNode<V>? right;
  @override
  V? value;

  _RedBlackNodeImpl({
    required final this.value,
    required final this.parent,
    required final this.left,
    required final this.right,
  }) : color = RedBlackNodeColor.red;

  _RedBlackNodeImpl.nil() : color = RedBlackNodeColor.black;

  @override
  String toString() {
    return value.toString();
  }
}

class _RedBlackTreeImpl<V extends Object> implements RedBlackTree<V> {
  /// Total order on [V].
  final int Function(V a, V b) order;

  /// Designated node used as a traversal path terminator. This node does not
  /// hold or reference any data managed by the [RedBlackTree].
  @override
  final RedBlackNode<V> nil;

  /// The red black tree invariants:
  /// * The [root] is black.
  /// * All leaves ([nil]) are black.
  /// * If a node is red, then both its children are black.
  /// * Every path from a given node to any of its leaves
  ///   goes through the same number of black nodes.
  @override
  RedBlackNode<V>? root;

  _RedBlackTreeImpl(
    final this.order,
  ) : nil = _RedBlackNodeImpl<V>.nil();

  @override
  bool get is_empty {
    return root == null;
  }

  @override
  void append(
    final V value,
  ) {
    RedBlackNode<V>? _sibling(
      final RedBlackNode<V>? node,
    ) {
      final parent = node?.parent;
      if (node == parent?.left) {
        return parent?.right;
      } else {
        return parent?.left;
      }
    }

    if (is_empty) {
      root = _RedBlackNodeImpl<V>(
        value: value,
        left: nil,
        right: nil,
        parent: null,
      );
    } else {
      RedBlackNode<V> _add(
        final RedBlackNode<V> node,
        final V value,
      ) {
        if (order(value, node.value!) < 0) {
          if (node.left != nil) {
            return _add(node.left!, value);
          } else {
            return node.left = _RedBlackNodeImpl<V>(
              value: value,
              parent: node,
              left: nil,
              right: nil,
            );
          }
        } else if (order(value, node.value!) > 0) {
          if (node.right != nil) {
            return _add(node.right!, value);
          } else {
            return node.right = _RedBlackNodeImpl<V>(
              value: value,
              parent: node,
              left: nil,
              right: nil,
            );
          }
        } else {
          // Duplicate value found.
          return root!;
        }
      }

      root = _add(root!, value);
    }
    void _add_reorder(
      final RedBlackNode<V> n,
    ) {
      RedBlackNode<V> node = n;
      RedBlackNode<V>? parent = node.parent;
      final uncle = _sibling(node.parent);
      final grand_parent = node.parent?.parent;
      // [node] is [root].
      if (parent == null) {
        node.color = RedBlackNodeColor.black;
      } else if (parent.color == RedBlackNodeColor.black) {
        // [parent] is black, tree is valid.
        return;
      } else if (uncle!.color == RedBlackNodeColor.red) {
        // Double red problem encountered with red [uncle].
        // Recolor [parent], [uncle] and [grandparent] of node.
        uncle.color = parent.color = RedBlackNodeColor.black;
        grand_parent!.color = RedBlackNodeColor.red;
        // Check if [grandparent] is not violating any property.
        _add_reorder(grand_parent);
      } else {
        // Double red problem encountered with black [uncle].
        // [parent] is left child.
        if (parent == grand_parent!.left) {
          // [node] is right child, rotate left about [parent].
          if (node == parent.right) {
            _rotate_left(parent);
            // Update [parent] and [node].
            parent = grand_parent.left;
            node = parent!.left!;
          }
          // [node] is left child, rotate right about [grandparent].
          _rotate_right(grand_parent);
        }
        // [parent] is right child.
        else if (parent == grand_parent.right) {
          // [node] is left child, rotate right about [parent].
          if (node == parent.left) {
            _rotate_right(parent);
            // Update [parent] and [node].
            parent = grand_parent.right;
            node = parent!.right!;
          }
          // [node] is right child, rotate left about [grandparent].
          _rotate_left(grand_parent);
        }
        grand_parent.color = RedBlackNodeColor.red;
        parent.color = RedBlackNodeColor.black;
      }
    }

    _add_reorder(root!);
    while (root?.parent != null) {
      root = root?.parent;
    }
  }

  @override
  bool contains(
    final V value,
  ) {
    if (is_empty) {
      return false;
    } else {
      bool _compare_and_check(
        final RedBlackNode<V> node,
        final V value,
      ) {
        if (node.value == value) {
          return true;
        } else {
          if (order(node.value!, value) >= 0) {
            if (node.left != nil) {
              return _compare_and_check(node.left!, value);
            } else {
              return false;
            }
          } else {
            if (node.right != nil) {
              return _compare_and_check(node.right!, value);
            } else {
              return false;
            }
          }
        }
      }

      return _compare_and_check(root!, value);
    }
  }

  @override
  void delete(
    final V value,
  ) {
    RedBlackNode<V>? _sibling(
      final RedBlackNode<V>? node,
    ) {
      final parent = node?.parent;
      if (node == parent?.left) {
        return parent?.right;
      } else {
        return parent?.left;
      }
    }

    void _delete(
      final RedBlackNode<V> node,
      final V value,
    ) {
      // Base Case, [value] not found.
      if (node == nil) return;
      if (order(node.value!, value) > 0) {
        _delete(node.left!, value);
      } else if (order(node.value!, value) < 0) {
        _delete(node.right!, value);
      } else {
        // [node] with [value] found.
        // [node] has two children.
        if (node.left != nil && node.right != nil) {
          // Successor to [node] is the next inOrder node.
          RedBlackNode<V>? successor = node.right;
          while (successor!.left != nil) {
            successor = successor.left;
          }
          node.value = successor.value;
          _delete(node.right!, successor.value!);
        } else {
          // Delete [node] and reorder.
          final parent = node.parent;
          if (parent == null) {
            root = null;
          }
          RedBlackNode<V>? _delete_reorder(
            final RedBlackNode<V> node,
          ) {
            RedBlackNode<V>? _near_nephew(
                final RedBlackNode<V> node,
                ) {
              final parent = node.parent;
              final sibling = _sibling(node);
              if (node == parent?.left) {
                return sibling?.left;
              } else {
                return sibling?.right;
              }
            }

            RedBlackNode<V>? _far_nephew(
                final RedBlackNode<V> node,
                ) {
              final parent = node.parent;
              final sibling = _sibling(node);
              if (node == parent?.left) {
                return sibling?.right;
              } else {
                return sibling?.left;
              }
            }

            // Childless red node.
            if (node.color == RedBlackNodeColor.red) {
              return nil;
            } else {
              // Childless black node.
              if (node.left == nil && node.right == nil) {
                RedBlackNode<V>? sibling = _sibling(node);
                RedBlackNode<V>? parent = node.parent;
                RedBlackNode<V>? near_nephew = _near_nephew(node);
                RedBlackNode<V>? far_nephew = _far_nephew(node);
                // [node]'s [sibling] is red.
                if (sibling?.color == RedBlackNodeColor.red) {
                  // Rotate with [parent] as pivot and convert to case with
                  //  black [sibling].
                  if (parent!.left == node) {
                    _rotate_left(parent);
                  } else {
                    _rotate_right(parent);
                  }
                  parent.color = RedBlackNodeColor.red;
                  sibling!.color = RedBlackNodeColor.black;
                  // Update relations.
                  sibling = _sibling(node);
                  parent = node.parent;
                  near_nephew = _near_nephew(node);
                  far_nephew = _far_nephew(node);
                }
                // [node]'s [sibling] and both the nephews are black..
                if (sibling?.color == RedBlackNodeColor.black &&
                    near_nephew!.color == RedBlackNodeColor.black &&
                    far_nephew!.color == RedBlackNodeColor.black) {
                  // ..with red parent.
                  if (parent!.color == RedBlackNodeColor.red) {
                    sibling!.color = RedBlackNodeColor.red;
                    parent.color = RedBlackNodeColor.black;
                  } else {
                    // ..with black parent.
                    sibling!.color = RedBlackNodeColor.red;
                    _delete_reorder(parent);
                  }
                  return nil;
                }
                // [node]'s [sibling] is black and at least one nephew is red.
                if (sibling?.color == RedBlackNodeColor.black &&
                    (near_nephew!.color == RedBlackNodeColor.red ||
                        far_nephew!.color == RedBlackNodeColor.red)) {
                  switch (far_nephew!.color) {
                  // Far nephew is black, perform rotation on [sibling]
                  //  and convert it to other case.
                    case RedBlackNodeColor.black:
                      if (node == parent!.left) {
                        _rotate_right(sibling!);
                      } else {
                        _rotate_left(sibling!);
                      }
                      near_nephew.color = RedBlackNodeColor.black;
                      sibling.color = RedBlackNodeColor.red;
                      // Update relations.
                      sibling = _sibling(node);
                      near_nephew = _near_nephew(node);
                      far_nephew = _far_nephew(node);
                      continue to_red_case;
                    to_red_case:
                    // Far nephew is red.
                    case RedBlackNodeColor.red:
                      if (node == parent!.left) {
                        _rotate_left(parent);
                      } else {
                        _rotate_right(parent);
                      }
                      sibling!.color = parent.color;
                      parent.color = far_nephew!.color = RedBlackNodeColor.black;
                      break;
                  }
                  return nil;
                }
                // [node] is root.
                return null;
              } else {
                // Black node with one child.
                final parent = node.parent;
                final child = (){
                  if (node.left != nil) {
                    return node.left;
                  } else {
                    return node.right;
                  }
                }();
                child!.parent = parent;
                child.color = RedBlackNodeColor.black;
                return child;
              }
            }
          }

          if (node == parent?.left) {
            parent?.left = _delete_reorder(node);
          } else {
            parent?.right = _delete_reorder(node);
          }
        }
      }
    }

    if (!is_empty) {
      _delete(root!, value);
    }
    while (root?.parent != null) {
      root = root?.parent;
    }
  }

  // TODO generalize move out.
  void _rotate_left(
    final RedBlackNode<V> node,
  ) {
    // Rotates [node] N to left and makes C it's parent.
    //
    //          N                   C
    //         /↶\                 / \
    //            C       ⟶       N
    //           / \             / \
    //          ⬤                  ⬤
    // Left subtree of C becomes right subtree of N.
    final child = node.right;
    final parent = node.parent;
    node.right = child!.left;
    child.left = node;
    node.parent = child;
    // Update other parent/child connections.
    if (node.right != nil) {
      node.right!.parent = node;
    }
    // In case [node] is not [root].
    if (parent != null) {
      if (node == parent.left) {
        parent.left = child;
      } else if (node == parent.right) {
        parent.right = child;
      }
    }
    child.parent = parent;
  }

  // TODO generalize move out.
  void _rotate_right(
    final RedBlackNode<V> node,
  ) {
    // Rotates [node] N to right and makes C it's parent.
    //
    //            N                 C
    //           /↷\       ⟶       / \
    //          C                     N
    //         / \                   / \
    //            ⬤                ⬤
    // Right subtree of C becomes left subtree of N.
    final child = node.left;
    final parent = node.parent;
    node.left = child!.right;
    child.right = node;
    node.parent = child;
    // Update other parent/child connections.
    if (node.left != nil) {
      node.left!.parent = node;
    }
    // In case [node] is not [root].
    if (parent != null) {
      if (node == parent.left) {
        parent.left = child;
      } else if (node == parent.right) {
        parent.right = child;
      }
    }
    child.parent = parent;
  }
}

// TODO remove once dsl is being used only.
enum RedBlackNodeColor {
  red,
  black,
}

// region rbnode
abstract class RBNode<V> {
  R match<R>({
    required final R Function(RBNodeNormal<V>) normal,
    required final R Function(RBNodeNil<V>) nil,
  });
}

class RBNodeNormal<V> implements RBNode<V> {
  RedBlackNodeColor color;
  RedBlackNode<V>? parent;
  RedBlackNode<V> left;
  RedBlackNode<V> right;
  V? value;

  RBNodeNormal({
    required final this.color,
    required final this.parent,
    required final this.left,
    required final this.right,
    required final this.value,
  });
  R match<R>({
    required final R Function(RBNodeNormal<V>) normal,
    required final R Function(RBNodeNil<V>) nil,
  }) {
    return normal(this);
  }
}

class RBNodeNil<V> implements RBNode<V> {
  RedBlackNode<V> parent;

  RBNodeNil({
    required final this.parent,
  });

  RedBlackNodeColor get color {
    return RedBlackNodeColor.black;
  }

  R match<R>({
    required final R Function(RBNodeNormal<V>) normal,
    required final R Function(RBNodeNil<V>) nil,
  }) {
    return nil(this);
  }
}
// endregion
// endregion
