package states;

import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import sys.io.File;
import haxe.Json;
import flixel.effects.FlxFlicker;
import flixel.group.FlxSpriteGroup;

class GalleryState extends MusicBeatState
{
    var itemGroup:FlxTypedGroup<GalleryImage>;

    var imagePaths:Array<String>;
    var imageDescriptions:Array<String>;
    var imageTitle:Array<String>;
    var linkOpen:Array<String>;
    var descriptionText:FlxText;

    var currentIndex:Int = 0;
    var allowInputs:Bool = true;

    var uiGroup:FlxSpriteGroup;
    var hideUI:Bool = false;

    var imageSprite:FlxSprite;
    var background:FlxSprite;
    var titleText:FlxText;
    var bars:FlxSprite;
    var backspace:FlxSprite;
    
    var imagePath:String = "gallery/";

    override public function create():Void
    {   
        var jsonData:String = File.getContent("assets/shared/images/gallery/gallery.json");
        var imageData:Array<ImageData> = haxe.Json.parse(jsonData);

        imagePaths = [];
        imageDescriptions = [];
        imageTitle = [];
        linkOpen = [];
        
        for (data in imageData) {
            imagePaths.push(data.path);
            imageDescriptions.push(data.description);
            imageTitle.push(data.title);
            linkOpen.push(data.link);
        }
    
        itemGroup = new FlxTypedGroup<GalleryImage>();
        uiGroup = new FlxSpriteGroup();

        for (i in 0...imagePaths.length) {
            var newItem = new GalleryImage();
            newItem.loadGraphic(Paths.image(imagePath + imagePaths[i]));
            newItem.antialiasing = ClientPrefs.data.antialiasing;
            newItem.screenCenter();
            newItem.ID = i;
            itemGroup.add(newItem);
        }
    
        background = new FlxSprite().loadGraphic(Paths.image("gallery/ui/background"));
        add(background);

        bars = new FlxSprite().loadGraphic(Paths.image("gallery/ui/bars"));
        uiGroup.add(bars);

        add(itemGroup);
    
        descriptionText = new FlxText(50, -100, FlxG.width - 100, imageDescriptions[currentIndex]);
        descriptionText.setFormat("vcr.ttf", 32, 0xffffff, "center");
        descriptionText.screenCenter();
        descriptionText.y += 275;
        uiGroup.add(descriptionText);
    
		titleText = new FlxText(50, -100, FlxG.width - 100, imageTitle[currentIndex]);
		titleText.screenCenter();
		titleText.setFormat(Paths.font("vcr.ttf"), 32, 0xffffff, "center");
        titleText.y -= 275;
		uiGroup.add(titleText);
    
		backspace = new FlxSprite(0, 560).loadGraphic(Paths.image("gallery/ui/exit"));
		uiGroup.add(backspace);
    
        add(uiGroup);

        persistentUpdate = true;
        changeSelection();
    
        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if ((controls.UI_LEFT_P || controls.UI_RIGHT_P) && allowInputs) {
            changeSelection(controls.UI_LEFT_P ? -1 : 1);
            FlxG.sound.play(Paths.sound("scrollMenu"));
        }
    
        if (controls.BACK && allowInputs)
        {
            allowInputs = false;
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
			FlxFlicker.flicker(backspace, 0.4, 0.10, false);
        }
    
		if (FlxG.keys.justPressed.X && !hideUI)
		{
			hideUI = true;
			FlxTween.tween(uiGroup, {alpha: 0}, 0.2, {ease: FlxEase.linear});
		}
		else if (FlxG.keys.justPressed.X && hideUI)
		{
			hideUI = false;
			FlxTween.tween(uiGroup, {alpha: 1}, 0.2, {ease: FlxEase.linear});
		}

        if (controls.ACCEPT && allowInputs)
            CoolUtil.browserLoad(linkOpen[currentIndex]);
    }
    
    private function changeSelection(i:Int = 0)
    {
        currentIndex = FlxMath.wrap(currentIndex + i, 0, imageTitle.length - 1);
    
        descriptionText.text = imageDescriptions[currentIndex];
        titleText.text = imageTitle[currentIndex]; 

        var change = 0;
        for (item in itemGroup) {
            item.posX = change++ - currentIndex;
            item.alpha = (item.ID == currentIndex) ? 1 : 0.6;
        }
    }
}

class GalleryImage extends FlxSprite {
    public var lerpSpeed:Float = 6;
    public var posX:Float = 0;
    
    override function update(elapsed:Float) {
        super.update(elapsed);
        x = FlxMath.lerp(x, (FlxG.width - width) / 2 + posX * 760, boundTo(elapsed * lerpSpeed, 0, 1));
    }
}

function boundTo(value:Float, min:Float, max:Float):Float {
    var newValue:Float = value;
    if(newValue < min) newValue = min;
    else if(newValue > max) newValue = max;
    return newValue;
}

typedef ImageData = {
    path:String,
    description:String,
    title:String,
    link:String
}
