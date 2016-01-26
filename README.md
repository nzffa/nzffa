# NZ Farm Forestry Association Membership Management System

This repository is NZFFA's radiant instance. For more information on Radiant, see:
http://github.com/radiant/radiant/

Current Radiant version is: 1.0.1


## License

The NZFFA website source code is released under the MIT license and is copyright (c) 2011-2016 NZFFA.

##About this extension

This is the NZFFA Membership Management System based on Radiant CMS and is the main project that ties all the rest together. Most of the extensions are pulled in via the Gemfile. 

Note: This repository has a few additional extensions in vendor/extensions, one of which is named nzffa;
https://github.com/nzffa/nzffa/tree/master/vendor/extensions/nzffa
This is what holds the reader subscriptions and payments functionality, and branch admin (Front-end administration login is provided for each group secretary to access and edit records within group directories).
Some more nzffa MMS specific gems are pulled in via the Gemfile here:
https://github.com/nzffa/nzffa/blob/master/Gemfile#L58-L73
These are either written for nzffa specifically, or somewhat customised versions of existing extensions.
Things could be cleaner still, but we're getting there.

For the complete member management system our following forked extensions are required:

radiant-nzffa_marketplace-extension

radiant-nzffa_conference-extension

radiant-reader-extension

radiant-forum-extension

radiant-page_reader_group_permissions-extension

For conferences you can bolt on our radiant-nzffa_conference-extension

The code is well tested and robust. [The NZFFA website] (http://www.nzffa.org.nz) has been based on this for many years. Development continues

