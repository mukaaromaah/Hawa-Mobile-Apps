---
name: Minimal Mint
colors:
  surface: '#e7fff2'
  surface-dim: '#c1e1d1'
  surface-bright: '#e7fff2'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#dafbea'
  surface-container: '#d4f5e5'
  surface-container-high: '#cff0df'
  surface-container-highest: '#c9ead9'
  on-surface: '#022016'
  on-surface-variant: '#404942'
  inverse-surface: '#19362b'
  inverse-on-surface: '#d7f8e8'
  outline: '#707971'
  outline-variant: '#c0c9bf'
  surface-tint: '#2f6a46'
  primary: '#004425'
  on-primary: '#ffffff'
  primary-container: '#205c3a'
  on-primary-container: '#95d2a7'
  inverse-primary: '#97d4a9'
  secondary: '#3e674f'
  on-secondary: '#ffffff'
  secondary-container: '#bfedcf'
  on-secondary-container: '#446d55'
  tertiary: '#004427'
  on-tertiary: '#ffffff'
  tertiary-container: '#005e37'
  on-tertiary-container: '#82d6a2'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#b2f1c4'
  primary-fixed-dim: '#97d4a9'
  on-primary-fixed: '#00210f'
  on-primary-fixed-variant: '#135130'
  secondary-fixed: '#bfedcf'
  secondary-fixed-dim: '#a4d1b4'
  on-secondary-fixed: '#002112'
  on-secondary-fixed-variant: '#264f39'
  tertiary-fixed: '#9ff5bf'
  tertiary-fixed-dim: '#84d8a4'
  on-tertiary-fixed: '#002110'
  on-tertiary-fixed-variant: '#005230'
  background: '#e7fff2'
  on-background: '#022016'
  surface-variant: '#c9ead9'
typography:
  display-hero:
    fontFamily: Outfit
    fontSize: 64px
    fontWeight: '700'
    lineHeight: 72px
    letterSpacing: -0.03em
  display-hero-mobile:
    fontFamily: Outfit
    fontSize: 44px
    fontWeight: '700'
    lineHeight: 52px
    letterSpacing: -0.02em
  headline-metric:
    fontFamily: Outfit
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-metric-mobile:
    fontFamily: Outfit
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Outfit
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Outfit
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 30px
    letterSpacing: 0em
  title-sm:
    fontFamily: Outfit
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: 0em
  body-lg:
    fontFamily: Outfit
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-md:
    fontFamily: Outfit
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0em
  status-pill:
    fontFamily: Outfit
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-caps:
    fontFamily: Outfit
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.06em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1.5rem
  gutter-mobile: 1rem
  margin: 3rem
  margin-mobile: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.5rem
---

## Brand & Style

This design system embodies environmental wellness, quiet atmospheric data, and sensory calm. Tailored for conscious living, ecological monitoring, and restorative well-being, the aesthetic prioritizes extreme clarity and breathing room over visual noise. 

The visual movement blends **Minimalism** with organic, tactile **Pill-Form Data Structures**. Information is expressed through weightless surfaces, crisp environmental metrics, and floating data bubbles rather than dense grids. The interface instills a sense of renewal, pure air, and reassuring balance—completely steering clear of technical coldness or heavy industrial tones.

## Colors

The palette draws strictly from botanical and atmospheric greens, balanced against pale sage grounds. Dark modes and saturated blues are deliberately excluded to maintain an unbroken sense of daytime purity.

- **Primary (`#205C3A`)**: Deep forest green. Dictates primary action points, selected states, key interactive indicators, and primary visual emphasis.
- **Secondary (`#A8D5B8`)**: Soft spring mint. Reserved for subtle dividing borders, track lines, secondary interactive states, and soft outlines.
- **Tertiary (`#55A878`)**: Active vegetative green. Denotes optimal health states, positive trend paths, and safe baseline ranges.
- **Surfaces**: 
  - Canvas Ground: `#EAF5EE` (soothing tinted air/sage).
  - Secondary Underlay: `#F4FAF6` (recessed grouping sections).
  - Card & Container: `#FFFFFF` (pristine floating islands).
- **Text Roles**:
  - Primary Text: `#18352A` (deepest herbal slate for effortless readability).
  - Secondary Text: `#71847A` (muted sage gray for labels, timestamps, and secondary descriptors).
- **Diagnostic Feedback**:
  - Safe / Optimal: `#55A878`
  - Caution / Warning: `#E9A23B`
  - Critical / Action Needed: `#D96C6C`

## Typography

The type system relies on pure geometric modernism through clean circular letterforms, delivering effortless scannability. Large numerical figures take visual precedence, anchoring the user's attention, while secondary descriptors remain short, light, and unobtrusive.

- **Numerical Hierarchy**: Environmental values, scores, and indices use `display-hero` or `headline-metric` at 700 weight with tight negative letter-spacing to present data as self-contained graphic elements.
- **Section Headers**: Structured via `headline-lg` and `headline-md` at 600 weight, creating decisive grouping without visual weightiness.
- **Metadata & Labels**: Kept crisp via `label-caps` in uppercase tracking or `status-pill` in medium weight, maintaining balance against voluminous rounded containers.

## Layout & Spacing

The layout model favors fluid, airy compositions with generous outer buffers to evoke room to breathe.

- **Grid Structure**: A flexible 12-column system on desktop collapsing to 6 columns on tablet and 2 columns on mobile. Cards and bubble clusters utilize internal flex layouts to auto-flow metrics gracefully.
- **Rhythm**: Generous section margins (`margin: 3rem`) separate distinct data zones, preventing the interface from feeling dense. Compact metric clusters lean on `space-sm` and `space-md` internally, surrounded by expansive card padding (`space-lg` to `space-xl`).
- **Breakpoints**:
  - `Desktop (> 1024px)`: Multi-column modular cards with asymmetrical balance.
  - `Tablet (768px – 1023px)`: 2-column balanced layouts; metric bubbles adapt to horizontal rows.
  - `Mobile (< 767px)`: Single-column vertical stream, full-width white islands, and horizontal swipe carousels for data bubbles.

## Elevation & Depth

Visual hierarchy is constructed entirely through **tonal layering** and **diffuse ambient illumination**, eliminating heavy or gray drop-shadows.

- **Base Ground**: `#EAF5EE` provides an organic, light-absorbing foundation.
- **Mid-Tier (Recessed Wells)**: `#F4FAF6` creates inset metric nests or contextual groupings directly on the base canvas without borders.
- **Top-Tier Surfaces (Cards & Bubbles)**: Pure `#FFFFFF` surfaces sit raised with an ultra-soft botanical ambient glow:
  - `box-shadow: 0 8px 30px -4px rgba(24, 53, 42, 0.04), 0 2px 6px -1px rgba(24, 53, 42, 0.02)`
- **Low-Contrast Outlines**: When crisp structure is needed within cards, a delicate 1px boundary of `#A8D5B8` at 50% opacity is used rather than high-contrast dividing rules.

## Shapes

The design system embraces an ultra-rounded visual geometry dominated by 24px container radiuses and 9999px fully-rounded pills.

- **Cards & Modules**: Bound by a standard radius of `1.5rem` (24px), providing gentle contouring that feels friendly and organic.
- **Data Bubbles & Status Tags**: Fully pill-shaped (`9999px`), wrapping numerical data, progress indicators, chips, and quick filters into frictionless capsules.
- **Interactive Controls**: Buttons and inputs share the continuous pill profile (`9999px`), reinforcing physical softness across touchpoints.

## Components

- **Buttons**:
  - *Primary*: Full pill radius (`rounded-full`), solid `#205C3A` fill, white `#FFFFFF` text. Hover state shifts smoothly to `#18352A`.
  - *Secondary*: Pill radius, `#F4FAF6` fill with a crisp 1px `#A8D5B8` border, `#205C3A` text.
  - *Sizing*: 48px height for comfortable touch ergonomics, 24px horizontal padding.
- **Data Bubbles (Signature Element)**:
  - Free-standing or card-nested capsules (`rounded-full`) engineered for metrics.
  - Background: `#FFFFFF` or `#F4FAF6` with subtle inner padding (`space-xs` vertical, `space-md` horizontal).
  - Structure: Number (e.g., "42") rendered in `headline-metric`, accompanied by a tiny upper-case metric label (e.g., "AQI") and a colored status dot.
- **Status Chips**:
  - Compact pills (`rounded-full`) utilizing 10% opacity tints of the status color for the fill, pairing with full-saturation text (`#55A878` for Good, `#E9A23B` for Fair, `#D96C6C` for Critical).
- **Cards**:
  - White `#FFFFFF` slabs with `rounded-3xl` (24px) corners, padded with `space-lg` or `space-xl`.
  - No sharp interior divider lines; content separation is achieved through white space or nested `#F4FAF6` rounded panels.
- **Inputs & Form Controls**:
  - Background `#FFFFFF` with 1.5px continuous border in `#A8D5B8`.
  - Fully rounded (`rounded-full`) text inputs, featuring primary text `#18352A` and muted `#71847A` placeholder copy.
  - Radio buttons and toggles feature organic thumb transitions, utilizing `#205C3A` as the active indicator.
- **Lists**:
  - Borderless item groups separated by `space-sm` gaps, each item resting inside an individual soft-hover `#F4FAF6` pill-shaped row.