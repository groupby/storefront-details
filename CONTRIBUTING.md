## Modify the CHANGELOG.md

Our CHANGELOG.md follows the [Keep a Changelog](https://keepachangelog.com) format. 
For every change, add an "Unreleased" entry to the top of the changelog in the following format, removing any inapplicable sections:

```md
## [Unreleased] [<release type>]
### Added 
- <Describe additions>

### Changed
- <Describe changes>

### Deprecated 
- <Describe deprecations>

### Removed 
- <Describe removals>

### Fixed 
- <Describe fixes>

### Security
- <Describe security fixes>
```

The release type corresponds to the arugement to `npm version`. 

Supported release types:
- `major`
- `minor`
- `patch`
- `premajor`
- `preminor`
- `prepatch`
- `prerelease`
- `from-git`
