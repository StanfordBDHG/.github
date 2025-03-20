<!--

This source file is part of the Stanford Biodesign Digital Health Group open-source organization

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

http://localhost

# Stanford Biodesign Digital Health Group

This repository serves as a collection of default community health files, GitHub Action workflows, templates, and information for the Stanford Biodesign Digital Health Group organization.

## GitHub Actions

This repository contains several GitHub Actions that automate and simplify the process of contributing to Stanford Biodesign Digital Health Group-related projects.

### Test Using Xcodebuild or Run Fastlane

Allows GitHub Actions to build complex Swift Packages supporting Apple platforms as well as Xcode projects with a diverse set of requirements ranging from custom commands, xcodebuild, to using Fastlane.
You can learn more about the arguments in the [`xcodebuild-or-fastlane.yml` GitHub Action file](https://github.com/StanfordBDHG/.github/blob/main/.github/workflows/xcodebuild-or-fastlane.yml).

```yml
jobs:
  buildandtest:
    name: Build and Test Swift Package
    uses: StanfordBDHG/.github/.github/workflows/xcodebuild-or-fastlane.yml@v2
    with:
      artifactname: TemplatePackage.xcresult
      runsonlabels: '["macOS", "self-hosted"]'
      scheme: TemplatePackage
```

### Merge and Upload Coverage Report

Merge and upload code coverage reports to display them on codecov.io.
You can learn more about the arguments in the [`create-and-upload-coverage-report.yml` GitHub Action file](https://github.com/StanfordBDHG/.github/blob/main/.github/workflows/create-and-upload-coverage-report.yml).

```yml
jobs:
  uploadcoveragereport:
    name: Upload Coverage Report
    uses: StanfordBDHG/.github/.github/workflows/create-and-upload-coverage-report.yml@v2
    with:
      coveragereports: ResultBundle1.xcresult ResultBundle2.xcresult
```

### REUSE

Check that all your source files conform to the REUSE specification.
You can learn more about the arguments in the [`reuse.yml` GitHub Action file](https://github.com/StanfordBDHG/.github/blob/main/.github/workflows/reuse.yml).

```yml
jobs:
  reuse_action:
    name: REUSE Compliance Check
    uses: StanfordBDHG/.github/.github/workflows/reuse.yml@v2
```

### SwiftLint

Ensure that all Swift files conform to the defined style guide.
You can learn more about the arguments in the [`swiftlint.yml` GitHub Action file](https://github.com/StanfordBDHG/.github/blob/main/.github/workflows/swiftlint.yml).

```yml
swiftlint:
  name: SwiftLint
  uses: StanfordBDHG/.github/.github/workflows/swiftlint.yml@v2
```

### Action Tag Release

Small GitHub Action that automatically tags releases based on semantic version tags, essential for GitHub Action repos. E.g., you tag a release for v2.4.2, and the action tags a v2 and v2.4). You can learn more about the arguments in the [`action-release-tag.yml` GitHub Action file](https://github.com/StanfordBDHG/.github/blob/main/.github/workflows/action-release-tag.yml).

```yml
jobs:
  releasetag:
    name: Tag Release
    uses: StanfordBDHG/.github/.github/workflows/action-release-tag.yml@v2
    secrets:
      access-token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
    with:
      user: PaulsAutomationBot
```

### Build XCArchive

A GitHub Action that builds an XCArchive based on an Xcode Workspace file with a specific scheme. The resulting archive is uploaded and stored as an artifact.
You can learn more about the arguments in the [`archive.yml` GitHub Action file](https://github.com/StanfordBDHG/.github/blob/main/.github/workflows/archive.yml).

```yml
jobs:
  build-xcarchive:
    name: Build XCArchive
    uses: StanfordBDHG/.github/.github/workflows/archive.yml@v2
    with:
      workspaceFile: example.xcworkspace
      xcArchiveName: exampleXCArchiveName
      scheme: exampleScheme
      version: 0.1.0
```

### Create XCFramework and Release

A GitHub Action that creates an XCFramework from an Xcode Workspace file with a specific scheme. As an intermediate step, the action utilizes the [`archive.yml`](https://github.com/StanfordBDHG/.github/blob/main/.github/workflows/archive.yml) reusable workflow to create the XCArchives that are packaged within the XCFramework. The resulting XCFramework is committed to the respective branch and a tagged release is created.
You can learn more about the arguments in the [`xcframework.yml` GitHub Action file](https://github.com/StanfordBDHG/.github/blob/main/.github/workflows/xcframework.yml).

```yml
jobs:
  create-xcframework-and-release-workflow:
    name: Create XCFramework and Release
    uses: StanfordBDHG/.github/.github/workflows/xcframework.yml@v2
    with:
      workspaceFile: example.xcworkspace
      xcFrameworkName: exampleXCFrameworkName
      scheme: exampleScheme
      version: 0.1.0
      user: PaulsAutomationBot
    secrets:
      access-token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
```

## Continous Integration Setup

The [ContinousIntegration](https://github.com/StanfordBDHG/ContinousIntegration) repository contains the setup and information about our self-hosted GitHub Action runners that is fitting the GitHub Actions found in this repository.

## Our Research

For more information, check out our website at [biodesigndigitalhealth.stanford.edu](https://biodesigndigitalhealth.stanford.edu).

![Stanford Mussallem Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-light.png#gh-light-mode-only)
![Stanford Mussallem Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-dark.png#gh-dark-mode-only)
