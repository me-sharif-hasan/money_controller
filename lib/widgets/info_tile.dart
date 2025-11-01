import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const InfoTile({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: icon != null
            ? CircleAvatar(
                backgroundColor: (iconColor ?? primaryColor).withAlpha((0.1*255).round()),
                child: Icon(icon, color: iconColor ?? primaryColor),
              )
            : null,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        onTap: onTap,
        trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      ),
    );
  }
}

