# Vulnerability Discovery Techniques
My approach is documented here, and in the various commits in these pull requests: https://github.com/xanderhades/railsgoat/pulls?q=is%3Apr

## tools used
brakeman, Burp Suite

I use [mise](https://github.com/jdx/mise) to manage my local dev environment

## vulnerability discovery - SAST
Use a recent version of ruby for latest brakeman, it wants ruby >= 3.0.0. I already have 3.1.6 installed.

```
mise use ruby@3.1.6
gem install brakeman
```

Run brakeman locally and save to a file
`brakeman --color -o /dev/stdout -o brakeman/output.json -o brakeman/report.html`

I can then analyze the results from stdout, from brakeman/output.json or from a nicer brakeman/report.html file in a web browser

I then added `.github/actions/workflows/sast.yml` to scan the repository on a pull request, and upload the results to github itself, as seen here: https://github.com/xanderhades/railsgoat/security/code-scanning?query=pr%3A1+tool%3ABrakeman

I then merged this PR to see the results on the master branch. 

Of course I forgot to force 'squash merging' so the commit history on master is somewhat polluted, but I hope you will forgive me.

See scanning results here: https://github.com/xanderhades/railsgoat/security/code-scanning

## vulnerability discovery - DAST


### additional notes
In the real world, I might tune brakeman so only findings with a high degree of confidence are reported. Or I might just leave it as-is, and dismiss false positive issues found in https://github.com/xanderhades/railsgoat/security using the 'dismiss alert' feature.

## setup railsgoat
Read `README.md` for instructions to run railsgoat locally. I'll go with the provided docker compose stack.

`docker-compose` has been deprecated, on my environment I had to use `docker compose` instead.

```
docker compose build
docker compose run web rails db:setup
docker compose up
````

I created a `Makefile` to simplify usage.

`make init && make start`
railsgoat is then available at http://localhost:3000
