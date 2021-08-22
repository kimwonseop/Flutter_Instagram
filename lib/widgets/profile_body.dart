import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:testing_flutter/constants/common_size.dart';
import 'package:testing_flutter/constants/screen_size.dart';
import 'package:testing_flutter/screens/profile_screen.dart';
import 'package:testing_flutter/widgets/rounded_avatar.dart';

class ProfileBody extends StatefulWidget {
  final Function? onMenuChanged;

  const ProfileBody({Key? key, this.onMenuChanged}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftImagesPageMargin = 0;
  double _rightImagesPageMargin = size!.width;
  AnimationController? _iconAnimationController;

  @override
  void initState() {
    _iconAnimationController =
        AnimationController(vsync: this, duration: duration);
    super.initState();
  }

  @override
  void dispose() {
    _iconAnimationController!.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _appBar(),
          Expanded(
            child: CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(common_gap),
                        child: RoundedAvatar(size: 100),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: common_gap),
                          child: Table(
                            children: [
                              TableRow(children: [
                                _valueText('1234'),
                                _valueText('5678'),
                                _valueText('9876'),
                              ]),
                              TableRow(children: [
                                _labelText('Post'),
                                _labelText('Followers'),
                                _labelText('Following'),
                              ]),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  _username(),
                  _userBio(),
                  _editProfileBtn(),
                  _tabButtons(),
                  _selectedIndicator()
                ]),
              ),
              _imagesPager()
            ]),
          ),
        ],
      ),
    );
  }

  Row _appBar() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 44,
        ),
        Expanded(
            child: Text(
          'The Coding Papa',
          textAlign: TextAlign.center,
        )),
        IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _iconAnimationController!,
          ),
          onPressed: () {
            widget.onMenuChanged!();
            _iconAnimationController!.status == AnimationStatus.completed
                ? _iconAnimationController!.reverse()
                : _iconAnimationController!.forward();
          },
        )
      ],
    );
  }

  Text _valueText(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      );

  Text _labelText(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
      );

  SliverToBoxAdapter _imagesPager() {
    return SliverToBoxAdapter(
        child: Stack(children: <Widget>[
      AnimatedContainer(
        duration: duration,
        transform: Matrix4.translationValues(_leftImagesPageMargin, 0, 0),
        curve: Curves.fastOutSlowIn,
        child: _images(),
      ),
      AnimatedContainer(
        duration: duration,
        transform: Matrix4.translationValues(_rightImagesPageMargin, 0, 0),
        curve: Curves.fastOutSlowIn,
        child: _images(),
      ),
    ]));
  }

  GridView _images() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(
          30,
          (index) => CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: "https://picsum.photos/id/$index/100/100")),
    );
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
        duration: duration,
        alignment: _selectedTab == SelectedTab.left
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          height: 3,
          width: size!.width / 2,
          color: Colors.black87,
        ),
        curve: Curves.fastOutSlowIn);
  }

  Row _tabButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: IconButton(
            onPressed: () {
              setState(() {
                _tabSelected(SelectedTab.left);
              });
            },
            icon: ImageIcon(
              AssetImage('assets/images/grid.png'),
              color: _selectedTab == SelectedTab.right
                  ? Colors.black
                  : Colors.black26,
            ),
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () {
              setState(() {
                _tabSelected(SelectedTab.right);
              });
            },
            icon: ImageIcon(
              AssetImage('assets/images/saved.png'),
              color: _selectedTab == SelectedTab.right
                  ? Colors.black26
                  : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  _tabSelected(SelectedTab selectedTab) {
    setState(() {
      switch (selectedTab) {
        case SelectedTab.left:
          _selectedTab = SelectedTab.left;
          _leftImagesPageMargin = 0;
          _rightImagesPageMargin = size!.width;
          break;
        case SelectedTab.right:
          _selectedTab = SelectedTab.right;
          _leftImagesPageMargin = -size!.width;
          _rightImagesPageMargin = 0;
          break;
      }
    });
  }

  Padding _editProfileBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: SizedBox(
        height: 24,
        child: OutlineButton(
          onPressed: () {},
          borderSide: BorderSide(color: Colors.black45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _username() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        'username',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _userBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        'This is what i believe.',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

enum SelectedTab { left, right }
