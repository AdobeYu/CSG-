/* nadetraining.nut
 * Nade Training Script
 * by S0lll0s, Bidj, Rurre and Mellet
 * USAGE:
 *	script_execute nadetraining
 *	script nadeSetup()
 * 	bind "rctrl" "script nadeSavePos()"
 *	bind "ralt" "script nadePause()"
 * Press the key (right ctrl in this case) before every nade you want save, all following nades will fly the same path
 * regardless of how you throw them. To pause the script and throw nades freely use the other bind (right alt in this case).
 */

this.nadePos		<- null;
this.nadeVel		<- null;
this.nadeSaveMode	<- true;
this.nadeLastNade	<- null;
this.nadeIsPaused	<- false;

function nadeSetup() {
	printl( @"[NT] nadetraining.nut" );
	printl( @"[NT] Nade Training Script" );
	printl( @"[NT] by S0lll0s, Bidj, Rurre and Mellet" );
	printl( @"[NT] USAGE:" );
	printl( @"[NT] 	 bind ""ins"" ""script nadeSavePos()""" );
	printl( @"[NT] 	 bind ""del"" ""script nadePause()""" );
	printl( @"[NT] Press the key before every nade you save, all following nades will fly the same path" );

	printl( @"[NT] starting setup..." );
	if (!Entities.FindByName(null, "nadeTimer"))
	{
		local v_nadeTimer = null;
		v_nadeTimer = Entities.CreateByClassname("logic_timer");
		EntFireByHandle(v_nadeTimer, "addoutput", "targetname nadeTimer", 0.0, null, null);
	}
	EntFire("nadeTimer", "toggle");
	EntFire("nadeTimer", "addoutput", "refiretime 0.05");
	EntFire("nadeTimer", "enable" );
	EntFire("nadeTimer", "addoutput", "startdisabled 0");
	EntFire("nadeTimer", "addoutput", "UseRandomTime 0");
	EntFire("nadeTimer", "addoutput", "ontimer nadeTimer,RunScriptCode,nadeThink()");
	printl( @"[NT] done.");
}

function nadeSavePos() {
	nadeSaveMode = true;
	ScriptPrintMessageCenterAll( "扔出以记录投掷" );
}

function nadeThink() {
	local nade = null;

    while ((nade = Entities.FindByClassname(nade, "flashbang_projectile")) != null ) {
        deleteOtherNades( nade );
        saveRestore( nade );
    }

	nade = null;
	while ((nade = Entities.FindByClassname(nade, "hegrenade_projectile")) != null ) {
        deleteOtherNades( nade );
		saveRestore( nade );
	}

    nade = null;
    while ((nade = Entities.FindByClassname(nade, "incgrenade_projectile")) != null) {
        deleteOtherNades( nade );
		saveRestore( nade );
	}

	nade = null;
	while ((nade = Entities.FindByClassname(nade, "decoy_projectile")) != null ) {
        deleteOtherNades( nade );
		saveRestore( nade );
	}

    nade = null;
    while ((nade = Entities.FindByClassname(nade, "molotov_projectile")) != null) {
        deleteOtherNades( nade );
		saveRestore( nade );
	}

    nade = null;
    while ((nade = Entities.FindByClassname(nade, "smokegrenade_projectile")) != null) {
        deleteOtherNades( nade );
        saveRestore( nade );
	}
}

function nadePause() {
	nadeIsPaused = !nadeIsPaused;
	if ( nadeIsPaused )
	{
		ScriptPrintMessageCenterAll( "自由模式。\n（自由模式无法记录投掷）" );
	} else {
		ScriptPrintMessageCenterAll( "记录模式。\n（按下Insert记录新的投掷）" );
	}
}

function saveRestore( nade ) {
	if (!nadeIsPaused){
		if ( nadeLastNade != nade ) {
			if ( nadeSaveMode ) {
				ScriptPrintMessageCenterAll( "Saved" );
				nadePos = nade.GetCenter();
				nadeVel = nade.GetVelocity();
				nadeSaveMode = false;
			} else {
				nade.SetAbsOrigin( nadePos );
				nade.SetVelocity( nadeVel );
			}
			nadeLastNade = nade;
		}
	}
}

function deleteOtherNades( nade ){
    local other = null;
    if (other == null)
        other = Entities.FindByClassname(null, "smokegrenade_projectile");
    if (other == null)
        other = Entities.FindByClassname(null, "molotov_projectile");
    if (other == null)
        other = Entities.FindByClassname(null, "incgrenade_projectile");

    if (other != null && other != nade){
        other.Destroy();
    }
}