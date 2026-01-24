<img align="left" src="./images/icon-dark.svg" alt="icon" width="64" height="64">

# `ipd` — iCloud Photos Deduplicator

![how it looks like](./images/ipd.png)

`ipd` is a small macOS utility application that tries to detect images with the same name, same creation date and type. It's meant to help out the iCloud Photos Duplicate finder, as it sometimes misses obvious clones, `ipd` only looks for obvious ones.

## Why did I build it?

I noticed that, whenever I would use a Shared Album in iCloud and download all the images and videos, I'd have duplicates
for all images that I previously added to said album. I would always try to clean my library and remove the JPEG that was
created for the Shared Album and keep the original, but I grew tired of that, so I tried to make it easier with this little application.

## How it works
- The application fetches all your photos and videos, and checks if multiple ones have the same name and creation date.
- If duplicates are found, you can delete the one that is of lesser quality and leave your library a bit cleaner than you found it.

Note: Please check if it really is the same image, if one of them is edited it may still show up as a duplicate, don't delete it then :)

## Build & Run
1. Clone the repo.
2. Change the `DEVELOPMENT_TEAM` value in `project.yml`
3. Run `xcodegen generate`
4. Open Xcode, build and run the application
5. On first launch, grant Photos permission when prompted.

## Privacy
All processing occurs on-device. Photos access is only used to read metadata and delete items the user confirms.
The application does not upload your photos.
