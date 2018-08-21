floofAchievements = floofAchievements or {}
floofAchievements.Config = floofAchievements.Config or {}

//Should we use a button to open our achievement ui?
floofAchievements.Config.UseKey = true //Default = true; If this is set to false then we will be using chat command

//If the above is set to true, what key should we use to open our menu?
floofAchievements.Config.Key = KEY_O //Default = KEY_O; You can find all the KEY enums here: https://wiki.garrysmod.com/page/Enums/KEY

//If we're not going to use keys to open our menu what should our chat command be?
floofAchievements.Config.ChatCommandUI = "Achievements" //Default = "Achievements";

//Should we list all of our achievements even though we're not going to use them? e.g showing DarkRP achievements for TTT.
floofAchievements.Config.AchievementFilter = true //Default = true; as we are using custom functions for specific gamemodes.

//This is for TTT - Should we wait til the end of the round before we unlock achievements?
floofAchievements.Config.ShouldWaitWithUnlock = true //Default = true;