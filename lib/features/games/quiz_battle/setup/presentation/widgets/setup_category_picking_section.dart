import 'package:flutter/material.dart';

import '../../../categories/domain/models/category.dart';
import '../../domain/models/setup_state.dart';
import '../../domain/models/team.dart';

class SetupCategoryPickingSection extends StatelessWidget {
  const SetupCategoryPickingSection({
    super.key,
    required this.setup,
    required this.availableCategories,
    required this.onPickCategory,
    required this.onResetPicking,
  });

  final SetupState setup;
  final List<SetupCategoryOption> availableCategories;
  final void Function({
    required String teamId,
    required String categoryId,
  }) onPickCategory;
  final VoidCallback onResetPicking;

  static const int categoriesPerTeam = 3;

  @override
  Widget build(BuildContext context) {
    final Team? currentPickingTeam = _resolveCurrentPickingTeam();
    final bool isPickingStep = setup.isCategoryPickingStep || setup.isReady;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Category Picking',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Each team selects 3 categories. All selected categories are added to the shared board.',
            ),
            const SizedBox(height: 16),

            if (!isPickingStep)
              const Text(
                'Run the lottery first.',
              )
            else ...<Widget>[
              if (currentPickingTeam != null)
                _CurrentPickingCard(
                  team: currentPickingTeam,
                  selectedCount:
                      (setup.categorySelectionsByTeamId[currentPickingTeam.id] ??
                              const <String>[])
                          .length,
                ),
              if (currentPickingTeam != null)
                const SizedBox(height: 16),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availableCategories.map((SetupCategoryOption category) {
                  final bool isSelected =
                      setup.selectedCategoryIds.contains(category.id);

                  final bool canPick = currentPickingTeam != null &&
                      !isSelected &&
                      setup.isCategoryPickingStep;

                  return _CategoryChip(
                    title: category.title,
                    isSelected: isSelected,
                    onTap: canPick
                        ? () {
                            onPickCategory(
                              teamId: currentPickingTeam.id,
                              categoryId: category.id,
                            );
                          }
                        : null,
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              const Text(
                'Selections by Team',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              ..._resolveOrderedTeams().map((Team team) {
                final List<String> selections =
                    setup.categorySelectionsByTeamId[team.id] ??
                        const <String>[];

                return _TeamSelectionTile(
                  team: team,
                  selectedCategoryTitles: selections
                      .map((String categoryId) =>
                          _resolveCategoryTitle(categoryId))
                      .toList(),
                  isCurrent: team.id == setup.currentPickingTeamId,
                );
              }),

              const SizedBox(height: 16),

              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: setup.pickOrderTeamIds.isNotEmpty
                          ? onResetPicking
                          : null,
                      child: const Text('Reset Category Picking'),
                    ),
                  ),
                ],
              ),

              if (setup.isReady) ...<Widget>[
                const SizedBox(height: 12),
                const Text(
                  'Category picking is complete. The match is ready to start.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Team? _resolveCurrentPickingTeam() {
    final String? currentPickingTeamId = setup.currentPickingTeamId;
    if (currentPickingTeamId == null) {
      return null;
    }

    for (final Team team in setup.teams) {
      if (team.id == currentPickingTeamId) {
        return team;
      }
    }

    return null;
  }

  List<Team> _resolveOrderedTeams() {
    final Map<String, Team> teamsById = <String, Team>{
      for (final Team team in setup.teams) team.id: team,
    };

    if (setup.pickOrderTeamIds.isEmpty) {
      return setup.teams;
    }

    return setup.pickOrderTeamIds
        .map((String teamId) => teamsById[teamId])
        .whereType<Team>()
        .toList();
  }

  String _resolveCategoryTitle(String categoryId) {
    for (final SetupCategoryOption category in availableCategories) {
      if (category.id == categoryId) {
        return category.title;
      }
    }
    return categoryId;
  }
}

class SetupCategoryOption {
  const SetupCategoryOption({
    required this.category,
  });

  final Category category;

  String get id => category.id;
  String get title => category.title;
  String? get icon => category.icon;
}

class _CurrentPickingCard extends StatelessWidget {
  const _CurrentPickingCard({
    required this.team,
    required this.selectedCount,
  });

  final Team team;
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    final Color teamColor = Color(team.colorValue);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: teamColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: teamColor,
          width: 1.4,
        ),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: teamColor,
            child: Text(
              team.name.isEmpty ? '?' : team.name.characters.first,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${team.name.isEmpty ? team.id : team.name} is choosing now',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$selectedCount/$SetupCategoryPickingSection.categoriesPerTeam',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(title),
      selected: isSelected,
      onSelected: onTap == null ? null : (_) => onTap!(),
    );
  }
}

class _TeamSelectionTile extends StatelessWidget {
  const _TeamSelectionTile({
    required this.team,
    required this.selectedCategoryTitles,
    required this.isCurrent,
  });

  final Team team;
  final List<String> selectedCategoryTitles;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final Color teamColor = Color(team.colorValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? teamColor : Colors.grey.shade300,
          width: isCurrent ? 1.4 : 1,
        ),
        color: isCurrent ? teamColor.withValues(alpha: 0.08) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 10,
                backgroundColor: teamColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  team.name.isEmpty ? team.id : team.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${selectedCategoryTitles.length}/3',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (selectedCategoryTitles.isEmpty)
            const Text('No categories selected yet.')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedCategoryTitles
                  .map(
                    (String title) => Chip(
                      label: Text(title),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}