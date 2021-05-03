import 'package:test/test.dart';

import '../lib/src/data.dart';

void main() {
  group('Node Element', () {
    var e = Element(
      type: ElementType.node,
      id: 1,
      timestamp: DateTime.utc(2001, 9, 11),
      version: 2,
      changeset: 124124,
      user: "Mogens",
      uid: 12421412,
      tags: {},
      raw_lat: 10.4,
      raw_lon: 4.5,
      raw_members: [],
      raw_nodes: [],
    );

    test('has lat', () => expect(e.lat, 10.4));
    test('has lon', () => expect(e.lon, 4.5));
  });

  group('Way Element', () {
    var e = Element(
      type: ElementType.way,
      id: 1,
      timestamp: DateTime.utc(2001, 9, 11),
      version: 2,
      changeset: 124124,
      user: "Mogens",
      uid: 12421412,
      tags: {},
      raw_lat: 10.4,
      raw_lon: 4.5,
      raw_nodes: [35352060, 35352061],
      raw_members: [],
    );

    test('does not have lat', () => expect(() => e.lat, throwsException));
    test('does not have lon', () => expect(() => e.lon, throwsException));
  });

  group('Relation Element', () {
    var e = Element(
      type: ElementType.relation,
      id: 1,
      timestamp: DateTime.utc(2001, 9, 11),
      version: 2,
      changeset: 124124,
      user: "Mogens",
      uid: 12421412,
      tags: {},
      raw_lat: 10.4,
      raw_lon: 4.5,
      raw_nodes: [],
      raw_members: [
        Member(
          type: "node",
          ref: 6772305769,
          role: "sign",
        )
      ],
    );

    test('does not have lat', () => expect(() => e.lat, throwsException));
    test('does not have lon', () => expect(() => e.lon, throwsException));
  });

  group('User', () {
    var user = User(
        id: 11321,
        display_name: "maptogether-test",
        account_created: DateTime.utc(2001, 9, 11),
        description: "",
        contributor_terms: {"agreed": true, "pd": false},
        roles: [],
        changesets: {"count": 0},
        traces: {"count": 0},
        blocks: Block(received: {"count": 0, "active": 0}),
        languages: ["en-US", "en"],
        messages:
            Message(received: {"count": 0, "unread": 0}, sent: {"count": 0}));

      test('has lat', () => expect(user.id, 11321));
  });
}
