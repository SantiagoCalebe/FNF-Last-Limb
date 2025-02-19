package states;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import backend.WeekData;
import backend.Highscore;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import backend.Song;

class StoryMenuCustomState extends MusicBeatState 
{
    var bg:FlxSprite;
    var checker:FlxBackdrop;
    var week:FlxText;

    override function create() 
    {
        transIn = FlxTransitionableState.defaultTransIn;
        transOut = FlxTransitionableState.defaultTransOut;
        
        checker = new FlxBackdrop(Paths.image('lastlimbstuff/mainmenu/Grid_lmao'));
        checker.updateHitbox();
        checker.scrollFactor.set(0, 0);
        checker.alpha = 0.2;
        checker.screenCenter(X);
        add(checker);

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('lastlimbstuff/storymodemenu/bg'));
		bg.frames = Paths.getSparrowAtlas('lastlimbstuff/storymodemenu/bg');
		bg.animation.addByPrefix('idle', 'bumpinguys', 24, true); 
		bg.animation.play('idle');
		bg.scrollFactor.set();
		bg.screenCenter();
		bg.flipX = true; 
        bg.y -= 100;
        bg.scale.set(0.5, 0.5);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

        week = new FlxText(0, 0, FlxG.width, "Week Limb");
        week.setFormat("VCR OSD Mono", 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        week.screenCenter();
        week.y += 150;
        week.antialiasing = ClientPrefs.data.antialiasing;
        add(week);

        super.create();
    }
        
    override function update(elapsed:Float) {
        super.update(elapsed);

        applyHoverEffect(week);

        checker.x += .5 * (elapsed / (1 / 120)); 
        checker.y -= 0.16;

        if (FlxG.keys.justPressed.ESCAPE) {
            MusicBeatState.switchState(new MainMenuState());
        }

    }

    private function applyHoverEffect(song:FlxText):Void {
        if (FlxG.mouse.overlaps(song)) {
            song.color = FlxColor.fromString("#004512"); 
            if (FlxG.mouse.justPressed) {
                FlxTween.tween(song, { alpha: 0.5 }, 0.1, { onComplete: function(tween) { song.alpha = 1; } });
                FlxTween.tween(FlxG.camera, { alpha: 0 }, 1, { type: FlxTween.ONESHOT, onComplete: cast onZoomComplete });
            }
        } else {
            song.color = FlxColor.fromString("#00ff44"); 
        }
    }

    private function onZoomComplete():Void {
        WeekData.reloadWeekFiles(true);
        PlayState.SONG = Song.loadFromJson('lock-and-key', 'lock-and-key');
        PlayState.storyPlaylist = ['lock-and-key'];
        PlayState.isStoryMode = true;
        Difficulty.list = ['Normal'];
        PlayState.storyDifficulty = 0;
        PlayState.storyWeek = WeekData.weeksList.indexOf('limb');
        LoadingState.loadAndSwitchState(new PlayState(), true);
    }
}


