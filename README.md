# The-Block
Scripts created for The Block

# How unique bins are are created within new projects

# When a new project is created from the template, the bins created will either be duplicates from the template, or they will be new bins.
# 1) Duplicate bins should be named with "duplicate_" at the front of the bin name so the script can identify them.
#	 These bins should contain content that you want to duplicate over every project. These bins cannot be opened over multiple projects at the same time or you will get the get the "Unable to open bin" error message.
#	 A prime example of a unique bin would be a "timecode" bin that contains a timecode layer you want editors to use across projects for consistency.
# 2) Bins that don't start with "duplicate_" will be recreated as a unique bins, and should be empty placeholder bins for a project.
#	 A typical example would be a "completed_requests" bin that edit assist drop requests into, or "outgoing GFX" bins that editors drop reference sequences into.
#	 Unique bins are technically not unique, but rather copied across to new project folders from a pool of unique bins in the "bins" folder.
#	 This folder should be populated by unique bins created in AVID.
#	 The way the script works is that when a new project folder is created, unique bins are taken one-by-one from the pool of bins like a queue, and renamed to what they should be based on the episode template.
#	 For example, if each project contains 10 bins. The episode 1 project will take bins 1 to 10, episode 2 will take bins 11 to 20 and so forth.
#	 For reference, every TB18 project contains XX unique bins, which would mean over 50 episodes you'd need XXX unique bins in the bins folder for every project to have unique bins.
