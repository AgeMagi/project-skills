# Mobile screen concepts

Choose iOS, Android, or an explicitly neutral cross-platform direction. Use the intended platform's navigation and system regions. A mobile comp should represent an app flow rather than a shrunken website.

Map the requested journey before drawing: onboarding → authentication → home, browse → detail, or cart → checkout → confirmation, for example. Carry relevant state forward. Generate the screens needed for that journey, not unrelated visually attractive screens. Do not add an onboarding or authentication project when only a home screen was requested.

Keep palette, type hierarchy, spacing, shapes, icons, imagery, controls, and navigation consistent across screens. Make screen purpose and the next action evident. Allow variation in content and composition without changing the app's identity.

Respect top/bottom safe areas, system bars, bottom navigation, keyboard implications, and fixed action clearance. Keep content and touch regions comfortable. Do not use decorative status indicators, random data, or tiny card stacks to make a screen look complex.

A subtle device frame can support presentation. For implementation handoff, prioritize unobstructed screen content; use frameless views when chrome would obscure measurements. Match the intended platform instead of putting Android content inside an iPhone by habit.

Check the first screen for clear hierarchy, readable copy, obvious controls, and restrained clutter. Inspect all later screens for continuity and believable transitions. Include loading, error, empty, or confirmation screens when the requested flow needs them. Raster concepts do not demonstrate working gestures, keyboard behavior, screen-reader support, or Dynamic Type.
