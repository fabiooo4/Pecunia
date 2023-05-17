import 'package:flutter/material.dart';
import 'package:pecunia/widgets/account_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int activeCardIndex = 0;
  int _index = 0;

  void _onCardTapped(int index) {
    setState(() {
      activeCardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello {user}',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text('Welcome Back!', style: TextStyle(fontSize: 15))
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0.0),
                            minimumSize: const Size(40, 40),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        onPressed: () {},
                        child: const Icon(Icons.add)),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: 3,
                  controller: PageController(viewportFraction: 0.7),
                  onPageChanged: (int index) => setState(() => _index = index),
                  itemBuilder: (_, i) {
                    final isActive = i == activeCardIndex;
                    return Transform.scale(
                      scale: isActive ? 1 : 0.9,
                      child: AccountCard(
                        name: 'Account Name $i',
                        onTap: () => _onCardTapped(i),
                        totalBalance: 1000,
                        income: 1000,
                        expense: 0,
                        active: isActive,
                      ),
                    );
                  },
                ),
              ),
              /* SizedBox(
                height: 200,
                width: double.infinity,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                            3,
                            (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AccountCard(
                                    name: 'Account Name $index',
                                    onTap: () => _onCardTapped(index),
                                    totalBalance: 1000,
                                    income: 1000,
                                    expense: 0,
                                    active: index == activeCardIndex,
                                  ),
                                )),
                      ),
                    ),
                  ],
                ), 
              ), */
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
