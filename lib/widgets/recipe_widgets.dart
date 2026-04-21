import 'package:flutter/material.dart';
import '../theme/app_design.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String time;
  final String cuisine;
  final String views;
  final double? width;
  final double height;
  final int missingCount;
  final List<String>? missingNames;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.time,
    required this.cuisine,
    this.views = "",
    this.width,
    this.height = 400,
    this.missingCount = 0,
    this.missingNames,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width * 0.7,
        height: height,
        decoration: AppDesign.cardDecoration(context).copyWith(
          image: DecorationImage(
            image: imagePath.startsWith('http')
                ? NetworkImage(imagePath) as ImageProvider
                : AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDesign.borderRadiusLarge),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.05),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          padding: EdgeInsets.all(AppDesign.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Badge for Ready/Almost
              if (missingCount == 0)
                _StatusBadge(
                  text: "READY",
                  color: AppColors.accent,
                  icon: Icons.check_circle_rounded,
                )
              else
                _StatusBadge(
                  text: "+ $missingCount MORE",
                  color: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppDesign.headingMedium(
                  context,
                ).copyWith(color: Colors.white, fontSize: 20),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (missingNames != null && missingNames!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Missing: ${missingNames!.join(', ')}",
                    style: AppDesign.bodySmall(context).copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              Row(
                children: [
                  _InfoChip(label: time),
                  const SizedBox(width: 8),
                  _InfoChip(label: cuisine),
                  if (views.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    _InfoChip(label: views),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color? backgroundColor;
  final IconData? icon;

  const _StatusBadge({
    required this.text,
    required this.color,
    this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppDesign.bodySmall(context).copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: AppDesign.bodySmall(
          context,
        ).copyWith(color: Colors.white, fontSize: 11),
      ),
    );
  }
}

class PantryChip extends StatelessWidget {
  final String name;
  final String icon;

  const PantryChip({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            name,
            style: AppDesign.bodyMedium(
              context,
            ).copyWith(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceGrey,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppDesign.bodyMedium(context).copyWith(
            color: isActive ? Colors.white : AppColors.textHeading(context),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final String title;
  final String value;

  const StatTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppDesign.headingMedium(context).copyWith(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(value, style: AppDesign.bodySmall(context)),
      ],
    );
  }
}

class AccordionSection extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final Color? backgroundColor;

  const AccordionSection({
    super.key,
    required this.title,
    required this.children,
    this.backgroundColor,
  });

  @override
  State<AccordionSection> createState() => _AccordionSectionState();
}

class _AccordionSectionState extends State<AccordionSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(AppDesign.borderRadiusMedium),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) =>
              setState(() => _isExpanded = expanded),
          title: Text(
            widget.title,
            style: AppDesign.headingMedium(context).copyWith(fontSize: 20),
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: AppColors.textHeading(context),
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDesign.padding,
                0,
                AppDesign.padding,
                AppDesign.padding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final IconData? icon;

  final TextEditingController? controller;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.icon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppDesign.bodySmall(context).copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textHeading(context).withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceGrey,
            borderRadius: BorderRadius.circular(AppDesign.borderRadiusMedium),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppDesign.bodyMedium(
                context,
              ).copyWith(color: AppColors.textBody(context).withOpacity(0.3)),
              prefixIcon: icon != null
                  ? Icon(
                      icon,
                      size: 20,
                      color: AppColors.textBody(context).withOpacity(0.4),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDesign.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),

        decoration: BoxDecoration(
          border: Border.all(color: AppColors.surfaceGrey, width: 2),
          borderRadius: BorderRadius.circular(AppDesign.borderRadiusMedium),
        ),
        child: icon,
      ),
    );
  }
}
