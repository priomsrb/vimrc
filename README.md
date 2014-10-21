This is my vim profile. I'm using vundle to manage my plugins. To make the size of the repository smaller, I removed the `.git/` directories inside all my bundles using:

`find . | grep /.git$ | xargs rm -rf`

If I need to update my plugins, I can remove remove their bundle directory and use `:BundleInstall`.
