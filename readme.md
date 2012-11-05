#TPCodeaExamples 

Example projects for Codea TexturePacker exporters (TPCodea) and tpBatch.lua


##Instructions for TPCodeaTabExample (uses Codea project tab exporter):

###Import via copy/paste
1. Open https://github.com/apendley/TPCodeaExamples/blob/master/SmallWorldSprites.png in Mobile Safari, and copy the image to the clipboard
2. Import the copied image into Codea. Make sure to save it as "SmallWorldSprites", and make sure the Retina option is selected.
3. Open the TPCodeaTabExample project in Codea and run it!

###Import via Dropbox:

1. Republish the sprite sheet
2. Copy the newly-exported SmallWorldSprites@2x.png and SmallWorldSprites.png to the Apps/Codea folder in your Dropbox
3. In Codea, sync your Dropbox sprite pack
4. Install the TPCodeaTabExample project into the Codea app
5. Open the TPCodeaTabExample project in codea, and replace the contents of the SmallWorldSprites tab with the contents of the newly-exported SmallWorldSprites.lua file
6. In the setup() function in the Main tab, change <code>spriteSheet = tpBatch(tp["SmallWorldSprites"])</code> to <code>spriteSheet = tpBatch(tp["SmallWorldSprites"], "Dropbox")</code>
7. Run the project

##Instructions for TPCodeaChunkExample (uses Codea chunk exporter):

###Import via copy/paste
1. Open https://github.com/apendley/TPCodeaExamples/blob/master/SmallWorldSprites.png in Mobile Safari, and copy the image to the clipboard
2. Import the copied image into Codea. Make sure to save it as "SmallWorldSprites", and make sure the Retina option is selected.
3. Open the TPCodeaTabExample project in Codea and run it!

###Import via Dropbox:

1. Republish the sprite sheet
2. Copy the newly-exported SmallWorldSprites@2x.png and SmallWorldSprites.png to the Apps/Codea folder in your Dropbox
3. In Codea, sync your Dropbox sprite pack
4. Copy the newly-exported SmallWorldSprites.lua file into the public folder in your Dropbox, and get the public link to it 
5. Install the TPCodeaChunkExample project into the Codea app and open it
6. Change the _spriteSheetURL at the top of the file to link to the SmallWorldSprites from step 4
7. In the createBatchRenderer() function in the Main tab, change <code>spriteSheet = tpBatch(object)</code> to <code>spriteSheet = tpBatch(object, "Dropbox")</code>
8. Run the project

On the first run, the sprite sheet data will be downloaded from your Dropbox and saved to your project's data. On subsequent runs, the sprite sheet data will be loaded from your project's data instead of being downloaded.

##Notes:

* I've added the Small World assets and the TexturePacker file for reference for 2 reasons: 1) so you can re-export the sprite sheet data to use the Dropbox import method, and 2) so you can see the settings used to create a Retina-ready Codea sprite sheet.