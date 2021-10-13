#include "AF2Legacy"

AF2Player af2player;

void AF2Player_Call()
{
	af2player.RegisterExpansion(af2player);
}

class AF2Player : AFBaseClass
{
	void ExpansionInfo()
	{
		this.AuthorName = "Zode";
		this.ExpansionName = "AdminFuckery2 Команды Игроков";
		this.ShortName = "AF2P";
	}
	
	void ExpansionInit()
	{
		RegisterCommand("player_teleportaim", "s", "(игроки) - телепорт по прицелу", ACCESS_G, @AF2Player::teleportaim);
		RegisterCommand("say !tpaim", "s", "(игроки) - телепорт по прицелу", ACCESS_G, @AF2Player::teleportaim, CMD_SUPRESS);
		RegisterCommand("player_teleportmeto", "s", "(игроки) - телепорт к игроку", ACCESS_G, @AF2Player::teleportmeto);
		RegisterCommand("say !tpmeto", "s", "(игроки) - телепорт к игроку", ACCESS_G, @AF2Player::teleportmeto, CMD_SUPRESS);
		RegisterCommand("player_teleporttome", "s", "(игроки) - телепорт игрока к вам", ACCESS_G, @AF2Player::teleporttome);
		RegisterCommand("say !tptome", "s", "(игроки) - телепорт игрока к вам", ACCESS_G, @AF2Player::teleporttome, CMD_SUPRESS);
		RegisterCommand("player_teleportpos", "sv", "(игроки) (X) (Y) (Z) - телепорт по кординатам", ACCESS_G, @AF2Player::teleportpos);
		RegisterCommand("player_disarm", "s!s", "(игроки) <оружие> - убирает оружия/ие игрока, не указуйте оружие чтобы отобрать все оружия", ACCESS_G, @AF2Player::disarm);
		RegisterCommand("player_getmodel", "s", "(игроки) - узнаёт название модели игрока", ACCESS_Z, @AF2Player::getmodel);
		RegisterCommand("player_give", "ss", "(игроки) (weapon_/ammo_/item_) - выдаёт вещь", ACCESS_G, @AF2Player::give);
		RegisterCommand("say !give", "ss", "(игроки) (weapon_/ammo_/item_) - выдаёт вещь", ACCESS_G, @AF2Player::give, CMD_SUPRESS);
		RegisterCommand("player_giveall", "!ss", " <игроки> <сет> - выдаёт все оружия напишите ins2 или cs16 чтоб выдать оружие соотвественым плагинам", ACCESS_G, @AF2Player::giveall);
		RegisterCommand("player_giveammo", "s!i", "(игроки) <0/1 данному оружию/всем оружям> - выдает патроны", ACCESS_G, @AF2Player::giveammo);
		RegisterCommand("say !giveammo", "s!i", "(игроки) <0/1 данному оружию/всем оружию> - выдает патроны", ACCESS_G, @AF2Player::giveammo, CMD_SUPRESS);
		RegisterCommand("player_givemapcfg", "s", "(игроки) - выдает стандартное экипировку карты", ACCESS_G, @AF2Player::givemapcfg);
		RegisterCommand("player_position", "s", "(игрок) - показывает позицию игрока", ACCESS_G, @AF2Player::position);
		RegisterCommand("player_resurrect", "s!b", "(игроки) <0/1 возрождение/на месте> - возрождение", ACCESS_G, @AF2Player::resurrect);
		RegisterCommand("say !resurrect", "s!b", "(игроки) <0/1 возрождение/на месте> - возрождение", ACCESS_G, @AF2Player::resurrect, CMD_SUPRESS);
		RegisterCommand("player_maxspeed", "sf", "(игроки) (скорость в юнитах) - меняет скорость игрока, -1 для стандратной скорости", ACCESS_G, @AF2Player::maxspeed);
		RegisterCommand("player_keyvalue", "ss!sss", "(игроки) (параметр) <значение> <знач.> <знач.> - меняет параметры игрока", ACCESS_F|ACCESS_G, @AF2Player::keyvalue);
		RegisterCommand("player_nosolid", "s!b", "(игроки) <0/1 выкл/вкл> - солидность", ACCESS_G, @AF2Player::nosolid);
		RegisterCommand("say !nosolid", "s!i", "(игроки) <0/1 выкл/вкл> - солидность", ACCESS_G, @AF2Player::nosolid, CMD_SUPRESS);
		RegisterCommand("player_noclip", "s!i", "(игроки) <0/1 выкл/вкл> - ноклип", ACCESS_G, @AF2Player::noclip);
		RegisterCommand("player_god", "s!i", "(игроки) <0/1 выкл/вкл> - бессмертие", ACCESS_G, @AF2Player::god);
		RegisterCommand("player_freeze", "s!i", "(игроки) <0/1 выкл/вкл> - замораживает/размораживает ", ACCESS_G, @AF2Player::freeze);
		RegisterCommand("say !freeze", "s!i", "(игроки) <0/1 выкл/вкл> - замораживает/размораживает ", ACCESS_G, @AF2Player::freeze, CMD_SUPRESS);
		RegisterCommand("player_ignite", "s", "(игроки) - поджечь игрока", ACCESS_G, @AF2Player::ignite, CMD_PRECACHE);
		RegisterCommand("player_viewmode", "sb", "(игроки) (0/1 от 1-го лица/ от 3-го лица) - переключает от 1-го и 3-го лица", ACCESS_G, @AF2Player::viewmode);
		RegisterCommand("player_notarget", "s!i", "(игроки) <0/1 выкл/вкл> - нотаргет", ACCESS_G, @AF2Player::notarget);
		RegisterCommand("player_tag", "!ss", "<игроки> <тег> - дать тег игроку, только админы могут видеть теги, используйте без аргументов чтобы посмотреть список", ACCESS_G, @AF2Player::tagplayer, CMD_PRECACHE);
		RegisterCommand("say !tag", "!ss", "<игроки> <тег> - дать тег игроку, только админы могут видеть теги, используйте без аргументов чтобы посмотреть список", ACCESS_G, @AF2Player::tagplayer, CMD_PRECACHE|CMD_SUPRESS);
		RegisterCommand("player_tagfix", "", "- фикс тег, если чтото с ними не так", ACCESS_G, @AF2Player::tagfix, CMD_PRECACHE);
		RegisterCommand("say !tagfix", "", "- фикс тег, если чтото с ними не так", ACCESS_G, @AF2Player::tagfix, CMD_PRECACHE|CMD_SUPRESS);
		RegisterCommand("player_exec", "ss!i", "(игроки) (\"команда\") <без кавычек 0/1> - заставляет игрока написать за него в консоль", ACCESS_G, @AF2Player::cexec);
		RegisterCommand("player_dumpinfo", "s!b", "(игроки) <0/1 грязно> - показывает игровые значения о игроке", ACCESS_F|ACCESS_G, @AF2Player::dumpinfo);
	
		g_Hooks.RegisterHook(Hooks::Player::PlayerSpawn, @AF2Player::PlayerSpawn);
		
		AF2Player::g_playerModes.deleteAll(); // reset player data
		recheckPlayers();
		if(AF2Player::g_playerThink !is null)
			g_Scheduler.RemoveTimer(AF2Player::g_playerThink);
	
		@AF2Player::g_playerThink = g_Scheduler.SetInterval("playerThink", 0.25f);
	}
	
	void MapInit()
	{
		AF2Player::g_playerModes.deleteAll(); // reset player data
		AF2Player::tagListReset();
		recheckPlayers();
		g_SoundSystem.PrecacheSound("ambience/flameburst1.wav");
		g_Game.PrecacheModel("sprites/flame2.spr");
		if(AF2Player::g_playerThink !is null)
			g_Scheduler.RemoveTimer(AF2Player::g_playerThink);
	
		@AF2Player::g_playerThink = g_Scheduler.SetInterval("playerThink", 0.25f);
		
		dictionary MenuCommands = {
			{".player_giveammo","дать патрон"},
			{".player_ignite","поджечь"},
			{".player_teleporttome","телепорт к себе"},
			{".player_teleportmeto","телепорт меня к"},
			{".player_freeze","переключить заморозку"},
			{".player_nosolid","переключить несолидность"},
			{".player_noclip","переключить ноклип"},
			{".player_god","переключить бессмертие"},
			{".player_notarget","переключить нотаргет"}
		}; // purposefully not broadcasting to everything with *, instead using SID
		af2player.SendMessage("AF2MS", "RegisterMenuCommand", MenuCommands);
	}
	
	void StopEvent()
	{
		if(AF2Player::g_playerThink !is null)
			g_Scheduler.RemoveTimer(AF2Player::g_playerThink);
	}
	
	void StartEvent()
	{
		AF2Player::g_playerModes.deleteAll(); // reset player data
		recheckPlayers();
		if(AF2Player::g_playerThink !is null)
			g_Scheduler.RemoveTimer(AF2Player::g_playerThink);
	
		@AF2Player::g_playerThink = g_Scheduler.SetInterval("playerThink", 0.25f);
	}
	
	void ReceiveMessageEvent(string sSender, string sIdentifier, dictionary dData)
	{
		if(sIdentifier == "RecheckPlayer")
		{
			CBasePlayer@ pPlayer = cast<CBasePlayer@>(cast<CBaseEntity@>(dData["player"]));
			if(pPlayer is null)
				AF2Player::CheckPlayerModes(null);
			else
				AF2Player::CheckPlayerModes(pPlayer);
		}
	}
	
	void recheckPlayers()
	{
		CBasePlayer@ pSearch = null;
		for(int i = 1; i <= g_Engine.maxClients; i++)
		{
			@pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
			if(pSearch !is null)
			{
				if(!AF2Player::g_playerModes.exists(pSearch.entindex()))
					AF2Player::g_playerModes[pSearch.entindex()] = 0;
			}
		}
	}
	
	void ClientConnectEvent(CBasePlayer@ pPlayer)
	{
		if(!AF2Player::g_playerModes.exists(pPlayer.entindex()))
			AF2Player::g_playerModes[pPlayer.entindex()] = 0;
			
		string sId = AFBase::FormatSafe(AFBase::GetFixedSteamID(pPlayer));
		string sTag = AF2Player::getTagData(sId);
		if(sTag != "none")
		{
			AF2Player::tagTalk("[AF2P Теги] "+pPlayer.pev.netname+" (тег: "+sTag+") подключился");
			AF2Player::tagViewAdd(pPlayer, sTag);
			AF2Player::g_tagList[pPlayer.entindex()] = sTag;
		}
	}
	
	void ClientDisconnectEvent(CBasePlayer@ pPlayer)
	{
		if(AF2Player::g_playerModes.exists(pPlayer.entindex()))
			AF2Player::g_playerModes.delete(pPlayer.entindex());
			
		if(AF2Player::g_tagList.exists(pPlayer.entindex()))
		{
			AF2Player::tagViewRemove(pPlayer);
			AF2Player::g_tagList.delete(pPlayer.entindex());
		}
	}
}

namespace AF2Player
{
	const int g_TagVisibleTo = ACCESS_G;

	void dumpinfo(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		bool bDirty = AFArgs.GetCount() >= 1 ? AFArgs.GetBool(0) : false;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				dictionary stuff = bDirty ? AF2LegacyCode::reverseGetKeyvalue(pTarget) : AF2LegacyCode::prunezero(AF2LegacyCode::reverseGetKeyvalue(pTarget));
				array<string> dkeys = stuff.getKeys();
				af2player.Tell("Игрок \""+pTarget.pev.netname+"\" значение:", AFArgs.User, HUD_PRINTCONSOLE);
				for(uint j = 0; j < dkeys.length(); j++)
				{
					string sout = string(stuff[dkeys[j]]);
					af2player.Tell("\""+dkeys[j]+"\" -> \""+sout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
				}
				af2player.Tell("========", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}
	
	const array<string> execBlackList = {
	 "say !",
	 "say \"!"
	};

	void cexec(AFBaseArguments@ AFArgs)
	{
		string sOut = AFArgs.GetString(1);
		array<string> parsed = sOut.Split(" ");
		int noquotes = AFArgs.GetCount() >= 3 ? AFArgs.GetInt(2) : 0;
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
		
		for(uint i = 0; i < execBlackList.length(); i++)
		{
			if(sOut.Find(execBlackList[i], 0, String::CaseInsensitive) != String::INVALID_INDEX)
			{
				af2player.Tell("Нельзя выполнить, найдена команда черного списка: \""+execBlackList[i]+"\"", AFArgs.User, HUD_PRINTCONSOLE);
				af2player.Log("Заблокировано: "+AFArgs.User.pev.netname+" попытался выполнить удаленно \""+sOut+"\" на цель(ей): "+AFArgs.GetString(0));
				return;
			}
		}
		
		if(sOut.Find(".", 0, String::CaseInsensitive) != String::INVALID_INDEX)
		{
			array<string> coms = AFBase::g_afbConCommandList.getKeys();
			for(uint i = 0; i < coms.length(); i++)
			{
				if(sOut.Find(coms[i], 0, String::CaseInsensitive) != String::INVALID_INDEX)
				{
					af2player.Tell("Нельзя выполнить, найдена команда черного списка: \""+coms[i]+"\"", AFArgs.User, HUD_PRINTCONSOLE);
					af2player.Log("Заблокировано: "+AFArgs.User.pev.netname+" попытался выполнить удаленно \""+sOut+"\" на цель(ей): "+AFArgs.GetString(0));
					return;
				}
			}
		}
		
		
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), 0, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				NetworkMessage message(MSG_ONE_UNRELIABLE, NetworkMessages::NetworkMessageType(9), pTarget.edict());
					message.WriteString(sOut);
				message.End();
				
				af2player.Tell("Удал. Выполненно на "+pTarget.pev.netname+": "+sOut, AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}

	void tagfix(AFBaseArguments@ AFArgs)
	{
		HUD targetHud = AFArgs.IsChat ? HUD_PRINTTALK : HUD_PRINTCONSOLE;
		tagRefreshView(AFArgs.User);
		af2player.Tell("Обновлен просмотр тегов", AFArgs.User, targetHud);
	}

	void tagplayer(AFBaseArguments@ AFArgs)
	{
		HUD targetHud = AFArgs.IsChat ? HUD_PRINTTALK : HUD_PRINTCONSOLE;
		
		if(AFArgs.GetCount() == 0)
		{
			af2player.Tell("Показую список тегов в консоль...", AFArgs.User, targetHud);
			af2player.Tell("Доступные теги (изпользуйте \"отключен\" чтоб убрать тег):", AFArgs.User, HUD_PRINTCONSOLE);
			for(uint i = 0; i < g_validTags.length(); i++)
				af2player.Tell(g_validTags[i], AFArgs.User, HUD_PRINTCONSOLE);
				
			return;
		}
		else if(AFArgs.GetCount() == 1)
		{
			af2player.Tell("Аргументы отсутствуют! изпользование: <цель> <тег>", AFArgs.User, targetHud);
			return;
		}
		
		string sTag = AFArgs.GetString(1);
		
		if(g_validTags.find(sTag) <= -1 && sTag != "отключен")
		{
			af2player.Tell("Неизвестный тег! Изпользуйте без агрументов чтобы посмотреть список тегов", AFArgs.User, targetHud);
			return;
		}
		
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, targetHud, AFArgs.GetString(0), 0, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				if(sTag == "отключен")
				{
					if(g_tagList.exists(pTarget.entindex()))
					{
						removeTag(pTarget);
						tagTalk("[AF2P Теги] Админ "+AFArgs.User.pev.netname+" убрал тег у "+pTarget.pev.netname);
						af2player.Tell("Убрал тег у "+pTarget.pev.netname, AFArgs.User, targetHud);
					}else{
						af2player.Tell("Нельзя убрать: тега нету!", AFArgs.User, targetHud);
					}
				}else{
					addTag(pTarget, sTag);
					tagTalk("[AF2P Теги] Админ "+AFArgs.User.pev.netname+" установил тег "+sTag+" у "+pTarget.pev.netname);
					af2player.Tell("Установлен тег "+sTag+" у "+pTarget.pev.netname, AFArgs.User, targetHud);
				}
			}
		}
	}

	dictionary g_tagList;
	string g_tagPath = "sprites/zode/";
	string g_tagFilePath = "scripts/plugins/store/AFBaseTags.txt";
	array<string> g_validTags = {
	"blocker",
	"rusher",
	"suspect",
	"troll"
	};
	
	void reloadPlayerTags()
	{
		g_tagList.deleteAll();
		CBasePlayer@ pSearch;
		for(int i = 1; i < g_Engine.maxClients; i++)
		{
			@pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
			if(pSearch !is null)
			{
				string sId = AFBase::FormatSafe(AFBase::GetFixedSteamID(pSearch));
				string sTag = getTagData(sId);
				if(sTag == "none")
					continue;
				
				g_tagList[pSearch.entindex()] = sTag;
			}
		}
		
		@pSearch = null;
		for(int i = 1; i <= g_Engine.maxClients; i++)
		{
			@pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
			if(pSearch !is null)
			{
				if(AFBase::CheckAccess(pSearch, g_TagVisibleTo))
				{
					tagRefreshView(pSearch);
				}
			}
		}
	}
	
	void tagRefreshView(CBasePlayer@ pView)
	{
		if(pView is null)
			return;
			
		if(pView !is null && AFBase::CheckAccess(pView, g_TagVisibleTo))
		{
			CBasePlayer@ pSearch;
			for(int i = 1; i <= g_Engine.maxClients; i++)
			{
				@pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
				if(@pSearch !is null)
				{
					if(g_tagList.exists(pSearch.entindex()))
					{
						string sSprite = g_tagPath+string(g_tagList[pSearch.entindex()])+".spr";
						
						NetworkMessage killmessage(MSG_ONE_UNRELIABLE, NetworkMessages::SVC_TEMPENTITY, pView.edict());
							killmessage.WriteByte(TE_KILLPLAYERATTACHMENTS);
							killmessage.WriteByte(pSearch.entindex());
						killmessage.End();
					
						NetworkMessage message(MSG_ONE_UNRELIABLE, NetworkMessages::SVC_TEMPENTITY, pView.edict());
							message.WriteByte(TE_PLAYERATTACHMENT);
							message.WriteByte(pSearch.entindex());
							message.WriteCoord(51.0f);
							message.WriteShort(g_EngineFuncs.ModelIndex(sSprite));
							message.WriteShort(32767);
						message.End();
					}
				}
			}
		}
	}
	
	void tagViewAdd(CBasePlayer@ pTarg, string sTag)
	{
		string sSprite = g_tagPath+sTag+".spr";
		CBasePlayer@ pSearch;
		for(int i = 1; i <= g_Engine.maxClients; i++)
		{
			@pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
			if(pSearch !is null)
			{
				if(AFBase::CheckAccess(pSearch, g_TagVisibleTo))
				{
					NetworkMessage message(MSG_ONE_UNRELIABLE, NetworkMessages::SVC_TEMPENTITY, pSearch.edict());
						message.WriteByte(TE_PLAYERATTACHMENT);
						message.WriteByte(pTarg.entindex());
						message.WriteCoord(51.0f);
						message.WriteShort(g_EngineFuncs.ModelIndex(sSprite));
						message.WriteShort(32767);
					message.End();
				}
			}
		}
	}
	
	void tagViewRemove(CBasePlayer@ pTarg)
	{
		CBasePlayer@ pSearch;
		for(int i = 1; i <= g_Engine.maxClients; i++)
		{
			@pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
			if(pSearch !is null)
			{
				if(AFBase::CheckAccess(pSearch, g_TagVisibleTo))
				{
					NetworkMessage message(MSG_ONE_UNRELIABLE, NetworkMessages::SVC_TEMPENTITY, pSearch.edict());
						message.WriteByte(TE_KILLPLAYERATTACHMENTS);
						message.WriteByte(pTarg.entindex());
					message.End();
				}
			}
		}
	}
	
	void tagListReset()
	{
		g_tagList.deleteAll();
		for(uint i = 0; i < g_validTags.length(); i++)
		{
			g_Game.PrecacheModel(g_tagPath+g_validTags[i]+".spr");
		}
	}
	
	void tagTalk(string sTalk)
	{
		CBasePlayer@ pSearch;
		for(int i = 1; i <= g_Engine.maxClients; i++)
		{
			@pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
			if(pSearch !is null)
			{
				if(AFBase::CheckAccess(pSearch, g_TagVisibleTo))
				{
					g_PlayerFuncs.ClientPrint(pSearch, HUD_PRINTTALK, sTalk+"\n");
				}
			}
		}
	}
	
	void addTag(CBasePlayer@ pTarget, string sTag)
	{
		if(g_tagList.exists(pTarget.entindex())) //reset view basically
			tagViewRemove(pTarget);
		
		setTagData(pTarget, sTag);
		tagViewAdd(pTarget, sTag);
	}
	
	void removeTag(CBasePlayer@ pTarget)
	{
		g_tagList.delete(pTarget.entindex());
		setTagData(pTarget, "отключен");
		tagViewRemove(pTarget);
	}
	
	bool setTagData(CBasePlayer@ pTarget, string sTag)
	{
		string usrId = AFBase::FormatSafe(AFBase::GetFixedSteamID(pTarget));
		File@ file = g_FileSystem.OpenFile(g_tagFilePath, OpenFile::READ);
		dictionary lTags;
		if(file !is null && file.IsOpen())
		{
			while(!file.EOFReached())
			{
				string sLine;
				file.ReadLine(sLine);
				string sFix = sLine.SubString(sLine.Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					sLine = sLine.SubString(0, sLine.Length()-1);
				
				if(sLine.SubString(0,1) == "#" || sLine.IsEmpty())
					continue;
				
				array<string> parsed = sLine.Split(" ");
				
				//effing linux
				if(parsed[1].SubString(parsed[1].Length()-1,1) == " " || parsed[1].SubString(parsed[1].Length()-1,1) == "\n" || parsed[1].SubString(parsed[1].Length()-1,1) == "\r" || parsed[1].SubString(parsed[1].Length()-1,1) == "\t")
					parsed[1] = parsed[1].SubString(0, parsed[1].Length()-1);
				
				lTags[parsed[0]] = parsed[1];
			}
			file.Close();
		}else{
			af2player.Log("Ошибка инсталляции: не найден файл список тегов");
			return false;
		}
		
		if(sTag == "отключен" && lTags.exists(usrId))
		{
			lTags.delete(usrId);
		}else{
			lTags[usrId] = sTag;
			g_tagList[pTarget.entindex()] = sTag;
		}
		
		@file = g_FileSystem.OpenFile(g_tagFilePath, OpenFile::WRITE);
		if(file !is null)
		{
			array<string> sIds = lTags.getKeys();
			for(uint i = 0; i < sIds.length(); i++)
			{
				file.Write(sIds[i]+" "+string(lTags[sIds[i]])+"\n");
			}
			
			file.Close();
			return true;
		}else{
			af2player.Log("Ошибка написанния файла тегов");
			return false;
		}
	}
	
	string getTagData(string sId)
	{
		
		File@ file = g_FileSystem.OpenFile(g_tagFilePath, OpenFile::READ);
		if(file !is null && file.IsOpen())
		{
			string sReturn = "none";
			while(!file.EOFReached())
			{
				string sLine;
				file.ReadLine(sLine);
				
				string sFix = sLine.SubString(sLine.Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					sLine = sLine.SubString(0, sLine.Length()-1);
				
				if(sLine.SubString(0,1) == "#" || sLine.IsEmpty())
					continue;
					
				array<string> parsed = sLine.Split(" ");
					
				//effing linux
				if(parsed[1].SubString(parsed[1].Length()-1,1) == " " || parsed[1].SubString(parsed[1].Length()-1,1) == "\n" || parsed[1].SubString(parsed[1].Length()-1,1) == "\r" || parsed[1].SubString(parsed[1].Length()-1,1) == "\t")
					parsed[1] = parsed[1].SubString(0, parsed[1].Length()-1);
					
				if(parsed[0] == sId)
					sReturn = parsed[1];
			}
			
			file.Close();
			return sReturn;
		}else{
			af2player.Log("Ошибка инсталляции: не найден файл список тегов");
			return "none";
		}
	}

	CScheduledFunction@ g_playerThink = null;

	void playerThink()
	{
		CBasePlayer@ pSearch = null;
		if(AFBase::IsSafe())
		{
			for(int i = 1; i <= g_Engine.maxClients; i++)
			{
				@pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
				if(pSearch !is null)
				{
					if(int(AF2Player::g_playerModes[pSearch.entindex()]) & AF2Player::PLAYER_FLAMING > 0)
					{
						float fRand = g_PlayerFuncs.SharedRandomFloat(pSearch.random_seed, 0, 1);
						if(fRand >= 0.66f)
							g_SoundSystem.PlaySound(pSearch.edict(), CHAN_ITEM, "ambience/flameburst1.wav", 1.0f, 1.0f, 0, 100+Math.RandomLong(-16, 16));
					
						Vector vFlame = pSearch.pev.origin+Vector(Math.RandomFloat(-20,20),Math.RandomFloat(-20,20),Math.RandomFloat(-20,20));
						NetworkMessage message(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
							message.WriteByte(TE_SPRITE);
							message.WriteCoord(vFlame.x);
							message.WriteCoord(vFlame.y);
							message.WriteCoord(vFlame.z+32);
							message.WriteShort(g_EngineFuncs.ModelIndex("sprites/flame2.spr"));
							message.WriteByte(10);
							message.WriteByte(200);
						message.End();
						g_PlayerFuncs.ScreenFade(pSearch, Vector(220,120,60), 0.5f, 0.1f, 50, 0);
						pSearch.pev.punchangle = Vector(Math.RandomFloat(-4.0f, 4.0f), Math.RandomFloat(-4.0f, 4.0f), Math.RandomFloat(-4.0f, 4.0f));
						pSearch.TakeHealth(-5.0f, DMG_BURN);
					}
				}
			}
		}
	}

	HookReturnCode PlayerSpawn(CBasePlayer@ pPlayer)
	{
		EHandle ePlayer = pPlayer;
		g_Scheduler.SetTimeout("PlayerPostSpawn", 0.25f, ePlayer);
		if(int(g_playerModes[pPlayer.entindex()]) & PLAYER_FLAMING > 0)
		{
			int iFlags = int(g_playerModes[pPlayer.entindex()]);
			iFlags &= ~PLAYER_FLAMING;
			g_playerModes[pPlayer.entindex()] = iFlags;
		}
		
		return HOOK_CONTINUE;
	}
	
	void PlayerPostSpawn(EHandle ePlayer)
	{
		if(ePlayer)
		{
			CBaseEntity@ pPlayer = ePlayer;
			CheckPlayerModes(cast<CBasePlayer@>(pPlayer));
		}
	}
	
	void viewmode(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), 0, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				PlayerViewMode viewMode = AFArgs.GetBool(1) ? ViewMode_ThirdPerson : ViewMode_FirstPerson;
				pTarget.SetViewMode(viewMode);
				string sMode = AFArgs.GetBool(1) ? "3-го лица" : "1-го лица";
				af2player.Tell("Установлен "+pTarget.pev.netname+" режим от \""+sMode+"\"", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}

	void ignite(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), 0, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				bool bIsOn = int(g_playerModes[pTarget.entindex()]) & PLAYER_FLAMING > 0 ? true : false;
				if(!bIsOn)
				{
					af2player.Tell("Подожгли "+pTarget.pev.netname+" ", AFArgs.User, HUD_PRINTCONSOLE);
					af2player.TellAll("ОМГ! "+pTarget.pev.netname+" самопроизвольно возгорелся!", HUD_PRINTTALK);
					g_SoundSystem.PlaySound(pTarget.edict(), CHAN_ITEM, "ambience/flameburst1.wav", 1.0f, 1.0f);
					int iFlags = int(g_playerModes[pTarget.entindex()]);
					iFlags |= PLAYER_FLAMING;
					g_playerModes[pTarget.entindex()] = iFlags;
				}else
					af2player.Tell("Игрок "+pTarget.pev.netname+" уже горит!", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}

	void freeze(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		HUD targetHud = AFArgs.IsChat ? HUD_PRINTTALK : HUD_PRINTCONSOLE;
		int iMode = AFArgs.GetCount() >= 2 ? AFArgs.GetInt(1) : -1;
		if(AFBase::GetTargetPlayers(AFArgs.User, targetHud, AFArgs.GetString(0), 0, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				bool bIsOn = int(g_playerModes[pTarget.entindex()]) & PLAYER_FROZEN > 0 ? true : false;
				if(iMode == -1)
				{
					af2player.Tell("Переключена заморозка у "+pTarget.pev.netname, AFArgs.User, targetHud);
					int iFlags = int(g_playerModes[pTarget.entindex()]);
					iFlags ^= PLAYER_FROZEN;
					g_playerModes[pTarget.entindex()] = iFlags;
				}else if(iMode == 1)
				{
					if(!bIsOn)
					{
						af2player.Tell("Включено заморозка у "+pTarget.pev.netname, AFArgs.User, targetHud);
						int iFlags = int(g_playerModes[pTarget.entindex()]);
						iFlags |= PLAYER_FROZEN;
						g_playerModes[pTarget.entindex()] = iFlags;
					}else
						af2player.Tell("Игрок "+pTarget.pev.netname+" уже заморожен!", AFArgs.User, targetHud);
				}else{
					if(bIsOn)
					{
						af2player.Tell("Отключено заморозка у "+pTarget.pev.netname, AFArgs.User, targetHud);
						int iFlags = int(g_playerModes[pTarget.entindex()]);
						iFlags &= ~PLAYER_FROZEN;
						g_playerModes[pTarget.entindex()] = iFlags;
					}else
						af2player.Tell("Игрок "+pTarget.pev.netname+" не заморожен!", AFArgs.User, targetHud);
				}
			}
			
			CheckPlayerModes(null);
		}
	}

	void god(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		int iMode = AFArgs.GetCount() >= 2 ? AFArgs.GetInt(1) : -1;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				bool bIsOn = int(g_playerModes[pTarget.entindex()]) & PLAYER_GOD > 0 ? true : false;
				if(iMode == -1)
				{
					af2player.Tell("Переключен бессмертие для"+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
					int iFlags = int(g_playerModes[pTarget.entindex()]);
					iFlags ^= PLAYER_GOD;
					g_playerModes[pTarget.entindex()] = iFlags;
				}else if(iMode == 1)
				{
					if(!bIsOn)
					{
						af2player.Tell("Включено бессмертие для"+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
						int iFlags = int(g_playerModes[pTarget.entindex()]);
						iFlags |= PLAYER_GOD;
						g_playerModes[pTarget.entindex()] = iFlags;
					}else
						af2player.Tell("Игрок "+pTarget.pev.netname+" уже бессмертен!", AFArgs.User, HUD_PRINTCONSOLE);
				}else{
					if(bIsOn)
					{
						af2player.Tell("Отключено бессмертие для"+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
						int iFlags = int(g_playerModes[pTarget.entindex()]);
						iFlags &= ~PLAYER_GOD;
						g_playerModes[pTarget.entindex()] = iFlags;
					}else
						af2player.Tell("Игрок "+pTarget.pev.netname+" не бессмертен!", AFArgs.User, HUD_PRINTCONSOLE);
				}
			}
			
			CheckPlayerModes(null);
		}
	}

	void noclip(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		int iMode = AFArgs.GetCount() >= 2 ? AFArgs.GetInt(1) : -1;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				bool bIsOn = int(g_playerModes[pTarget.entindex()]) & PLAYER_NOCLIP > 0 ? true : false;
				if(iMode == -1)
				{
					af2player.Tell("Переключен ноклип для "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
					int iFlags = int(g_playerModes[pTarget.entindex()]);
					iFlags ^= PLAYER_NOCLIP;
					g_playerModes[pTarget.entindex()] = iFlags;
				}else if(iMode == 1)
				{
					if(!bIsOn)
					{
						af2player.Tell("Включен ноклип для "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
						int iFlags = int(g_playerModes[pTarget.entindex()]);
						iFlags |= PLAYER_NOCLIP;
						g_playerModes[pTarget.entindex()] = iFlags;
					}else
						af2player.Tell("Игрок "+pTarget.pev.netname+" уже в ноклипе!", AFArgs.User, HUD_PRINTCONSOLE);
				}else{
					if(bIsOn)
					{
						af2player.Tell("Отключен ноклип для "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
						int iFlags = int(g_playerModes[pTarget.entindex()]);
						iFlags &= ~PLAYER_NOCLIP;
						g_playerModes[pTarget.entindex()] = iFlags;
					}else
						af2player.Tell("Игрок "+pTarget.pev.netname+" уже в клипе!", AFArgs.User, HUD_PRINTCONSOLE);
				}
			}
			
			CheckPlayerModes(null);
		}
	}

	void nosolid(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		HUD targetHud = AFArgs.IsChat ? HUD_PRINTTALK : HUD_PRINTCONSOLE;
		int iMode = AFArgs.GetCount() >= 2 ? AFArgs.GetInt(1) : -1;
		if(AFBase::GetTargetPlayers(AFArgs.User, targetHud, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				bool bIsOn = int(g_playerModes[pTarget.entindex()]) & PLAYER_NOSOLID > 0 ? true : false;
				if(iMode == -1)
				{
					af2player.Tell("Переключен солидность для"+pTarget.pev.netname, AFArgs.User, targetHud);
					int iFlags = int(g_playerModes[pTarget.entindex()]);
					iFlags ^= PLAYER_NOSOLID;
					g_playerModes[pTarget.entindex()] = iFlags;
				}else if(iMode == 1)
				{
					if(!bIsOn)
					{
						af2player.Tell("Включен солидность для"+pTarget.pev.netname, AFArgs.User, targetHud);
						int iFlags = int(g_playerModes[pTarget.entindex()]);
						iFlags |= PLAYER_NOSOLID;
						g_playerModes[pTarget.entindex()] = iFlags;
					}else
						af2player.Tell("Игрок "+pTarget.pev.netname+" уже не солидный!", AFArgs.User, targetHud);
				}else{
					if(bIsOn)
					{
						af2player.Tell("Отключен солидность для"+pTarget.pev.netname, AFArgs.User, targetHud);
						int iFlags = int(g_playerModes[pTarget.entindex()]);
						iFlags &= ~PLAYER_NOSOLID;
						g_playerModes[pTarget.entindex()] = iFlags;
					}else
						af2player.Tell("Игрок "+pTarget.pev.netname+" уже солидный!", AFArgs.User, targetHud);
				}
			}
			
			CheckPlayerModes(null);
		}
	}
	
	void CheckPlayerModes(CBasePlayer@ pTarget)
	{
		if(pTarget is null)
		{
			CBasePlayer@ pSearch = null;
			for(int i = 1; i <= g_Engine.maxClients; i++)
			{
				@pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
				if(pSearch !is null)
				{
					if(int(g_playerModes[pSearch.entindex()]) & PLAYER_FROZEN > 0)
					{
						if(pSearch.pev.flags & FL_FROZEN == 0)
							pSearch.pev.flags |= FL_FROZEN;
					}else{
						if(pSearch.pev.flags & FL_FROZEN > 0)
							pSearch.pev.flags &= ~FL_FROZEN;
					}
					
					if(int(g_playerModes[pSearch.entindex()]) & PLAYER_GOD > 0)
					{
						if(pSearch.pev.flags & FL_GODMODE == 0)
							pSearch.pev.flags |= FL_GODMODE;
					}else{
						if(pSearch.pev.flags & FL_GODMODE > 0)
							pSearch.pev.flags &= ~FL_GODMODE;
					}
					
					if(int(g_playerModes[pSearch.entindex()]) & PLAYER_NOCLIP > 0)
					{
						if(pSearch.pev.movetype != MOVETYPE_NOCLIP)
							pSearch.pev.movetype = MOVETYPE_NOCLIP;

						if(pSearch.pev.flags & FL_FLY == 0)
							pSearch.pev.flags |= FL_FLY;
					}else{
						if(pSearch.pev.movetype != MOVETYPE_WALK)
							pSearch.pev.movetype = MOVETYPE_WALK;
							
						if(pSearch.pev.flags & FL_FLY > 0)
							pSearch.pev.flags &= ~FL_FLY;
					}
					
					if(int(g_playerModes[pSearch.entindex()]) & PLAYER_NOSOLID > 0)
					{
						if(pSearch.pev.movetype != SOLID_NOT)
							if(!pSearch.GetObserver().IsObserver())
								pSearch.pev.solid = SOLID_NOT;
					}else{
						if(pSearch.pev.movetype != SOLID_BBOX)
							if(!pSearch.GetObserver().IsObserver())
								pSearch.pev.solid = SOLID_BBOX;
					}
					
					if(int(g_playerModes[pSearch.entindex()]) & PLAYER_NOTARGET > 0)
					{
						if(pSearch.pev.flags & FL_NOTARGET == 0)
							pSearch.pev.flags |= FL_NOTARGET;
					}else{
						if(pSearch.pev.flags & FL_NOTARGET > 0)
							pSearch.pev.flags &= ~FL_NOTARGET;
					}
				}
			}
		}else{
			if(int(g_playerModes[pTarget.entindex()]) & PLAYER_FROZEN > 0)
			{
				if(pTarget.pev.flags & FL_FROZEN == 0)
					pTarget.pev.flags |= FL_FROZEN;
			}else{
				if(pTarget.pev.flags & FL_FROZEN > 0)
					pTarget.pev.flags &= ~FL_FROZEN;
			}
			
			if(int(g_playerModes[pTarget.entindex()]) & PLAYER_GOD > 0)
			{
				if(pTarget.pev.flags & FL_GODMODE == 0)
					pTarget.pev.flags |= FL_GODMODE;
			}else{
				if(pTarget.pev.flags & FL_GODMODE > 0)
					pTarget.pev.flags &= ~FL_GODMODE;
			}
			
			if(int(g_playerModes[pTarget.entindex()]) & PLAYER_NOCLIP > 0)
			{
				if(pTarget.pev.movetype != PLAYER_NOCLIP)
					pTarget.pev.movetype = MOVETYPE_NOCLIP;
			}else{
				if(pTarget.pev.movetype != MOVETYPE_WALK)
					pTarget.pev.movetype = MOVETYPE_WALK;
			}
			
			if(int(g_playerModes[pTarget.entindex()]) & PLAYER_NOSOLID > 0)
			{
				if(pTarget.pev.movetype != SOLID_TRIGGER)
					if(!pTarget.GetObserver().IsObserver())
						pTarget.pev.solid = SOLID_TRIGGER;
			}else{
				if(pTarget.pev.movetype != SOLID_BBOX)
					if(!pTarget.GetObserver().IsObserver())
						pTarget.pev.solid = SOLID_BBOX;
			}
			
			if(int(g_playerModes[pTarget.entindex()]) & PLAYER_NOTARGET > 0)
			{
				if(pTarget.pev.flags & FL_NOTARGET == 0)
					pTarget.pev.flags |= FL_NOTARGET;
			}else{
				if(pTarget.pev.flags & FL_NOTARGET > 0)
					pTarget.pev.flags &= ~FL_NOTARGET;
			}
		}
	}
	
	dictionary g_playerModes;

	enum PlayerModes
	{
		PLAYER_NOSOLID = 1,
		PLAYER_NOCLIP = 2,
		PLAYER_FLAMING = 4,
		PLAYER_GOD = 8,
		PLAYER_FROZEN = 16,
		PLAYER_NOTARGET = 32
	}

	void keyvalue(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		string sVal = AFArgs.GetCount() >= 3 ? AFArgs.GetString(2) : "";
		string sValY = AFArgs.GetCount() >= 4 ? AFArgs.GetString(3) : "";
		string sValZ = AFArgs.GetCount() >= 5 ? AFArgs.GetString(4) : "";
		string sValout = "";
		if(sVal != "" && sValY != "" && sValZ != "")
			sValout = sVal+" "+sValY+" "+sValZ;
		else
			sValout = sVal;
			
		bool bHasE = AFBase::CheckAccess(AFArgs.User, ACCESS_E);
		
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				if(sValout == "")
				{
					string sReturn = AF2LegacyCode::getKeyValue(pTarget, AFArgs.GetString(1));
					if(sReturn != "§§§§N/A")
					{
						af2player.Tell("У игрока \""+pTarget.pev.netname+"\" параметр стоит на \""+sReturn+"\"", AFArgs.User, HUD_PRINTCONSOLE);
					}
					else
					{
						//retarded. but works.
						if(AFArgs.GetString(1).ToLowercase() == "m_ieffectblockweapons")
							af2player.Tell("У игрока \""+pTarget.pev.netname+"\" параметр стоит на \""+string(pTarget.m_iEffectBlockWeapons)+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						else if(AFArgs.GetString(1).ToLowercase() == "m_ieffectinvulnerable")
							af2player.Tell("У игрока \""+pTarget.pev.netname+"\" параметр стоит на \""+string(pTarget.m_iEffectInvulnerable)+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						else if(AFArgs.GetString(1).ToLowercase() == "m_ieffectinvisible")
							af2player.Tell("У игрока \""+pTarget.pev.netname+"\" параметр стоит на \""+string(pTarget.m_iEffectInvisible)+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						else if(AFArgs.GetString(1).ToLowercase() == "m_ieffectnonsolid")
							af2player.Tell("У игрока \""+pTarget.pev.netname+"\" параметр стоит на \""+string(pTarget.m_iEffectNonSolid)+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						else if(AFArgs.GetString(1).ToLowercase() == "m_fleffectrespiration")
							af2player.Tell("У игрока \""+pTarget.pev.netname+"\" параметр стоит на \""+string(pTarget.m_flEffectRespiration)+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						else if(AFArgs.GetString(1).ToLowercase() == "m_fleffectgravity")
							af2player.Tell("У игрока \""+pTarget.pev.netname+"\" параметр стоит на \""+string(pTarget.m_flEffectGravity)+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						else if(AFArgs.GetString(1).ToLowercase() == "m_fleffectfriction")
							af2player.Tell("У игрока \""+pTarget.pev.netname+"\" параметр стоит на \""+string(pTarget.m_flEffectFriction)+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						else if(AFArgs.GetString(1).ToLowercase() == "m_fleffectspeed")
							af2player.Tell("У игрока \""+pTarget.pev.netname+"\" параметр стоит на \""+string(pTarget.m_flEffectSpeed)+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						else if(AFArgs.GetString(1).ToLowercase() == "m_fleffectdamage")
							af2player.Tell("У игрока \""+pTarget.pev.netname+"\" параметр стоит на \""+string(pTarget.m_flEffectDamage)+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						else if(AFArgs.GetString(1).ToLowercase() == "m_ideaths")
							af2player.Tell("У игрока \""+pTarget.pev.netname+"\" параметр стоит на \""+string(pTarget.m_iDeaths)+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						else
							af2player.Tell("Не поддержуемый параметр", AFArgs.User, HUD_PRINTCONSOLE);
						
					}
				}else{
					if(AFArgs.GetString(1) == "model" || AFArgs.GetString(1) == "viewmodel" || AFArgs.GetString(1) == "weaponmodel" || AFArgs.GetString(1) == "modelindex")
					{
						if(!bHasE)
						{
							af2player.Tell("Заблокировано: вам требуеться иметь доступ Е чтобы изпользовать это (\"большой риск\" доступ).", AFArgs.User, HUD_PRINTCONSOLE);
							return;
						}
					}
					
					//round two
					if(AFArgs.GetString(1).ToLowercase() == "m_ieffectblockweapons")
					{
						af2player.Tell("Установлено игроку \""+pTarget.pev.netname+"\" параметр на \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						pTarget.m_iEffectBlockWeapons = atoi(sValout);
					}
					else if(AFArgs.GetString(1).ToLowercase() == "m_ieffectinvulnerable")
					{
						af2player.Tell("Установлено игроку \""+pTarget.pev.netname+"\" параметр на \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						pTarget.m_iEffectInvulnerable = atoi(sValout);
					}
					else if(AFArgs.GetString(1).ToLowercase() == "m_ieffectinvisible")
					{
						af2player.Tell("Установлено игроку \""+pTarget.pev.netname+"\" параметр на \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						pTarget.m_iEffectInvisible = atoi(sValout);
					}
					else if(AFArgs.GetString(1).ToLowercase() == "m_ieffectnonsolid")
					{
						af2player.Tell("Установлено игроку \""+pTarget.pev.netname+"\" параметр на \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						pTarget.m_iEffectNonSolid = atoi(sValout);
					}
					else if(AFArgs.GetString(1).ToLowercase() == "m_fleffectrespiration")
					{
						af2player.Tell("Установлено игроку \""+pTarget.pev.netname+"\" параметр на \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						pTarget.m_flEffectRespiration = atof(sValout);
					}
					else if(AFArgs.GetString(1).ToLowercase() == "m_fleffectgravity")
					{
						af2player.Tell("Установлено игроку \""+pTarget.pev.netname+"\" параметр на \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						pTarget.m_flEffectGravity = atof(sValout);
					}
					else if(AFArgs.GetString(1).ToLowercase() == "m_fleffectfriction")
					{
						af2player.Tell("Установлено игроку \""+pTarget.pev.netname+"\" параметр на \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						pTarget.m_flEffectFriction = atof(sValout);
					}
					else if(AFArgs.GetString(1).ToLowercase() == "m_fleffectspeed")
					{
						af2player.Tell("Установлено игроку \""+pTarget.pev.netname+"\" параметр на \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						pTarget.m_flEffectSpeed = atof(sValout);
					}
					else if(AFArgs.GetString(1).ToLowercase() == "m_fleffectdamage")
					{
						af2player.Tell("Установлено игроку \""+pTarget.pev.netname+"\" параметр на \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						pTarget.m_flEffectDamage = atof(sValout);
					}
					else if(AFArgs.GetString(1).ToLowercase() == "m_ideaths")
					{
						af2player.Tell("Установлено игроку \""+pTarget.pev.netname+"\" параметр на \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						pTarget.m_iDeaths = atoi(sValout);
					}
					else
					{
						af2player.Tell("Установлено игроку \""+pTarget.pev.netname+"\" параметр на \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
						g_EntityFuncs.DispatchKeyValue(pTarget.edict(), AFArgs.GetString(1), sValout);
					}
				}
			}
		}
	}

	void maxspeed(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				pTarget.SetMaxSpeedOverride(int(AFArgs.GetFloat(1)));
				af2player.Tell("Установлена максмимальная скорость "+string(AFArgs.GetFloat(1))+" на "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}

	void resurrect(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		HUD targetHud = AFArgs.IsChat ? HUD_PRINTTALK : HUD_PRINTCONSOLE;
		bool bNoRespawn = AFArgs.GetCount() >= 2 ? AFArgs.GetBool(1) : false;
		if(AFBase::GetTargetPlayers(AFArgs.User, targetHud, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				Vector oldPos = pTarget.pev.origin;
				Vector oldAngles = pTarget.pev.angles;
				g_PlayerFuncs.RespawnPlayer(pTarget, true, true);
				if(bNoRespawn)
				{
					pTarget.SetOrigin(oldPos);
					pTarget.pev.fixangle = FAM_FORCEVIEWANGLES;
					pTarget.pev.angles = oldAngles;
				}
				
				af2player.Tell("Возрожден "+pTarget.pev.netname, AFArgs.User, targetHud);
			}
		}
	}

	void position(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				af2player.Tell("Игрок "+pTarget.pev.netname+" позиция X: "+pTarget.pev.origin.x+" Y: "+pTarget.pev.origin.y+" Z: "+pTarget.pev.origin.z, AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}

	void givemapcfg(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NODEAD|TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				g_PlayerFuncs.ApplyMapCfgToPlayer(pTarget, false);
				af2player.Tell("Выдана конфигурация карты для "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}

	void giveammo(AFBaseArguments@ AFArgs)
	{
		bool bAllWeapons = AFArgs.GetCount() >= 2 ? AFArgs.GetBool(1) : true;
		array<CBasePlayer@> pTargets;
		HUD targetHud = AFArgs.IsChat ? HUD_PRINTTALK : HUD_PRINTCONSOLE;
		if(AFBase::GetTargetPlayers(AFArgs.User, targetHud, AFArgs.GetString(0), TARGETS_NODEAD|TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				if(!pTarget.HasWeapons())
				{
					af2player.Tell(string(pTarget.pev.netname)+" не имеет никаких оружий которым выдать можно патроны.", AFArgs.User, targetHud);
					continue;
				}
				
				bool wasGivenAmmo = false;
				if(!bAllWeapons)
				{
					CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pTarget.m_hActiveItem.GetEntity());
					if(activeItem.PrimaryAmmoIndex() > -1)
					{
						pTarget.GiveAmmo(activeItem.iMaxAmmo1(), activeItem.pszAmmo1(), activeItem.iMaxAmmo1());
						wasGivenAmmo = true;
					}
					
					if(activeItem.SecondaryAmmoIndex() > -1)
					{
						pTarget.GiveAmmo(activeItem.iMaxAmmo2(), activeItem.pszAmmo2(), activeItem.iMaxAmmo2());
						wasGivenAmmo = true;
					}
					
					if(wasGivenAmmo)
						af2player.Tell("Выданы патроны для "+pTarget.pev.netname+" (держит: "+activeItem.pszName()+")", AFArgs.User, targetHud);
					else
						af2player.Tell("Нельзя выдать патроны для "+pTarget.pev.netname+", оружие не изпользует патроны! (держит: "+activeItem.pszName()+")", AFArgs.User, targetHud);
					
					continue;
				}
				
				CBasePlayerItem@ pItem;
				CBasePlayerWeapon@ pWeapon;
				int amt = 0;
				for(uint j = 0; j < MAX_ITEM_TYPES; j++)
				{
					@pItem = pTarget.m_rgpPlayerItems(j);
					while(pItem !is null)
					{
						@pWeapon = pItem.GetWeaponPtr();
						wasGivenAmmo = false;
						if(pWeapon.PrimaryAmmoIndex() > -1)
						{
							pTarget.GiveAmmo(pWeapon.iMaxAmmo1(), pWeapon.pszAmmo1(), pWeapon.iMaxAmmo1());
							wasGivenAmmo = true;
						}
						
						if(pWeapon.SecondaryAmmoIndex() > -1)
						{
							pTarget.GiveAmmo(pWeapon.iMaxAmmo2(), pWeapon.pszAmmo2(), pWeapon.iMaxAmmo2());
							wasGivenAmmo = true;
						}
						
						if(wasGivenAmmo) amt++;
						
						@pItem = cast<CBasePlayerItem@>(pItem.m_hNextItem.GetEntity());
					}
				}
					
				if(amt > 0)
					af2player.Tell("Выданы патроны для "+pTarget.pev.netname+" (потенциально доставлены оружия: "+string(amt)+")", AFArgs.User, targetHud);
				else
					af2player.Tell("Невыданы патроны для "+pTarget.pev.netname+" (потенциально доставлены оружия: "+string(amt)+"!)", AFArgs.User, targetHud);
			}
		}
	}

	const array<string> player_weaponlist_native = 
	{
		"weapon_357", "weapon_9mmar", "weapon_9mmhandgun", "weapon_crossbow",
		"weapon_crowbar", "weapon_displacer", "weapon_eagle", "weapon_egon",
		"weapon_gauss", "weapon_grapple", "weapon_handgrenade", "weapon_hornetgun",
		"weapon_m16", "weapon_m249", "weapon_medkit", "weapon_minigun",
		"weapon_pipewrench", "weapon_rpg", "weapon_satchel", "weapon_shotgun",
		"weapon_snark", "weapon_sniperrifle", "weapon_sporelauncher", "weapon_tripmine",
		"weapon_uzi"
	};

	const array<string> player_weaponlist_ins2 = 
	{
		"weapon_ins2ak12", "weapon_ins2ak74", "weapon_ins2akm", "weapon_ins2aks74u",
		"weapon_ins2asval", "weapon_ins2m1014", "weapon_ins2beretta", "weapon_ins2knuckles",
		"weapon_ins2c96carb", "weapon_ins2c96", "weapon_ins2coach", "weapon_ins2m1911",
		"weapon_ins2python", "weapon_ins2deagle", "weapon_ins2dragunov", "weapon_ins2fg42",
		"weapon_ins2f2000", "weapon_ins2fnfal", "weapon_ins2m249", "weapon_ins2galil",
		"weapon_ins2g43", "weapon_ins2glock17", "weapon_ins2g3a3", "weapon_ins2mp5k",
		"weapon_ins2mp7", "weapon_ins2ump45", "weapon_ins2usp", "weapon_ins2ithaca",
		"weapon_ins2kabar", "weapon_ins2kukri", "weapon_ins2l85a2", "weapon_ins2enfield",
		"weapon_ins2garand", "weapon_ins2at4", "weapon_ins2m14ebr", "weapon_ins2m16a4",
		"weapon_ins2stick", "weapon_ins2m4a1", "weapon_ins2m60", "weapon_ins2law",
		"weapon_ins2m79", "weapon_ins2makarov", "weapon_ins2mg42", "weapon_ins2mk2",
		"weapon_ins2mosin", "weapon_ins2m590", "weapon_ins2mp18", "weapon_ins2mp40",
		"weapon_ins2pzfaust", "weapon_ins2pzschreck", "weapon_ins2ppsh41", "weapon_ins2rpg7",
		"weapon_ins2rpk", "weapon_ins2saiga12", "weapon_ins2sks", "weapon_ins2m29",
		"weapon_ins2l2a3", "weapon_ins2stg44", "weapon_ins2m1928", "weapon_ins2webley"
	};
	
	const array<string> player_weaponlist_cs16 =
	{
		"weapon_p228", "weapon_dualelites", "weapon_csglock18", "weapon_aug",
		"weapon_c4", "weapon_famas", "weapon_ak47", "weapon_g3sg1",
		"weapon_p90", "weapon_fiveseven", "weapon_csm249", "weapon_hegrenade",
		"weapon_galil", "weapon_mac10", "weapon_usp", "weapon_mp5navy",
		"weapon_ump45", "weapon_csknife", "weapon_sg550", "weapon_sg552",
		"weapon_m3", "weapon_xm1014", "weapon_awp", "weapon_m4a1",
		"weapon_csdeagle", "weapon_tmp", "weapon_scout"
	};
	
	const array<string> player_weaponlist_cof =
	{
		"weapon_cofswitchblade", "weapon_cofnightstick", "weapon_cofbranch", "weapon_cofsledgehammer",
		"weapon_cofaxe", "weapon_cofglock", "weapon_cofvp70", "weapon_cofp345",
		"weapon_cofrevolver", "weapon_cofshotgun", "weapon_cofrifle", "weapon_cofm16",
		"weapon_cofg43", "weapon_coftmp", "weapon_cofmp5", "weapon_cотключенamas",
		"weapon_cofsyringe", "weapon_coflantern", "weapon_cofbooklaser", "weapon_cofcamera",
		"weapon_cofak74", "weapon_cofberetta", "weapon_cofdeagle", "weapon_cofp228",
		"weapon_cofglock18", "weapon_cofanaconda", "weapon_cofgolden", "weapon_cofuzi",
		"weapon_cofl85", "weapon_cofmp5k", "weapon_cofbenelli", "weapon_cofknife",
		"weapon_cofhammer", "weapon_cofspear", "weapon_cofm76", "v_action"
	};
	
	enum player_weaponlist_available
	{
		WEAPONLIST_INS2 = 1,
		WEAPONLIST_CS16 = 2,
		WEAPONLIST_COF = 4
	}
	
	void giveall(AFBaseArguments@ AFArgs)
	{
		string sTargets = AFArgs.GetCount() > 0 ? AFArgs.GetString(0) : "";
		string sSet = AFArgs.GetCount() > 1 ? AFArgs.GetString(1) : "vanilla";
		int availables = 0;
		if(sTargets == "")
		{
			af2player.Tell("Доступные сеты (изпользуйте \"all\" чтобы выдать ВСЕ оружия):", AFArgs.User, HUD_PRINTCONSOLE);
			array<string> plugins = g_PluginManager.GetPluginList();
			af2player.Tell("vanilla", AFArgs.User, HUD_PRINTCONSOLE);
			for(uint i = 0; i < plugins.length(); i++)
			{
				if(plugins[i].ToLowercase() == "insurgency mod")
					af2player.Tell("ins2", AFArgs.User, HUD_PRINTCONSOLE);
				if(plugins[i].ToLowercase() == "counter-strike 1.6 mod")
					af2player.Tell("cs16", AFArgs.User, HUD_PRINTCONSOLE);
				if(plugins[i].ToLowercase() == "cry of fear")
					af2player.Tell("cof", AFArgs.User, HUD_PRINTCONSOLE);
			}
			
			return;
		}
		
		//read out whats available for "all" set... because who knows - someone might be mad enough to run all at once
		array<string> plugins = g_PluginManager.GetPluginList();
		for(uint i = 0; i < plugins.length(); i++)
		{
			if(plugins[i].ToLowercase() == "insurgency mod")
				availables |= WEAPONLIST_INS2;
			if(plugins[i].ToLowercase() == "counter-strike 1.6 mod")
				availables |= WEAPONLIST_CS16;
			if(plugins[i].ToLowercase() == "cry of fear")
				availables |= WEAPONLIST_COF;
		}
		
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, sTargets, TARGETS_NODEAD|TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				af2player.Tell("Выдано всё из \""+sSet+"\" сета для "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
				if(sSet == "vanilla")
				{
					for(uint j = 0; j < player_weaponlist_native.length(); j++)
						pTarget.GiveNamedItem(player_weaponlist_native[j], 0, 9999);
				}
				else if(sSet == "ins2")
				{
					for(uint j = 0; j < player_weaponlist_ins2.length(); j++)
						pTarget.GiveNamedItem(player_weaponlist_ins2[j], 0, 9999);
				}
				else if(sSet == "cs16")
				{
					for(uint j = 0; j < player_weaponlist_cs16.length(); j++)
						pTarget.GiveNamedItem(player_weaponlist_cs16[j], 0, 9999);
				}
				else if(sSet == "cof")
				{
					for(uint j = 0; j < player_weaponlist_cof.length(); j++)
						pTarget.GiveNamedItem(player_weaponlist_cof[j], 0, 9999);
				}
				else if(sSet == "all") // you mad man
				{
					for(uint j = 0; j < player_weaponlist_native.length(); j++)
						pTarget.GiveNamedItem(player_weaponlist_native[j], 0, 9999);
						
					if(availables & WEAPONLIST_INS2 > 0)
						for(uint j = 0; j < player_weaponlist_ins2.length(); j++)
							pTarget.GiveNamedItem(player_weaponlist_ins2[j], 0, 9999);
						
					if(availables & WEAPONLIST_CS16 > 0)
						for(uint j = 0; j < player_weaponlist_cs16.length(); j++)
							pTarget.GiveNamedItem(player_weaponlist_cs16[j], 0, 9999);
						
					if(availables & WEAPONLIST_COF > 0)
						for(uint j = 0; j < player_weaponlist_cof.length(); j++)
							pTarget.GiveNamedItem(player_weaponlist_cof[j], 0, 9999);
				}
			}
		}
	}

	void give(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		HUD targetHud = AFArgs.IsChat ? HUD_PRINTTALK : HUD_PRINTCONSOLE;
		if(AFArgs.GetString(1) == "weapon_entmover")
		{
			af2player.Tell("Нельзя выдать ентмувер!", AFArgs.User, targetHud);
			return;
		}
		
		if(AFBase::GetTargetPlayers(AFArgs.User, targetHud, AFArgs.GetString(0), TARGETS_NODEAD|TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				if(pTarget.HasNamedPlayerItem(AFArgs.GetString(1)) !is null)
				{
					af2player.Tell("Нельзя выдать"+AFArgs.GetString(1)+" для "+pTarget.pev.netname+": цель уже имеет такое оружие!", AFArgs.User, targetHud);
					continue;
				}
				
				pTarget.GiveNamedItem(AFArgs.GetString(1), 0, 9999);
				af2player.Tell("Выдан "+AFArgs.GetString(1)+" для "+pTarget.pev.netname, AFArgs.User, targetHud);
			}
		}
	}

	void getmodel(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				KeyValueBuffer@ pInfo = g_EngineFuncs.GetInfoKeyBuffer(pTarget.edict());
				af2player.Tell("Игрок "+pTarget.pev.netname+" имеет модель "+pInfo.GetValue("model"), AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}

	void disarm(AFBaseArguments@ AFArgs)
	{
		string sTargetWeapon = AFArgs.GetCount() >= 2 ? AFArgs.GetString(1) : "";
		if(sTargetWeapon == "weapon_entmover")
		{
			af2player.Tell("Нельзя отобрать ентмувер!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		array<CBasePlayer@> pTargets;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), 0, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				if(!pTarget.HasWeapons())
				{
					af2player.Tell("Нельзя отобрать "+pTarget.pev.netname+": игрок не имеет оружий!", AFArgs.User, HUD_PRINTCONSOLE);
				}
				
				if(sTargetWeapon == "")
				{
					//special case behavior so we can remove all weapons except entmover
					int amt = 0;
					CBasePlayerItem@ pItem;
					CBasePlayerItem@ pItemHold;
					CBasePlayerWeapon@ pWeapon;
					for(uint j = 0; j < MAX_ITEM_TYPES; j++)
					{
						@pItem = pTarget.m_rgpPlayerItems(j);
						while(pItem !is null)
						{
							@pWeapon = pItem.GetWeaponPtr();
							
							if(pWeapon.GetClassname() != "weapon_entmover")
							{
								@pItemHold = pItem;
								@pItem = cast<CBasePlayerItem@>(pItem.m_hNextItem.GetEntity());
								pTarget.RemovePlayerItem(pItemHold);
								amt++;
								continue;
							}
							
							@pItem = cast<CBasePlayerItem@>(pItem.m_hNextItem.GetEntity());
						}
					}
					
					af2player.Tell("Отобрали "+string(amt)+" оружий из "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
				}
				else
				{
					if(AFBase::RemoveSingleItem(pTarget, sTargetWeapon))
						af2player.Tell("Отобрали \""+sTargetWeapon+"\" из "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
					else
						af2player.Tell(string(pTarget.pev.netname)+" не имеет оружия \""+sTargetWeapon+"\"", AFArgs.User, HUD_PRINTCONSOLE);
				}
			}
		}
	}

	void teleportpos(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		HUD targetHud = AFArgs.IsChat ? HUD_PRINTTALK : HUD_PRINTCONSOLE;
		if(AFBase::GetTargetPlayers(AFArgs.User, targetHud, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			Vector position = AFArgs.GetVector(1);
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				af2player.Tell("Телепортировали "+pTarget.pev.netname+" на X: "+position.x+" Y: "+position.y+" Z: "+position.z, AFArgs.User, targetHud);
				pTarget.SetOrigin(position);
				pTarget.pev.velocity = Vector(0,0,0);
				pTarget.pev.flFallVelocity = 0.0f;
			}
		}
	}

	void teleporttome(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		HUD targetHud = AFArgs.IsChat ? HUD_PRINTTALK : HUD_PRINTCONSOLE;
		if(AFBase::GetTargetPlayers(AFArgs.User, targetHud, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				af2player.Tell("Телепортировали "+pTarget.pev.netname, AFArgs.User, targetHud);
				pTarget.SetOrigin(AFArgs.User.pev.origin);
				pTarget.pev.velocity = Vector(0,0,0);
				pTarget.pev.fixangle = FAM_FORCEVIEWANGLES;
				pTarget.pev.angles = AFArgs.User.pev.angles;
			}
		}
	}

	void teleportmeto(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		HUD targetHud = AFArgs.IsChat ? HUD_PRINTTALK : HUD_PRINTCONSOLE;
		if(AFBase::GetTargetPlayers(AFArgs.User, targetHud, AFArgs.GetString(0), TARGETS_NOALL|TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			af2player.Tell("Телепортировали на "+AFArgs.GetString(0), AFArgs.User, targetHud);
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				AFArgs.User.SetOrigin(pTarget.pev.origin);
				AFArgs.User.pev.velocity = Vector(0,0,0);
				AFArgs.User.pev.fixangle = FAM_FORCEVIEWANGLES;
				AFArgs.User.pev.angles = pTarget.pev.angles;
				AFArgs.User.pev.flFallVelocity = 0.0f;
			}
		}
	}

	void teleportaim(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		HUD targetHud = AFArgs.IsChat ? HUD_PRINTTALK : HUD_PRINTCONSOLE;
		if(AFBase::GetTargetPlayers(AFArgs.User, targetHud, AFArgs.GetString(0), TARGETS_NOAIM|TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			g_EngineFuncs.MakeVectors(AFArgs.User.pev.v_angle);
			Vector vecSrc = AFArgs.User.GetGunPosition();
			Vector vecAiming = g_Engine.v_forward;
			TraceResult tr;
			g_Utility.TraceHull(vecSrc, vecSrc+vecAiming*2048, dont_ignore_monsters, human_hull, AFArgs.User.edict(), tr);
			Vector endResult = tr.vecEndPos;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				af2player.Tell("Телепортировали "+pTarget.pev.netname, AFArgs.User, targetHud);
				pTarget.SetOrigin(endResult);
				pTarget.pev.velocity = Vector(0,0,0);
				pTarget.pev.flFallVelocity = 0.0f;
			}
		}
	}
	
	void notarget(AFBaseArguments@ AFArgs)
	{
		array<CBasePlayer@> pTargets;
		int iMode = AFArgs.GetCount() >= 2 ? AFArgs.GetInt(1) : -1;
		if(AFBase::GetTargetPlayers(AFArgs.User, HUD_PRINTCONSOLE, AFArgs.GetString(0), TARGETS_NOIMMUNITYCHECK, pTargets))
		{
			CBasePlayer@ pTarget = null;
			for(uint i = 0; i < pTargets.length(); i++)
			{
				@pTarget = pTargets[i];
				bool bIsOn = int(g_playerModes[pTarget.entindex()]) & PLAYER_NOTARGET > 0 ? true : false;
				if(iMode == -1)
				{
					af2player.Tell("Переключен нотаргет для "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
					int iFlags = int(g_playerModes[pTarget.entindex()]);
					iFlags ^= PLAYER_NOTARGET;
					g_playerModes[pTarget.entindex()] = iFlags;
				}else if(iMode == 1)
				{
					if(!bIsOn)
					{
						af2player.Tell("Включен нотаргет для "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
						int iFlags = int(g_playerModes[pTarget.entindex()]);
						iFlags |= PLAYER_NOTARGET;
						g_playerModes[pTarget.entindex()] = iFlags;
					}else
						af2player.Tell("Игрок "+pTarget.pev.netname+" уже в нотаргете!", AFArgs.User, HUD_PRINTCONSOLE);
				}else{
					if(bIsOn)
					{
						af2player.Tell("Установлен нотаргет для "+pTarget.pev.netname, AFArgs.User, HUD_PRINTCONSOLE);
						int iFlags = int(g_playerModes[pTarget.entindex()]);
						iFlags &= ~PLAYER_NOTARGET;
						g_playerModes[pTarget.entindex()] = iFlags;
					}else
						af2player.Tell("Игрок "+pTarget.pev.netname+" уже в таргете!", AFArgs.User, HUD_PRINTCONSOLE);
				}
			}
			
			CheckPlayerModes(null);
		}
	}
}