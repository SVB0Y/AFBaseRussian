AF2Fun af2fun;

void AF2Fun_Call()
{
	af2fun.RegisterExpansion(af2fun);
}

class AF2Fun : AFBaseClass
{
	void ExpansionInfo()
	{
		this.AuthorName = "Zode";
		this.ExpansionName = "AdminFuckery2 Фан команды";
		this.ShortName = "AF2F";
	}
	
	void ExpansionInit()
	{
		RegisterCommand("fun_fade", "s!iiiffii", "(игроки) <R> <G> <B> <время затухания> <длительность> <прозрачность> <флаги> - затухание экранов!", ACCESS_H, @AF2Fun::fade);
		RegisterCommand("fun_shake", "fff", " <размах> <частота> <длительность> - землетресение!", ACCESS_H, @AF2Fun::shake);
		RegisterCommand("fun_gibhead", "s", "(игроки) - МЯСО!!! - спавнить череп на игрока", ACCESS_H, @AF2Fun::gibhead);
		RegisterCommand("fun_gibrand", "s!i", "(игроки) <количество> - МЯСО!!! - спавнить мясо на игрока)", ACCESS_H, @AF2Fun::gibrand);
		RegisterCommand("fun_shootgrenade", "!ff", "<скорость вылета> <длительность в секундах> - кидает гранату", ACCESS_H, @AF2Fun::shootgrenade);
		RegisterCommand("fun_shootportal", "!fff", ".fun_shootportal <урон> <радиус> <скорость> - стреляет порталами", ACCESS_H, @AF2Fun::shootportal);
		RegisterCommand("fun_shootrocket", "!f", "<скорость> - стреляет ракетой!", ACCESS_H, @AF2Fun::shootrocket);
		RegisterCommand("fun_maplight", "s", "(знак от A (самая темная) до Z (самая светлая), М стоит по стандарту) - меняет яркость карты", ACCESS_H, @AF2Fun::maplight);
		RegisterCommand("fun_flash", "s!i", "(игроки) <0/1 выкл/вкл> - извините, а кто включил мой фонарик?", ACCESS_H, @AF2Fun::flash);
		RegisterCommand("fun_conc", "sfff", " (игроки) (размах) (частота) (время затухания) - БУХАРИК!", ACCESS_H, @AF2Fun::conc);
		RegisterCommand("fun_fog", "si!iiii", "(игроки) (R) <G> <B> <начало в юнитах> <конец в юнитах> - я ничего не вижу, -1 чтобы отключить!!!!", ACCESS_H, @AF2Fun::fog);
	}
}

namespace AF2Fun
{
	void fog(AFBaseArguments@ AFArgs)
	{
		int r = AFArgs.GetInt(1);
		int g = AFArgs.GetCount() >= 3 ? AFArgs.GetInt(2) : 0;
		int b = AFArgs.GetCount() >= 4 ? AFArgs.GetInt(3) : 0;
		int fogstart = AFArgs.GetCount() >= 5 ? AFArgs.GetInt(4) : 0;
		int fogend = AFArgs.GetCount() >= 6 ? AFArgs.GetInt(5) : 1024;
	
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				NetworkMessage msg(MSG_ONE_UNRELIABLE, NetworkMessages::Fog, pTarget.edict());
					msg.WriteShort(0); //id
					msg.WriteByte(r<=-1?0:1); //enable state
					msg.WriteCoord(0); //unused
					msg.WriteCoord(0); //unused
					msg.WriteCoord(0); //unused
					msg.WriteShort(0); //radius
 					msg.WriteByte(r>=0?r:0); //r
					msg.WriteByte(g); //g
					msg.WriteByte(b); //b
					msg.WriteShort(fogstart); //start dist
					msg.WriteShort(fogend); //end dist
				msg.End();
				af2fun.Tell("туман применен: "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
		
		
	}

	const array<string> g_validLight = {
	"q", "w", "e", "r", "t", "y", "u", "i", "o", "p",
	"a", "s", "d", "f", "g", "h", "j", "k", "l",
	"z", "x", "c", "v", "b", "n", "m"
	};

	void maplight(AFBaseArguments@ AFArgs)
	{
		string cRead = AFArgs.GetString(0);
		if(cRead.Length() >= 2)
		{
			af2fun.Tell("Нельзя изпользовать несколько символов!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		cRead = cRead.ToLowercase();
		if(g_validLight.find(cRead) <= -1)
		{
			af2fun.Tell("Нельзя установить яркость карты: неизтвестный символ (Только от A до Z!)", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		g_EngineFuncs.LightStyle(0, cRead);
		af2fun.Tell("яркость карты установлен на \""+cRead+"\"", AFArgs.User, HUD_PRINTCONSOLE);
	}

	void shootrocket(AFBaseArguments@ AFArgs)
	{
		float fVel = AFArgs.GetCount() >= 1 ? AFArgs.GetFloat(0) : 0.0f;
		g_EngineFuncs.MakeVectors(AFArgs.User.pev.v_angle);
		Vector vecSrc = AFArgs.User.pev.origin+AFArgs.User.pev.view_ofs+g_Engine.v_forward*16;
		if(fVel >= 1.0f)
		{
			Vector vecVel = g_Engine.v_forward*fVel;
			g_EntityFuncs.CreateRPGRocket(vecSrc, AFArgs.User.pev.v_angle, vecVel, AFArgs.User.edict());
		}else
			g_EntityFuncs.CreateRPGRocket(vecSrc, AFArgs.User.pev.v_angle, AFArgs.User.edict());
	}

	void shootportal(AFBaseArguments@ AFArgs)
	{
		float fDmg = AFArgs.GetCount() >= 1 ? AFArgs.GetFloat(0) : 256.0f;
		float fRad = AFArgs.GetCount() >= 2 ? AFArgs.GetFloat(1) : 256.0f;
		float fVel = AFArgs.GetCount() >= 3 ? AFArgs.GetFloat(2) : 256.0f;
		Vector angShoot = AFArgs.User.pev.v_angle + AFArgs.User.pev.punchangle;
		g_EngineFuncs.MakeVectors(angShoot);
		Vector vecSrc = AFArgs.User.pev.origin+AFArgs.User.pev.view_ofs+g_Engine.v_forward*16;
		Vector vecVel = g_Engine.v_forward*fVel;
		g_EntityFuncs.CreateDisplacerPortal(vecSrc, vecVel, AFArgs.User.edict(), fDmg, fRad);
	}

	void shootgrenade(AFBaseArguments@ AFArgs)
	{
		float fMult = AFArgs.GetCount() >= 1 ? AFArgs.GetFloat(0) : 8.0f;
		float fTime = AFArgs.GetCount() >= 2 ? AFArgs.GetFloat(1) : 3.0f;
		Vector angThrow = AFArgs.User.pev.v_angle + AFArgs.User.pev.punchangle;
		if(angThrow.x < 0)
			angThrow.x = -10+angThrow.x*0.8888888888888889f; // magic number: ((90-10)/90.0f)
		else
			angThrow.x = -10+angThrow.x*1.1111111111111111f; // magic number: ((90+10)/90.0f)
			
		float flVel = (90-angThrow.x)*fMult;
		g_EngineFuncs.MakeVectors(angThrow);
		Vector vecSrc = AFArgs.User.pev.origin+AFArgs.User.pev.view_ofs+g_Engine.v_forward*16;
		Vector vecThrow = g_Engine.v_forward*flVel+AFArgs.User.pev.velocity;
		if(fTime <= 0.0f)
			g_EntityFuncs.ShootContact(AFArgs.User.pev, vecSrc, vecThrow);
		else
			g_EntityFuncs.ShootTimed(AFArgs.User.pev, vecSrc, vecThrow, fTime);
	}

	void gibrand(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		int iAmt = AFArgs.GetCount() >= 2 ? AFArgs.GetInt(1) : 8;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				g_EntityFuncs.SpawnRandomGibs(pTarget.pev, iAmt, 1);
			}
		}
	}

	void gibhead(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				g_EntityFuncs.SpawnHeadGib(pTarget.pev);
			}
		}
	}

	void fade(AFBaseArguments@ AFArgs)
	{
		int iR = AFArgs.GetCount() >= 2 ? AFBase::cclamp(AFArgs.GetInt(1), 0, 255) : 255;
		int iG = AFArgs.GetCount() >= 3 ? AFBase::cclamp(AFArgs.GetInt(2), 0, 255) : 255;
		int iB = AFArgs.GetCount() >= 4 ? AFBase::cclamp(AFArgs.GetInt(3), 0, 255) : 255;
		float fFade = AFArgs.GetCount() >= 5 ? AFBase::cclamp(AFArgs.GetFloat(4), 0.0, 32000) : 4.0f;
		float fHold = AFArgs.GetCount() >= 6 ? AFBase::cclamp(AFArgs.GetFloat(5), 0.0, 32000) : 4.0f;
		int iA = AFArgs.GetCount() >= 7 ? AFBase::cclamp(AFArgs.GetInt(6), 0, 255) : 255;
		int iFlags = AFArgs.GetCount() >= 8 ? AFBase::cclamp(AFArgs.GetInt(7), 0, 8) : 0;
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				g_PlayerFuncs.ScreenFade(pTarget, Vector(iR, iG, iB), fFade, fHold, iA, iFlags);
			}
		}
	}
	
	void shake(AFBaseArguments@ AFArgs)
	{
		float fAmp = AFArgs.GetCount() >= 1 ? AFArgs.GetFloat(0) : 10.0f;
		float fFreq = AFArgs.GetCount() >= 2 ? AFArgs.GetFloat(1): 10.0f;
		float fDur = AFArgs.GetCount() >= 3 ? AFArgs.GetFloat(2) : 10.0f;
		g_PlayerFuncs.ScreenShakeAll(AFArgs.User.pev.origin, fAmp, fFreq, fDur);
	}
	
	void flash(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				if(AFArgs.GetCount() == 1)
				{
					af2fun.Tell("фонарик переключен: "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
					if(pTarget.FlashlightIsOn())
						pTarget.FlashlightTurnOff();
					else
						pTarget.FlashlightTurnOn();
				}else{
					af2fun.Tell("фонарик настроен: "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
					if(AFArgs.GetInt(1) == 0)
						pTarget.FlashlightTurnOff();
					else
						pTarget.FlashlightTurnOn();
				}
			}
		}
	 }
	 
	 void conc(AFBaseArguments@ AFArgs)
	 {
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				g_PlayerFuncs.ConcussionEffect(pTarget, AFArgs.GetFloat(1), AFArgs.GetFloat(2), AFArgs.GetFloat(3));
				if(AFArgs.GetString(0) == "@me")
					af2fun.Tell("\"Это не может быть хорошим для меня но я чуствую лучше\"", AFArgs.User, HUD_PRINTCONSOLE);
				else
					af2fun.Tell("отбухарили: "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	 }
}