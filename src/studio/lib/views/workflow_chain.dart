import 'package:flutter/material.dart';
import '../models/workflow.dart';
import '../constants.dart';

class WorkflowChain extends StatelessWidget {
  final WorkflowStep step;
  final bool isEnabled;

  const WorkflowChain({
    super.key,
    required this.step,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final arrowColor = isEnabled ? Colors.green : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _NodeBox(
              domain: domainLabel(step.sourceDomain),
              label: step.sourceEvent.split('.').last,
              icon: Icons.event,
              color: Colors.blue.shade100,
              textColor: Colors.blue.shade800,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward, color: arrowColor, size: 28),
                GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.settings, size: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: _NodeBox(
              domain: domainLabel(step.targetDomain),
              label: step.targetAction,
              icon: Icons.play_arrow,
              color: Colors.green.shade100,
              textColor: Colors.green.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

class _NodeBox extends StatelessWidget {
  final String domain;
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;

  const _NodeBox({
    required this.domain,
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(height: 4),
          Text(
            domain,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
