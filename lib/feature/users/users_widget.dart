import 'package:flutter/material.dart';

import '../../data/model/user.dart';
import '../../external/service_locator.dart';
import '../../res/colours.dart';
import '../../res/keys.dart';
import '../../res/strings.dart';
import '../../utils/routing.dart';
import '../../utils/ui/orientation_list_view.dart';

class UsersWidget extends StatelessWidget {
  final List<User> users;

  const UsersWidget(this.users, {super.key});

  UsersKeys get keys => Keys.i.users;

  @override
  Widget build(BuildContext context) {
    return OrientationListView(
      users,
      key: keys.lsCards,
      builder: _buildUser,
    );
  }

  Widget _buildUser(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Routing.i.pushUser(context, user),
        child: Card(
          key: keys.wdCard(user.id),
          shadowColor: Colours.i.userCardShadow,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBasicInfo(user),
                _buildCompany(context, user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildBasicInfo(User user) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(user.name)),
              SizedBox(width: 16),
              Text('${user.id}'),
            ],
          ),
          _boldText(user.username),
          Text(user.email),
          _boldText(user.phone),
          Text(user.website),
        ],
      ),
    );
  }

  Row _buildCompany(BuildContext context, User user) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.all(16),
          icon: Icon(Icons.location_on_rounded),
          onPressed: () => _showLocation(context, user),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _boldText(
                user.company.name,
                centerEnd: true,
              ),
              Text(
                user.company.catchPhrase,
                textAlign: TextAlign.end,
              ),
              _boldText(
                user.company.bs,
                centerEnd: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLocation(BuildContext context, User user) {
    final address = user.address;
    showDialog<void>(
      context: context,
      builder: (context) {
        final strings = context.s.users;
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: EdgeInsets.all(16),
          contentPadding: EdgeInsets.all(16),
          title: Text(strings.address),
          children: [
            Text(address.street),
            _boldText(address.suite),
            Text(address.city),
            _boldText(address.zipcode),
            TextButton(
              child: Text(strings.showOnMap),
              onPressed: () async {
                final geo = address.geo;
                final success = await sl().mapService.open(geo.lat, geo.lng);
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.s.error)),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _boldText(String text, {bool centerEnd = false}) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w800),
      textAlign: centerEnd ? TextAlign.end : null,
    );
  }
}
