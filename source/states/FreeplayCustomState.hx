package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxBackdrop;
import lime.app.Application;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import backend.WeekData;
import backend.Highscore;
import backend.Song;

class FreeplayCustomState extends MusicBeatState {
    var checker:FlxBackdrop;
	var namebar:FlxSprite;
    var song1:FlxText;
    var song2:FlxText;
    var titleText1:FlxText;
	var titleText2:FlxText;

    override function create() {
        FlxG.mouse.visible = true;

        checker = new FlxBackdrop(Paths.image('lastlimbstuff/mainmenu/Grid_lmao'));
        checker.updateHitbox();
        checker.scrollFactor.set(0, 0);
        checker.alpha = 0.2;
        checker.screenCenter(X);
        add(checker);

        song2 = new FlxText(FlxG.width, "Lock and Key");
        song2.setFormat("VCR OSD Mono", 64, FlxColor.GREEN, "center");
        song2.screenCenter();		
		song2.antialiasing = true;
		song2.scale.set(1.5, 1.5);
        add(song2);

        super.create();
    }

    private function createSongText(songName:String, posY:Float):FlxText {
        var songText:FlxText = new FlxText(0, posY, FlxG.width, songName);
        songText.scrollFactor.set();
        songText.color = FlxColor.WHITE; 
        songText.size = 64;
        songText.screenCenter();
        songText.setFormat("VCR OSD Mono", 64, FlxColor.WHITE, "center");
        add(songText);
        
        return songText;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        checker.x += .5 * (elapsed / (1 / 120)); 
        checker.y -= 0.16;

        if (FlxG.keys.justPressed.ESCAPE) {
            MusicBeatState.switchState(new MainMenuState());
        }

        if (FlxG.mouse.overlaps(song2) && FlxG.mouse.justPressed) {
			FlxG.sound.play(Paths.sound('confirmMenu'));
			PlayState.SONG = Song.loadFromJson('lock-and-key', 'lock-and-key');
			LoadingState.loadAndSwitchState(new PlayState());
        }

        applyHoverEffect(song2);
    }

	private function applyHoverEffect(song:FlxText):Void {
        if (FlxG.mouse.overlaps(song)) {
            song.color = FlxColor.fromString("#004512"); 
            if (FlxG.mouse.justPressed) {
                FlxTween.tween(song, { alpha: 0.5 }, 0.1, { onComplete: function(tween) { song.alpha = 1; } });
                FlxTween.tween(FlxG.camera, { zoom: 50 }, 1, { type: FlxTween.ONESHOT, onComplete: cast onZoomComplete });
            }
        } else {
            song.color = FlxColor.fromString("#00ff44"); 
        }
    }

    private function onZoomComplete():Void {
        // I have nothing to do after this so fuck it
    }
}
