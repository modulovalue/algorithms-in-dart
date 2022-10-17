import 'package:algorithms/trees/threaded_binary_tree.dart';
import 'package:test/test.dart';

void main() {
  late ThreadedBinaryTree<String> empty, singleNode, multipleNodes;

  setUp(() {
    empty = ThreadedBinaryTree();
    singleNode = ThreadedBinaryTree.withSingleValue('@');
    multipleNodes = ThreadedBinaryTree.fromList(
        ['f', 'b', 'g', 'a', 'd', 'i', 'c', 'e', 'h']);
    /*---------------------------------------------
    multipleNodes:
                f
              /   \
             b     g
            / \     \
           a   d     i
              / \   /
             c   e h
    https://en.wikipedia.org/wiki/File:Threaded_tree.svg
    ---------------------------------------------*/
  });

  test('Test empty tree', () {
    expect(empty.isEmpty, isTrue);
    expect(singleNode.isEmpty, isFalse);
    expect(multipleNodes.isEmpty, isFalse);
  });

  test('Test single node', () {
    expect(singleNode.root!.value, equals('@'));
    expect(multipleNodes.root!.value, equals('f'));
  });

  test('Nullify', () {
    var test = ThreadedBinaryTree<int>.fromList([1, 2, 3]);
    test.nullify();
    expect(test.isEmpty, isTrue);
  });

  test('Check contains', () {
    expect(empty.contains(''), isFalse);
    expect(singleNode.contains('@'), isTrue);
    expect(singleNode.contains(''), isFalse);
    expect(multipleNodes.contains('nope'), isFalse);

    for (var i in ['f', 'b', 'g', 'a', 'd', 'i', 'c', 'e', 'h']) {
      expect(multipleNodes.contains(i), isTrue);
    }
  });

  group('Traversal', () {
    test('Pre-order', () {
      expect(empty.pre_order(), <String>[]);
      expect(singleNode.pre_order(), <String>['@']);
      expect(multipleNodes.pre_order(),
          equals(<String>['f', 'b', 'a', 'd', 'c', 'e', 'g', 'i', 'h']));
    });

    test('Post-order', () {
      expect(empty.post_order(), <String>[]);
      expect(singleNode.post_order(), <String>['@']);
      expect(multipleNodes.post_order(),
          equals(<String>['a', 'c', 'e', 'd', 'b', 'h', 'i', 'g', 'f']));
    });

    test('In-order', () {
      expect(empty.in_order(), <String>[]);
      expect(singleNode.in_order(), <String>['@']);
      expect(multipleNodes.in_order(),
          equals(<String>['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']));
    });
  });

  test('Add node', () {
    var test = ThreadedBinaryTree<int>();
    var list = test.in_order();

    test.add(50);
    expect(
        test.in_order(),
        equals(list
          ..add(50)
          ..sort()));

    test.add(60);
    expect(
        test.in_order(),
        equals(list
          ..add(60)
          ..sort()));

    test.add(70);
    expect(
        test.in_order(),
        equals(list
          ..add(70)
          ..sort()));

    test.add(40);
    expect(
        test.in_order(),
        equals(list
          ..add(40)
          ..sort()));

    test.add(55);
    expect(
        test.in_order(),
        equals(list
          ..add(55)
          ..sort()));

    test.add(75);
    expect(
        test.in_order(),
        equals(list
          ..add(75)
          ..sort()));

    test.add(53);
    expect(
        test.in_order(),
        equals(list
          ..add(53)
          ..sort()));

    test.add(54);
    expect(
        test.in_order(),
        equals(list
          ..add(54)
          ..sort()));

    test.add(30);
    expect(
        test.in_order(),
        equals(list
          ..add(30)
          ..sort()));

    test.add(45);
    expect(
        test.in_order(),
        equals(list
          ..add(45)
          ..sort()));

    test.add(35);
    expect(
        test.in_order(),
        equals(list
          ..add(35)
          ..sort()));

    test.add(51);
    expect(
        test.in_order(),
        equals(list
          ..add(51)
          ..sort()));
  });

  test('Delete node', () {
    var list = multipleNodes.in_order();

    multipleNodes.delete('f');
    expect(multipleNodes.in_order(), equals(list..remove('f')));

    multipleNodes.delete('a');
    expect(multipleNodes.in_order(), equals(list..remove('a')));

    multipleNodes.delete('i');
    expect(multipleNodes.in_order(), equals(list..remove('i')));

    multipleNodes.delete('c');
    expect(multipleNodes.in_order(), equals(list..remove('c')));

    multipleNodes.delete('e');
    expect(multipleNodes.in_order(), equals(list..remove('e')));

    multipleNodes.delete('d');
    expect(multipleNodes.in_order(), equals(list..remove('d')));

    multipleNodes.delete('b');
    expect(multipleNodes.in_order(), equals(list..remove('b')));

    multipleNodes.delete('g');
    expect(multipleNodes.in_order(), equals(list..remove('g')));

    multipleNodes.delete('h');
    expect(multipleNodes.in_order(), (list..remove('h')));

    expect(multipleNodes.isEmpty, isTrue);
  });
}
