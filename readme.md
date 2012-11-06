#TPCodeaExamples 

Example projects for Codea TexturePacker exporters (TPCodea) and tpBatch.lua


##Instructions for TPCodeaTabExample (uses Codea project tab exporter):

###Import via copy/paste
1. Open https://github.com/apendley/TPCodeaExamples/blob/master/assets/SmallWorldSprites%402x.png in Mobile Safari, and copy the image to the clipboard
2. Import the copied image into Codea. Make sure to name it "SmallWorldSprites" (without the @2x suffix), and make sure the Retina option is selected, so Codea will create the non-retina version.
3. Open the TPCodeaTabExample project in Codea and run it!

###Import via Dropbox:

1. Copy the SmallWorldSprites@2x.png and SmallWorldSprites.png textures from the assets folder into the Apps/Codea folder in your Dropbox.
2. In Codea, sync your Dropbox sprite pack
3. Install the TPCodeaTabExample project into the Codea app
4. In the setup() function in the Main tab, change <code>spriteSheet = tpBatch(tp["SmallWorldSprites"])</code> to <code>spriteSheet = tpBatch(tp["SmallWorldSprites"], "Dropbox")</code>
5. Run the project

##Instructions for TPCodeaChunkExample (uses Codea chunk exporter):

###Import via copy/paste
1. Open https://github.com/apendley/TPCodeaExamples/blob/master/assets/SmallWorldSprites%402x.png in Mobile Safari, and copy the image to the clipboard
2. Import the copied image into Codea. Make sure to name it "SmallWorldSprites" (without the @2x suffix), and make sure the Retina option is selected, so Codea will create the non-retina version.
3. Open the TPCodeaTabExample project in Codea and run it!

###Import via Dropbox:

1. Copy the SmallWorldSprites@2x.png and SmallWorldSprites.png textures from the assets folder into the Apps/Codea folder in your Dropbox.
2. In Codea, sync your Dropbox sprite pack
3. Install the TPCodeaChunkExample project into the Codea app and open it
4. In the createBatchRenderer() function in the Main tab, change <code>spriteSheet = tpBatch(object)</code> to <code>spriteSheet = tpBatch(object, "Dropbox")</code>
5. Run the project

On the first run, the sprite sheet data will be downloaded from your Dropbox and saved to your project's data. On subsequent runs, the sprite sheet data will be loaded from your project's data instead of being downloaded.

##Notes:

* I've added the Small World assets and the TexturePacker file for reference so you can see the settings used to create a Retina-ready Codea sprite sheet.