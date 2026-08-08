import 'package:flutter/material.dart';
import '../models/event.dart';
import '../constants.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDeprecated = event.status == 'deprecated';
    final isChangePending = event.status == 'change_pending';

    return Card(
      child: Container(
        decoration: isChangePending
            ? BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.orange.shade400, width: 4),
                ),
              )
            : null,
        child: ListTile(
          onTap: onTap,
          enabled: !isDeprecated,
          title: Text(
            event.type,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              decoration: isDeprecated ? TextDecoration.lineThrough : null,
              color: isDeprecated ? Colors.grey : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                domainLabel(event.source),
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 12),
              ),
              Text(
                event.description,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                backgroundColor: eventDirectionColor(event.direction),
                textStyle: const TextStyle(color: Colors.white, fontSize: 10),
                label: Text(eventDirectionLabel(event.direction), style: const TextStyle(fontSize: 10)),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event.version,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11),
                  ),
                  Text(
                    '${event.subscriberCount} 订阅',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
