import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/features/home/presentation/widgets/active_user_skelton.dart';
import 'package:sync_communication_app/features/home/presentation/widgets/active_user_widget.dart';
import 'package:sync_communication_app/features/home/presentation/widgets/chat_tile_widget.dart';
import 'package:sync_communication_app/features/home/presentation/widgets/custom_header.dart';
import 'package:sync_communication_app/features/home/presentation/widgets/custom_search_bar.dart';
import 'package:sync_communication_app/features/home/presentation/widgets/empty_chats_widget.dart';
import 'package:sync_communication_app/widgets/skelton_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    final uid = context.read<UserCubit>().state.user!.uid;

    context.read<ActiveCubit>().watchActiveUsers(uid);
    context.read<ChatListCubit>().getUserChats(uid);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = context.read<UserCubit>().state.user;

    return RefreshIndicator(
      onRefresh: () async {
        final uid = context.read<UserCubit>().state.user!.uid;
        context.read<ActiveCubit>().watchActiveUsers(uid);
        context.read<ChatListCubit>().getUserChats(uid);
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: CustomHeader(user: user),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomSearchBar(),
                  const SizedBox(height: 12),

                  BlocBuilder<ActiveCubit, ActiveState>(
                    buildWhen: (previous, current) =>
                        current is ActiveUsersLoading ||
                        current is ActiveUsersLoaded,
                    builder: (context, state) {
                      if (state is ActiveUsersLoading) {
                        return SizedBox(
                          height: 130,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (_, _) => const ActiveUserSkeleton(),
                          ),
                        );
                      }

                      if (state is ActiveUsersLoaded) {
                        if (state.users.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Now',
                              style: context.textTheme.titleLarge,
                            ),

                            SizedBox(
                              height: 150,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: state.users.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  return ActiveUserWidget(
                                    activeUser: state.users[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),

          BlocBuilder<ChatListCubit, ChatListState>(
            buildWhen: (previous, current) =>
                current is ChatListLoading || current is ChatListLoaded,
            builder: (context, state) {
              if (state is ChatListLoading) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      ...List.generate(4, (_) => const SkeletonTile()),
                    ]),
                  ),
                );
              }

              if (state is! ChatListLoaded) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }

              if (state.chats.isEmpty) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const EmptyChatsWidget(),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    Text('Your Chats', style: context.textTheme.titleLarge),

                    const SizedBox(height: 12),

                    ...state.chats.map(
                      (chatTile) => ChatTileWidget(chatTile: chatTile),
                    ),
                  ]),
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
