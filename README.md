# dotnet-bubble

An hack based on the build scripts of [macios](https://github.com/xamarin/xamarin-macios/) which creates a local install of a given version of dotnet along with a script donut.sh to invoke it.

## Setup

1. Open variables.json and:

- Update the first three variables (macios, root, vsts_pat_location) to specific locations on your machine.
- Update the last two variables (macios_build_id, maui_build_id) to point to the specific macios and maui build you want to install

2. make

./donut.sh will then point to your "bubble" NET6 install that contains macios and maui

## Example Usage

```
mkdir foo
cd foo
../donut.sh new ios
```

`The template "iOS Application (Preview)" was created successfully.`
