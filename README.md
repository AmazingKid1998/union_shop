# Union Shop — Flutter Coursework

This repository contains the coursework project for students enrolled in the **Programming Applications and Programming Languages (M30235)** and **User Experience Design and Implementation (M32605)** modules at the University of Portsmouth.

## Overview

The Student Union has an e-commerce website, which you can access via this link: [https://shop.upsu.net](https://shop.upsu.net)

In short, your task is to recreate the same website using Flutter. You must not start from scratch, as this repository provides an incomplete Flutter implementation of the Student Union site that you must build upon. [The getting started section of this document](#getting-started) will explain more.

⚠️ The UPSU.net link on the navbar of the union website is a link to an external site. This is not part of the application that you need to develop. So ignore the link highlighted below:

![Union Shop Header](https://raw.githubusercontent.com/manighahrmani/sandwich_shop/refs/heads/main/images/screenshot_union_site_header.png)

## Getting Started

### Prerequisites

You have three options for your development environment:

1. **Firebase Studio** (browser-based, no installation required)
2. **University Windows computers** (via AppsAnywhere)
3. **Personal computer** (Windows or macOS)

Below is a quick guide for each option. For more information, you can refer to [Worksheet 0 — Introduction to Dart, Git and GitHub](https://manighahrmani.github.io/sandwich_shop/worksheet-0.html) and [Worksheet 1 — Introduction to Flutter](https://manighahrmani.github.io/sandwich_shop/worksheet-1.html).

**Firebase Studio:**

- Access [idx.google.com](https://idx.google.com) with a personal Google account
- Create a new workspace (template selection not needed for this coursework)
- Clone your forked repository using the command palette

**University Computers:**

- Open [AppsAnywhere](https://appsanywhere.port.ac.uk/sso) and launch the following in the given order:
  - Git
  - Flutter And Dart SDK
  - Visual Studio Code

**Personal Windows Computer:**

- Install [Chocolatey package manager](https://chocolatey.org/install)
- Run in PowerShell (as Administrator):

  ```bash
  choco install git vscode flutter -y
  ```

**Personal macOS Computer:**

- Install [Homebrew package manager](https://brew.sh/)
- Run in Terminal:

  ```bash
  brew install --cask visual-studio-code flutter
  ```

#### Verify Installation (Skip if using Firebase Studio)

After installation, verify your setup by running:

```bash
flutter doctor
```

This command checks your environment and displays a report of the status of your Flutter installation.

**For detailed step-by-step instructions**, refer to [Worksheet 1 — Introduction to Flutter](https://manighahrmani.github.io/sandwich_shop/worksheet-1.html), which covers the complete setup process for all three options.

### Fork the Repository

Go to the repository containing the code for the coursework and click on the fork button as shown in the screenshot: [https://github.com/manighahrmani/union_shop/fork](https://github.com/manighahrmani/union_shop/fork) (Alternatively, just use this link: [https://github.com/manighahrmani/union_shop/fork](https://github.com/manighahrmani/union_shop/fork))

![Fork Button](https://raw.githubusercontent.com/manighahrmani/sandwich_shop/refs/heads/main/images/screenshot_fork_button.png)

Do not change anything and click on the Create fork button. You should then have a public fork of my repository with a URL like (YOUR-USERNAME replaced with your username): [https://github.com/YOUR-USERNAME/union_shop](https://github.com/YOUR-USERNAME/union_shop)

![Fork Settings](https://raw.githubusercontent.com/manighahrmani/sandwich_shop/refs/heads/main/images/screenshot_fork_settings.png)

Note that the name of this created fork must be “union_shop”. If you already have a repository with this name, you need to rename it beforehand.

### Clone Your Forked Repository

If you are using Firebase Studio, head to [https://idx.google.com](https://idx.google.com), click on Import Repo and paste the URL of your forked repository. Name your workspace as `union_shop`.

Otherwise, open a terminal, change to your desired directory, and run the following commands:

```bash
git clone https://github.com/YOUR-USERNAME/union_shop.git
cd union_shop
```

Replace `YOUR-USERNAME` with your actual GitHub username.

### Install Dependencies

Your editor should automatically prompt you to install the required dependencies when you open the project. If not, open the integrated terminal (open the Command Palette with `Ctrl+Shift+P` or `Cmd+Shift+P` and type "Terminal: Create New Terminal") and run the following command:

```bash
flutter pub get
```

### Run the Application

This application is primarily designed to run on **web** and should be viewed in **mobile view** using browser developer tools. We recommend using Google Chrome.

Select Chrome as the target device and run the application either from the `main.dart` file or by entering the following command in the terminal:

```bash
flutter run -d chrome
```

Once the app is running in Chrome, open Chrome DevTools by right-clicking on the page and selecting "Inspect" (or use the shortcut `F12`). Click the "Toggle device toolbar" button as shown in the screenshot below.

![Chrome DevTools Mobile View](https://raw.githubusercontent.com/manighahrmani/sandwich_shop/refs/heads/main/images/screenshot_chrome_devtools.png)

From the Dimensions menu, select a mobile device preset (e.g., iPhone 12 Pro, Pixel 5) or set custom dimensions

![Device Selection](https://raw.githubusercontent.com/manighahrmani/sandwich_shop/refs/heads/main/images/screenshot_chrome_devtools_device_selection.png)

### Running Tests

To run the widget tests:

```bash
flutter test
```

To run tests for a specific file:

```bash
flutter test test/home_test.dart
flutter test test/product_test.dart
```

### Assessment Criteria

In short, your objective is to reimplement the features and functionality of the existing Union Shop website ([https://shop.upsu.net](https://shop.upsu.net)) using Flutter. For detailed task requirements and marking criteria, please refer to the coursework document:

**[Coursework Document](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/EbM1UcwOHMRLmcKeI0btHqYBeZ3ADWjyN0EXBWdHLhsO_g?e=FDEQLt)**

This document outlines the specification for your coursework, the breakdown of marks, submission guidelines, and deadlines.

## Project Structure

This starter repository provides a minimal skeletal structure with:

- **Homepage** (`lib/main.dart`): A basic homepage
- **Product Page** (`lib/product_page.dart`): A single product page
- **Widget Tests**: Basic tests for both of the above pages (`test/home_test.dart` and `test/product_test.dart`)

Here is an overview of the project structure:

```plaintext
union_shop/
├── lib/
│   ├── main.dart           # Main application and homepage
│   └── product_page.dart   # Product detail page
├── test/
│   ├── home_test.dart      # Homepage widget tests
│   └── product_test.dart   # Product page widget tests
├── pubspec.yaml            # Project dependencies
└── README.md               # This file
```

Note that this is the initial structure. You are of course expected to create additional files and directories as needed to complete the coursework. You can also reorganize the project structure as you see fit.

## Support and Resources

For questions or issues related to this coursework use [the dedicated Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg). Please first check the existing posts in the forum to see if your question has already been answered before posting a new question.

Use the worksheets listed on [the homepage](https://manighahrmani.github.io/sandwich_shop/) as your primary learning resource for Flutter development. You must refrain from using other online resources such as Stack Overflow, YouTube tutorials, or other websites for this coursework as they may contain outdated or incorrect information.

## Tips

**Commit regularly!** Save your progress frequently by committing your changes to Git. This creates checkpoints you can return to if needed.

```bash
git add .
git commit -m "Brief description of what you changed"
git push
```

If you made a small mistake, you can revert to a previous commit:

1. View your commit history: `git log --oneline`
2. Find the commit hash (e.g., `abc1234`) where things were working
3. Revert to that commit: `git reset --hard abc1234`
4. Force push if needed: `git push --force`

If things are completely broken and are unrecoverable, you can start fresh by re-forking the repository:

1. Delete your forked repository on GitHub (Settings → Danger Zone → Delete this repository)
2. Fork the original repository again: [https://github.com/manighahrmani/union_shop](https://github.com/manighahrmani/union_shop)
3. **Remember to keep it public!**
4. Clone your fresh fork and start again

Regular commits not only help you recover from mistakes, but also demonstrate your development process. Remember you are marked based on your commits.

## License

This project is created for educational purposes as part of the University of Portsmouth coursework.
