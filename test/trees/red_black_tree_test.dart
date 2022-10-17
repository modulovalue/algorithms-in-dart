import 'package:algorithms/trees/binary_search_tree.dart';
import 'package:algorithms/trees/red_black_tree.dart';
import 'package:test/test.dart';

import 'binary_search_tree_test.dart';

void main() {
  int _black_node_count<V>(
    final RedBlackNode<V> node,
    final RedBlackNode<V> nil,
  ) {
    if (node == nil) {
      return 0;
    } else {
      // Red node must have black children.
      expect(
        true,
            () {
          if (node.color == RedBlackNodeColor.red) {
            return node.left!.color == RedBlackNodeColor.black &&
                node.right!.color == RedBlackNodeColor.black;
          } else {
            return true;
          }
        }(),
      );
      // Both left and right paths must have same number of black nodes.
      int left_count = _black_node_count(node.left!, nil);
      int right_count = _black_node_count(node.right!, nil);
      expect(left_count == right_count, isTrue);
      // Add node to the count if it is black.
      if (node.color == RedBlackNodeColor.black) {
        return ++left_count;
      } else {
        return left_count;
      }
    }
  }

  /// Checks if [tree] is a valid Red Black Tree or not.
  ///
  /// Valid Red Black Tree must be a valid Binary Search tree,
  ///  it's root and leaf([nil]) nodes must be black,
  ///  all red nodes must have black children and
  ///  every path from a given node to any of its descendant [nil] nodes goes
  ///   through the same number of black nodes.
  bool is_valid_red_black_tree<T>(
    final RedBlackTree<T> tree,
  ) {
    if (tree.is_empty) {
      return true;
    } else {
      final test = BinarySearchTree<T>.withSingleValue(
        tree.root!.value!,
        (final a, final b) => tree.order(a, b!),
      );
      create_binary_search_tree<T>(
        test.root!,
        tree.red_black_tree_pre_order(),
        tree.red_black_tree_in_order(),
      );
      expect(is_valid_binary_search_tree(test), isTrue);
      // Root must be black.
      if (tree.root!.color != RedBlackNodeColor.black) {
        return false;
      } else {
        return _black_node_count(tree.root!.left!, tree.nil) ==
            _black_node_count(tree.root!.right!, tree.nil);
      }
    }
  }

  late RedBlackTree<String> empty_tree;
  late RedBlackTree<String> multi_node_tree;
  late RedBlackTree<int> single_node_tree;
  setUp(() {
    empty_tree = red_black_tree_from_list(
      list: [],
      order: (final a, final b) => a.compareTo(b!),
    );
    single_node_tree = red_black_tree_from_list(
      list: [0],
      order: (final a, final b) => a.compareTo(b!),
    );
    multi_node_tree = red_black_tree_from_list(
      list: ['m', 'n', 'o', 'l', 'k', 'q', 'p', 'h', 'i', 'a'],
      order: (final a, final b) => a.compareTo(b!),
    );
    /*---------------------------------------------
    multiNodeTree: (Black nodes are encircled.)

               ⓛ
             /    \
            i      n
           / \    / \
          ⓗ  ⓚ ⓜ  ⓟ
         /          / \
        a          o   q
    ---------------------------------------------*/
  });
  test('Red Black Tree property', () {
    expect(is_valid_red_black_tree(empty_tree), isTrue);
    expect(is_valid_red_black_tree(single_node_tree), isTrue);
    expect(is_valid_red_black_tree(multi_node_tree), isTrue);
  });
  test('Test empty tree', () {
    expect(empty_tree.is_empty, isTrue);
    expect(single_node_tree.is_empty, isFalse);
    expect(multi_node_tree.is_empty, isFalse);
  });
  test('Test single node', () {
    expect(single_node_tree.root!.value, equals(0));
    expect(multi_node_tree.root!.value, equals('l'));
  });
  test('Check contains', () {
    expect(empty_tree.contains('10'), isFalse);
    expect(single_node_tree.contains(10), isFalse);
    expect(single_node_tree.contains(0), isTrue);
    expect(multi_node_tree.contains('z'), isFalse);
    for (var i in ['m', 'n', 'o', 'l', 'k', 'q', 'p', 'h', 'i', 'a']) {
      expect(multi_node_tree.contains(i), isTrue);
    }
  });
  group('Traversal', () {
    test('Pre-order', () {
      expect(empty_tree.red_black_tree_pre_order(), <int>[]);
      expect(single_node_tree.red_black_tree_pre_order(), <int>[0]);
      expect(multi_node_tree.red_black_tree_pre_order(),
          equals(<String>['l', 'i', 'h', 'a', 'k', 'n', 'm', 'p', 'o', 'q']));
    });
    test('Post-order', () {
      expect(empty_tree.red_black_tree_post_order(), <int>[]);
      expect(single_node_tree.red_black_tree_post_order(), <int>[0]);
      expect(multi_node_tree.red_black_tree_post_order(),
          equals(<String>['a', 'h', 'k', 'i', 'm', 'o', 'q', 'p', 'n', 'l']));
    });
    test('In-order', () {
      expect(empty_tree.red_black_tree_in_order(), <int>[]);
      expect(single_node_tree.red_black_tree_in_order(), <int>[0]);
      expect(multi_node_tree.red_black_tree_in_order(),
          equals(<String>['a', 'h', 'i', 'k', 'l', 'm', 'n', 'o', 'p', 'q']));
    });
  });
  test('Add node', () {
    final test = red_black_tree_from_list<int>(
      list: [],
      order: (final a, final b) => a.compareTo(b!),
    );
    List<Comparable> list = test.red_black_tree_in_order();
    test.append(50);
    expect(
        list
          ..add(50)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
    test.append(60);
    expect(
        list
          ..add(60)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
    test.append(70);
    expect(
        list
          ..add(70)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
    test.append(40);
    expect(
        list
          ..add(40)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
    test.append(55);
    expect(
        list
          ..add(55)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
    test.append(75);
    expect(
        list
          ..add(75)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
    test.append(53);
    expect(
        list
          ..add(53)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
    test.append(54);
    expect(
        list
          ..add(54)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
    test.append(30);
    expect(
        list
          ..add(30)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
    test.append(45);
    expect(
        list
          ..add(45)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
    test.append(35);
    expect(
        list
          ..add(35)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
    test.append(51);
    expect(
        list
          ..add(51)
          ..sort(),
        test.red_black_tree_in_order());
    expect(is_valid_red_black_tree(test), isTrue);
  });
  test('Delete node', () {
    List<String> list = multi_node_tree.red_black_tree_in_order();
    multi_node_tree.delete('m');
    expect(list..remove('m'), multi_node_tree.red_black_tree_in_order());
    expect(is_valid_red_black_tree(multi_node_tree), isTrue);
    multi_node_tree.delete('p');
    expect(list..remove('p'), multi_node_tree.red_black_tree_in_order());
    expect(is_valid_red_black_tree(multi_node_tree), isTrue);
    multi_node_tree.delete('l');
    expect(list..remove('l'), multi_node_tree.red_black_tree_in_order());
    expect(is_valid_red_black_tree(multi_node_tree), isTrue);
    multi_node_tree.delete('o');
    expect(list..remove('o'), multi_node_tree.red_black_tree_in_order());
    expect(is_valid_red_black_tree(multi_node_tree), isTrue);
    multi_node_tree.delete('q');
    expect(list..remove('q'), multi_node_tree.red_black_tree_in_order());
    expect(is_valid_red_black_tree(multi_node_tree), isTrue);
    multi_node_tree.delete('a');
    expect(list..remove('a'), multi_node_tree.red_black_tree_in_order());
    expect(is_valid_red_black_tree(multi_node_tree), isTrue);
    multi_node_tree.delete('k');
    expect(list..remove('k'), multi_node_tree.red_black_tree_in_order());
    expect(is_valid_red_black_tree(multi_node_tree), isTrue);
    multi_node_tree.delete('h');
    expect(list..remove('h'), multi_node_tree.red_black_tree_in_order());
    expect(is_valid_red_black_tree(multi_node_tree), isTrue);
    multi_node_tree.delete('n');
    expect(list..remove('n'), multi_node_tree.red_black_tree_in_order());
    expect(is_valid_red_black_tree(multi_node_tree), isTrue);
    multi_node_tree.delete('i');
    expect(list..remove('i'), multi_node_tree.red_black_tree_in_order());
    expect(is_valid_red_black_tree(multi_node_tree), isTrue);
  });
}
