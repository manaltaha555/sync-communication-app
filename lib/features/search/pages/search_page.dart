import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'dart:async';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/features/search/widgets/search_input_text_field.dart';
import 'package:sync_communication_app/features/search/widgets/search_result_tile.dart';
import 'package:sync_communication_app/widgets/gradient_background.dart';
import 'package:sync_communication_app/widgets/skelton_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  Timer? _debounce;
  late String userId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value, String userId) {
    _debounce?.cancel();

    if (value.trim().isEmpty) {
      context.read<ChatListCubit>().cleanSearch();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (value.length >= 2) {
        context.read<ChatListCubit>().searchUsers(
          query: value,
          currentUserId: userId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserCubit>().state.user?.uid;

    return GradientBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 36, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SearchInputTextField(
                      controller: _controller,
                      onChanged: (value) => _onChanged(value, userId!),
                    ),
                  ),
                ],
              ),
            ),

            // ── Results ─────────────────────────────────────────
            Expanded(
              child: BlocBuilder<ChatListCubit, ChatListState>(
                builder: (context, state) {
                  return switch (state) {
                    SearchLoading() => ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: 6,
                      itemBuilder: (context, index) => const SkeletonTile(),
                    ),
                    SearchError(:final message) => _ErrorView(message: message),
                    SearchLoaded(:final results) when results.isEmpty =>
                      _EmptyView(hasQuery: _controller.text.trim().isNotEmpty),
                    SearchLoaded(:final results) => ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final item = results[index];
                        return SearchResultTile(
                          item: item,
                          currentUserId: userId!,
                        );
                      },
                    ),
                    _ => _EmptyView(hasQuery: false),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final bool hasQuery;
  const _EmptyView({required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(hasQuery ? '🔍' : '💬', style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            hasQuery ? 'No users found' : 'Search for someone to chat with',
            style: TextStyle(
              color: context.scheme.onSurfaceVariant,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('😕', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(color: context.scheme.secondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
