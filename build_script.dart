import 'dart:io';

void main() async {
  await copyReleaseNotesForGooglePlay();
}

const googlePlayReleaseNotesFolder = './release_notes/';
const googlePlayReleaseNotesFileName = 'whatsnew-en-US';
const githubReleaseNotesFileName = './RELEASE_NOTES.md';

Future<void> copyReleaseNotesForGooglePlay() async {
  final contents = await File(githubReleaseNotesFileName).readAsString();
  await Directory(googlePlayReleaseNotesFolder).create(recursive: true);
  await File(googlePlayReleaseNotesFolder + googlePlayReleaseNotesFileName).writeAsString(contents);
}
