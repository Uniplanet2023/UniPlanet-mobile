import 'package:flutter/material.dart';
import 'package:uniplanet/core/utils/price_formatter.dart';

class PriceText extends StatelessWidget {
  final double price;
  final double? optionalPrice;

  const PriceText({
    super.key,
    required this.price,
    this.optionalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          // Strikethrough optional price (if provided) with grey color and thicker line
          if (optionalPrice != null) ...[
            TextSpan(
              text: '\$',
              style: TextStyle(
                color: Colors.black54, // Set color to grey
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough, // Apply strikethrough
                decorationThickness: 2.0, // Make the strikethrough line thicker
              ),
            ),
            TextSpan(
              text: '${PriceFormatter(optionalPrice!).getDigit()}.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54, // Set color to grey
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough, // Apply strikethrough
                decorationThickness: 2.0, // Make the strikethrough line thicker
              ),
            ),
            TextSpan(
              text: PriceFormatter(optionalPrice!).getDecimal(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54, // Set color to grey
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough, // Apply strikethrough
                decorationThickness: 2.0, // Make the strikethrough line thicker
              ),
            ),
            const TextSpan(text: '  '), // Add space between prices
          ],
          // Current price (no strikethrough, normal color)
          TextSpan(
            text: '\$',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '${PriceFormatter(price).getDigit()}.',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.tertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: PriceFormatter(price).getDecimal(),
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.tertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
