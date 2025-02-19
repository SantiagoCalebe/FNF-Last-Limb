package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class CreditsState extends MusicBeatState {
    private var creditsText:FlxText;
    private var instructionsText2:FlxText;
	private var instructionsText:FlxText;
    private var scrollSpeed:Float = 60;
	private var acceleratedScrollSpeed:Float = 120;
	var checker:FlxBackdrop;

    override public function create():Void {
        super.create();

		checker = new FlxBackdrop(Paths.image('lastlimbstuff/mainmenu/Grid_lmao'));
		//checker.velocity.set(112, 110);
		checker.updateHitbox();
		checker.scrollFactor.set(0, 0);
		checker.alpha = 0.2;
		checker.screenCenter(X);
		add(checker);

		instructionsText = new FlxText(10, 10, FlxG.width - 20, 
            "Press ESC to skip"
        );
		instructionsText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, "bottom");
		add(instructionsText);

        instructionsText2 = new FlxText(10, 30, FlxG.width - 20, 
            "Press G to enter Github REPO."
        );
		instructionsText2.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, "bottom");
		add(instructionsText2);

        creditsText = new FlxText(0, FlxG.height, FlxG.width, 
			//First credit shit
            "FNF': Last Limb \n Made with love for 4th Gamebanana JAM: \n DYSTOPIA \n\n\n\n\n\n\n" +

			//The good part lol
            "Team SEES crew: \n\n\n" +

			//People
            "Agent \nDirector and Artist. \n\n\n" +
            "Santiago \nProgrammer and Composer. \n\n\n" +
			"Butter \nProgrammer, Animator, Ex-Composer and Charter. \n\n\n" +
			"KBZ \nComposer. \n\n\n" +
			"Atesz \nChromatic Creator. \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" +

			"Thank you so much for supporting \n FNF': Last Limb \n  - A submission for the 4th Gamebanana JAM."

        );
        creditsText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, "center");
        add(creditsText);

        var duration:Float = (creditsText.height + FlxG.height) / scrollSpeed;
        FlxTween.tween(creditsText, { y: -creditsText.height }, duration, {
            type: FlxTween.ONESHOT,
            onComplete: function(tween:FlxTween) {
    
                MusicBeatState.switchState(new MainMenuState());
            }
        });
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

		checker.x += .5*(elapsed/(1/120)); 
		checker.y -= 0.16;

        if (FlxG.keys.justPressed.ESCAPE) {
            MusicBeatState.switchState(new MainMenuState());
        }

        if (FlxG.keys.justPressed.G) {
            CoolUtil.browserLoad('https://github.com/santiagocalebe/FNF-Last-Limb');
        }
    }
}
