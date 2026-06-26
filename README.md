# Linear Leveling

A lightweight, vanilla-style leveling overhaul.

## Description

In vanilla Morrowind, the attribute multipliers you get on the level up screen increase at an inconsistent rate. It takes 1 skill increase for a +2, 5 for a +3, 8 for a +4, and 10 for a +5. When you level up, all multiplier progress is reset to 0. This means that if you had 4 skill increases and take the resulting +2 multiplier, 3 of those increases are wasted. On top of that, since you can only pick three attributes to improve per level, any progress in unselected attributes is lost.

This mod makes a couple of simple changes to the system:

- Unused skill increases carry over to the next level.
- Attribute multipliers now grow consistently and linearly. By default, every 2.5 skill increases in an attribute raise its multiplier by +1, up to +5 at 10 skill increases. While you can't increase a skill's level exactly 2.5 times, half-levels carry over. In practice, this means you'll gain +1 in an attribute every 2 or 3 levels of a skill, alternating.

For example, if you level strength skills 3 times, speed skills 5 times and personality skills 2 times, you’ll see +2 for strength (3 points) and +3 for speed (5 points) on the level up screen. If you then choose strength, speed and luck, 0.5 strength points and 2 personality points carry over. On the next level, if you raise strength 2 more times and personality 8 times, you’ll get +2 in strength (2.5 points total) and +5 in personality (10 points total).

The number of skill increases required per multiplier and the contribution of major, minor and misc skills are configurable. The default settings are based on vanilla progression.

### Alternative Health Calculation

This mod also features an (entirely optional) alternative health calculation, based on your current endurance and class skills. The skills that contribute to health gains are all weapon skills, armor skills, athletics and acrobatics. The exact formula is:

    Starting Health + (Level - 1) * 0.06 * Endurance + (Level - 1) * 0.40 * # Health Affecting Skills

A little convoluted, but in practice this achieves what I was hoping for, which is a health formula that doesn't care about when you level endurance and creates more meaningful differences between different classes. In practice, an Altmer mage will have a little less health than in vanilla, a Nord warrior will have a little more, and everyone in between will be, well, in between.

## Requirements

OpenMW 0.49 or later.

Starting a new game is necessary for the alternative health calculation feature. Otherwise it can be installed mid-game, but for best results, install it when your attribute multipliers are at 0 (for example, right after a level up).

If Stats Window Extender is installed, you can enable a setting to show skill increases in the level tooltip.
