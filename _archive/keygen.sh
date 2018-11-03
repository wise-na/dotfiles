
# create new github account for user @ http://github.com
# or add key to existing github account
# create keys for new computer / user
ssh-keygen -t rsa -N "" -C "<your_email_username>@yourdomain.com" -f ~/.ssh/test_id_rsa

# Start agent in background
eval "$(ssh-agent -s)"

# # If OSX 10.12+
echo 'Host *
 AddKeysToAgent yes
 UseKeychain yes
 IdentityFile ~/.ssh/id_rsa
' >> ~/.ssh/config

# # Add to local keys
# ssh-add -K ~/.ssh/test_id_rsa
#
#
#
# # copy key to clipboard
# pbcopy < ~/.ssh/id_rsa.pub
#
# # Add key on github
# open https://github.com/settings/keys
#
# # copy keys user account @ http://github.com
# # https://help.github.com/articles/generating-ssh-keys
