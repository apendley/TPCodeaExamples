TPCodeaExample
=

Example project for Codea (project tab) TexturePacker exporter (TPCodea) and tpBatch.lua


Instructions:
=

1. Import SmallWorldSprites.png into Codea through your photo album (make sure to name it SmallWorldSprites, and make sure "Retina" is on when you import it)
2. Install the TPCodeaTabExample.codea project into the Codea app
3. Open the TPCodeaTabExample project in Codea and run it!

Alternate Instructions Using Dropbox:
=

1. Republish the sprite sheet
2. Copy the newly-exported SmallWorldSprites@2x.png and SmallWorldSprites.png to the Apps/Codea folder in your Dropbox
3. In Codea, sync your Dropbox sprite pack
4. Install the TPCodeaTabExample project into the Codea app
5. Open the TPCodeaTabExample project in codea, and replace the contents of the SmallWorldSprites tab with the contents of the newly-exported SmallWorldSprites.lua file
6. In the setup() function in the Main tab, change <code>spriteSheet = tpBatch(tp["SmallWorldSprites"])</code> to <code>spriteSheet = tpBatch(tp["SmallWorldSprites"], "Dropbox")</code>
7. Run the project

Notes:
=

* This project uses data generated from the Codea (project tab) exporter.
* I've added the Small World assets and the TexturePacker file for reference, so you can see the settings used to create the sprite sheet. Pay special attention to the AutoSD options if you plan on making your sprite sheet retina-ready.