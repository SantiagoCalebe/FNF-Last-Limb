package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import backend.WeekData;
import backend.Highscore;
import backend.Song;

import states.StoryMenuCustomState;
import states.FreeplayCustomState;
import states.GalleryState;
import states.CreditsState;
import options.OptionsState;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.3'; // This is also used in Discord RPC
	public static var lastLimbVersion:String = '1.0'; // This is also (not) used in Discord RPC
	public static var curconfirmed:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'gallery',
		'options'
	];

	var checker:FlxBackdrop;
	var cameraoverlay:FlxSprite;
	var char:FlxSprite;

	var story:FlxText;
	var free:FlxText;
	var gallery:FlxText;
	var credits:FlxText;
	var options:FlxText;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.mouse.visible = true;

		#if DISCORD_ALLOWED
		// Updating sDiscord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		checker = new FlxBackdrop(Paths.image('lastlimbstuff/mainmenu/Grid_lmao'));
		//checker.velocity.set(112, 110);
		checker.updateHitbox();
		checker.scrollFactor.set(0, 0);
		checker.alpha = 0.2;
		checker.screenCenter(X);
		add(checker);

		story = new FlxText(FlxG.width, "Story");
        story.setFormat("VCR OSD Mono", 32, FlxColor.GREEN, "center");
        story.screenCenter();
		story.scale.set(1.5, 1.5);
        story.y -= 300;
		story.alpha = 0.5;
		story.antialiasing = ClientPrefs.data.antialiasing;
		story.x -= 500;
        add(story);

		free = new FlxText(FlxG.width, "FreePlay");
        free.setFormat("VCR OSD Mono", 32, FlxColor.GREEN, "center");
        free.screenCenter();
		free.scale.set(1.5, 1.5);
        free.y -= 300;
		free.alpha = 0.5;
		free.antialiasing = ClientPrefs.data.antialiasing;
		free.x -= 250;
        add(free);

		gallery = new FlxText(FlxG.width, "Gallery");
        gallery.setFormat("VCR OSD Mono", 32, FlxColor.GREEN, "center");
        gallery.screenCenter();		
		gallery.antialiasing = ClientPrefs.data.antialiasing;
		gallery.scale.set(1.5, 1.5);
        gallery.y -= 300;
		gallery.alpha = 0.5;
        add(gallery);

		credits = new FlxText(FlxG.width, "Credits");
        credits.setFormat("VCR OSD Mono", 32, FlxColor.GREEN, "center");
        credits.screenCenter();
		credits.scale.set(1.5, 1.5);
		credits.antialiasing = ClientPrefs.data.antialiasing;
        credits.y -= 300;
		credits.x += 250;
		credits.alpha = 0.5;
        add(credits);

		options = new FlxText(FlxG.width, "Options");
        options.setFormat("VCR OSD Mono", 32, FlxColor.GREEN, "center");
        options.screenCenter();
		options.antialiasing = ClientPrefs.data.antialiasing;
		options.scale.set(1.5, 1.5);
		options.alpha = 0.5;
        options.y -= 300;
		options.x += 500;
        add(options);

		char = new FlxSprite(0, 200).loadGraphic(Paths.image('lastlimbstuff/mainmenu/thatonebirdgirl'));
		char.frames = Paths.getSparrowAtlas('lastlimbstuff/mainmenu/thatonebirdgirl');
		char.animation.addByPrefix('idle', 'idle', 24, true);
		char.animation.play('idle');
		char.scrollFactor.set();
		char.screenCenter();
		char.y += 200;
		char.flipX = true;
		char.antialiasing = ClientPrefs.data.antialiasing;
		add(char);

		var lLVer:FlxText = new FlxText(12, FlxG.height - 64, 0, "Last Limb v. " + lastLimbVersion, 12);
		lLVer.scrollFactor.set();
		lLVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v. " + psychEngineVersion, 12);
		psychVer.scrollFactor.set();
		psychVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(psychVer);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);

		cameraoverlay = new FlxSprite(Paths.image('lastlimbstuff/mainmenu/moldurabb'));
		cameraoverlay.scrollFactor.set(0, 0);
		cameraoverlay.antialiasing = ClientPrefs.data.antialiasing;
		cameraoverlay.screenCenter();
		add(cameraoverlay);

			/*
			
			I was getting no image when i tried to add this stupid bird so this line is just console thing so it's useless.
			
			if (thatonebirdgirl.graphic != null) {
				trace("Loaded!");
			} else {
				trace("NOOOOOO IT FAILED TO LOAD *CRIES* [Null Object Reference]");
			}
			*/


		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		super.create();

	}

	var confirmedSomethin:Bool = false;


	override function update(elapsed:Float)
	{	
		FlxG.mouse.visible = true;

		applyHoverEffect(story);
        applyHoverEffect(free);
		applyHoverEffect(gallery);
        applyHoverEffect(credits);
		applyHoverEffect(options);

		if (FlxG.mouse.justPressed)
			{
				if (FlxG.mouse.overlaps(story))
				{
					story.alpha = 1;
					FlxG.camera.flash(FlxColor.GREEN, 1);
					FlxG.sound.play(Paths.sound('confirmMenu'));
					MusicBeatState.switchState(new StoryMenuCustomState());
				}
				else if (FlxG.mouse.overlaps(free))
				{
					free.alpha = 1;
					FlxG.camera.flash(FlxColor.GREEN, 1);
					FlxG.sound.play(Paths.sound('confirmMenu'));
					MusicBeatState.switchState(new FreeplayCustomState());
				}
				else if (FlxG.mouse.overlaps(gallery))
				{
					gallery.alpha = 1;
					FlxG.camera.flash(FlxColor.GREEN, 1);
					FlxG.sound.play(Paths.sound('confirmMenu'));
					MusicBeatState.switchState(new GalleryState());
				}
				else if (FlxG.mouse.overlaps(credits))
				{
					credits.alpha = 1;
					FlxG.camera.flash(FlxColor.GREEN, 1);
					FlxG.sound.play(Paths.sound('confirmMenu'));
					MusicBeatState.switchState(new CreditsMenuState());
				}
				else if (FlxG.mouse.overlaps(options))
				{
					options.alpha = 1;
					FlxG.camera.flash(FlxColor.GREEN, 1);
					FlxG.sound.play(Paths.sound('confirmMenu'));
					MusicBeatState.switchState(new OptionsState());
				}
			}

		checker.x += .5*(elapsed/(1/120)); 
		checker.y -= 0.16;

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			#if desktop
			if (controls.justPressed('debug_1'))
			{
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end

		super.update(elapsed);
	}

	private function applyHoverEffect(song:FlxText):Void {
        if (FlxG.mouse.overlaps(song)) {
            song.color = FlxColor.fromString("#004512"); 
            if (FlxG.mouse.justPressed) {
                FlxTween.tween(song, { alpha: 0.5 }, 0.1, { onComplete: function(tween) { song.alpha = 1; } });
            }
        } else {
            song.color = FlxColor.fromString("#00ff44"); 
        }
    }
}
