# Presage website (main branch live at presagegroup.com)

[![Netlify Status](https://api.netlify.com/api/v1/badges/d9ec25ff-3c82-4803-a84b-2eafcb85cb7c/deploy-status)](https://app.netlify.com/sites/peppy-tulumba-8f6533/deploys)

To build the site for the first time on your computer:

1. Install juliaup (run `curl -fsSL https://install.julialang.org | sh` or `brew install juliaup`in a terminal on macOS or Linux, or `winget install julia -s msstore` on Windows)
2. Use juliaup to install julia (in a terminal, type `juliaup add release`). 
3. Clone this repository
4. Navigate to the repository directory in a terminal
5. Start julia and activate this environment with `] activate .`, where `]` is the command to enter the julia REPL Package mode. The prompt should say "presagegroup-com" if this worked correctly. 
6. Instantiate this environment with `instantiate` while still in package mode.
7. At the normal julia prompt (use backspace to exit package mode, your prompt should now say "julia>"), type `using Franklin` to load `Franklin.jl`.
8. `serve()` will start a local server at http://localhost:8000 and open a preview of the site in your browser

To make a change to the website: 

1. Fetch the current state of the repo from github. In github desktop, this is done by clicking the "Fetch origin" button at the top. 
2. Make a local branch with a name that describes your intended change ("september-blog-post", "new-fitforflight-page", "fix-darkmode", etc.). In github desktop, click on the down arrow beside "Current branch" and type your name into the box, then click the "New branch" button.
3. Make changes locally and commit them. Commits can either be based on completing pieces of the work (e.g. "first paragraph added") or just over time (e.g. "end of day may 12"). Aim to not make too many changes between commits.
4. Build the site locally to preview your change. See instructions above (you can start from step 4). 
5. Push your branch to github (button in the top bar of github desktop). This should be done at minimum once per day so your work is backed up.
6. Repeat steps 3-5 until you are happy with your changes
7. Make a pull request from your branch to main. This can be done on the github website under "Pull Requests". Click the green button and ask for a review from someone else in analytics just to make sure nothing has broken.
8. They merge the changes to main and they will be live in a couple minutes

