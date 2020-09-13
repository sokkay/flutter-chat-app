import 'package:chat/blocs/auth/authentication_bloc.dart';
import 'package:chat/routes/routes_constants.dart';
import 'package:chat/widgets/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsAppBar extends StatelessWidget {
  const ChatsAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        height: size.height * 0.33,
        width: size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _userSection(),
                  _actions(context),
                ],
              ),
            ),
            // Histories
            Flexible(
              child: Container(
                padding: EdgeInsets.only(top: 15, bottom: size.height * 0.06),
                child: Placeholder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularButton(
          onPress: () {},
          color: Colors.pink[100],
          iconData: Icons.search,
        ),
        SizedBox(width: 10),
        CircularButton(
          onPress: () => _handleAddFriend(context),
          color: Colors.blue[700],
          iconData: Icons.add,
        ),
      ],
    );
  }

  Widget _userSection() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final user = state.user;
        return Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, profilePage),
              child: Hero(
                tag: "user avatar",
                child: CircleAvatar(
                  backgroundImage: AssetImage(user.avatarPreset),
                ),
              ),
            ),
            SizedBox(width: 16),
            Text(
              user.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        );
      },
    );
  }

  void _handleAddFriend(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 100,
      ),
    );
  }
}
