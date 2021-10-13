//stock

AFBaseBase afbasebase;
void AFBaseBaseExpansionCall()
{
	afbasebase.RegisterExpansion(afbasebase);
}

class AFBaseBase : AFBaseClass
{
	void ExpansionInfo()
	{
		this.AuthorName = "Zode";
		this.ExpansionName = "AdminFuckery Базовая";
		this.ShortName = "AFB";
		this.StatusOverride = true; // Base plugin cant be stopped
	}
	
	void ExpansionInit()
	{
		AFBaseBase::g_decaltrackers.resize(0);
		RegisterCommand("afb_help", "!ib", "<страница 1-10> <0/1 показывать дополнения> - показывает команды афб", ACCESS_Z, @AFBaseBase::help, CMD_SERVER);
		RegisterCommand("afb_info", "", "- информация о афб", ACCESS_Z, @AFBaseBase::info, CMD_SERVER);
		RegisterCommand("afb_who", "!b", "<0/1 не укорачивать ники> - показывает общее доступную информацию о игроках", ACCESS_Z, @AFBaseBase::who, CMD_SERVER);
		RegisterCommand("afb_expansion_list", "", "- список дополнений афб", ACCESS_Z, @AFBaseBase::extlist, CMD_SERVER);
		RegisterCommand("afb_expansion_stop", "s", "(айди дополнения) - останавливает дополнение", ACCESS_B, @AFBaseBase::extstop, CMD_SERVER);
		RegisterCommand("afb_expansion_start", "s", "(айди дополнения) - стартует дополнение", ACCESS_B, @AFBaseBase::extstart, CMD_SERVER);
		RegisterCommand("afb_access", "s!s", "(игрок) (доступ) - выдаёт административные флаги выбранному игроку, + выдает, - отбирает", ACCESS_B, @AFBaseBase::access, CMD_SERVER); 
		RegisterCommand("admin_kick", "s!s", "(игрок) <\"причина\"> - кикает игрока", ACCESS_E, @AFBaseBase::kick, CMD_SERVER);
		RegisterCommand("admin_rcon", "s!i", "(команда) <без кавычек 0/1> - выполняет команду от имени консоли", ACCESS_C, @AFBaseBase::rcon);
		RegisterCommand("admin_changelevel", "s", "(название карты) - меняет карту", ACCESS_E, @AFBaseBase::changelevel, CMD_SERVER);
		RegisterCommand("admin_slay", "s", "(игрок) - убивает игрока", ACCESS_G, @AFBaseBase::slay, CMD_SERVER);
		RegisterCommand("admin_slap", "s!i", "(игрок) <урон> - бьёт игрока", ACCESS_G, @AFBaseBase::slap, CMD_SERVER);
		RegisterCommand("admin_say", "bis!isiiiff", "(0/1 показывать имя) (0/1/2 чат/худ/по середине) (\"текст\") <длительность> <игрок> <R> <G> <B> <X> <Y> - пишет текст", ACCESS_H, @AFBaseBase::say, CMD_SERVER);
		RegisterCommand("admin_trackdecals", "!i", "<0/1 вкл/выкл> - отслеживает стим айди и имя игрока, при наводке на спрей", ACCESS_G, @AFBaseBase::trackdecals);
		RegisterCommand("admin_ban", "s!sib", "(\"стим айди\") <\"причина\"> (длительность в минутах, 0 навсегда) (0 бан по стим айди, 1 бан по айпи) - банит игрока", ACCESS_D, @AFBaseBase::ban, CMD_SERVER);
		RegisterCommand("admin_unban", "s", "(\"стим айди/айпи\") - разбан игрока", ACCESS_D, @AFBaseBase::unban, CMD_SERVER);
		RegisterCommand("afb_setlast", "s", "(игрок) - ставит на игрока тег @last, полезно если к примеру ты часто пишешь ему команды", ACCESS_G, @AFBaseBase::selectlast);
		RegisterCommand("admin_banlate", "s!si", "(\"стим айди/айпи\") <\"причина\"> (длительность в минутах, 0 навсегда) - банит игрока, добавляя его айди/айпи в бан лист", ACCESS_D, @AFBaseBase::banlate, CMD_SERVER);
		RegisterCommand("admin_blockdecals", "sb", "(игрок) (0/1 разбан/бан) - блокирует выбранному игроку использовать спрей", ACCESS_G, @AFBaseBase::bandecals, CMD_SERVER);
		RegisterCommand("admin_gag", "ss", "(игроки) (режим a/c/v) - мьюутить игрока, c = чат, v = голосовой, a = оба", ACCESS_G, @AFBaseBase::gag, CMD_SERVER);
		RegisterCommand("admin_ungag", "s", "(игроки) - размьючивает игрока", ACCESS_G, @AFBaseBase::ungag, CMD_SERVER);
		RegisterCommand("afb_peek", "s", "(игрок) - показывает информацию о игроке", ACCESS_B, @AFBaseBase::peek, CMD_SERVER);
		RegisterCommand("afb_disconnected", "!b", "<0/1 не укорачивать ники> - показывает недавний список игроков которые вышли из сервера", ACCESS_E, @AFBaseBase::disconnected, CMD_SERVER);
		RegisterCommand("afb_last", "!b", "<0/1 не укорачивать ники> - алиас к .afb_disconnected, тоже показывает информацию о игроках которые недавно вышли", ACCESS_E, @AFBaseBase::disconnected, CMD_SERVER);
		RegisterCommand("afb_whatsnew", "", "- показывает список новых изменений в обновлённом версии afb", ACCESS_Z, @AFBaseBase::whatsnew, CMD_SERVER);
		
		@AFBaseBase::cvar_iBanMaxMinutes = CCVar("afb_maxban", 10080, "максимальное время бана в минутах (по стандарту: 10080)", ConCommandFlag::AdminOnly, CVarCallback(this.afb_cvar_ibanmaxminutes));
		
		g_Hooks.RegisterHook(Hooks::Player::PlayerDecal, @AFBaseBase::PlayerDecalHook);
		g_Hooks.RegisterHook(Hooks::Player::PlayerPreDecal, @AFBaseBase::PlayerPreDecalHook);
		g_Hooks.RegisterHook(Hooks::Player::PlayerSpawn, @AFBaseBase::PlayerSpawn);
		g_Hooks.RegisterHook(Hooks::Player::ClientSay, @AFBaseBase::PlayerTalk);
	}
	
	void afb_cvar_ibanmaxminutes(CCVar@ cvar, const string &in szOldValue, float flOldValue)
	{
		if(cvar.GetInt() < 0)
			cvar.SetInt(1);
	}
	
	void MapInit()
	{
		AFBaseBase::g_decaltrackers.resize(0);
		g_Game.PrecacheModel("sprites/zbeam3.spr");
		g_SoundSystem.PrecacheSound("zode/thunder.ogg");
		g_Game.PrecacheGeneric("sound/zode/thunder.ogg");
		g_SoundSystem.PrecacheSound("weapons/cbar_hitbod1.wav");
		AFBaseBase::g_PlayerDecalTracker.Reset();
		AFBaseBase::CheckDisconnects();
		
		dictionary MenuCommands = {
			{".admin_slay","slay"},
			{".afb_setlast","set as @last target"}
		}; // purposefully not broadcasting to everything with *, instead using SID
		afbasebase.SendMessage("AF2MS", "RegisterMenuCommand", MenuCommands);
	}
	
	void ClientDisconnectEvent(CBasePlayer@ pUser)
	{
		if(AFBaseBase::g_decaltrackers.find(pUser.entindex()) > -1)
			AFBaseBase::g_decaltrackers.removeAt(AFBaseBase::g_decaltrackers.find(pUser.entindex()));
			
		AFBaseBase::UserDisconnected(pUser);
	}
}

namespace AFBaseBase
{
	void whatsnew(AFBaseArguments@ AFArgs)
	{
		File@ file = g_FileSystem.OpenFile("scripts/plugins/AFBase/chlog.txt", OpenFile::READ);
		
		if(file !is null && file.IsOpen())
		{
			TellLongCustom("----AdminFuckeryBase: Что нового:------------------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
			TellLongCustom("AFB Версия: "+AFBase::g_afInfo+"\nСписок изменений:\n", AFArgs.User, HUD_PRINTCONSOLE);
			
			while(!file.EOFReached())
			{
				string sLine;
				file.ReadLine(sLine);
				//fix for linux
				string sFix = sLine.SubString(sLine.Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					sLine = sLine.SubString(0, sLine.Length()-1);
					
				if(sLine.IsEmpty())
					continue;
					
				TellLongCustom(sLine+"\n", AFArgs.User, HUD_PRINTCONSOLE);
			}
			
			TellLongCustom("--------------------------------------------------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
			file.Close();
		}else{
			AFBase::BaseLog("Ошибка установки: неможет найти файл изменений");
			afbasebase.Tell("Ошибка установки: неможет найти файл изменений", AFArgs.User, HUD_PRINTCONSOLE);
		}
	}

	class DisconnectedUser
	{
		string sTime;
		string sNick;
		string sIp;
		string sSteam;
	}
	
	dictionary g_disconnectedUserList;
	
	void UserDisconnected(CBasePlayer@ pUser)
	{
		DisconnectedUser disUser;
		DateTime datetime;
		time_t unixtime = datetime.ToUnixTimestamp();
		disUser.sTime = string(unixtime);
		AFBase::AFBaseUser@ AFBUser = AFBase::GetUser(pUser);
		if(AFBUser is null)
		{
			afbasebase.Log("Лог дисконектов: провалено нахождение закешированую информацию пользователей");
			return;
		}
		
		disUser.sNick = AFBUser.sNick;
		disUser.sIp = AFBUser.sIp;
		disUser.sSteam = AFBUser.sSteam;
		g_disconnectedUserList[disUser.sSteam] = disUser;
	}
	
	void CheckDisconnects()
	{
		array<string> disKeys = g_disconnectedUserList.getKeys();
		array<string> toRemove;
		DisconnectedUser@ disUser = null;
		for(uint i = 0; i < disKeys.length(); i++)
		{
			@disUser = cast<DisconnectedUser@>(g_disconnectedUserList[disKeys[i]]);
			if(disUser !is null)
			{
				DateTime datetime;
				time_t unixtime = datetime.ToUnixTimestamp();
				DateTime datetime2 = datetime;
				datetime2.SetUnixTimestamp(atoi(disUser.sTime));
				time_t unixtime2 = datetime2.ToUnixTimestamp();
				time_t unixtimeleft = unixtime-unixtime2;
				int iTime = int(unixtimeleft/60);
				if(iTime >= 30)
					toRemove.insertLast(disKeys[i]);
			}
		}
		
		for(uint i = 0; i < toRemove.length(); i++)
		{
			g_disconnectedUserList.delete(toRemove[i]);
		}
	}
	
	void disconnected(AFBaseArguments@ AFArgs)
	{
		bool bNoFormat = AFArgs.GetCount() >= 1 ? AFArgs.GetBool(0) : false;
		array<string> disKeys = g_disconnectedUserList.getKeys();
		string sSpace = "                                                                                                                                                                ";
		TellLongCustom("----AdminFuckeryBase: Игроки которые недавно вышли из сервера-----------------\n", AFArgs.User, HUD_PRINTCONSOLE);
		if(!bNoFormat)
			TellLongCustom("----Ники которые имееют 15+ символов будут укорочены с \"~\", изпользуйте .afb_disconnected 1 чтобы обойти это\n", AFArgs.User, HUD_PRINTCONSOLE);
		else
			TellLongCustom("----Ники не укороченые. Форматирование может сломаться от этого, изпользуйте .afb_disconnected 0 чтобы обойти это\n", AFArgs.User, HUD_PRINTCONSOLE);
		int iOffsetId = 0;
		uint iLongestNick = 4;
		uint iLongestAuth = 6;
		uint iLongestIp = 2;
		uint iLongestMinutes = 6;
		string stempip = "";
		DisconnectedUser@ disUser = null;
		for(uint i = 0; i < disKeys.length(); i++)
		{
			@disUser = cast<DisconnectedUser@>(g_disconnectedUserList[disKeys[i]]);
			if(disUser !is null)
			{
				if(disUser.sNick.Length() > iLongestNick)
					if(!bNoFormat)
						if(disUser.sNick.Length() > 14)
							iLongestNick = 14;
						else
							iLongestNick = disUser.sNick.Length();
					else
						iLongestNick = disUser.sNick.Length();
					
				if(disUser.sSteam.Length() > iLongestAuth)
					iLongestAuth = disUser.sSteam.Length();
					
				stempip = disUser.sIp == "" ? "N/A Unknown" : disUser.sIp;
					
				if(stempip.Length() > iLongestIp)
					iLongestIp = stempip.Length();
			}
		}
		
		iOffsetId = int(floor(disKeys.length()/10));
		if(iOffsetId < 1)
			iOffsetId = 1;
		string sVID = sSpace.SubString(0,iOffsetId)+"#  ";
		string sVNICK = "Ник"+sSpace.SubString(0,iLongestNick-4)+"  ";
		string sVAUTH = "АутID"+sSpace.SubString(0,iLongestAuth-6)+"  ";
		string sVIP = "IP"+sSpace.SubString(0,iLongestIp-2)+"  ";
		string sMIN = "Минут(ов)"+sSpace.SubString(0,iLongestMinutes-6);
		TellLongCustom(sVID+sVNICK+sVAUTH+sVIP+sMIN+"\n", AFArgs.User, HUD_PRINTCONSOLE);
		for(uint i = 0; i < disKeys.length(); i++)
		{
			@disUser = cast<DisconnectedUser@>(g_disconnectedUserList[disKeys[i]]);
			if(disUser !is null)
			{
				iOffsetId = iOffsetId-int(floor((1+i)/10));
				if(iOffsetId < 1)
					iOffsetId = 1;
					
				if(i >= 9) // 21.7.2017 -- fixes offset by one character when more than 10 players are in the server
					sVID = sSpace.SubString(0, iOffsetId)+string(1+i)+" ";
				else
					sVID = sSpace.SubString(0, iOffsetId)+string(1+i)+"  ";
					
				if(!bNoFormat)
					if(disUser.sNick.Length() > 14)
					{
						string sFormNick = disUser.sNick.SubString(0,13)+"~";
						sVNICK = sFormNick+sSpace.SubString(0,iLongestNick-14)+"  ";
					}else
						sVNICK = disUser.sNick+sSpace.SubString(0,iLongestNick-disUser.sNick.Length())+"  ";
				else
					sVNICK = disUser.sNick+sSpace.SubString(0,iLongestNick-disUser.sNick.Length())+"  ";
				
				sVAUTH = disUser.sSteam+sSpace.SubString(0,iLongestAuth-disUser.sSteam.Length())+"  ";
				stempip = disUser.sIp == "" ? "N/A Unknown" : disUser.sIp;
				sVIP = stempip+sSpace.SubString(0, iLongestIp-stempip.Length())+"  ";
				
				DateTime datetime;
				time_t unixtime = datetime.ToUnixTimestamp();
				DateTime datetime2 = datetime;
				datetime2.SetUnixTimestamp(atoi(disUser.sTime));
				time_t unixtime2 = datetime2.ToUnixTimestamp();
				time_t unixtimeleft = unixtime-unixtime2;
				sMIN = string(int(unixtimeleft/60));
				sMIN = sMIN+sSpace.SubString(0, iLongestMinutes-sMIN.Length());
				
				TellLongCustom(sVID+sVNICK+sVAUTH+sVIP+sMIN+"\n", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
		TellLongCustom("--------------------------------------------------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
	}

	void peek(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), 0, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				AFBase::AFBaseUser@ afbUser = AFBase::GetUser(pTarget);
				if(afbUser is null)
				{
					afbasebase.Tell("Нельзя посмотреть: AFBaseUser класс отсутсвует!", AFArgs.User, HUD_PRINTCONSOLE);
					return;
				}
				
				afbasebase.Tell("Смотрим: "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Tell("bLock: "+(afbUser.bLock ? "True" : "False"), AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Tell("iAccess: "+string(afbUser.iAccess), AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Tell("sAccess: "+afbUser.sAccess, AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Tell("sLastTarget: "+afbUser.sLastTarget, AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Tell("sNick: "+afbUser.sNick, AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Tell("sOldNick: "+afbUser.sOldNick, AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Tell("sSteam: "+afbUser.sSteam, AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Tell("bSprayBan: "+(afbUser.bSprayBan ? "True" : "False"), AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Tell("iGagMode: "+string(afbUser.iGagMode), AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}

	void AddBan(CBasePlayer@ pTarget, int iMinutes, string sReason, bool bUseIp)
	{
		string sId = AFBase::FormatSafe(AFBase::GetFixedSteamID(pTarget));
		AFBase::AFBaseUser afbUser = AFBase::GetUser(pTarget);
		string sIp = afbUser.sIp;
		
		if(bUseIp)
			AFBase::UpdateBanFile(sIp, iMinutes, sReason, true);
		else
			AFBase::UpdateBanFile(sId, iMinutes, sReason, false);
		
		if(iMinutes == 0)
			g_EngineFuncs.ServerCommand("kick #"+string(g_EngineFuncs.GetPlayerUserId(pTarget.edict()))+" \""+sReason+" (длительность бана: навсегда)\"\n");
		else
			g_EngineFuncs.ServerCommand("kick #"+string(g_EngineFuncs.GetPlayerUserId(pTarget.edict()))+" \""+sReason+" (длительность бана: "+string(iMinutes)+"m)\"\n");
	}
	
	void AddBan(string sInput, int iMinutes, string sReason, bool bIsIp)
	{
		if(bIsIp)
			AFBase::UpdateBanFile(sInput, iMinutes, sReason, true);
		else
			AFBase::UpdateBanFile(sInput, iMinutes, sReason, false);
	}
	
	bool RemoveBan(string sInput, bool bIsIp)
	{
		bool bOut = false;
		if(bIsIp)
			bOut = AFBase::UpdateBanFile(sInput, -1, "разбан", true);
		else
			bOut = AFBase::UpdateBanFile(sInput, -1, "разбан", false);
			
		return bOut;
	}

	void ungag(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOALL|TARGETS_NOAIM|TARGETS_NORANDOM, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				int iIndex = pTarget.entindex();
				AFBase::AFBaseUser afbUser = AFBase::GetUser(pTarget);
				if(afbUser.iGagMode == -1)
				{
					afbasebase.Tell("Нельзя размьютить: "+pTarget.pev.netname+"! Цель уже размьючена.", AFArgs.User, HUD_PRINTCONSOLE);
					continue;
				}
				
				afbUser.bLock = false;
				afbUser.iGagMode = -1;
				afbUser.bLock = true;
				AFBase::g_afbUserList[iIndex] = afbUser;
				
				CheckGagBan(pTarget);
				string sFixId = AFBase::FormatSafe(AFBase::GetFixedSteamID(pTarget));
				AFBase::UpdateGagFile(sFixId, -1);
				
				afbasebase.TellAll(AFArgs.FixedNick+" размьючиваем игрока \""+pTarget.pev.netname+"\"", HUD_PRINTTALK);
				afbasebase.Tell("размьючиваем \""+pTarget.pev.netname+"\"", AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Log(AFArgs.FixedNick+" размьючен \""+pTarget.pev.netname+"\"");
			}
		}
	}

	HookReturnCode PlayerTalk(SayParameters@ sparams)
	{
		CBasePlayer@ pUser = sparams.GetPlayer();
		
		if(AFBase::g_afbUserList.exists(pUser.entindex()))
		{
			AFBase::AFBaseUser afbUser = AFBase::GetUser(pUser);
			if(afbUser.iGagMode == 1 || afbUser.iGagMode == 3)
			{
				afbasebase.Tell("Чат запрещён: вы замьючены", pUser, HUD_PRINTTALK);
				sparams.set_ShouldHide(true);
				return HOOK_HANDLED;
			}
		}
		
		return HOOK_CONTINUE;
	}

	void CheckGagBan(CBasePlayer@ pPlayer)
	{
		if(pPlayer is null)
		{
			//since the new ban system doesn't actually care about players but rather the indexes and is cleared when a player disconnects,
			// we just check & apply each index against each other
			for(int i = 1; i < g_Engine.maxClients; i++)
			{
				AFBase::AFBaseUser@ afbUser = AFBase::GetUser(i);
				if(afbUser is null) continue;
				
				if(afbUser.iGagMode >= 2) // voice or all
					for(int j = 1; j < g_Engine.maxClients; j++)
						g_EngineFuncs.Voice_SetClientListening(j, i, true);
				else
					for(int j = 1; j < g_Engine.maxClients; j++)
						g_EngineFuncs.Voice_SetClientListening(j, i, false);
			}
			
			return;
		}
		
		//route for gag/ungag commands
		AFBase::AFBaseUser@ afbUser = AFBase::GetUser(pPlayer);
		if(afbUser is null) return; // shouldn't happen but is a possibility
		
		if(afbUser.iGagMode >= 2)
			for(int i = 1; i <= g_Engine.maxClients; i++)
				g_EngineFuncs.Voice_SetClientListening(i, pPlayer.entindex(), true);
		else
			for(int i = 1; i <= g_Engine.maxClients; i++)
				g_EngineFuncs.Voice_SetClientListening(i, pPlayer.entindex(), false);
	}

	void gag(AFBaseArguments@ AFArgs)
	{
		string sMode = AFArgs.GetString(1);
		if(sMode != "a" && sMode != "c" && sMode != "v")
		{
			afbasebase.Tell("Неизвестный режим!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		int iMode = 0;
		if(sMode == "a")
			iMode = 3;
		else if(sMode == "c")
			iMode = 1;
		else
			iMode = 2;
			
		string sOutMode = "";
		if(iMode == 3)
			sOutMode = "чат & голосовой";
		else if(iMode == 2)
			sOutMode = "голосовой";
		else
			sOutMode = "чат";
	
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOALL|TARGETS_NOAIM|TARGETS_NORANDOM, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				int iIndex = pTarget.entindex();
				AFBase::AFBaseUser afbUser = AFBase::GetUser(pTarget);
				if(afbUser.iGagMode != -1)
				{
					afbasebase.Tell("Нельзя замьютить: "+pTarget.pev.netname+"! Цель уже имеет режим мьюта.", AFArgs.User, HUD_PRINTCONSOLE);
					continue;
				}
				
				afbUser.bLock = false;
				afbUser.iGagMode = iMode;
				afbUser.bLock = true;
				AFBase::g_afbUserList[iIndex] = afbUser;
				
				CheckGagBan(pTarget);
				string sFixId = AFBase::FormatSafe(AFBase::GetFixedSteamID(pTarget));
				AFBase::UpdateGagFile(sFixId, iMode);
				
				afbasebase.TellAll(AFArgs.FixedNick+" замьючил игрока \""+pTarget.pev.netname+"\" (режим: "+sOutMode+")", HUD_PRINTTALK);
				afbasebase.Tell("Замьютил \""+pTarget.pev.netname+"\" (режим: "+sOutMode+")", AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Log(AFArgs.FixedNick+" замьючен \""+pTarget.pev.netname+"\" (режим: "+sOutMode+" )");
			}
		}
	}

	HookReturnCode PlayerSpawn(CBasePlayer@ pPlayer)
	{
		EHandle ePlayer = pPlayer;
		g_Scheduler.SetTimeout("PlayerPostSpawn", 0.01f, ePlayer);
		
		return HOOK_CONTINUE;
	}
	
	void PlayerPostSpawn(EHandle ePlayer)
	{
		CheckGagBan(null); //trigger a check against all indexes so that gag bans are applied for players that join later than when the gag happened
		/*if(ePlayer)
		{
			CBaseEntity@ pPlayer = ePlayer;
			//CheckSprayBan(cast<CBasePlayer@>(pPlayer));
			CheckGagBan(cast<CBasePlayer@>(pPlayer));
		}*/
	}
	
	void CheckSprayBan(CBasePlayer@ pTarget)
	{	
		if(pTarget is null)
			return;
			
		if(AFBase::g_afbUserList.exists(pTarget.entindex()))
		{
			AFBase::AFBaseUser afbUser = AFBase::GetUser(pTarget);
			if(afbUser.bSprayBan)
				pTarget.m_flNextDecalTime = Math.FLOAT_MAX;
			else
				pTarget.m_flNextDecalTime = Math.FLOAT_MIN;
		}
	}
	
	HookReturnCode PlayerPreDecalHook(CBasePlayer@ pPlayer, const TraceResult& in trace, bool& out bResult)
	{
		if(AFBase::g_afbUserList.exists(pPlayer.entindex()))
		{
			AFBase::AFBaseUser afbUser = AFBase::GetUser(pPlayer);
			if(afbUser.bSprayBan)
			{
				bResult = false;
			}
			else
			{
				bResult = true;
			}
		}else{
			bResult = true;
		}
		
		return HOOK_CONTINUE;
	}
	
	void bandecals(AFBaseArguments@ AFArgs)
	{
		bool bMode = AFArgs.GetBool(1);
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOALL|TARGETS_NOAIM|TARGETS_NORANDOM, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				int iIndex = pTarget.entindex();
				AFBase::AFBaseUser afbUser = AFBase::GetUser(pTarget);
				if(afbUser.bSprayBan && bMode)
				{
					afbasebase.Tell("Нельзя заблокировать спрей: у игрока и так заблокировано!", AFArgs.User, HUD_PRINTCONSOLE);
					continue;
				}else if(!afbUser.bSprayBan && !bMode)
				{
					afbasebase.Tell("Нельзя разблокировать спрей: спрей игрока не заблокирован", AFArgs.User, HUD_PRINTCONSOLE);
					continue;
				}
				
				afbUser.bLock = false;
				afbUser.bSprayBan = bMode;
				afbUser.bLock = true;
				AFBase::g_afbUserList[iIndex] = afbUser;
				
				string sFixId = AFBase::FormatSafe(AFBase::GetFixedSteamID(pTarget));
				AFBase::UpdateSprayFile(sFixId, bMode);
				//CheckSprayBan(pTarget);
				
				if(bMode)
				{
					afbasebase.TellAll(AFArgs.FixedNick+" заблокировал игроку \""+AFArgs.GetString(0)+"\" изпользовать спрей", HUD_PRINTTALK);
					afbasebase.Tell("Заблокировано \""+AFArgs.GetString(0)+"\" изпользовать спрей", AFArgs.User, HUD_PRINTCONSOLE);
					afbasebase.Log(AFArgs.FixedNick+" заблокировал \""+AFArgs.GetString(0)+"\" изпользовать спрей");
				}else{
					afbasebase.TellAll(AFArgs.FixedNick+" разблокировал игроку \""+AFArgs.GetString(0)+"\" изпользовать спрей", HUD_PRINTTALK);
					afbasebase.Tell("Разблокировано \""+AFArgs.GetString(0)+"\" изпользовать спрей", AFArgs.User, HUD_PRINTCONSOLE);
					afbasebase.Log(AFArgs.FixedNick+" разблокировал \""+AFArgs.GetString(0)+"\" изпользовать спрей");
				}
			}
		}
	}

	void banlate(AFBaseArguments@ AFArgs)
	{
		string sReason = AFArgs.GetCount() >= 2 ? AFArgs.GetString(1) : "забанен";
		int iMinutes = AFArgs.GetCount() >= 3 ? AFArgs.GetInt(2) : 30;
		
		if(!AFBase::IsNumeric(AFArgs.RawArgs[3]))
		{
			afbasebase.TellLong("Упс! Походу вы перепутали аргументы. Вы написали параметр \""+AFArgs.RawArgs[3]+"\" как длительность бана.", AFArgs.User, HUD_PRINTCONSOLE);
			afbasebase.TellLong("Изпользование: .admin_banlate (\"стим айди/айпи\") <\"причина\"> (длительность в минутах, 0 навсегда)", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		if(iMinutes < 0)
			iMinutes = 0;
			
		if(iMinutes == 0 && !AFArgs.IsServer)
		{
			if(!AFBase::CheckAccess(AFArgs.User, ACCESS_C))
			{
				afbasebase.Tell("Бан навсегда невозможен: у вас не хватает флага С!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
		}else if(iMinutes > cvar_iBanMaxMinutes.GetInt()){
			iMinutes = cvar_iBanMaxMinutes.GetInt();
			afbasebase.Tell("Ограничиваем время бана, которая больше чем параметр: "+string(cvar_iBanMaxMinutes.GetInt()), AFArgs.User, HUD_PRINTCONSOLE);
		}
			
		string sHold = AFArgs.GetString(0);
		if(sHold.SubString(0,6).ToLowercase() == "steam_")
		{
			if(iMinutes > 0)
			{
				afbasebase.TellAll(AFArgs.FixedNick+" забанил \""+AFArgs.GetString(0)+"\" на "+string(iMinutes)+" минут", HUD_PRINTTALK);
				afbasebase.Tell("Забанили \""+AFArgs.GetString(0)+"\" на "+string(iMinutes)+" минут", AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Log(AFArgs.FixedNick+" забанил \""+AFArgs.GetString(0)+"\" на "+string(iMinutes)+" минут");
			}else{
				afbasebase.TellAll(AFArgs.FixedNick+" забанил \""+AFArgs.GetString(0)+"\" навсегда", HUD_PRINTTALK);
				afbasebase.Tell("Забанили \""+AFArgs.GetString(0)+"\" навсегда", AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Log(AFArgs.FixedNick+" забанил \""+AFArgs.GetString(0)+"\" навсегда");
			}
			
			AddBan(sHold, iMinutes, sReason, false);
		}else{
			if(sHold.ToLowercase() == "loopback" || sHold == "127.0.0.1")
			{
				afbasebase.Tell("Бан невозможен: айпи пользователя локальный!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
			
			if(iMinutes > 0)
			{
				afbasebase.TellAll(AFArgs.FixedNick+" забанил \""+AFArgs.GetString(0)+"\" на "+string(iMinutes)+" минут", HUD_PRINTTALK);
				afbasebase.Tell("Забанили \""+AFArgs.GetString(0)+"\" на "+string(iMinutes)+" минут", AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Log(AFArgs.FixedNick+" забанил \""+AFArgs.GetString(0)+"\" на "+string(iMinutes)+" минут");
			}else{
				afbasebase.TellAll(AFArgs.FixedNick+" забанил \""+AFArgs.GetString(0)+"\" навсегда", HUD_PRINTTALK);
				afbasebase.Tell("Забанили \""+AFArgs.GetString(0)+"\" навсегда", AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Log(AFArgs.FixedNick+" забанил \""+AFArgs.GetString(0)+"\" навсегда");
			}
			
			AddBan(sHold, iMinutes, sReason, true);
		}
	}

	void selectlast(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOALL, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				afbasebase.Tell("Выбраная цель: "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}

	CCVar@ cvar_iBanMaxMinutes;
	
	void ban(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		string sReason = AFArgs.GetCount() >= 2 ? AFArgs.GetString(1) : "banned";
		int iMinutes = AFArgs.GetCount() >= 3 ? AFArgs.GetInt(2) : 30;
		bool bBanIp = AFArgs.GetCount() >= 4 ? AFArgs.GetBool(3) : false;

		if(sReason == "" || sReason == " ") //fix an edge case where the user inputs "" as the ban reason and completely breaks everything
			sReason = "banned";
		
		if(AFArgs.GetCount() >= 3)
		{
			if(!AFBase::IsNumeric(AFArgs.RawArgs[3]))
			{
				afbasebase.TellLong("Упс! Походу вы перепутали аргументы. Вы написали параметр  \""+AFArgs.RawArgs[3]+"\" как длительность бана.", AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.TellLong("Изпользование: .admin_ban (\"стим айди\") <\"причина\"> (длительность в минутах, 0 навсегда) (0 бан по стим айди, 1 бан по айпи)", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
		}

		if(iMinutes < 0)
			iMinutes = 0;
			
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOALL|TARGETS_NOAIM|TARGETS_NORANDOM, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				string sHold = AFBase::FormatSafe(AFBase::GetFixedSteamID(pTarget));
				if(sHold != "")
				{
					string sId = AFBase::FormatSafe(AFBase::GetFixedSteamID(pTarget));
					AFBase::AFBaseUser@ afbUser = AFBase::GetUser(pTarget);
					if(afbUser is null)
					{
						afbasebase.Tell("Бан невозможен: несуществующий игрок?", AFArgs.User, HUD_PRINTCONSOLE);
						return;
					}
					
					string sIp = afbUser.sIp;
					if(sIp == "" && bBanIp)
					{
						afbasebase.Tell("Бан невозможен: айпи пользователя не найден -- плагин перезапущен?", AFArgs.User, HUD_PRINTCONSOLE);
						return;
					}
					
					if(sIp == "loopback" || sIp == "127.0.0.1")
					{
						afbasebase.Tell("Бан невозможен: айпи пользователя локальный!", AFArgs.User, HUD_PRINTCONSOLE);
						return;
					}
					
					if(iMinutes == 0 && !AFArgs.IsServer)
					{
						if(!AFBase::CheckAccess(AFArgs.User, ACCESS_C))
						{
							afbasebase.Tell("Бан навсегда невозможен: вам нехватает флага С!", AFArgs.User, HUD_PRINTCONSOLE);
							return;
						}
					}else if(iMinutes > cvar_iBanMaxMinutes.GetInt()){
						iMinutes = cvar_iBanMaxMinutes.GetInt();
						afbasebase.Tell("Ограничиваем время бана, которая больше чем параметр: "+string(cvar_iBanMaxMinutes.GetInt()), AFArgs.User, HUD_PRINTCONSOLE);
					}
					
					string sFill = bBanIp ? "ip: "+sIp : "steamid: "+sId;
					if(iMinutes > 0)
					{
						afbasebase.TellAll(AFArgs.FixedNick+" забанил игрока "+pTarget.pev.netname+" ("+sFill+") на "+string(iMinutes)+" минут (причина: "+sReason+")", HUD_PRINTTALK);
						afbasebase.Tell("Забанили игрока "+pTarget.pev.netname+" ("+sFill+") на "+string(iMinutes)+" минут с причиной\""+sReason+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						afbasebase.Log(AFArgs.FixedNick+" забанил игрока "+pTarget.pev.netname+" ("+sFill+") на "+string(iMinutes)+" минут с причиной \""+sReason+"\"");
					}else{
						afbasebase.TellAll(AFArgs.FixedNick+" забанил игрока "+pTarget.pev.netname+" ("+sFill+") навсегда (причина: "+sReason+")", HUD_PRINTTALK);
						afbasebase.Tell("Забанили игрока "+pTarget.pev.netname+" ("+sFill+") навсегда с причиной \""+sReason+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						afbasebase.Log(AFArgs.FixedNick+" забанил игрока "+pTarget.pev.netname+" ("+sFill+") навсегда с причиной \""+sReason+"\"");
					}
					
					AddBan(pTarget, iMinutes, sReason, bBanIp);
				}
			}
		}
	}
	
	void unban(AFBaseArguments@ AFArgs)
	{
		string sHold = AFArgs.GetString(0);
		if(sHold.SubString(0,6).ToLowercase() == "steam_")
		{
			if(RemoveBan(sHold, false))
			{
				afbasebase.TellAll(AFArgs.FixedNick+" разбанил "+sHold, HUD_PRINTTALK);
				afbasebase.Tell("Разбанили "+sHold, AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Log(AFArgs.FixedNick+" разбанил "+sHold);
			}else{
				afbasebase.Tell("Такой записи в бан листе не существует!", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}else{
			if(RemoveBan(sHold, true))
			{
				afbasebase.TellAll(AFArgs.FixedNick+" разбанил "+sHold, HUD_PRINTTALK);
				afbasebase.Tell("Разбанили "+sHold, AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Log(AFArgs.FixedNick+" разбанил "+sHold);
			}else{
				afbasebase.Tell("Такой записи в бан листе не существует!", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}
	
	const uint g_uiMaxDecals = 64;
	const float g_flLifetime = 960;
	const float g_flMaxDistance = 128;
	const int g_iMessageLifeTime = 2;
	array<string> g_decaltrackers;
	
	final class PlayerDecal
	{
		private string m_szPlayerName;
		private string m_szAuthId;
		private Vector m_vecPosition;
		private float m_flCreationTime;
		
		string PlayerName
		{
			get const { return m_szPlayerName; }
		}
		
		string AuthId
		{
			get const { return m_szAuthId; }
		}
		
		Vector Position
		{
			get const { return m_vecPosition; }
		}
		
		float CreationTime
		{
			get const { return m_flCreationTime; }
		}
		
		PlayerDecal()
		{
			Reset();
		}
		
		bool Init( CBasePlayer@ pPlayer, const Vector& in vecPosition, const float flCreationTime )
		{
			Reset();
			if(pPlayer is null)
				return false;
				
			m_szPlayerName = pPlayer.pev.netname;
			m_szAuthId = g_EngineFuncs.GetPlayerAuthId( pPlayer.edict() );
			m_vecPosition = vecPosition;
			m_flCreationTime = flCreationTime;
			return IsValid();
		}
		
		void Reset()
		{
			m_szPlayerName 		= "";
			m_szAuthId 			= "";
			m_vecPosition 		= g_vecZero;
			m_flCreationTime 	= 0;
		}
		
		bool IsInitialized() const
		{
			return m_flCreationTime > 0;
		}
		
		bool HasExpired() const
		{
			return ( m_flCreationTime + g_flLifetime ) < g_Engine.time;
		}
		
		bool IsValid() const
		{
			return !HasExpired() && 
					!m_szPlayerName.IsEmpty() && !m_szAuthId.IsEmpty();
		}
	}
	
	final class PlayerDecalTracker
	{
		private array<PlayerDecal@> m_PlayerDecals;
		private array<int> m_iWasLooking;
		private CScheduledFunction@ m_pFunction = null;
		
		PlayerDecalTracker()
		{
			m_PlayerDecals.resize( g_uiMaxDecals );
			for( uint uiIndex = 0; uiIndex < m_PlayerDecals.length(); ++uiIndex )
				@m_PlayerDecals[ uiIndex ] = @PlayerDecal();
				
			m_iWasLooking.resize( g_Engine.maxClients );
			for( uint uiIndex = 0; uiIndex < m_iWasLooking.length(); ++uiIndex )
				m_iWasLooking[ uiIndex ] = 0;
		}
		
		void Reset()
		{
			for( uint uiIndex = 0; uiIndex < m_PlayerDecals.length(); ++uiIndex )
				m_PlayerDecals[ uiIndex ].Reset();
				
			for( uint uiIndex = 0; uiIndex < m_iWasLooking.length(); ++uiIndex )
				m_iWasLooking[ uiIndex ] = 0;
				
			if( m_pFunction !is null )
				g_Scheduler.RemoveTimer( m_pFunction );
				
			//Think every second
			@m_pFunction = g_Scheduler.SetInterval( @this, "Think", 1 +Math.RandomFloat(0.01f, 0.09f) );
		}
		
		private PlayerDecal@ FindFreeEntry( const bool bInvalidateOldest )
		{
			PlayerDecal@ pDecal = null;
			PlayerDecal@ pOldest = null;
			for( uint uiIndex = 0; uiIndex < m_PlayerDecals.length(); ++uiIndex )
			{
				@pDecal = m_PlayerDecals[ uiIndex ];
				if( !pDecal.IsValid() )
					return pDecal;
				else if( bInvalidateOldest )
				{
					if( pOldest is null || pOldest.CreationTime > pDecal.CreationTime )
					{
						@pOldest = pDecal;
					}
				}
			}
			
			return pOldest;
		}
		
		private const PlayerDecal@ FindNearestDecal( const Vector& in vecOrigin ) const
		{
			PlayerDecal@ pDecal = null;
			PlayerDecal@ pNearest = null;
			float flNearestDistance = Math.FLOAT_MAX;
			for( uint uiIndex = 0; uiIndex < m_PlayerDecals.length(); ++uiIndex )
			{
				@pDecal = m_PlayerDecals[ uiIndex ];
				if( !pDecal.IsValid() )
					continue;
				
				const float flDistance = ( pDecal.Position - vecOrigin ).Length();
				if( pNearest is null || flDistance < flNearestDistance )
				{
					flNearestDistance = flDistance;
					@pNearest = pDecal;
				}
			}
			
			return pNearest;
		}
		
		void PlayerDecalInit( CBasePlayer@ pPlayer, const TraceResult& in trace )
		{
			if( pPlayer is null )
				return;
				
			PlayerDecal@ pEntry = FindFreeEntry( true );
			//This shouldn't ever happen, but still
			if( pEntry is null )
				return;
				
			pEntry.Init( pPlayer, trace.vecEndPos, g_Engine.time );
		}
		
		void Think()
		{
			for( int iPlayer = 1; iPlayer <= g_Engine.maxClients; ++iPlayer )
			{
				CBasePlayer@ pPlayer = g_PlayerFuncs.FindPlayerByIndex( iPlayer );
				if( pPlayer is null || pPlayer.IsConnected() == false )
					continue;

				if(g_decaltrackers.find(pPlayer.entindex()) <= -1)
					continue;

				const Vector vecEyes = pPlayer.pev.origin + pPlayer.pev.view_ofs;
				Vector vec;
				
				{
					Vector vecDummy;
					g_EngineFuncs.AngleVectors( pPlayer.pev.v_angle, vec, vecDummy, vecDummy );
				}
				
				TraceResult tr;
				g_Utility.TraceLine( vecEyes, vecEyes + ( vec * WORLD_BOUNDARY ), dont_ignore_monsters, pPlayer.edict(), tr );
				bool bWasLooking = false;
				if( tr.flFraction < 1.0 )
				{
					const PlayerDecal@ pNearest = FindNearestDecal( tr.vecEndPos );
					if( pNearest !is null )
					{
						if( ( pNearest.Position - tr.vecEndPos ).Length() <= g_flMaxDistance )
						{
							bWasLooking = true;
							string szMessage;
							snprintf( szMessage, "Spray by \n%1 \nAuth ID: %2", pNearest.PlayerName, pNearest.AuthId );
							g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTCENTER, szMessage );
						}
					}
				}
				
				if( bWasLooking )
					m_iWasLooking[ iPlayer - 1 ] = g_iMessageLifeTime;
				else
				{
					if( m_iWasLooking[ iPlayer - 1 ] > 0 )
					{
						g_PlayerFuncs.ClientPrint( pPlayer, HUD_PRINTCENTER, " " );
						--m_iWasLooking[ iPlayer - 1 ];
					}
				}
			}
		}
	}
	
	PlayerDecalTracker g_PlayerDecalTracker;
	
	HookReturnCode PlayerDecalHook(CBasePlayer@ pPlayer, const TraceResult& in trace)
	{
		g_PlayerDecalTracker.PlayerDecalInit(pPlayer, trace);
		return HOOK_CONTINUE;
	}

	void trackdecals(AFBaseArguments@ AFArgs)
	{
		int iMode = AFArgs.GetCount() >= 1 ? AFBase::cclamp(AFArgs.GetInt(0), 0, 1) : -1;
		if(iMode == -1)
		{
			if(g_decaltrackers.find(AFArgs.User.entindex()) > -1)
			{
				g_decaltrackers.removeAt(g_decaltrackers.find(AFArgs.User.entindex()));
				afbasebase.Tell("Остановили отслеживание", AFArgs.User, HUD_PRINTCONSOLE);
			}else{
				g_decaltrackers.insertLast(AFArgs.User.entindex());
				afbasebase.Tell("Начали отслеживание", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}else if(iMode == 1)
		{
			if(g_decaltrackers.find(AFArgs.User.entindex()) > -1)
			{
				afbasebase.Tell("Нельзя установить: не отслеживаем!", AFArgs.User, HUD_PRINTCONSOLE);
			}else{
				g_decaltrackers.insertLast(AFArgs.User.entindex());
				afbasebase.Tell("Начали отслеживание", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}else{
			if(g_decaltrackers.find(AFArgs.User.entindex()) > -1)
			{
				g_decaltrackers.removeAt(g_decaltrackers.find(AFArgs.User.entindex()));
				afbasebase.Tell("Остановили отслеживание", AFArgs.User, HUD_PRINTCONSOLE);
			}else{
				afbasebase.Tell("Нельзя установить: отслеживаем!", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}

	void say(AFBaseArguments@ AFArgs)
	{
		bool bShowName = AFArgs.GetBool(0);
		int iTargetHud = AFBase::cclamp(AFArgs.GetInt(1), 0, 2);
		string sMessage = AFArgs.GetString(2);
		int iHold = AFArgs.GetCount() >= 4 ? AFArgs.GetInt(3) : 5;
		string sWantedTarget = AFArgs.GetCount() >= 5 ? AFArgs.GetString(4) : "@all";
		int iR = AFArgs.GetCount() >= 6 ? AFArgs.GetInt(5) : 255;
		int iG = AFArgs.GetCount() >= 7 ? AFArgs.GetInt(6) : 255;
		int iB = AFArgs.GetCount() >= 8 ? AFArgs.GetInt(7) : 255;
		float fX = AFArgs.GetCount() >= 9 ? AFArgs.GetFloat(8) : -1.0f;
		float fY = AFArgs.GetCount() >= 10 ? AFArgs.GetFloat(9) : -1.0f;
		if(bShowName)
			sMessage = " [АДМИН] "+AFArgs.FixedNick+": "+sMessage;
		else if(!bShowName && iTargetHud == 0) // fix uglyness in chat
			sMessage = " "+sMessage;
			
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, sWantedTarget, TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			afbasebase.Tell("Транслировался \""+sMessage+"\"", AFArgs.User, HUD_PRINTCONSOLE);
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				if(iTargetHud == 0)
				{
					g_PlayerFuncs.ClientPrint(pTarget, HUD_PRINTTALK, " "+sMessage+"\n");
				}else if(iTargetHud == 1)
				{
					HUDTextParams hudTXT;
					hudTXT.holdTime=iHold;
					hudTXT.r1=iR;
					hudTXT.g1=iG;
					hudTXT.b1=iB;
					hudTXT.x=fX;
					hudTXT.y=fY;
					hudTXT.fadeinTime = 0.2f;
					hudTXT.fadeoutTime = 0.2f;
					hudTXT.channel = 2;
					g_PlayerFuncs.HudMessage(pTarget, hudTXT, sMessage+"\n");
				}else{
					g_PlayerFuncs.ClientPrint(pTarget, HUD_PRINTCENTER, sMessage+"\n");
				}
			}
		}
	}

	void slap(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		int iDamage = AFArgs.GetCount() >= 2 ? AFArgs.GetInt(1) : 5;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), 0, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				afbasebase.TellAll(AFArgs.FixedNick+" ударил игрока "+pTarget.pev.netname+" на "+string(iDamage)+" урона", HUD_PRINTTALK);
				afbasebase.Tell("Ударил игрока "+pTarget.pev.netname+" на "+string(iDamage)+" урона", AFArgs.User, HUD_PRINTCONSOLE);
				entvars_t@ world = g_EntityFuncs.Instance(0).pev;
				pTarget.TakeDamage(world, world, iDamage, DMG_GENERIC);
				pTarget.pev.velocity = Vector(Math.RandomFloat(-512,512), Math.RandomFloat(-512,512), Math.RandomFloat(-512,512));
				pTarget.pev.punchangle = Vector(Math.RandomFloat(-16,16), Math.RandomFloat(-16,16), Math.RandomFloat(-16,16));
				if(AFBase::IsSafe())
				{
					g_SoundSystem.PlaySound(pTarget.edict(), CHAN_STATIC, "weapons/cbar_hitbod1.wav", 1.0f, 1.0f);
				}
			}
		}
	}

	void slay(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), 0, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				afbasebase.TellAll(AFArgs.FixedNick+" убил игрока "+pTarget.pev.netname, HUD_PRINTTALK);
				afbasebase.Tell("Убили игрока "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Log(AFArgs.FixedNick+" убил игрока "+pTarget.pev.netname);
				entvars_t@ world = g_EntityFuncs.Instance(0).pev;
				//making sure slay works with non-vanilla players (SCXPM/Balancing scripts or when the admin has poked around with _keyvalue health)
				pTarget.pev.health = 1;
				pTarget.pev.armorvalue = 0;
				pTarget.TakeDamage(world, world, 16384.0f, DMG_ALWAYSGIB|DMG_CRUSH);
				if(AFBase::IsSafe())
				{
					TraceResult tr;
					g_EngineFuncs.MakeVectors(pTarget.pev.angles);
					g_Utility.TraceLine(pTarget.pev.origin, pTarget.pev.origin+g_Engine.v_up*4096, ignore_monsters, pTarget.edict(), tr);
					NetworkMessage message(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
						message.WriteByte(TE_BEAMPOINTS);
						message.WriteCoord(pTarget.pev.origin.x);
						message.WriteCoord(pTarget.pev.origin.y);
						message.WriteCoord(pTarget.pev.origin.z);
						message.WriteCoord(tr.vecEndPos.x);
						message.WriteCoord(tr.vecEndPos.y);
						message.WriteCoord(tr.vecEndPos.z);
						message.WriteShort(g_EngineFuncs.ModelIndex("sprites/zbeam3.spr"));
						message.WriteByte(0);
						message.WriteByte(1);
						message.WriteByte(2);
						message.WriteByte(16);
						message.WriteByte(64);
						message.WriteByte(175);
						message.WriteByte(215);
						message.WriteByte(255);
						message.WriteByte(255);
						message.WriteByte(0);
					message.End();
					NetworkMessage message2(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
						message2.WriteByte(TE_DLIGHT);
						message2.WriteCoord(pTarget.pev.origin.x);
						message2.WriteCoord(pTarget.pev.origin.y);
						message2.WriteCoord(pTarget.pev.origin.z);
						message2.WriteByte(24);
						message2.WriteByte(175);
						message2.WriteByte(215);
						message2.WriteByte(255);
						message2.WriteByte(4);
						message2.WriteByte(88);
					message2.End();
					g_SoundSystem.PlaySound(pTarget.edict(), CHAN_STATIC, "zode/thunder.ogg", 1.0f, 1.0f);
				}
			}
		}
	}
	void changelevel(AFBaseArguments@ AFArgs)
	{
		string sMap = AFArgs.GetString(0);
		sMap = sMap.ToLowercase(); //fixes problems with linux and fastdl
		if(!g_EngineFuncs.IsMapValid(sMap))
		{
			afbasebase.Tell("Can't change: \""+sMap+"\" doesn't exist!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		afbasebase.Tell("Меняем карту на: "+sMap, AFArgs.User, HUD_PRINTCONSOLE);
		afbasebase.TellAll(AFArgs.FixedNick+" поменял карту на "+sMap, HUD_PRINTTALK);
		afbasebase.Log(AFArgs.FixedNick+" поменял карту на "+sMap);
		NetworkMessage message(MSG_ALL, NetworkMessages::SVC_INTERMISSION, null);
		message.End();
		g_Scheduler.SetTimeout("changelevelsteptwo", 4.0f, sMap);
	}
	
	void changelevelsteptwo(string &in sMap)
	{
		g_EngineFuncs.ChangeLevel(sMap);
	}

	const array<string> g_blackListCommands =
	{
	"rcon_password",
	"sv_password",
	"hostname",
	"shutdown",
	"exit",
	"quit",
	"shutdownserver"
	};

	void rcon(AFBaseArguments@ AFArgs)
	{
		array<string> aSHold = AFArgs.GetString(0).Split(" ");
		int noquotes = AFArgs.GetCount() >= 2 ? AFArgs.GetInt(1) : 0;
		
		if(aSHold[0] == " " || aSHold[0] == "\n" || aSHold[0] == "\r" || aSHold[0] == "\t")
					aSHold[0] = aSHold[0].SubString(0, aSHold[0].Length()-1);
		
		if(aSHold[0] == "")
		{
			afbasebase.Tell("Невозможно выполнить rcon: пусто", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}else if(int(AFArgs.GetString(0).FindFirstOf(";", 0)) > -1)
		{
			afbasebase.Tell("Невозможно выполнить rcon: имеет \";\"", AFArgs.User, HUD_PRINTCONSOLE);
			afbasebase.Log("Админ "+AFArgs.User.pev.netname+" пытался выполнить rcon с знаком \";\"");
			return;
		}else if(g_blackListCommands.find(aSHold[0]) > -1)
		{
			afbasebase.Tell("Невозможно выполнить rcon: команда в чёрном списке \""+aSHold[0]+"\"", AFArgs.User, HUD_PRINTCONSOLE);
			afbasebase.Log("Админ "+AFArgs.User.pev.netname+" пытался выполнить rcon с командой из черного списка \""+aSHold[0]+"\"");
			return;
		}else if(int(AFArgs.GetString(0).FindFirstOf("as_command", 0)) > -1)
		{
			array<string> t = AFArgs.GetString(0).Split(" ");
			array<string> c = AFBase::g_afbConCommandList.getKeys();
			bool b = false;
			int w = 0;
			for(uint j = 0; j < t.length(); j++)
			{
				for(uint i = 0; i < c.length(); i++)
				{
					if(t[j] == "."+c[i] || t[j] == "."+AFBase::g_afServerPrefix+c[i])
					{
						w = i; b = true; break;
					}
				}
			}
			if(b)
			{
				afbasebase.Tell("Невозможно выполнить rcon: имеет AFB команду \""+c[w]+"\"", AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Log("Админ "+AFArgs.User.pev.netname+" пытался выполнить rcon с AFB командой \""+c[w]+"\"");
				return;
			}
		}
		
		string sOut = AFArgs.GetString(0);
		
		array<string> parsed = sOut.Split(" ");
		if(parsed.length() >= 2)
		{
			sOut = noquotes == 0 ? parsed[0]+" \"" : parsed[0]+" ";
			for(uint i = 1; i < parsed.length(); i++)
				if(i > 1)
					sOut += " "+parsed[i];
				else
					sOut += parsed[i];
			
			sOut += noquotes == 0 ? "\"" : "";
		}
		
		afbasebase.Tell("Выполнен rcon: "+sOut, AFArgs.User, HUD_PRINTCONSOLE);
		afbasebase.Log("Админ "+AFArgs.User.pev.netname+" выполнил rcon "+sOut);
		g_EngineFuncs.ServerCommand(sOut+"\n");
	}

	void kick(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		string sReason = AFArgs.GetCount() >= 2 ? AFArgs.GetString(1) : "kicked";
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOALL|TARGETS_NOAIM|TARGETS_NORANDOM, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				afbasebase.TellAll(AFArgs.FixedNick+" кикнул игрока "+pTarget.pev.netname+" (причина: "+sReason+")", HUD_PRINTTALK);
				afbasebase.Tell("Кикнули игрока "+pTarget.pev.netname+" с причиной \""+sReason+"\"", AFArgs.User, HUD_PRINTCONSOLE);
				afbasebase.Log(AFArgs.FixedNick+" кикнул игрока "+pTarget.pev.netname+" с причиной \""+sReason+"\"");
				g_EngineFuncs.ServerCommand("kick #"+string(g_EngineFuncs.GetPlayerUserId(pTarget.edict()))+" \""+sReason+"\"\n");
			}
		}
	}

	void access(AFBaseArguments@ AFArgs)
	{
		if(AFBase::g_cvar_afb_ignoreAccess.GetInt() >= 1)
		{
			afbasebase.Tell("Нельзя изменить: afb_access_ignore включен.", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		array<CBasePlayer@> pTargets;
		string sFlags = AFArgs.GetCount() >= 2 ? AFArgs.GetString(1).ToLowercase() : "!";
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				if(!AFArgs.IsServer)
				{
					if(pTarget.entindex() == AFArgs.User.entindex() && sFlags != "!")
					{
						if(int(sFlags.FindFirstOf("b", 0)) > -1 && (sFlags.SubString(0,1) == "-" || sFlags.SubString(0,1) == "+"))
						{
							afbasebase.Tell("Нельзя изменить: нельзя добавлять или убирать доступ 'B' не себя", AFArgs.User, HUD_PRINTCONSOLE);
							continue;
						}else if(int(sFlags.FindFirstOf("b", 0)) <= -1 && (sFlags.SubString(0,1) != "-" && sFlags.SubString(0,1) != "+"))
						{
							afbasebase.Tell("Нельзя изменить: нельзя ставить доступ без доступа 'B'", AFArgs.User, HUD_PRINTCONSOLE);
							continue;
						}
					}
				}
				
				if(sFlags.SubString(0,1) == "+")
				{
					string sFixId = AFBase::FormatSafe(AFBase::GetFixedSteamID(pTarget));
					AFBase::AFBaseUser@ afbUser = AFBase::GetUser(pTarget);
					if(afbUser is null)
					{
						afbasebase.Tell("Нельзя добавить: несуществующий игрок?", AFArgs.User, HUD_PRINTCONSOLE);
						return;
					}
					
					array<string> aSHold = AFBase::ExplodeString(afbUser.sAccess, "z");
					array<string> aSHold2 = AFBase::ExplodeString(sFlags.SubString(1,sFlags.Length()-1), "z");
					bool bExists = false;
					for(uint j = 0; j < aSHold2.length(); j++)
					{
						bExists = false;
						for(uint k = 0; k < aSHold.length(); k++)
						{
							if(aSHold2[j] == aSHold[k])
								bExists = true;
						}
						
						if(!bExists)
							aSHold.insertLast(aSHold2[j]);
					}
					
					aSHold.sortAsc();
					string sHold = AFBase::ImplodeString(aSHold);
					string sNewAccess = "";
					int iNewAccess = 0;		
					AFBase::translateAccess(sHold, sNewAccess, iNewAccess);
					if(sNewAccess.SubString(sNewAccess.Length()-1, 1) == "z")
						sNewAccess = sNewAccess.SubString(0, sNewAccess.Length()-1);
						
					afbUser.bLock = false;
					afbUser.iAccess = iNewAccess;
					afbUser.sAccess = sNewAccess+"z";
					afbUser.bLock = true;
					AFBase::g_afbUserList[pTarget.entindex()] = afbUser;
					afbasebase.Log(AFArgs.FixedNick+" изменил "+string(pTarget.pev.netname)+" доступ на "+sNewAccess+"z");
					afbasebase.Tell("Изменил "+string(pTarget.pev.netname)+" доступ на "+sNewAccess+"z", AFArgs.User, HUD_PRINTCONSOLE);
					afbasebase.TellAll(AFArgs.FixedNick+" изменил "+pTarget.pev.netname+" доступ на \""+sNewAccess+"z\"", HUD_PRINTTALK);
					AFBase::UpdateAccessFile(sFixId, sNewAccess);
				}else if(sFlags.SubString(0,1) == "-")
				{
					string sFixId = AFBase::FormatSafe(AFBase::GetFixedSteamID(pTarget));
					AFBase::AFBaseUser@ afbUser = AFBase::GetUser(pTarget);
					if(afbUser is null)
					{
						afbasebase.Tell("Нельзя добавить: несуществующий игрок?", AFArgs.User, HUD_PRINTCONSOLE);
						return;
					}
					
					array<string> aSHold = AFBase::ExplodeString(afbUser.sAccess, "z");
					array<string> aSHold2 = AFBase::ExplodeString(sFlags.SubString(1,sFlags.Length()-1), "z");
					array<string> aSHold3;
					bool bExists = false;
					for(uint j = 0; j < aSHold.length(); j++)
					{
						bExists = false;
						for(uint k = 0; k < aSHold2.length(); k++)
						{
							if(aSHold[j] == aSHold2[k])
								bExists = true;
						}
						
						if(!bExists)
							aSHold3.insertLast(aSHold[j]);
					}
					
					aSHold3.sortAsc();
					string sHold = AFBase::ImplodeString(aSHold3);
					string sNewAccess = "";
					int iNewAccess = 0;						
					AFBase::translateAccess(sHold, sNewAccess, iNewAccess);
					if(sNewAccess.SubString(sNewAccess.Length()-1, 1) == "z")
						sNewAccess = sNewAccess.SubString(0, sNewAccess.Length()-1);
					
					afbUser.bLock = false;
					afbUser.iAccess = iNewAccess;
					afbUser.sAccess = sNewAccess+"z";
					afbUser.bLock = true;
					AFBase::g_afbUserList[pTarget.entindex()] = afbUser;
					afbasebase.Log(AFArgs.FixedNick+" изменил "+string(pTarget.pev.netname)+" доступ на "+sNewAccess+"z");
					afbasebase.Tell("Изменил "+string(pTarget.pev.netname)+" доступ на "+sNewAccess+"z", AFArgs.User, HUD_PRINTCONSOLE);
					afbasebase.TellAll(AFArgs.FixedNick+" изменил "+pTarget.pev.netname+" доступ на \""+sNewAccess+"z\"", HUD_PRINTTALK);
					AFBase::UpdateAccessFile(sFixId, sNewAccess);
				}else if(sFlags != "!")
				{
					string sFixId = AFBase::FormatSafe(AFBase::GetFixedSteamID(pTarget));
					AFBase::AFBaseUser@ afbUser = AFBase::GetUser(pTarget);
					if(afbUser is null)
					{
						afbasebase.Tell("Нельзя добавить: несуществующий игрок?", AFArgs.User, HUD_PRINTCONSOLE);
						return;
					}
					
					array<string> sAHold = AFBase::ExplodeString(sFlags, "z");
					sAHold.sortAsc();
					string sHold = AFBase::ImplodeString(sAHold);
					int iNewAcc = 0;
					string sNewAcc = "";		
					AFBase::translateAccess(sHold, sNewAcc, iNewAcc);
					if(sNewAcc.SubString(sNewAcc.Length()-1, 1) == "z")
						sNewAcc = sNewAcc.SubString(0, sNewAcc.Length()-1);
					
					afbUser.bLock = false;
					afbUser.sAccess = sNewAcc+"z";
					afbUser.iAccess = iNewAcc;
					afbUser.bLock = true;
					AFBase::g_afbUserList[pTarget.entindex()] = afbUser;
					afbasebase.Log(AFArgs.FixedNick+" изменил "+string(pTarget.pev.netname)+" доступ на "+sNewAcc);
					afbasebase.Tell("Изменил "+string(pTarget.pev.netname)+" доступ на "+sNewAcc+"z", AFArgs.User, HUD_PRINTCONSOLE);
					afbasebase.TellAll(AFArgs.FixedNick+" изменил "+pTarget.pev.netname+" доступ на \""+sNewAcc+"\"", HUD_PRINTTALK);
					AFBase::UpdateAccessFile(sFixId, sNewAcc);
				}else{
					AFBase::AFBaseUser@ afbUser = AFBase::GetUser(pTarget);
					if(afbUser is null)
					{
						afbasebase.Tell("Немогу сказать: несуществующий игрок?", AFArgs.User, HUD_PRINTCONSOLE);
						return;
					}
					
					afbasebase.Tell(string(pTarget.pev.netname)+" доступ флаги: "+afbUser.sAccess, AFArgs.User, HUD_PRINTCONSOLE);
				}
			}
		}
	}

	void info(AFBaseArguments@ AFArgs)
	{
		TellLongCustom("----AdminFuckeryBase: Инфо------------------------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
		TellLongCustom("AFB Версия: "+AFBase::g_afInfo+"\n", AFArgs.User, HUD_PRINTCONSOLE);
		string sSafe = AFBase::g_afbIsSafePlugin ? "Да" : "Нет";
		TellLongCustom("Безопасный ли плагин?: "+sSafe+"\n", AFArgs.User, HUD_PRINTCONSOLE);
		TellLongCustom("AFB Пользователи: "+string(AFBase::g_afbUserList.getSize())+"\n", AFArgs.User, HUD_PRINTCONSOLE);
		TellLongCustom("AFB Дополнения: "+string(AFBase::g_afbExpansionList.getSize())+"\n", AFArgs.User, HUD_PRINTCONSOLE);
		TellLongCustom("AFB Команды: Кон/Чат "+string(AFBase::g_afbConCommandList.getSize())+"/"+string(AFBase::g_afbChatCommandList.getSize())+" (всего: "+string(AFBase::g_afbVisualCommandList.length())+")\n", AFArgs.User, HUD_PRINTCONSOLE);
		TellLongCustom("--------------------------------------------------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
	}

	void who(AFBaseArguments@ AFArgs)
	{
		AFBase::AFBaseUser@ AFBUser;
		if(!AFArgs.IsServer)
			@AFBUser = AFBase::GetUser(AFArgs.User);
		bool bNoFormat = AFArgs.GetCount() >= 1 ? AFArgs.GetBool(0) : false;
		bool bShowAll = AFArgs.IsServer?true:false;
		if(!AFArgs.IsServer)
			if(AFBUser.iAccess >= 2)
				bShowAll = true;
		array<string> afbKeys = AFBase::g_afbUserList.getKeys();
		string sSpace = "                                                                                                                                                                ";
		TellLongCustom("----AdminFuckeryBase: Игроки на сервере-----------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
		if(!bNoFormat)
			TellLongCustom("----Ники которые имееют 15+ символов будут укорочены с \"~\", изпользуйте .afb_who 1 чтобы обойти это\n", AFArgs.User, HUD_PRINTCONSOLE);
		else
			TellLongCustom("----Ники не укороченые. Форматирование может сломаться от этого, изпользуйте .afb_who 0 чтобы обойти это\n", AFArgs.User, HUD_PRINTCONSOLE);
		int iOffsetId = 0;
		uint iLongestNick = 4;
		uint iLongestOldNick = 8;
		uint iLongestAuth = 6;
		uint iLongestIp = 2;
		uint iLongestAccess = 6;
		string stempip = "";
		for(uint i = 0; i < afbKeys.length(); i++)
		{
			@AFBUser = cast<AFBase::AFBaseUser@>(AFBase::g_afbUserList[afbKeys[i]]);
			if(AFBUser !is null)
			{
				if(AFBUser.sNick.Length() > iLongestNick)
					if(!bNoFormat)
						if(AFBUser.sNick.Length() > 14)
							iLongestNick = 14;
						else
							iLongestNick = AFBUser.sNick.Length();
					else
						iLongestNick = AFBUser.sNick.Length();
					
				if(AFBUser.sOldNick.Length() > iLongestOldNick)
					if(!bNoFormat)
						if(AFBUser.sNick.Length() > 14)
							iLongestOldNick = 14;
						else
							iLongestOldNick = AFBUser.sOldNick.Length();
					else
						iLongestOldNick = AFBUser.sOldNick.Length();
					
					
				if(AFBUser.sSteam.Length() > iLongestAuth)
					iLongestAuth = AFBUser.sSteam.Length();
					
				stempip = AFBUser.sIp == "" ? "N/A Init" : AFBUser.sIp;
					
				if(stempip.Length() > iLongestIp)
					iLongestIp = stempip.Length();
					
				if(AFBUser.sAccess.Length() > iLongestAccess)
					iLongestAccess = AFBUser.sAccess.Length();
			}
		}
		
		iOffsetId = int(floor(afbKeys.length()/10));
		if(iOffsetId < 1)
			iOffsetId = 1;
		string sVID = sSpace.SubString(0,iOffsetId)+"#  ";
		string sVNICK = "Nick"+sSpace.SubString(0,iLongestNick-4)+"  ";
		string sVOLDNICK = "Old nick"+sSpace.SubString(0,iLongestOldNick-8)+"  ";
		string sVAUTH = "Authid"+sSpace.SubString(0,iLongestAuth-6)+"  ";
		string sVIP = "Ip"+sSpace.SubString(0,iLongestIp-2)+"  ";
		string sVIMM = "Imm  ";
		string sVACCESS = "Access";
		if(bShowAll)
			TellLongCustom(sVID+sVNICK+sVOLDNICK+sVAUTH+sVIP+sVIMM+sVACCESS+"\n", AFArgs.User, HUD_PRINTCONSOLE);
		else
			TellLongCustom(sVID+sVNICK+sVAUTH+sVIMM+sVACCESS+"\n", AFArgs.User, HUD_PRINTCONSOLE);
		for(uint i = 0; i < afbKeys.length(); i++)
		{
			@AFBUser = cast<AFBase::AFBaseUser@>(AFBase::g_afbUserList[afbKeys[i]]);
			if(AFBUser !is null)
			{
				iOffsetId = iOffsetId-int(floor((1+i)/10));
				if(iOffsetId < 1)
					iOffsetId = 1;
					
				if(i >= 9) // 21.7.2017 -- fixes offset by one character when more than 10 players are in the server
					sVID = sSpace.SubString(0, iOffsetId)+string(1+i)+" ";
				else
					sVID = sSpace.SubString(0, iOffsetId)+string(1+i)+"  ";
					
				if(!bNoFormat)
					if(AFBUser.sNick.Length() > 14)
					{
						string sFormNick = AFBUser.sNick.SubString(0,13)+"~";
						sVNICK = sFormNick+sSpace.SubString(0,iLongestNick-14)+"  ";
					}else
						sVNICK = AFBUser.sNick+sSpace.SubString(0,iLongestNick-AFBUser.sNick.Length())+"  ";
				else
					sVNICK = AFBUser.sNick+sSpace.SubString(0,iLongestNick-AFBUser.sNick.Length())+"  ";
					
				if(!bNoFormat)
					if(AFBUser.sOldNick.Length() > 14)
					{
						string sFormNick = AFBUser.sOldNick.SubString(0,13)+"~";
						sVOLDNICK = sFormNick+sSpace.SubString(0,iLongestOldNick-14)+"  ";
					}else
						sVOLDNICK = AFBUser.sOldNick+sSpace.SubString(0, iLongestOldNick-AFBUser.sOldNick.Length())+"  ";
				else
					sVOLDNICK = AFBUser.sOldNick+sSpace.SubString(0, iLongestOldNick-AFBUser.sOldNick.Length())+"  ";
				
				sVAUTH = AFBUser.sSteam+sSpace.SubString(0,iLongestAuth-AFBUser.sSteam.Length())+"  ";
				stempip = AFBUser.sIp == "" ? "N/A Init" : AFBUser.sIp;
				sVIP = stempip+sSpace.SubString(0, iLongestIp-stempip.Length())+"  ";
				sVIMM = AFBase::CheckAccess(atoi(afbKeys[i]), ACCESS_A) ? "Yes  " : "No   ";
				sVACCESS = AFBUser.sAccess+sSpace.SubString(0, iLongestAccess-AFBUser.sAccess.Length());
				if(bShowAll)
					TellLongCustom(sVID+sVNICK+sVOLDNICK+sVAUTH+sVIP+sVIMM+sVACCESS+"\n", AFArgs.User, HUD_PRINTCONSOLE);
				else
					TellLongCustom(sVID+sVNICK+sVAUTH+sVIMM+sVACCESS+"\n", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
		TellLongCustom("--------------------------------------------------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
	}

	void extlist(AFBaseArguments@ AFArgs)
	{
		AFBaseClass@ AFBClass = null;
		array<string> afbKeys = AFBase::g_afbExpansionList.getKeys();
		string sSpace = "                                                                                                                                                                ";
		TellLongCustom("----AdminFuckeryBase: Дополнения------------------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
		int iOffsetId = 0;
		uint iLongestSID = 3;
		uint iLongestName = 4;
		uint iLongestAuthor = 6;
		for(uint i = 0; i < afbKeys.length(); i++)
		{
			@AFBClass = cast<AFBaseClass@>(AFBase::g_afbExpansionList[afbKeys[i]]);
			if(AFBClass !is null)
			{
				if(AFBClass.ShortName.Length() > iLongestSID)
					iLongestSID = AFBClass.ShortName.Length();
					
				if(AFBClass.ExpansionName.Length() > iLongestName)
					iLongestName = AFBClass.ExpansionName.Length();
					
				if(AFBClass.AuthorName.Length() > iLongestAuthor)
					iLongestAuthor = AFBClass.AuthorName.Length();
			}
		}
		
		iOffsetId = int(floor(afbKeys.length()/10));
		if(iOffsetId < 1)
			iOffsetId = 1;
		string sVID = sSpace.SubString(0,iOffsetId)+"#  ";
		string sVSID = "SID"+sSpace.SubString(0,iLongestSID-3)+"  ";
		string sVNAME = "Имя"+sSpace.SubString(0,iLongestName-4)+"  ";
		string sVAUTH = "Автор"+sSpace.SubString(0,iLongestAuthor-6)+"  ";
		string sVSTAT = "Статус";
		TellLongCustom(sVID+sVSID+sVNAME+sVSTAT+"\n", AFArgs.User, HUD_PRINTCONSOLE);
		for(uint i = 0; i < afbKeys.length(); i++)
		{
			@AFBClass = cast<AFBaseClass@>(AFBase::g_afbExpansionList[afbKeys[i]]);
			if(AFBClass !is null)
			{
				iOffsetId = iOffsetId-int(floor((1+i)/10));
				if(iOffsetId < 1)
					iOffsetId = 1;
			
				if(i >= 9) // 17.02.2018 -- fixes offset by one character when more than 10 extensions are in the server
					sVID = sSpace.SubString(0, iOffsetId)+string(1+i)+" ";
				else
					sVID = sSpace.SubString(0, iOffsetId)+string(1+i)+"  ";
			
				sVSID = AFBClass.ShortName+sSpace.SubString(0,iLongestSID-AFBClass.ShortName.Length())+"  ";
				sVNAME = AFBClass.ExpansionName+sSpace.SubString(0,iLongestName-AFBClass.ExpansionName.Length())+"  ";
				sVAUTH = AFBClass.AuthorName+sSpace.SubString(0,iLongestAuthor-AFBClass.AuthorName.Length())+"  ";
				sVSTAT = AFBClass.Running ? "Работает" : "Остановлен";
				TellLongCustom(sVID+sVSID+sVNAME+sVSTAT+"\n", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
		TellLongCustom("--------------------------------------------------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
	}

	void extstop(AFBaseArguments@ AFArgs)
	{
		AFBaseClass@ AFBClass = null;
		array<string> afbKeys = AFBase::g_afbExpansionList.getKeys();
		for(uint i = 0; i < afbKeys.length(); i++)
		{
			@AFBClass = cast<AFBaseClass@>(AFBase::g_afbExpansionList[afbKeys[i]]);
			if(AFBClass !is null)
			{
				if(AFArgs.GetString(0) == AFBClass.ShortName)
				{
					if(AFBClass.StatusOverride)
					{
						TellLongCustom("[AFB] Ошибка: Дополнение "+AFBClass.ShortName+" невозможно остановить: закрыто!\n", AFArgs.User, HUD_PRINTCONSOLE);
						afbasebase.Log(AFArgs.FixedNick+" попытался остановить закрытое дополнение "+string(AFBClass.ShortName));
						return;
					}else{
						if(AFBClass.Running)
						{
							TellLongCustom("[AFB] Дополнение остановлен: "+AFBClass.ShortName+".\n", AFArgs.User, HUD_PRINTCONSOLE);
							afbasebase.Log(AFArgs.FixedNick+" дополнение остановлено "+string(AFBClass.ShortName));
							AFBClass.Stop();
							return;
						}else{
							TellLongCustom("[AFB] Невозможно остановить дополнение "+AFBClass.ShortName+": Уже остановлен!\n", AFArgs.User, HUD_PRINTCONSOLE);
							afbasebase.Log(AFArgs.FixedNick+" попытался остановить уже остановленое дополнение "+string(AFBClass.ShortName));
							return;
						}
					}
				}
			}
		}
		
		TellLongCustom("[AFB] Провалено нахождение SID дополнения, проверьте ваше правописание (с учетом регистра).\n", AFArgs.User, HUD_PRINTCONSOLE);
	}
	
	void extstart(AFBaseArguments@ AFArgs)
	{
		AFBaseClass@ AFBClass = null;
		array<string> afbKeys = AFBase::g_afbExpansionList.getKeys();
		for(uint i = 0; i < afbKeys.length(); i++)
		{
			@AFBClass = cast<AFBaseClass@>(AFBase::g_afbExpansionList[afbKeys[i]]);
			if(AFBClass !is null)
			{
				if(AFArgs.GetString(0) == AFBClass.ShortName)
				{
					if(AFBClass.StatusOverride)
					{
						TellLongCustom("[AFB] Ошибка: Дополнение "+AFBClass.ShortName+" не запустилось: закрыто!\n", AFArgs.User, HUD_PRINTCONSOLE);
						afbasebase.Log(AFArgs.FixedNick+" попытался запустить закрытое дополнение "+string(AFBClass.ShortName));
						return;
					}else{
						if(AFBClass.Running)
						{
							TellLongCustom("[AFB] Невозможно запустить дополнение "+AFBClass.ShortName+": Уже запущен!\n", AFArgs.User, HUD_PRINTCONSOLE);
							afbasebase.Log(AFArgs.FixedNick+" попытался запустить уже запущеное дополнение "+string(AFBClass.ShortName));
							return;
						}else{
							TellLongCustom("[AFB] Запускаем дополнение: "+AFBClass.ShortName+".\n", AFArgs.User, HUD_PRINTCONSOLE);
							afbasebase.Log(AFArgs.FixedNick+" запустил дополнение "+string(AFBClass.ShortName));
							AFBClass.Start();
							return;
						}
					}
				}
			}
		}
		
		TellLongCustom("[AFB] Провалено нахождение SID дополнения, проверьте ваше правописание (с учетом регистра).\n", AFArgs.User, HUD_PRINTCONSOLE);
	}
	
	void help(AFBaseArguments@ AFArgs)
	{
		array<string> sComm;
		AFBase::VisualCommand@ visCom;
		AFBaseClass@ AFBClass = null;
			
		bool bShowExp = AFArgs.GetCount() >= 2 ? AFArgs.GetBool(1) : false;
		if(!AFArgs.IsServer)
		{
			AFBase::AFBaseUser@ afbUser = AFBase::GetUser(AFArgs.User);
			for(uint i = 0; i < AFBase::g_afbVisualCommandList.length(); i++)
			{
				//AFBase::ParseCommand(AFBase::g_afbVisualCommandList[i], iCmdAccess, sENameID, sVisual);
				@visCom = cast<AFBase::VisualCommand@>(AFBase::g_afbVisualCommandList[i]);
				if(afbUser.iAccess & visCom.iCmdAccess == visCom.iCmdAccess && visCom.iFlags & CMD_SERVERONLY == 0)
				{
					@AFBClass = cast<AFBaseClass@>(AFBase::g_afbExpansionList[visCom.sENameID]);
					if(AFBClass !is null)
						if(AFBClass.Running)
							if(bShowExp)
								sComm.insertLast("["+visCom.sENameID+"] "+visCom.sVisual);
							else
								sComm.insertLast(visCom.sVisual);
				}
			}
		}else{
			for(uint i = 0; i < AFBase::g_afbVisualCommandList.length(); i++)
			{
				@visCom = cast<AFBase::VisualCommand@>(AFBase::g_afbVisualCommandList[i]);
				if(visCom.iFlags & CMD_SERVERONLY != 0 || visCom.iFlags & CMD_SERVER != 0)
				{
					@AFBClass = cast<AFBaseClass@>(AFBase::g_afbExpansionList[visCom.sENameID]);
					if(AFBClass !is null)
						if(AFBClass.Running)
							if(bShowExp)
								sComm.insertLast("["+visCom.sENameID+"] "+visCom.sVisual);
							else
								sComm.insertLast(visCom.sVisual);
				}
			}
		}
		sComm.sortAsc();
		
		uint cStart = AFArgs.GetCount() >= 1 ? AFArgs.GetInt(0) : 0;
		
		if(cStart <= 0)
			cStart = 1;
		
		cStart--;
		cStart=cStart*10; // faking pages
		uint cEnd = cStart+10;
		if(cStart >= sComm.length())
		{
			TellLongCustom("[AFB] Такой страницы нет! попытались открыть страницу "+(1+cStart/10)+", но длина списка только до "+(1+((sComm.length()-1)/10))+" страниц!\n", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}

		uint pLength = 0;
		for(uint i = cStart; i < cEnd; i++)
		{
			if(i < sComm.length())
				pLength++;
		}
		
		TellLongCustom("----AdminFuckeryBase help: Список команд-----------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
		TellLongCustom("Маленький гайд: (арг) обязательная настройка, <арг> опциональная настройка. Цели: @all, @admins, @noadmins, @alive\n", AFArgs.User, HUD_PRINTCONSOLE);
		TellLongCustom(" @dead, @aim, @random, @last, @me, \"nickname\" (подержует * подстановочный знак), \"STEAM_0:1:ID\"\n", AFArgs.User, HUD_PRINTCONSOLE);
		TellLongCustom("--------------------------------------------------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
		for(uint i = 0; i < pLength; i++)
		{
				TellLongCustom(" "+(1+i+cStart)+": "+sComm[i+cStart]+"\n", AFArgs.User, HUD_PRINTCONSOLE);
		}
		
		TellLongCustom("--------------------------------------------------------------------------------\n", AFArgs.User, HUD_PRINTCONSOLE);
		if(cStart+10 < sComm.length())
			TellLongCustom("[AFB] напишите \".afb_help "+(1+(cEnd)/10)+"\" для больше страниц - показуем страницу "+(1+cStart/10)+" из "+(1+((sComm.length()-1)/10))+".\n", AFArgs.User, HUD_PRINTCONSOLE);
		else
			TellLongCustom("[AFB] показуем страницу "+(1+cStart/10)+" из "+(1+((sComm.length()-1)/10))+".\n", AFArgs.User, HUD_PRINTCONSOLE);
	}
	
	void TellLongCustom(string sIn, CBasePlayer@ pUser, HUD targetHud)
	{
		bool bServer = pUser is null ? true : false;
		string sHoldIn = sIn;
		while(sHoldIn.Length() > 128)
		{
			if(!bServer)
				g_PlayerFuncs.ClientPrint(pUser, targetHud, sHoldIn.SubString(0, 128));
			else
				g_EngineFuncs.ServerPrint(sHoldIn.SubString(0, 128));
			sHoldIn = sHoldIn.SubString(127, sHoldIn.Length()-127);
		}
		
		if(sHoldIn.Length() > 0)
		{
			if(!bServer)
				g_PlayerFuncs.ClientPrint(pUser, targetHud, sHoldIn);
			else
				g_EngineFuncs.ServerPrint(sHoldIn);
		}
	}
}