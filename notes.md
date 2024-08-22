# Vulnerability Discovery Techniques
My approach is documented here, and in the various commits in these pull requests: https://github.com/xanderhades/railsgoat/pulls?q=is%3Apr

## tools used
brakeman, OWASP Zap, Burp Suite

I use [mise](https://github.com/jdx/mise) to manage my local dev environment

## vulnerability discovery - SAST
Use a recent version of ruby for latest brakeman, it wants ruby >= 3.0.0. I already have 3.1.6 installed.

```
mise use ruby@3.1.6
gem install brakeman
```

Run brakeman locally and save to a file
`brakeman --color -o /dev/stdout -o brakeman/output.json -o brakeman/report.html`

I can then analyze the results from `stdout`, from `brakeman/output.json` or from a nicer `brakeman/report.html` file in a web browser.

I then added `.github/actions/workflows/sast.yml` to scan the repository on a pull request and on a merge to master, and uploaded the results to GitHub, as seen here: https://github.com/xanderhades/railsgoat/security/code-scanning?query=pr%3A1+tool%3ABrakeman

I then merged the first PR to see the results on the master branch. 

Of course I forgot to force `squash merging` so the commit history on master is somewhat polluted, but I hope you will forgive me. In the real world, I use squash commit and use my PR title as the commit message.

See scanning results here: https://github.com/xanderhades/railsgoat/security/code-scanning

## vulnerability discovery - DAST

I added `.github/actions/workflows/dast.yml` to scan the repository with OWASP Zap on a merge to master and upload the results to GitHub, as seen here: https://github.com/xanderhades/railsgoat/security/code-scanning?query=pr%3A1+tool%3ABrakeman%2CZAProxy

## setup railsgoat
I read `README.md` for instructions to run railsgoat locally. I went with the provided docker compose stack.

`docker-compose` has been deprecated, on my environment I had to use `docker compose` instead.

```
docker compose build
docker compose run web rails db:setup
docker compose up
```

I created a `Makefile` to simplify usage.

`make init && make start`
railsgoat is then available at http://localhost:3000

### additional notes
In the real world, I might tune brakeman and zap so only findings with a high degree of confidence are reported. I might also just leave it as-is, and dismiss false positive issues found in https://github.com/xanderhades/railsgoat/security using the 'dismiss alert' feature. I might voluntarily fail a build if some new findings are found, but only if I have a high degree of confidence that false positives won't disrupt the dev workflow. The current settings were kept simple for this exercise.


## vulnerability analysis

I analyzed some of the vulnerabilities found by SAST/DAST and created GitHub issues in this repository, as seen here: https://github.com/xanderhades/railsgoat/issues 

I used Burp Suite to generate the CSRF PoC.

I used gifs in the reproduction steps and committed them to this repo, I wouldn't do this in the real world.
