# UI/UX Design Guidelines - Product Audit Tool

This document defines the design system, color palette, shadow/elevation guidelines, and UI component patterns for the Product Audit Tool application, based on the IC Norte design system.

**Version:** 2.0  
**Last Updated:** 2025-01-27  
**Design System:** IC Norte Theme (`ic_norte_theme`)

---

## Table of Contents

1. [Color System](#color-system)
2. [Typography](#typography)
3. [Spacing & Layout](#spacing--layout)
4. [Border Radius](#border-radius)
5. [Shadow & Elevation](#shadow--elevation)
6. [Component Patterns](#component-patterns)
7. [Status Indicators](#status-indicators)
8. [Responsive Design](#responsive-design)
9. [Accessibility](#accessibility)
10. [Internationalization](#internationalization)

---

## Color System

The Product Audit Tool uses the IC Norte design system color tokens. Always use theme tokens instead of hardcoded colors.

### Brand Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `brandForest` | `#1C4922` | App bar background, splash screens, brand highlights |
| `brandPrimary` | `#3BB947` | Primary CTAs, buttons, selected states |
| `brandSecondary` | `#2D9637` | Secondary accents, badges, chips |

### Status Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `statusSuccess` | `#3BB947` | Success states, approved items, processed OK |
| `statusError` | `#E1362C` | Error states, rejected items, processing errors |
| `statusWarning` | `#E7A300` | Warning states, pending operations |
| `statusInfo` | `#1B74E4` | Informational states |

**Product Audit Tool Status Mapping:**
- **Processing OK** → `statusSuccess` (#3BB947)
- **Processing Error** → `statusError` (#E1362C)
- **Pending** → `statusWarning` (#E7A300)
- **Unknown** → Neutral grey (see Text Colors)

### Background Colors (Light Mode)

| Token | Hex | Usage |
|-------|-----|-------|
| `bgPrimary` | `#F3F5F8` | Page background (Marfil) |
| `bgSurface` | `#FFFFFF` | Card backgrounds, input fields (White) |
| `bgSurfaceAlt` | `#EBEEF5` | Elevated surfaces, subtle backgrounds (Marfil azulado) |

### Background Colors (Dark Mode)

| Token | Hex | Usage |
|-------|-----|-------|
| `bgPrimary` | `#000000` | Page background (Pure black, OLED-friendly) |
| `bgSurface` | `#16181D` | Card backgrounds (Gris carbón) |
| `bgSurfaceAlt` | `#1D2026` | Elevated surfaces (Gris carbón elevado) |

### Text Colors (Light Mode)

| Token | Hex | Usage |
|-------|-----|-------|
| `textPrimary` | `#000000` | Primary text content |
| `textSecondary` | `#B5B7C1` | Secondary text, metadata, labels |
| `textOnBrand` | `#FFFFFF` | Text on brand-colored backgrounds |
| `textOnError` | `#FFFFFF` | Text on error backgrounds |

### Text Colors (Dark Mode)

| Token | Hex | Usage |
|-------|-----|-------|
| `textPrimary` | `#F4F6F8` | Primary text content (Off-white) |
| `textSecondary` | `#AAB2BC` | Secondary text, metadata (Light gray) |
| `textOnBrand` | `#FFFFFF` | Text on brand-colored backgrounds |
| `textOnError` | `#FFFFFF` | Text on error backgrounds |

### Border Colors

| Token | Hex (Light) | Hex (Dark) | Usage |
|-------|-------------|------------|-------|
| `borderSubtle` | `#E7E9EE` | `#262A31` | Hairline borders, dividers |

### Usage in Flutter

```dart
import 'package:ic_norte_theme/ic_norte_theme.dart';

// Context-aware (auto-detects theme):
final colors = ICNColors.of(context);
Container(color: colors.bgSurface)
Text('Hello', style: TextStyle(color: colors.textPrimary))

// Explicit light/dark:
Container(color: ICNColors.light.bgSurface)
Container(color: ICNColors.dark.bgSurface)

// Brand colors (same in both themes):
Container(color: ICNColors.brandPrimary)
Container(color: ICNColors.brandForest)
```

### Opacity Guidelines

Use consistent opacity values for visual hierarchy:

| Opacity | Usage | Example |
|---------|-------|---------|
| **0.08** | Card shadows | `Colors.black.withOpacity(0.08)` |
| **0.1** | Background tints for status chips | `statusSuccess.withOpacity(0.1)` |
| **0.3** | Border colors, subtle dividers | `statusSuccess.withOpacity(0.3)` |
| **0.5** | Disabled states, secondary actions | `statusSuccess.withOpacity(0.5)` |
| **0.85** | Strong shadows (max) | `Colors.black.withOpacity(0.85)` |
| **0.9** | Badge backgrounds, overlays | `statusSuccess.withOpacity(0.9)` |

### Color Application Rules

1. **Status Chips:**
   ```dart
   backgroundColor: statusColor.withOpacity(0.1)
   side: BorderSide(color: statusColor.withOpacity(0.3))
   ```

2. **Action Buttons:**
   - Active: Full color (`ICNColors.brandPrimary`, `ICNColors.statusError`)
   - Disabled: `color.withOpacity(0.5)`
   - Background when selected: `color.withOpacity(0.1)`

3. **Badges/Indicators:**
   - Background: `statusColor.withOpacity(0.9)`
   - Text: `ICNColors.textOnBrand` (white)

### Color Usage Rules

✅ **DO:**
- Always use theme tokens: `context.colors.bgSurface`
- Use `Colors.black.withOpacity()` for shadows (0.0-0.85 range)
- Use `Colors.white.withOpacity()` for highlights (0.0-0.30 range)
- Use `Colors.transparent` for transparent backgrounds

❌ **DON'T:**
- Hardcode colors: `Color(0xFFFFFFFF)` or `Colors.white`
- Use Material colors directly: `Colors.red`, `Colors.blue`
- Use deprecated flat accessors: `ICNColors.bgPrimary` (use `ICNColors.light.bgPrimary`)

---

## Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4px | Small elements |
| `small` | 8px | Small rounded corners |
| `medium` | 12px | Cards, buttons, inputs (main) |
| `large` | 16px | Large cards, modals |
| `extraLarge` | 24px | Extra large elements |
| `full` | 999px | Pills, circles |
| `card` | 16px | Card radius |
| `button` | 12px | Button radius |
| `input` | 12px | Input radius |
| `chip` | 12px | Chip radius |

### Usage in Flutter

```dart
import 'package:ic_norte_theme/ic_norte_theme.dart';

// Border radius:
BorderRadius.circular(ICNRadius.medium)
ICNRadius.cardBorderRadius  // Pre-built BorderRadius
ICNRadius.stadiumBorder     // Pill shape
ICNRadius.circleBorder      // Circle shape
```

### Product Audit Tool Specific

- **Cards:** `ICNRadius.card` (16px) for top corners, `ICNRadius.medium` (12px) for general cards
- **Badges:** `ICNRadius.xs` (4px)
- **Chips:** `ICNRadius.chip` (12px)

---

## Shadow & Elevation

### Elevation Levels

| Token | Value | Usage |
|-------|-------|-------|
| `none` | 0px | No shadow |
| `xs` | 1px | Subtle shadows (inputs) |
| `sm` | 2px | Light shadows (cards, buttons) |
| `md` | 4px | Medium shadows (product cards) |
| `lg` | 8px | Strong shadows (modals) |
| `xl` | 16px | Very strong shadows (overlays) |

### Shadow Usage

```dart
// ✅ GOOD - Shadow with opacity
BoxShadow(
  color: Colors.black.withOpacity(0.08),  // 0.0-0.85 range
  blurRadius: 8,
  offset: Offset(0, 2),
)

// ❌ BAD - Solid black shadow
BoxShadow(color: Colors.black, blurRadius: 8)
```

### Component Elevation

| Component | Elevation | Shadow | Usage |
|-----------|-----------|--------|-------|
| **Cards** | `ICNElevation.md` (4px) | `Colors.black.withOpacity(0.08)`, blur 8px | Image review cards, session list items |
| **App Bar** | 0px | No shadow | Standard AppBar |
| **Bottom Toolbar** | Custom | `BoxShadow` with `0.1` opacity, blur 4px | Floating action areas |
| **Dialogs** | `ICNElevation.lg` (8px) | Material default | Modal dialogs (if used) |

### Shadow Guidelines

1. **Minimal Shadows:** Use shadows sparingly for depth, not decoration
2. **Consistent Elevation:** Maintain consistent elevation levels across similar components
3. **Opacity Range:** Use `Colors.black.withOpacity()` in 0.0-0.85 range
4. **Performance:** Prefer Material elevation over custom shadows when possible
5. **Accessibility:** Ensure sufficient contrast with shadows

---

## Typography

### Font Family

- **Primary:** System UI (with fallbacks: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, sans-serif)

### Text Styles

| Style | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| `displayLarge` | 32px | 800 | 1.15 | Hero titles, landing pages |
| `displayMedium` | 30px | 800 | 1.15 | Large section headers |
| `displaySmall` | 28px | 800 | 1.15 | Medium section headers |
| `headlineLarge` | 18px | 800 | 1.15 | Section titles, product names |
| `headlineMedium` | 18px | 800 | 1.15 | Product titles, card headers |
| `headlineSmall` | 18px | 800 | 1.15 | Subsection titles |
| `titleLarge` | 16px | 700 | 1.20 | Card titles, form labels |
| `titleMedium` | 14px | 600 | 1.20 | Small titles, metadata |
| `titleSmall` | 14px | 600 | 1.20 | Micro titles |
| `bodyLarge` | 14px | 500 | 1.35 | Primary body text |
| `bodyMedium` | 14px | 400 | 1.35 | Secondary body text |
| `bodySmall` | 14px | 400 | 1.35 | Tertiary text, captions |
| `labelLarge` | 12px | 600 | 1.20 | Form labels, badges |
| `labelMedium` | 12px | 600 | 1.20 | Small labels |
| `labelSmall` | 12px | 600 | 1.20 | Micro labels |

### Product Audit Tool Specific Styles

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| `titleLarge` | 16px | 700 | Screen titles, card headers |
| `titleMedium` | 14px | 600 | Image index, metadata |
| `bodyMedium` | 14px | 400 | Primary content, descriptions |
| `bodySmall` | 14px | 400 | Timestamps, secondary info |
| `labelLarge` | 12px | 600 | Status chip labels |
| `labelSmall` | 10px | 700 | Badge text ("Processed") |

### Usage in Flutter

```dart
import 'package:ic_norte_theme/ic_norte_theme.dart';

// Standard Material styles:
Text('Title', style: ICNTypography.headlineLarge)
Text('Body', style: ICNTypography.bodyMedium)

// With color:
Text('Title', style: ICNTypography.titleLarge.copyWith(
  color: ICNColors.of(context).textPrimary,
))
```

### Typography Hierarchy

1. **Primary Text:** Use `ICNTypography.titleLarge` for important information
2. **Secondary Text:** Use `ICNTypography.bodySmall` with `textSecondary` color for metadata
3. **Status Text:** Use status colors with `ICNTypography.labelLarge`
4. **Badge Text:** Use `ICNTypography.labelSmall` (10px, bold)

---

## Component Patterns

### AppBar Patterns

**Primary/Navigation Pages** (Home, Audit Review):
- Green brand AppBar (`brandForest` #1C4922)
- Logo, navigation icons, search (if applicable)
- Full brand presence

**Detail/Secondary Pages** (Session Details):
- Silver bar ONLY (light gray background)
- Centered bold black title (`ICNTypography.titleLarge`, weight 800)
- Back button (44×44dp tap target)
- White/light gray background (`bgSurface`)
- Subtle bottom border (`borderSubtle`)

### Status Chips

**Pattern:**
- Icon (16px) + Label text
- Background: `statusColor.withOpacity(0.1)`
- Border: `statusColor.withOpacity(0.3)`
- Text color: Status color
- Font: `ICNTypography.labelLarge` (12px, weight 600)
- Border radius: `ICNRadius.chip` (12px)
- Padding: `EdgeInsets.symmetric(horizontal: ICNSpacing.xs, vertical: 0)`

**Example:**
```dart
Chip(
  avatar: Icon(icon, size: 16, color: statusColor),
  label: Text(label, style: ICNTypography.labelLarge.copyWith(color: statusColor)),
  backgroundColor: statusColor.withOpacity(0.1),
  side: BorderSide(color: statusColor.withOpacity(0.3)),
  padding: EdgeInsets.symmetric(horizontal: ICNSpacing.xs, vertical: 0),
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ICNRadius.chip)),
)
```

### Cards

**Pattern:**
- Background: `ICNColors.of(context).bgSurface`
- Padding: `ICNSpacing.md` (12px)
- Border radius: `ICNRadius.card` (16px) or `ICNRadius.medium` (12px)
- Shadow: `Colors.black.withOpacity(0.08)`, blur 8px, offset (0, 2)
- Elevation: `ICNElevation.md` (4px)
- Margin: `EdgeInsets.symmetric(horizontal: ICNSpacing.lg, vertical: ICNSpacing.sm)`

**Image Cards:**
- Image height: 200px
- Border radius: Top corners only (`BorderRadius.vertical(top: Radius.circular(ICNRadius.card))`)
- Full width with `BoxFit.cover`

### Action Buttons

**Pattern:**
- Style: `OutlinedButton.icon`
- Icon size: 18px
- Full width with `Expanded` widget
- Spacing: `ICNSpacing.sm` (8px) between buttons
- Border radius: `ICNRadius.button` (12px)
- Padding: `EdgeInsets.symmetric(horizontal: ICNSpacing.sm, vertical: 6)`

**Button Variants:**

| Variant | Background | Text | Usage |
|---------|------------|------|-------|
| Primary | `brandPrimary` (#3BB947) | White | Main actions |
| Destructive | `statusError` (#E1362C) | White | Delete, reject |
| Outline | Transparent | `brandPrimary` | Approve, secondary actions |

**States:**
- **Default:** Colored border (`color.withOpacity(0.5)`)
- **Selected/Active:** Colored border (full color) + background (`color.withOpacity(0.1)`)
- **Disabled:** `onPressed: null` (Material handles disabled state)

**Colors:**
- Approve: `ICNColors.brandPrimary` (#3BB947)
- Reject: `ICNColors.statusError` (#E1362C)

### Badges/Indicators

**Pattern:**
- Position: Top-right corner (`Positioned(top: ICNSpacing.sm, right: ICNSpacing.sm)`)
- Background: `statusColor.withOpacity(0.9)`
- Text: `ICNColors.textOnBrand` (white), `ICNTypography.labelSmall` (10px, bold)
- Padding: `EdgeInsets.symmetric(horizontal: 6, vertical: 2)`
- Border radius: `ICNRadius.xs` (4px)

**Example:**
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  decoration: BoxDecoration(
    color: ICNColors.statusSuccess.withOpacity(0.9),
    borderRadius: BorderRadius.circular(ICNRadius.xs),
  ),
  child: Text('Processed', style: ICNTypography.labelSmall.copyWith(color: ICNColors.textOnBrand)),
)
```

### Input Fields

**Pattern:**
- Background: `bgPrimary` (light mode) or `bgSurface` (dark mode)
- Border: `borderSubtle` color, 1px width
- Border radius: `ICNRadius.input` (12px)
- Padding: `ICNSpacing.inputPadding` (12px)
- Focus border: `brandPrimary` color

---

## Spacing & Layout

### Spacing Scale (4px base unit)

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4px | Minimal spacing |
| `sm` | 8px | Base unit, tight spacing, button gaps |
| `md` | 12px | Standard spacing, card padding |
| `lg` | 16px | Section spacing, page padding |
| `xl` | 20px | Large spacing |
| `xxl` | 24px | Extra large spacing |
| `xxxl` | 32px | Extra extra large spacing |

### Component-Specific Spacing

| Token | Value | Usage |
|-------|-------|-------|
| `cardPadding` | 12px | Card internal padding |
| `cardTextPadding` | 12/8/12/10 | Card text block padding |
| `imagePadding` | 12px | Image padding |
| `sectionSpacing` | 24px | Between sections |
| `pagePadding` | 16px | Page outer padding |
| `buttonPadding` | 8h/6v | Button padding |
| `inputPadding` | 12px | Input field padding |

### Usage in Flutter

```dart
import 'package:ic_norte_theme/ic_norte_theme.dart';

// Spacing:
Padding(padding: EdgeInsets.all(ICNSpacing.md))
SizedBox(height: ICNSpacing.lg)

// Responsive spacing:
ICNSpacing.getResponsiveSpacing(
  context,
  mobile: ICNSpacing.sm,
  tablet: ICNSpacing.md,
  desktop: ICNSpacing.lg,
)
```

### Layout Patterns

**Screen Padding:**
- Horizontal: `ICNSpacing.lg` (16px) for cards
- Vertical: `ICNSpacing.sm` (8px) for list items

**Card Padding:**
- Content: `ICNSpacing.md` (12px) all sides
- Image: No padding (full bleed)

**Button Spacing:**
- Between buttons: `ICNSpacing.sm` (8px)
- Button padding: `EdgeInsets.symmetric(horizontal: ICNSpacing.sm, vertical: 6)`

**Chip Spacing:**
- Between chips: `ICNSpacing.sm` (8px)
- Chip padding: `EdgeInsets.symmetric(horizontal: ICNSpacing.xs, vertical: 0)`

---

## Status Indicators

### Processing Status

| Status | Color | Icon | Label |
|--------|-------|------|-------|
| Unknown | Grey | `Icons.help_outline` | "Unknown" |
| Pending | Orange | `Icons.hourglass_empty` | "Pending" |
| Processed OK | Green | `Icons.check_circle` | "Processed" |
| Error | Red | `Icons.error` | "Error" |

### Review Status

| Status | Color | Icon | Label |
|--------|-------|------|-------|
| Not Reviewed | Grey | `Icons.radio_button_unchecked` | "Not reviewed" |
| Approved | Green | `Icons.check_circle` | "Approved" |
| Rejected | Red | `Icons.cancel` | "Rejected" |

### Summary Status (Session Level)

| Status | Color | Icon | Label |
|--------|-------|------|-------|
| Unreviewed | Grey | `Icons.radio_button_unchecked` | "Unreviewed" |
| Fully Approved | Green | `Icons.check_circle` | "Approved" |
| Partially Approved | Orange | `Icons.check_circle_outline` | "Partial" |
| Fully Rejected | Red | `Icons.cancel` | "Rejected" |

---

## Interactive Elements

### Buttons

**Primary Actions:**
- Use `ElevatedButton` for primary actions
- Use `OutlinedButton` for secondary actions
- Icon buttons: `IconButton` with appropriate tooltips

**Button States:**
- Enabled: Full color
- Disabled: `onPressed: null` (Material handles)
- Loading: Show `CircularProgressIndicator`

### Filters

**Filter Chips:**
- Use `FilterChip` widget
- Selected state: Material default
- Spacing: 8px between chips
- Horizontal layout with `Row`

### Lists

**List Items:**
- Use `Card` with `ListTile` for session items
- Tap target: Full card area
- Visual feedback: Material ripple effect

### Images

**Image Display:**
- Height: 200px for thumbnails
- Fit: `BoxFit.cover`
- Loading: `CircularProgressIndicator` with progress
- Error: Placeholder icon (`Icons.broken_image`)

---

## Responsive Design

### Breakpoints

| Breakpoint | Width | Usage |
|------------|-------|-------|
| Mobile | ≤ 599px | Single column, full-width |
| Tablet | 600px - 1023px | 2-3 columns, adaptive layout |
| Desktop | ≥ 1024px | Multi-column, fixed widths |

### Grid System

| Screen Size | Columns | Row Depth |
|-------------|---------|-----------|
| Mobile | ≤ 4 per row | Flexible |
| Tablet | 6-deep rows | 6 items |
| Desktop | Single-row collections | Horizontal scroll |

### Usage in Flutter

```dart
import 'package:ic_norte_theme/ic_norte_theme.dart';

// Breakpoint checks:
ICNBreakpoints.isMobile(context)
ICNBreakpoints.isTablet(context)
ICNBreakpoints.isDesktop(context)

// Get breakpoint type:
final type = ICNBreakpoints.getBreakpointType(context);

// Responsive spacing:
ICNSpacing.getResponsiveSpacing(
  context,
  mobile: ICNSpacing.sm,
  tablet: ICNSpacing.md,
  desktop: ICNSpacing.lg,
)
```

---

## Accessibility

### Minimum Requirements

- **Tap Targets:** Minimum 44×44dp for all interactive elements
- **Text Scaling:** Support up to 200% without layout breakage
- **Contrast:** AA standard (4.5:1 for text, 3:1 for UI elements)
- **Semantics:** Labels on icons/images, meaningful button labels

### Implementation

```dart
// ✅ GOOD - Accessible button
Semantics(
  label: 'Approve image',
  button: true,
  child: IconButton(
    icon: Icon(Icons.check),
    onPressed: () {},
  ),
)

// ✅ GOOD - Accessible image
Semantics(
  label: 'Product image #1',
  image: true,
  child: Image.network(url),
)
```

### States

All interactive components must support:

- **Hover:** Visual feedback on hover (desktop)
- **Focus:** Clear focus indicators (keyboard navigation)
- **Pressed:** Pressed state feedback
- **Disabled:** Muted appearance, non-interactive

### Color Contrast

- Ensure WCAG AA compliance (4.5:1 for normal text, 3:1 for large text)
- Status colors should have sufficient contrast on backgrounds
- Use opacity carefully to maintain readability
- Test with `ICNColors` theme tokens for proper contrast

### Visual Hierarchy

- Use color, size, and weight to establish hierarchy
- Important information: Bold (`ICNTypography.titleLarge`), larger, colored
- Secondary information: Regular (`ICNTypography.bodySmall`), smaller, `textSecondary` color

---

## Internationalization (i18n)

### Key Naming Convention

Follow `feature_section_name` pattern:

- `audit_session_title` → Audit session page title
- `audit_image_captured_at` → "Captured at" label
- `audit_status_processed` → "Processed" status label
- `audit_action_approve` → "Approve" button label
- `audit_action_reject` → "Reject" button label

### Usage

```dart
// ✅ GOOD - Localized text
Text(l10n.getString('audit_session_title'))

// ❌ BAD - Hardcoded text
Text('Audit Session')
```

### Date/Time Formatting

```dart
// Format: dd/MM/yyyy HH:mm (24-hour)
final formatter = IcnFormatters.dateTime(Locale('es', 'BO'));
formatter.format(DateTime.now())  // → "17/10/2025 14:30"
```

---

## Dark Mode Support

### Current Status

The app uses IC Norte theme system with full dark mode support:

1. **Status Colors:** Maintain same semantic colors (brandPrimary, statusError, statusWarning)
2. **Backgrounds:** Use `ICNColors.of(context).bgSurface` (auto-detects theme)
3. **Text:** Use `ICNColors.of(context).textPrimary` (auto-detects theme)
4. **Cards:** Use `ICNColors.of(context).bgSurface` for containers

### Dark Mode Considerations

- All color tokens automatically adapt to theme
- Test all status colors in both light and dark modes
- Ensure badges remain readable with proper contrast
- Maintain visual hierarchy across themes
- Use `ICNColors.of(context)` for context-aware colors

---

## Implementation Checklist

Before committing UI changes:

- [ ] **Colors:** Use `ICNColors.of(context).*` tokens, no hardcoded colors
- [ ] **Typography:** Use `ICNTypography.*` styles, no inline TextStyle
- [ ] **Spacing:** Use `ICNSpacing.*` tokens, no magic numbers
- [ ] **Border Radius:** Use `ICNRadius.*` tokens
- [ ] **Shadows:** Use `Colors.black.withOpacity(0.08)` range (0.0-0.85)
- [ ] **Responsive:** Test mobile/tablet/desktop breakpoints
- [ ] **Accessibility:** 44×44dp tap targets, semantic labels, AA contrast
- [ ] **i18n:** All user-facing text localized, no hardcoded strings
- [ ] **States:** Hover, focus, pressed, disabled states implemented
- [ ] **Dark Mode:** Tested in both light and dark themes

---

## Examples

### Status Chip Example
```dart
import 'package:ic_norte_theme/ic_norte_theme.dart';

Chip(
  avatar: Icon(Icons.check_circle, size: 16, color: ICNColors.statusSuccess),
  label: Text('Processed', style: ICNTypography.labelLarge.copyWith(color: ICNColors.statusSuccess)),
  backgroundColor: ICNColors.statusSuccess.withOpacity(0.1),
  side: BorderSide(color: ICNColors.statusSuccess.withOpacity(0.3)),
  padding: EdgeInsets.symmetric(horizontal: ICNSpacing.xs, vertical: 0),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ICNRadius.chip)),
)
```

### Action Button Example
```dart
import 'package:ic_norte_theme/ic_norte_theme.dart';

OutlinedButton.icon(
  onPressed: onApprove,
  icon: Icon(Icons.check, size: 18),
  label: Text('Approve', style: ICNTypography.buttonText),
  style: OutlinedButton.styleFrom(
    foregroundColor: ICNColors.brandPrimary,
    side: BorderSide(color: ICNColors.brandPrimary.withOpacity(0.5)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ICNRadius.button)),
    padding: EdgeInsets.symmetric(horizontal: ICNSpacing.sm, vertical: 6),
  ),
)
```

### Badge Example
```dart
import 'package:ic_norte_theme/ic_norte_theme.dart';

Container(
  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  decoration: BoxDecoration(
    color: ICNColors.statusSuccess.withOpacity(0.9),
    borderRadius: BorderRadius.circular(ICNRadius.xs),
  ),
  child: Text('Processed', style: ICNTypography.labelSmall.copyWith(color: ICNColors.textOnBrand)),
)
```

### Card Example
```dart
import 'package:ic_norte_theme/ic_norte_theme.dart';

Card(
  margin: EdgeInsets.symmetric(horizontal: ICNSpacing.lg, vertical: ICNSpacing.sm),
  elevation: ICNElevation.md,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ICNRadius.card)),
  child: Container(
    padding: EdgeInsets.all(ICNSpacing.md),
    decoration: BoxDecoration(
      color: ICNColors.of(context).bgSurface,
      borderRadius: BorderRadius.circular(ICNRadius.card),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Text('Card content', style: ICNTypography.bodyMedium),
  ),
)
```

---

## Additional Resources

- **Theme Package:** `ic_norte_theme` (monorepo)
- **Design System:** `ic_norte_theme/DESIGN_SYSTEM.md`
- **Color Guidelines:** `ic_norte_ecommerce/docs/COLOR_USAGE_GUIDELINES.md`
- **UI/UX Playbook:** `ic_norte_ecommerce/docs/condensed/C_UI_UX_PLAYBOOK.md`

---

**Last Updated:** 2025-01-27  
**Version:** 2.0  
**Design System:** IC Norte Theme

