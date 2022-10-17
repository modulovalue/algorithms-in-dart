import 'package:algorithms/trees/binary_search_tree.dart';
import 'package:algorithms/trees/binary_tree.dart';
import 'package:test/test.dart';

void main() {
  late BinarySearchTree<int> emptyTree, singleNodeTree, multiNodeTree;
  late List<BinarySearchTree<int>> treeList;
  setUp(() {
    emptyTree = BinarySearchTree<int>((final a, final b) => a.compareTo(b!));
    singleNodeTree = BinarySearchTree.withSingleValue(0, (final a, final b) => a.compareTo(b!));
    multiNodeTree = BinarySearchTree.fromList([11, -2, 1, 0, 21, 17, 9, -3], (final a, final b) => a.compareTo(b!));
    treeList = [emptyTree, singleNodeTree, multiNodeTree];
  });

  test('Binary Search Tree property', () {
    for (var tree in treeList) {
      expect(true, is_valid_binary_search_tree(tree));
    }
  });

  test('Test empty tree', () {
    expect(emptyTree.isEmpty, isTrue);
    expect(singleNodeTree.isEmpty, isFalse);
    expect(multiNodeTree.isEmpty, isFalse);
  });

  test('Test single node', () {
    expect(singleNodeTree.root!.value, equals(0));
    expect(multiNodeTree.root!.value, equals(11));
  });

  test('Multiple node', () {
    /*----------------------
               11
             /    \
           -2     21
          /  \    /
        -3    1  17
             / \
            0   9
    ----------------------*/
    expect(multiNodeTree.root!.value, equals(11));
    expect(multiNodeTree.root!.left!.value, equals(-2));
    expect(multiNodeTree.root!.left!.left!.value, equals(-3));
    expect(multiNodeTree.root!.left!.left!.left, isNull);
    expect(multiNodeTree.root!.left!.left!.right, isNull);
    expect(multiNodeTree.root!.left!.right!.value, equals(1));
    expect(multiNodeTree.root!.left!.right!.left!.value, equals(0));
    expect(multiNodeTree.root!.left!.right!.left!.left, isNull);
    expect(multiNodeTree.root!.left!.right!.left!.right, isNull);
    expect(multiNodeTree.root!.left!.right!.right!.value, equals(9));
    expect(multiNodeTree.root!.left!.right!.right!.left, isNull);
    expect(multiNodeTree.root!.left!.right!.right!.right, isNull);

    expect(multiNodeTree.root!.right!.value, equals(21));
    expect(multiNodeTree.root!.right!.right, isNull);
    expect(multiNodeTree.root!.right!.left!.value, equals(17));
    expect(multiNodeTree.root!.right!.left!.left, isNull);
    expect(multiNodeTree.root!.right!.left!.right, isNull);
  });

  test('Add', () {
    var ascendingTree = BinarySearchTree<int>((final a, final b) => a.compareTo(b!));
    ascendingTree.add(10);
    ascendingTree.add(20);
    ascendingTree.add(30);
    expect(ascendingTree.root!.value, equals(10));
    expect(ascendingTree.root!.right!.value, equals(20));
    expect(ascendingTree.root!.left, isNull);
    expect(ascendingTree.root!.right!.right!.value, equals(30));
    expect(ascendingTree.root!.right!.left, isNull);
    expect(ascendingTree.root!.right!.right!.left, isNull);
    expect(ascendingTree.root!.right!.right!.right, isNull);
    expect(true, is_valid_binary_search_tree(ascendingTree));

    var descendingTree = BinarySearchTree<int>((final a, final b) => a.compareTo(b!));
    descendingTree.add(-10);
    descendingTree.add(-20);
    descendingTree.add(-30);
    expect(descendingTree.root!.value, equals(-10));
    expect(descendingTree.root!.left!.value, equals(-20));
    expect(descendingTree.root!.right, equals(null));
    expect(descendingTree.root!.left!.left!.value, equals(-30));
    expect(descendingTree.root!.left!.right, equals(null));
    expect(descendingTree.root!.left!.left!.right, isNull);
    expect(descendingTree.root!.left!.left!.left, isNull);
    expect(true, is_valid_binary_search_tree(descendingTree));
  });

  test('Nullify', () {
    var tree = BinarySearchTree<int>.fromList([1, 2, 3], (final a, final b) => a.compareTo(b!));
    tree.nullify();
    expect(tree.isEmpty, isTrue);
  });

  test('Check contains', () {
    expect(emptyTree.contains(10), isFalse);
    expect(singleNodeTree.contains(10), isFalse);
    expect(singleNodeTree.contains(0), isTrue);
    expect(multiNodeTree.contains(1230), isFalse);

    for (var i in [11, -2, 1, 0, 21, 17, 9, -3]) {
      expect(multiNodeTree.contains(i), isTrue);
    }
  });

  group('Traversal ', () {
    test('Pre-order', () {
      expect(emptyTree.pre_order(), <int>[]);
      expect(singleNodeTree.pre_order(), <int>[0]);
      expect(multiNodeTree.pre_order(),
          equals(<int>[11, -2, -3, 1, 0, 9, 21, 17]));
    });

    test('Post-order', () {
      expect(emptyTree.post_order(), <int>[]);
      expect(singleNodeTree.post_order(), <int>[0]);
      expect(multiNodeTree.post_order(),
          equals(<int>[-3, 0, 9, 1, -2, 17, 21, 11]));
    });

    test('In-order', () {
      expect(emptyTree.in_order(), <int>[]);
      expect(singleNodeTree.in_order(), <int>[0]);
      expect(
          multiNodeTree.in_order(), equals(<int>[-3, -2, 0, 1, 9, 11, 17, 21]));
    });
  });

  test('Balance Tree', () {
    /*----------------------
      tree before balance()
             -1
            /  \
          -2    0
                 \
                  2
                   \
                    5
                   /
                  4
                 /
                3
    ----------------------*/
    var test = BinarySearchTree<int>.fromList([-1, -2, 0, 2, 5, 4, 3], (final a, final b) => a.compareTo(b!));
    test.balance();
    /*----------------------
      tree after balance()
              2
            /   \
          -1     4
          / \   / \
        -2   0 3   5
    ----------------------*/
    expect(test.pre_order(), equals(<int>[2, -1, -2, 0, 4, 3, 5]));
    expect(true, is_valid_binary_search_tree(test));
  });

  test('Delete node', () {
    emptyTree.delete(1);
    expect(emptyTree.in_order(), <int>[]);
    singleNodeTree.delete(0);
    expect(emptyTree.in_order(), <int>[]);

    /*----------------------
               11
             /    \
           -2     21
          /  \    /
        -3    1  17
             / \
            0   9
    ----------------------*/

    var test = BinarySearchTree<int>.fromList([11, -2, 1, 0, 21, 17, 9, -3], (final a, final b) => a.compareTo(b!));
    // delete node with no child
    test.delete(-3);
    expect(true, is_valid_binary_search_tree(test));

    test = BinarySearchTree<int>.fromList([11, -2, 1, 0, 21, 17, 9, -3], (final a, final b) => a.compareTo(b!));
    // delete node with one child
    test.delete(21);
    expect(true, is_valid_binary_search_tree(test));

    test = BinarySearchTree<int>.fromList([11, -2, 1, 0, 21, 17, 9, -3], (final a, final b) => a.compareTo(b!));
    // delete node with two children
    test.delete(-2);
    expect(true, is_valid_binary_search_tree(test));

    test = BinarySearchTree<int>.fromList([11, -2, 1, 0, 21, 17, 9, -3], (final a, final b) => a.compareTo(b!));
    // delete root node
    test.delete(11);
    expect(true, is_valid_binary_search_tree(test));
  });
}

/// Creates a Binary Search tree from the given [pre_order] and [in_order]
///  traversals.
///
/// [root] must not be `null`.
void create_binary_search_tree<V>(
  final BinaryNode<V> root,
  final List<V> pre_order,
  final List<V> in_order,
) {
  expect(root, isNotNull);
  expect(true, pre_order.length == in_order.length);
  // [root] is the only node in subtree.
  if (pre_order.length <= 1) {
    return;
  } else if (pre_order.length == 2) {
    // [root] has only one child.
    if (pre_order[0] == in_order[0]) {
      root.right = BinaryNode(pre_order[1]);
    } else {
      root.left = BinaryNode(pre_order[1]);
    }
  } else {
    // Multiple nodes present.
    // BST must have unique values.
    final unique_values = {...pre_order}.length == pre_order.length &&
        {...in_order}.length == in_order.length;
    expect(true, unique_values);
    // Index of [root] in [inOrder] list.
    int i_index = in_order.indexOf(pre_order[0]);
    // Set of values in the left subtree of [root].
    Set<V> set = {...in_order.sublist(0, i_index)};
    // Index of last value of left subtree in [preOrder] list.
    int p_index = pre_order.indexOf(set.last);
    for (var i = p_index + 1; set.contains(pre_order[i]); i++) {
      p_index = i;
    }
    _add_left(
      root,
      pre_order.sublist(1, p_index + 1),
      in_order.sublist(0, i_index),
    );
    _add_right(
      root,
      pre_order.sublist(p_index + 1),
      in_order.sublist(i_index + 1),
    );
  }
}

/// Checks if [tree] is a valid Binary Search Tree or not.
///
/// If inOrder traversal of [tree] has values "in-order", it is valid.
bool is_valid_binary_search_tree<T>(final BinarySearchTree<T> tree,) {
  if (tree.isEmpty) {
    return true;
  }
  List<T> in_order = tree.in_order();
  for (int i = 0; i < in_order.length - 1; i++) {
    if (tree.compare(in_order[i], in_order[i + 1]) >= 0) {
      return false;
    }
  }
  return true;
}

/// Adds left subtree to [root].
void _add_left<V>(
  final BinaryNode<V> root,
  final List<V> preOrder,
  final List<V> inOrder,
) {
  root.left = BinaryNode(preOrder[0]);
  create_binary_search_tree(root.left!, preOrder, inOrder);
}

/// Adds right subtree to [root].
void _add_right<V>(
  final BinaryNode<V> root,
  final List<V> preOrder,
  final List<V> inOrder,
) {
  root.right = BinaryNode(preOrder[0]);
  create_binary_search_tree(root.right!, preOrder, inOrder);
}
