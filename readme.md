#TPCodeaExamples 

Example projects for Codea TexturePacker exporters (TPCodea) and tpBatch.lua. 

##Importing example sprite sheet texture into Codea
###Import via copy/paste
1. Open https://github.com/apendley/TPCodeaExamples/blob/master/assets/SmallWorldSprites%402x.png in Mobile Safari, and copy the image to the clipboard
2. Import the copied image into Codea. Make sure to name it "SmallWorldSprites" (without the @2x suffix), and make sure the Retina option is selected, so Codea will create the non-retina version.
3. Open the TPCodeaTabExample and/or TPCodeaChunkExample project in Codea and run it!

###Import via photo album
1. Save the texture at https://github.com/apendley/TPCodeaExamples/blob/master/assets/SmallWorldSprites%402x.png into your photo album
2. Follow steps 2 and 3 from "Import via copy/paste" above

###Import via Dropbox
####Step 1: Import the texture

1. Copy the SmallWorldSprites@2x.png and SmallWorldSprites.png textures from the assets folder into the Apps/Codea folder in your Dropbox.
2. In Codea, sync your Dropbox sprite pack

####Step 2: Install and modify the project(s)
#####Modifying TPExampleCodeaTab

1. Install the TPCodeaTabExample project into the Codea app
2. In the setup() function in the Main tab, change <code>spriteSheet = tpBatch(tp["SmallWorldSprites"])</code> to <code>spriteSheet = tpBatch(tp["SmallWorldSprites"], "Dropbox")</code>
3. Run the project

#####Modifying TPCodeaExampleChunk

1. Install the TPCodeaChunkExample project into the Codea app and open it
2. In the createBatchRenderer() function in the Main tab, change <code>spriteSheet = tpBatch(object)</code> to <code>spriteSheet = tpBatch(object, "Dropbox")</code>
3. Run the project

On the first run, the sprite sheet data will be downloaded from assets/chunk/SmallWorldSprites.lua in this repo. On subsequent runs, the sprite sheet data will be loaded from your project's data instead of being downloaded.

##Notes:

* I've added the Small World assets and the TexturePacker file for reference so you can see the settings used to create a Retina-ready Codea sprite sheet.
* When creating sprite sheets for your own project, you only need to have TexturePacker generate the non-retina version (using the AutoSD feature) if you plan on using Dropbox to import your sprite sheet into Codea. If you import using the copy/paste or photo album methods, Codea can automatically generate the non-retain version when you import the texture.



