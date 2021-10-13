#include "AF2Legacy"
#include "AF2E/entmover"

AF2Entity af2entity;

void AF2Entity_Call()
{
	af2entity.RegisterExpansion(af2entity);
}

class AF2Entity : AFBaseClass
{
	void ExpansionInfo()
	{
		this.AuthorName = "Zode";
		this.ExpansionName = "AdminFuckery2 Энтити команды";
		this.ShortName = "AF2E";
	}
	
	void ExpansionInit()
	{
		RegisterCommand("ent_damage", "!fs", "<урон> <имя цели> - наносит урон объекту, без аргументов наносит 5000 урона", ACCESS_F, @AF2Entity::damage);
		RegisterCommand("ent_keyvalue", "s!sss", "(параметр) <значение> <значение> <значение> - меняет параметры объекту, изпользуйте \"!null!\" чтобы оставить параметр пустым", ACCESS_F, @AF2Entity::keyvalue);
		RegisterCommand("ent_keyvaluename", "ss!sss", "(имя цели) (параметр) <значение> <значение> <значение> - меняет параметры прописанному объекту", ACCESS_F, @AF2Entity::keyvaluename);
		RegisterCommand("ent_keyvaluerange", "sfs!sss", "(имя объекта) (радиус) (параметр) <значение> <значение> <значение> - меняет параметры какой либо группы объектов по радиусу", ACCESS_F, @AF2Entity::keyvaluerange);
		RegisterCommand("ent_kill", "!s", "<имя цели> - удаляет объект", ACCESS_F, @AF2Entity::kill);
		RegisterCommand("ent_trigger", "!s", "<имя цели> - активирует объект", ACCESS_F, @AF2Entity::trigger);
		RegisterCommand("ent_triggerrange", "sf", "(имя объекта/ов) (радиус) - активирует группу объектов по радиусу", ACCESS_F, @AF2Entity::triggerrange);
		RegisterCommand("ent_rotate", "fff!s", " (X) (Y) (Z) <имя цели> - переворачивает ось объекта, для лучших результатов изпользуйте ось 15", ACCESS_F, @AF2Entity::rotate);
		RegisterCommand("ent_rotateabsolute", "fff!s", "(X) (Y) (Z) <имя цели> - абсолютное переворачивание объекта", ACCESS_F, @AF2Entity::rotateabsolute);
		RegisterCommand("ent_create", "s!s", "(имя объекта) <\"параметр:значение:параметр:значение:параметр:значение\"> - создает объект с вашими параметрами, спавнит на вашу точку", ACCESS_F|ACCESS_E, @AF2Entity::create);
		RegisterCommand("ent_movename", "s", "(имя цели) - абсолтюное движение, двигает объект на ваши кординаты", ACCESS_F, @AF2Entity::moveabsolute);
		RegisterCommand("ent_move", "!b", "- используйте без каких либо аргументов чтобы вам прислали алиасы чтобы иcпользовать эту команду - Двигает нацеленый объект мышкой", ACCESS_F, @AF2Entity::move, CMD_PRECACHE);
		RegisterCommand("ent_movecopy", "!b", "- тоже самое что и .ent_move, но заодно и копирует", ACCESS_F, @AF2Entity::movecopy, CMD_PRECACHE);
		RegisterCommand("ent_drop", "", " - ложить объект нацеленый объект на пол", ACCESS_F, @AF2Entity::drop);
		RegisterCommand("ent_item", "s", "(weapon_/ammo_/item_) - спавнит какое либо оружие, патрон или предмет, облегченный .ent_create", ACCESS_F, @AF2Entity::item);
		RegisterCommand("ent_worldcopy", "f!vbbb", "(скорость) <угол вектора> <реверс> <0/1 X ось> <0/1 Y ось> - создает копию карты", ACCESS_F, @AF2Entity::worldcopy);
		RegisterCommand("ent_worldremove", "", "- убирает копию карты", ACCESS_F, @AF2Entity::worldremove);
		RegisterCommand("ent_mover", "!i", "- выдает weapon_entmover, позволяет двигать объекты на лкм, и удалять их на пкм", ACCESS_F, @AF2Entity::entmover, CMD_PRECACHE);
		RegisterCommand("ent_dumpinfo", "!bs", "<0/1 грязно> <имя цели> - показывает информацию о нацеленном ентити", ACCESS_F, @AF2Entity::dumpinfo);
		RegisterCommand("ent_rotatefix", "!s", "<имя цели> - попытается починить багнутое переворачивание", ACCESS_F, @AF2Entity::rotatefix);
		RegisterCommand("ent_grid", "i", "(размер сетки в юнитах) - включает сетку когда перетаскиваешь какой либо объект, 0 отключает", ACCESS_F, @AF2Entity::grid);
		RegisterCommand("ent_bbox", "!iiii", "<R> <G> <B> <длительность> - показывает границы объекта", ACCESS_F, @AF2Entity::bbox, CMD_PRECACHE);
		RegisterCommand("ent_bboxname", "s!iiii", "(имя цели) <R> <G> <B> <длительность> - показывает прописанного границы объекта", ACCESS_F, @AF2Entity::bboxname, CMD_PRECACHE);
		RegisterCommand("ent_show", "s", "(X/Y/Z) - показывает направление карты/мира", ACCESS_F, @AF2Entity::show, CMD_PRECACHE);
		
		g_Hooks.RegisterHook(Hooks::Player::PlayerPreThink, @AF2Entity::PlayerPreThink);
		g_Hooks.RegisterHook(Hooks::Player::PlayerSpawn, @AF2Entity::PlayerSpawn);
		g_Hooks.RegisterHook(Hooks::Player::PlayerKilled, @AF2Entity::PlayerKilled);
		
		AF2Entity::g_entMoving.deleteAll();
		AF2Entity::g_entWeapon.deleteAll();
		if(AF2Entity::g_entThink !is null)
			g_Scheduler.RemoveTimer(AF2Entity::g_entThink);
	
		@AF2Entity::g_entThink = g_Scheduler.SetInterval("entThink", AF2Entity::_entThink); // 0375f
	}
	
	void MapInit()
	{
		AF2Entity::g_entMoving.deleteAll();
		AF2Entity::g_entWeapon.deleteAll();
		if(AF2Entity::g_entThink !is null)
			g_Scheduler.RemoveTimer(AF2Entity::g_entThink);
	
		@AF2Entity::g_entThink = g_Scheduler.SetInterval("entThink", AF2Entity::_entThink);
		
		g_Game.PrecacheModel("models/zode/v_entmover.mdl");
		g_Game.PrecacheModel("models/zode/p_entmover.mdl");
		g_Game.PrecacheModel("sprites/zbeam4.spr");
		g_Game.PrecacheModel("sprites/zode/border.spr");
		g_Game.PrecacheModel("sprites/zerogxplode.spr");
		g_SoundSystem.PrecacheSound("tfc/items/inv3.wav");
		
		g_CustomEntityFuncs.RegisterCustomEntity( "AF2Entity::weapon_entmover", "weapon_entmover" );
		g_ItemRegistry.RegisterWeapon( "weapon_entmover", "zode" );
		g_Game.PrecacheOther("weapon_entmover");
		g_Game.PrecacheGeneric("sprites/zode/weapon_entmover.txt");
	}
	
	void PlayerDisconnectEvent(CBasePlayer@ pUser)
	{
		if(AF2Entity::g_entMoving.exists(pUser.entindex()))
			AF2Entity::g_entMoving.delete(pUser.entindex());
			
		if(AF2Entity::g_entWeapon.exists(pUser.entindex()))
			AF2Entity::g_entWeapon.delete(pUser.entindex());
	}
	
	void StopEvent()
	{
		// handle stop copy grab
		CBasePlayer@ pSearch = null;
		for(int i = 1; i <= g_Engine.maxClients; i++)
		{
			@pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
			if(pSearch !is null)
			{
				if(AF2Entity::g_entMoving.exists(pSearch.entindex()))
				{
					Vector grabIndex = Vector(AF2Entity::g_entMoving[pSearch.entindex()]);
					CBaseEntity@ pEntity = g_EntityFuncs.Instance(int(grabIndex.x));
					if(pEntity !is null)
					{
						AF2Entity::popEntRenderSettings(pEntity);
						CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
						pCustom.SetKeyvalue("$i_afbentgrab", 0);
						if(pEntity.IsPlayer())
						{
							if(pEntity.pev.movetype != MOVETYPE_WALK)
								pEntity.pev.movetype = MOVETYPE_WALK;
							
							if(pEntity.pev.flags & FL_FROZEN > 0)
								pEntity.pev.flags &= ~FL_FROZEN;
						}
					}
				}
				
				if(AF2Entity::g_entWeapon.exists(pSearch.entindex()))
				{
					AF2Entity::weaponmover(pSearch, false, false);
				}
			}
		}
		
		dictionary dData;
		dData["player"] = null;
		SendMessage("AF2P", "RecheckPlayer", dData);
		
		AF2Entity::g_entMoving.deleteAll();
		AF2Entity::g_entWeapon.deleteAll();
		if(AF2Entity::g_entThink !is null)
			g_Scheduler.RemoveTimer(AF2Entity::g_entThink);
	}
	
	void StartEvent()
	{
		if(AF2Entity::g_entThink !is null)
			g_Scheduler.RemoveTimer(AF2Entity::g_entThink);
	
		@AF2Entity::g_entThink = g_Scheduler.SetInterval("entThink", AF2Entity::_entThink);
	}
}

namespace AF2Entity
{
	float _entThink = 0.025; // 0375f orig: 0.075+(0<->0.05 variation)
	float _gridTimer = 0.0f;
	int _gridAmt = 10;
	float _gridThresh = _entThink*_gridAmt; 

	void showbeam(Vector position, int mode)
	{
		Vector from = position;
		Vector to = position;
		switch(mode)
		{
			case 0:
				//from.x -= 128;
				to.x += 128;
				
				makeLine(from, to, 255, 0, 0, 120);
				break;
			case 1:
				//from.y -= 128;
				to.y += 128;
				
				makeLine(from, to, 0, 255, 0, 120);
				break;
			case 2:
				//from.z -= 128;
				to.z += 128;
				
				makeLine(from, to, 0, 0, 255, 120);
				break;
		}
		
	}
	
	void show(AFBaseArguments@ AFArgs)
	{
		string mode = AFArgs.GetString(0);
		
		g_EngineFuncs.MakeVectors(AFArgs.User.pev.v_angle);
		Vector vecStart = AFArgs.User.GetGunPosition();
		TraceResult tr;
		g_Utility.TraceLine(vecStart, vecStart+g_Engine.v_forward*4096, ignore_monsters, AFArgs.User.edict(), tr);
		Vector endPoint = tr.vecEndPos - g_Engine.v_forward*48; // pull back a bit
		
		bool wasValid = false;
		for(uint i = 0; i < mode.Length(); i++)
		{
			if(mode[i] == "x")
			{
				showbeam(endPoint, 0);
				wasValid = true;
			}
			else if(mode[i] == "y")
			{
				showbeam(endPoint, 1);
				wasValid = true;
			}
			else if(mode[i] == "z")
			{
				showbeam(endPoint, 2);
				wasValid = true;
			}
			else
			{
				wasValid = false; // enforce
				break;	
			}
		}
		
		if(wasValid)
			af2entity.Tell("Показываю директорию: "+mode, AFArgs.User, HUD_PRINTCONSOLE);
		else
			af2entity.Tell("Недействительный режим директории: "+mode, AFArgs.User, HUD_PRINTCONSOLE);
	}
	
	void bboxname(AFBaseArguments@ AFArgs)
	{
		int r = AFArgs.GetCount() >= 2 ? AFArgs.GetInt(1) : 255;
		int g = AFArgs.GetCount() >= 3 ? AFArgs.GetInt(2) : 0;
		int b = AFArgs.GetCount() >= 4 ? AFArgs.GetInt(3) : 0;
		int t = AFArgs.GetCount() >= 5 ? AFArgs.GetInt(4) : 20;
		
		if(t <= 0)
			t = 1;
		if(t > 255)
			t = 255;
		
		int iC = 0;
		CBaseEntity@ pEntity = null;
		while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, AFArgs.GetString(0))) !is null)
		{
			Vector extent = (pEntity.pev.maxs-pEntity.pev.mins)/2.0f;
			Vector center = pEntity.IsBSPModel() ? getBrushOrigin(pEntity, true) : pEntity.IsPlayer() ? pEntity.pev.origin :  pEntity.IsMonster() ? pEntity.pev.origin+Vector(0,0,extent.z) : pEntity.pev.origin;
			makeBox(center, extent, pEntity.pev.angles, pEntity.IsBSPModel(), r,b,g,t);
			
			iC++;
		}
		
		if(iC == 0)
			af2entity.Tell("Такого объекта с именем не существует!", AFArgs.User, HUD_PRINTCONSOLE);
		else
			af2entity.Tell("Показуем bbox на "+string(iC)+" ентити", AFArgs.User, HUD_PRINTCONSOLE);
	}
	
	void bbox(AFBaseArguments@ AFArgs)
	{
		int r = AFArgs.GetCount() >= 1 ? AFArgs.GetInt(0) : 255;
		int g = AFArgs.GetCount() >= 2 ? AFArgs.GetInt(1) : 0;
		int b = AFArgs.GetCount() >= 3 ? AFArgs.GetInt(2) : 0;
		int t = AFArgs.GetCount() >= 4 ? AFArgs.GetInt(3) : 20;
		
		if(t <= 0)
			t = 1;
		if(t > 255)
			t = 255;
	
		CBaseEntity@ pEntity = g_Utility.FindEntityForward(AFArgs.User, 4096);
		if(pEntity is null)
		{
			af2entity.Tell("Нет объекта впереди(4096 юнитов)!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
	
		Vector extent = (pEntity.pev.maxs-pEntity.pev.mins)/2.0f;
		Vector center = pEntity.IsBSPModel() ? getBrushOrigin(pEntity, true) : pEntity.IsPlayer() ? pEntity.pev.origin :  pEntity.IsMonster() ? pEntity.pev.origin+Vector(0,0,extent.z) : pEntity.pev.origin;
		makeBox(center, extent, pEntity.pev.angles, pEntity.IsBSPModel(), r,b,g,t);
	}
	
	void grid(AFBaseArguments@ AFArgs)
	{
		CustomKeyvalues@ pCustom = AFArgs.User.GetCustomKeyvalues();
		pCustom.SetKeyvalue("$f_afbgrid", AFArgs.GetInt(0));
		if(AFArgs.GetInt(0) <= 0)
		{
			af2entity.Tell("Сетка отключена", AFArgs.User, HUD_PRINTCONSOLE);
		}else{
			af2entity.Tell("Сетка включена, в юнитах: "+AFArgs.GetInt(0), AFArgs.User, HUD_PRINTCONSOLE);
		}
	}

	void makeBox(Vector center, Vector extent, Vector rot, bool applyRotation, int r, int g, int b, int lifetime)
	{
		Vector frontTopLeft = Vector(center.x-extent.x, center.y+extent.y, center.z-extent.z);
		Vector frontTopRight = Vector(center.x+extent.x, center.y+extent.y, center.z-extent.z);
		Vector frontBottomLeft = Vector(center.x-extent.x, center.y-extent.y, center.z-extent.z);
		Vector frontBottomRight = Vector(center.x+extent.x, center.y-extent.y, center.z-extent.z);
		
		Vector backTopLeft = Vector(center.x-extent.x, center.y+extent.y, center.z+extent.z);
		Vector backTopRight = Vector(center.x+extent.x, center.y+extent.y, center.z+extent.z);
		Vector backBottomLeft = Vector(center.x-extent.x, center.y-extent.y, center.z+extent.z);
		Vector backBottomRight = Vector(center.x+extent.x, center.y-extent.y, center.z+extent.z);
		
		if(applyRotation)
		{
			frontTopLeft = transformPoint(frontTopLeft, center, rot);
			frontTopRight = transformPoint(frontTopRight, center, rot);
			frontBottomLeft = transformPoint(frontBottomLeft, center, rot);
			frontBottomRight = transformPoint(frontBottomRight, center, rot);
			
			backTopLeft = transformPoint(backTopLeft, center, rot);
			backTopRight = transformPoint(backTopRight, center, rot);
			backBottomLeft = transformPoint(backBottomLeft, center, rot);
			backBottomRight = transformPoint(backBottomRight, center, rot);
		}
		
		makeLine(frontTopLeft, frontTopRight, r,g,b,lifetime);
		makeLine(frontTopRight, frontBottomRight, r,g,b,lifetime);
		makeLine(frontBottomRight, frontBottomLeft, r,g,b,lifetime);
		makeLine(frontBottomLeft, frontTopLeft, r,g,b,lifetime);
		
		makeLine(backTopLeft, backTopRight, r,g,b,lifetime);
		makeLine(backTopRight, backBottomRight, r,g,b,lifetime);
		makeLine(backBottomRight, backBottomLeft, r,g,b,lifetime);
		makeLine(backBottomLeft, backTopLeft, r,g,b,lifetime);
		
		makeLine(frontTopLeft, backTopLeft, r,g,b,lifetime);
		makeLine(frontTopRight, backTopRight, r,g,b,lifetime);
		makeLine(frontBottomRight, backBottomRight, r,g,b,lifetime);
		makeLine(frontBottomLeft, backBottomLeft, r,g,b,lifetime);
	}

	Vector transformPoint(Vector point, Vector center, Vector rot)
	{
		Vector temp = point-center;
		return center + Math.RotateVector(temp, rot, Vector(0,0,0));
		
	}
	
	void makeLine(Vector i, Vector j, int r, int b, int g, int lifetime)
	{
		NetworkMessage msg(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
		
			msg.WriteByte(TE_BEAMPOINTS);
			
			msg.WriteCoord(i.x);
			msg.WriteCoord(i.y);
			msg.WriteCoord(i.z);
			msg.WriteCoord(j.x);
			msg.WriteCoord(j.y);
			msg.WriteCoord(j.z);
			
			msg.WriteShort(g_EngineFuncs.ModelIndex("sprites/zode/border.spr"));
			
			msg.WriteByte(0); //start
			msg.WriteByte(0); //end
			msg.WriteByte(lifetime);
			msg.WriteByte(24); //width
			msg.WriteByte(0); //noise
			
			msg.WriteByte(r);
			msg.WriteByte(g);
			msg.WriteByte(b);
			msg.WriteByte(200);
			
			msg.WriteByte(10); // scroll
		
		msg.End();
	}
	
	void makeLine2(Vector i, Vector j, int r, int b, int g, int lifetime)
	{
		NetworkMessage msg(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
		
			msg.WriteByte(TE_BEAMPOINTS);
			
			msg.WriteCoord(i.x);
			msg.WriteCoord(i.y);
			msg.WriteCoord(i.z);
			msg.WriteCoord(j.x);
			msg.WriteCoord(j.y);
			msg.WriteCoord(j.z);
			
			msg.WriteShort(g_EngineFuncs.ModelIndex("sprites/zbeam4.spr"));
			
			msg.WriteByte(0); //start
			msg.WriteByte(0); //end
			msg.WriteByte(lifetime);
			msg.WriteByte(12); //width
			msg.WriteByte(0); //noise
			
			msg.WriteByte(r);
			msg.WriteByte(g);
			msg.WriteByte(b);
			msg.WriteByte(255);
			
			msg.WriteByte(0); // scroll
		
		msg.End();
	}
	
	void dumpinfo(AFBaseArguments@ AFArgs)
	{
		string sTarget = AFArgs.GetCount() >= 2 ? AFArgs.GetString(1) : "";
		bool bDirty = AFArgs.GetCount() >= 1 ? AFArgs.GetBool(0) : false;
		if(sTarget == "")
		{
			CBaseEntity@ pEntity = g_Utility.FindEntityForward(AFArgs.User, 4096);
			if(pEntity is null)
			{
				af2entity.Tell("Нет объекта впереди (4096 юнитов)!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
			
			if(pEntity.IsPlayer())
			{
				af2entity.Tell("Нельзя свалить: цель это игрок!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
			
			dictionary stuff = bDirty ? AF2LegacyCode::reverseGetKeyvalue(pEntity) : AF2LegacyCode::prunezero(AF2LegacyCode::reverseGetKeyvalue(pEntity));
			array<string> dkeys = stuff.getKeys();
			af2entity.Tell("Значения объекта:", AFArgs.User, HUD_PRINTCONSOLE);
			for(uint i = 0; i < dkeys.length(); i++)
			{
				string sout = string(stuff[dkeys[i]]);
				af2entity.Tell("\""+dkeys[i]+"\" -> \""+sout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}else{
			int iC = 0;
			CBaseEntity@ pEntity = null;
			while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, sTarget)) !is null)
			{
				dictionary stuff = AF2LegacyCode::reverseGetKeyvalue(pEntity);
				array<string> dkeys = stuff.getKeys();
				af2entity.Tell("========\nЗначения объектов:\n========", AFArgs.User, HUD_PRINTCONSOLE);
				for(uint i = 0; i < dkeys.length(); i++)
				{
					string sout = string(stuff[dkeys[i]]);
					af2entity.Tell("\""+dkeys[i]+"\" -> \""+sout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
				}
				af2entity.Tell("========", AFArgs.User, HUD_PRINTCONSOLE);
				
				iC++;
			}
			
			if(iC == 0)
				af2entity.Tell("Такого объекта с именем не существует!", AFArgs.User, HUD_PRINTCONSOLE);
		}
	}
	
	dictionary g_entMoving;
	CScheduledFunction@ g_entThink = null;
	dictionary g_entWeapon;
	
	HookReturnCode PlayerSpawn(CBasePlayer@ pPlayer)
	{
		if(g_entWeapon.exists(pPlayer.entindex()))
			weaponmover(pPlayer, false, true);
		
		return HOOK_CONTINUE;
	}
	
	HookReturnCode PlayerKilled(CBasePlayer@ pPlayer, CBaseEntity@ pThing, int iNum)
	{
		if(g_entWeapon.exists(pPlayer.entindex()))
			weaponmover(pPlayer, false, false);
	
		return HOOK_CONTINUE;
	}
	
	HookReturnCode PlayerPreThink(CBasePlayer@ pPlayer, uint &out magicnumbers)
	{
		if(af2entity.Running)
		{
			if(g_entWeapon.exists(pPlayer.entindex()))
			{
				bool bUsing = g_entMoving.exists(pPlayer.entindex()) ? true : false;
				EntMoverData@ emd = cast<EntMoverData@>(g_entWeapon[pPlayer.entindex()]);
				
				if(pPlayer.pev.button & IN_ATTACK > 0)
				{
					//pPlayer.pev.button &= ~IN_ATTACK;
					
					if(!bUsing && !emd.bHolding)
					{
						emd.bHolding = true;
						emd.vColor = Vector(Math.RandomLong(0, 255),Math.RandomLong(0, 255),Math.RandomLong(0, 255));
						g_entWeapon[pPlayer.entindex()] = emd;
						g_EngineFuncs.MakeVectors(pPlayer.pev.v_angle);
						Vector vecStart = pPlayer.GetGunPosition();
						TraceResult tr;
						g_Utility.TraceLine(vecStart, vecStart+g_Engine.v_forward*4096, dont_ignore_monsters, pPlayer.edict(), tr);
						CBaseEntity@ pEntity = g_EntityFuncs.Instance(tr.pHit);
						if(pEntity is null || pEntity.pev.classname == "worldspawn")
						{
							af2entity.Tell("Нет объекта впереди (4096 юнитов)!", pPlayer, HUD_PRINTTALK);
							return HOOK_CONTINUE;
						}
						
						CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
						if(pCustom.GetKeyvalue("$i_afbentgrab").GetInteger() == 1)
						{
							af2entity.Tell("Нельзя схватить: объект уже схвачен!", pPlayer, HUD_PRINTTALK);
							return HOOK_CONTINUE;
						}
						g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_WEAPON, "tfc/items/inv3.wav", 1.0f, 1.0f, SND_FORCE_LOOP, PITCH_NORM);
						
						pushEntRenderSettings(pEntity);
						pCustom.SetKeyvalue("$i_afbentgrab", 1);
						//pEntity.pev.rendermode = 1;
						//pEntity.pev.renderfx = 0;
						//pEntity.pev.rendercolor = Vector(0, 255, 0);
						//pEntity.pev.renderamt = 88;
						Vector vecOffset = tr.vecEndPos;
						float fDist = (vecOffset - vecStart).Length();
						pCustom.SetKeyvalue("$v_afbentofs", vecOffset);
						writeEntOfs2(pEntity, pCustom);
						g_entMoving[pPlayer.entindex()] = Vector(pEntity.entindex(), fDist, 0);
						if(pEntity.IsPlayer())
						{
							if(pEntity.pev.movetype != MOVETYPE_NOCLIP)
								pEntity.pev.movetype = MOVETYPE_NOCLIP;
								
							if(pEntity.pev.flags & FL_FROZEN == 0)
								pEntity.pev.flags |= FL_FROZEN;
						}
					}
				}else{
					if(bUsing && emd.bHolding)
					{
						emd.bHolding = false;
						g_entWeapon[pPlayer.entindex()] = emd;
						g_SoundSystem.StopSound(pPlayer.edict(), CHAN_WEAPON, "tfc/items/inv3.wav", false);
						Vector grabIndex = Vector(g_entMoving[pPlayer.entindex()]);
						CBaseEntity@ pEntity = g_EntityFuncs.Instance(int(grabIndex.x));
						if(pEntity !is null)
						{
							popEntRenderSettings(pEntity);
							CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
							pCustom.SetKeyvalue("$i_afbentgrab", 0);
							if(pEntity.IsPlayer())
							{
								if(pEntity.pev.movetype != MOVETYPE_WALK)
									pEntity.pev.movetype = MOVETYPE_WALK;
								
								if(pEntity.pev.flags & FL_FROZEN > 0)
									pEntity.pev.flags &= ~FL_FROZEN;
								
								dictionary dData;
								EHandle ePlayer = cast<CBasePlayer@>(pEntity);
								dData["player"] = ePlayer;
								af2entity.SendMessage("AF2P", "RecheckPlayer", dData);
							}
						}
						
						g_entMoving.delete(pPlayer.entindex());
					}else if(!bUsing && emd.bHolding)
					{
						emd.bHolding = false;
						g_entWeapon[pPlayer.entindex()] = emd;
					}
				}
				
				if(pPlayer.pev.button & IN_ATTACK2 > 0)
				{
					//pPlayer.pev.button &= ~IN_ATTACK2;
					
					if(!emd.bHolding2)
					{
						emd.bHolding2 = true;
						g_entWeapon[pPlayer.entindex()] = emd;
						
						g_EngineFuncs.MakeVectors(pPlayer.pev.v_angle);
						Vector vecStart = pPlayer.GetGunPosition();
						TraceResult tr;
						g_Utility.TraceLine(vecStart, vecStart+g_Engine.v_forward*4096, dont_ignore_monsters, pPlayer.edict(), tr);
						CBaseEntity@ pEntity = g_EntityFuncs.Instance(tr.pHit);
						if(pEntity is null || pEntity.pev.classname == "worldspawn")
						{
							af2entity.Tell("Нет объекта впереди (4096 юнитов)!", pPlayer, HUD_PRINTTALK);
							return HOOK_CONTINUE;
						}
						
						if(pEntity.IsPlayer())
						{
							af2entity.Tell("Нельзя удалить: цель это игрок!", pPlayer, HUD_PRINTTALK);
							return HOOK_CONTINUE;
						}
						
						NetworkMessage msg(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
							msg.WriteByte(TE_BEAMPOINTS);
							msg.WriteCoord(vecStart.x);
							msg.WriteCoord(vecStart.y);
							msg.WriteCoord(vecStart.z-8);
							msg.WriteCoord(tr.vecEndPos.x);
							msg.WriteCoord(tr.vecEndPos.y);
							msg.WriteCoord(tr.vecEndPos.z);
							msg.WriteShort(g_EngineFuncs.ModelIndex("sprites/zbeam4.spr"));
							msg.WriteByte(0);
							msg.WriteByte(0);
							msg.WriteByte(4);
							msg.WriteByte(8);
							msg.WriteByte(32);
							msg.WriteByte(255);
							msg.WriteByte(0);
							msg.WriteByte(0);
							msg.WriteByte(255);
							msg.WriteByte(0);
						msg.End();
						
						NetworkMessage msg2(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
							msg2.WriteByte(TE_EXPLOSION);
							msg2.WriteCoord(tr.vecEndPos.x);
							msg2.WriteCoord(tr.vecEndPos.y);
							msg2.WriteCoord(tr.vecEndPos.z);
							msg2.WriteShort(g_EngineFuncs.ModelIndex("sprites/zerogxplode.spr"));
							msg2.WriteByte(10);
							msg2.WriteByte(15);
							msg2.WriteByte(0);
						msg2.End();
						
						g_EntityFuncs.Remove(pEntity);
					}
				}else{
					if(emd.bHolding2)
					{
						emd.bHolding2 = false;
						g_entWeapon[pPlayer.entindex()] = emd;
					}
				}
				
				if(pPlayer.pev.button & IN_ALT1 > 0)
				{
					pPlayer.pev.button &= ~IN_ALT1;
				}
				
				if(pPlayer.pev.button & IN_RELOAD > 0)
				{
					pPlayer.pev.button &= ~IN_RELOAD;
				}
			}
		}
		
		return HOOK_CONTINUE;
	}
	
	class EntMoverData
	{
		bool bHolding = false;
		bool bHolding2 = false;
		Vector vColor = Vector(0,0,0);
		string prevWeapon = "";
	}
	
	void weaponmover(CBasePlayer@ pPlayer, bool bMode, bool bReset)
	{
		if(bMode)
		{
			EntMoverData emd;
			
			CBasePlayerWeapon@ activeItem = cast<CBasePlayerWeapon@>(pPlayer.m_hActiveItem.GetEntity());
			if(activeItem !is null)
			{
				emd.prevWeapon = activeItem.pev.classname;
			}
			
			pPlayer.GiveNamedItem("weapon_entmover", 0, 9999);
			pPlayer.SelectItem("weapon_entmover");
			
			g_entWeapon[pPlayer.entindex()] = emd;
			
		}else{
			EntMoverData@ emd = cast<EntMoverData@>(g_entWeapon[pPlayer.entindex()]);
			
			if(!bReset)
			{
				//special case behavior here so it can remove the entmover
				CBasePlayerItem@ pItem;
				CBasePlayerItem@ pItemHold;
				CBasePlayerWeapon@ pWeapon;
				for(uint j = 0; j < MAX_ITEM_TYPES; j++)
				{
					@pItem = pPlayer.m_rgpPlayerItems(j);
					while(pItem !is null)
					{
						@pWeapon = pItem.GetWeaponPtr();
						
						if(pWeapon.GetClassname() == "weapon_entmover")
						{
							@pItemHold = pItem;
							@pItem = cast<CBasePlayerItem@>(pItem.m_hNextItem.GetEntity());
							pPlayer.RemovePlayerItem(pItemHold);
							break;
						}
						
						@pItem = cast<CBasePlayerItem@>(pItem.m_hNextItem.GetEntity());
					}
				}
				
				pPlayer.SelectItem(emd.prevWeapon);
			}
			pPlayer.SetItemPickupTimes(0);
			g_entWeapon.delete(pPlayer.entindex());
		}
	}
	
	void entmover(AFBaseArguments@ AFArgs)
	{
		int iMode = AFArgs.GetCount() >= 1 ? AFArgs.GetInt(0) : -1;
		bool bIsOn = g_entWeapon.exists(AFArgs.User.entindex());
		if(iMode == -1)
		{
			if(bIsOn)
			{
				weaponmover(AFArgs.User, false, false);
			}else{
				weaponmover(AFArgs.User, true, false);
			}
			
			af2entity.Tell("Переключен ентмувер", AFArgs.User, HUD_PRINTCONSOLE);
		}else if(iMode == 1)
		{
			if(!bIsOn)
			{
				weaponmover(AFArgs.User, true, false);
				af2entity.Tell("Выдан ентмувер", AFArgs.User, HUD_PRINTCONSOLE);
			}else{
				af2entity.Tell("Нелья выдать ентмувер: ентмувер уже в руках", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}else{
			if(bIsOn)
			{
				weaponmover(AFArgs.User, false, false);
				af2entity.Tell("Убран ентмувер", AFArgs.User, HUD_PRINTCONSOLE);
			}else{
				af2entity.Tell("Убрать ентмувер: ентмувер не в руках", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}
	}
	
	void worldcopy(AFBaseArguments@ AFArgs)
	{
		CBaseEntity@ pWorld = g_EntityFuncs.Create("func_rotating", Vector(0,0,0), AFArgs.GetVector(1), true);
		if(pWorld is null)
		{
			af2entity.Tell("Ошибка создать копию карты!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		g_EntityFuncs.DispatchKeyValue(pWorld.edict(), "model", "maps/"+g_Engine.mapname+".bsp");
		g_EntityFuncs.DispatchKeyValue(pWorld.edict(), "speed", AFArgs.GetFloat(0));
		//1 on 64 nosolid 2 reverse 4 xaxis 8 yaxis
		int iFlags = 65; // on nosolid
		if(AFArgs.GetBool(2))
			iFlags += 2; // reverse
			
		if(AFArgs.GetBool(3))
			iFlags += 4; // xaxis
			
		if(AFArgs.GetBool(4))
			iFlags += 8; // yaxis
			
		g_EntityFuncs.DispatchKeyValue(pWorld.edict(), "spawnflags", iFlags);
		g_EntityFuncs.DispatchKeyValue(pWorld.edict(), "effects", 2048);
		g_EntityFuncs.DispatchKeyValue(pWorld.edict(), "targetname", "afb_worldcopy");
		g_EntityFuncs.DispatchSpawn(pWorld.edict());
		af2entity.Tell("Создана копия карты!", AFArgs.User, HUD_PRINTCONSOLE);
	}
	
	void worldremove(AFBaseArguments@ AFArgs)
	{
		CBaseEntity@ pEntity = null;
		int iC = 0;
		while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, "afb_worldcopy")) !is null)
		{
			g_EntityFuncs.Remove(pEntity);
			iC++;
		}
		
		if(iC > 0)
			af2entity.Tell(string(iC)+" копии мира удалены", AFArgs.User, HUD_PRINTCONSOLE);
		else
			af2entity.Tell("Никаких копий мира не существует!", AFArgs.User, HUD_PRINTCONSOLE);
	}
	
	void item(AFBaseArguments@ AFArgs)
	{
		string sEnt = AFArgs.GetString(0);
		
		if(sEnt == "weapon_entmover")
		{
				af2entity.Tell("Нельзя заспавнить ентмувер!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
		}
		
		if(sEnt.SubString(0, 7) != "weapon_" && sEnt.SubString(0, 5) != "item_" && sEnt.SubString(0, 5) != "ammo_")
		{
			af2entity.Tell("Нельзя спавнить \""+AFArgs.GetString(0)+"\": не разрешено!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
	
		CBaseEntity@ pEntity = g_EntityFuncs.Create(AFArgs.GetString(0), AFArgs.User.pev.origin, Vector(0, AFArgs.User.pev.angles.y, 0), true);
		if(pEntity !is null)
		{
			g_EntityFuncs.DispatchSpawn(pEntity.edict());
			af2entity.Tell("Заспавнили \""+AFArgs.GetString(0)+"\"!", AFArgs.User, HUD_PRINTCONSOLE);
		}else
			af2entity.Tell("Ошибка спавна \""+AFArgs.GetString(0)+"\"!", AFArgs.User, HUD_PRINTCONSOLE);
	}
	
	void drop(AFBaseArguments@ AFArgs)
	{
		CBaseEntity@ pEntity = g_Utility.FindEntityForward(AFArgs.User, 4096);
		if(pEntity is null)
		{
			af2entity.Tell("Нет объекта впереди (4096 юнитов)!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		if(pEntity.IsPlayer())
		{
			af2entity.Tell("Нельзя положить: цель это игрок!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		g_EngineFuncs.DropToFloor(pEntity.edict());
		af2entity.Tell("Положили объект!", AFArgs.User, HUD_PRINTCONSOLE);
	}

	void movecopy(AFBaseArguments@ AFArgs)
	{
		int iMode = AFArgs.GetCount() >= 1 ? AFArgs.GetBool(0) ? 2 : 0 : -1;
		if(iMode == -1)
		{
			af2entity.Tell("Алиасы: (напишите их, рекомендованно сохранить их в autoexec.cfg)", AFArgs.User, HUD_PRINTCONSOLE);
			af2entity.Tell("    alias +copy \".ent_movecopy 1\"", AFArgs.User, HUD_PRINTCONSOLE);
			af2entity.Tell("    alias -copy \".ent_movecopy 0\"", AFArgs.User, HUD_PRINTCONSOLE);
			af2entity.Tell("    bind (кнопка) +copy", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		entActualMove(AFArgs, iMode);
	}

	void move(AFBaseArguments@ AFArgs)
	{
		int iMode = AFArgs.GetCount() >= 1 ? AFArgs.GetBool(0) ? 1 : 0 : -1;
		if(iMode == -1)
		{
			af2entity.Tell("Алиасы: (напишите их, рекомендованно сохранить их в autoexec.cfg)", AFArgs.User, HUD_PRINTCONSOLE);
			af2entity.Tell("    alias +grab \".ent_move 1\"", AFArgs.User, HUD_PRINTCONSOLE);
			af2entity.Tell("    alias -grab \".ent_move 0\"", AFArgs.User, HUD_PRINTCONSOLE);
			af2entity.Tell("    bind (кнопка) +grab", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		entActualMove(AFArgs, iMode);
	}
	
	int round(float f)
	{
		return int(floor(f+0.5f));
	}
	
	void entThink()
	{
		CBasePlayer@ pSearch = null;
		for(int i = 1; i <= g_Engine.maxClients; i++)
		{
			@pSearch = g_PlayerFuncs.FindPlayerByIndex(i);
			if(pSearch !is null)
			{
				if(g_entMoving.exists(pSearch.entindex()))
				{
					Vector grabIndex = Vector(g_entMoving[pSearch.entindex()]);
					CBaseEntity@ pEntity = g_EntityFuncs.Instance(int(grabIndex.x));
					if(pEntity !is null)
					{
						CustomKeyvalues@ pUser = pSearch.GetCustomKeyvalues();
						float grid = 0.0f;
						if(pUser.GetKeyvalue("$f_afbgrid").Exists())
							grid = pUser.GetKeyvalue("$f_afbgrid").GetFloat();
						
						Vector extent = (pEntity.pev.maxs-pEntity.pev.mins)/2.0f;
						Vector center = pEntity.IsBSPModel() ? getBrushOrigin(pEntity, true) : pEntity.IsPlayer() ? pEntity.pev.origin :  pEntity.IsMonster() ? pEntity.pev.origin+Vector(0,0,extent.z) : pEntity.pev.origin;
						
						CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
						Vector vecOffset = pCustom.GetKeyvalue("$v_afbentofs").GetVector();	
						Vector vecOrigin = pCustom.GetKeyvalue("$v_afbentrealorig").Exists() ? pCustom.GetKeyvalue("$v_afbentrealorig").GetVector() : pEntity.pev.origin;
						
						//faster magnitude calculation by stradegically "forgetting" to do sqrt
						Vector vecDiff = vecOrigin-pEntity.pev.origin;
						float fDist = vecDiff.x*vecDiff.x + vecDiff.y*vecDiff.y + vecDiff.z*vecDiff.z;
						if(grid <= 0.0f)
						{
							if(fDist>12.0f) // 6 units
								vecOrigin = pEntity.pev.origin;
						}else{
							if(fDist>(grid*grid)+12.0f) // 6 units + grid
								vecOrigin = pEntity.pev.origin;
						}
						
						g_EngineFuncs.MakeVectors(pSearch.pev.v_angle);
						Vector vecSrc = pSearch.GetGunPosition();
						Vector vecNewEnd = vecSrc+(g_Engine.v_forward*grabIndex.y);
						Vector vecUpdated = vecOrigin + (vecNewEnd-vecOffset);
						pCustom.SetKeyvalue("$v_afbentrealorig", vecUpdated);
						if(grid > 0.0f)
						{
							for(int j = 0; j < 3; j++)
								vecUpdated[j] = round((vecUpdated[j])/grid)*grid;
								//vecUpdated[j] = vecUpdated[j] - (vecUpdated[j]%grid);
								//vecUpdated[j] = ((vecUpdated[j]+halfGrid)/grid)*grid;
						
							if(_gridTimer >= _gridThresh)
							{
								_gridTimer = 0.0f;
								int grids = 4;
								int gridh = grids/2;
								
								int gridvisual = int(grids*grid);
									
								int gridt = (_gridAmt/2)-1;
								//horizontal
								Vector horizgrid = Vector(0,0,1);
								Vector verticalxgrid = Vector(1,0,0);
								
								if(grid >= 16)
								{								
									if(abs(DotProduct(g_Engine.v_forward, horizgrid)) > 0.5f)
									{
										for(int j = -gridh; j <= gridh; j++)
										{
											Vector startp = center;
											startp.x = startp.x + (j*grid);
											startp.y = startp.y + gridvisual;
											Vector endp = center;
											endp.x = endp.x + (j*grid);
											endp.y = endp.y - gridvisual;
											makeLine2(startp, endp, 255,0,0,gridt);
											
											Vector startp2 = center;
											startp2.y = startp2.y + (j*grid);
											startp2.x = startp2.x + gridvisual;
											Vector endp2 = center;
											endp2.y = endp2.y + (j*grid);
											endp2.x = endp2.x - gridvisual;
											makeLine2(startp2, endp2, 255,0,0,gridt);
										}
									}else{
										if(abs(DotProduct(g_Engine.v_forward, verticalxgrid)) > 0.5f)
										{
											for(int j = -gridh; j <= gridh; j++)
											{
												Vector startp = center;
												startp.z = startp.z + (j*grid);
												startp.y = startp.y + gridvisual;
												Vector endp = center;
												endp.z = endp.z + (j*grid);
												endp.y = endp.y - gridvisual;
												makeLine2(startp, endp, 255,0,0,gridt);
												
												Vector startp2 = center;
												startp2.y = startp2.y + (j*grid);
												startp2.z = startp2.z + gridvisual;
												Vector endp2 = center;
												endp2.y = endp2.y + (j*grid);
												endp2.z = endp2.z - gridvisual;
												makeLine2(startp2, endp2, 255,0,0,gridt);
											}
										}else{
											for(int j = -gridh; j <= gridh; j++)
											{
												Vector startp = center;
												startp.z = startp.z + (j*grid);
												startp.x = startp.x + gridvisual;
												Vector endp = center;
												endp.z = endp.z + (j*grid);
												endp.x = endp.x - gridvisual;
												makeLine2(startp, endp, 255,0,0,gridt);
												
												Vector startp2 = center;
												startp2.x = startp2.x + (j*grid);
												startp2.z = startp2.z + gridvisual;
												Vector endp2 = center;
												endp2.x = endp2.x + (j*grid);
												endp2.z = endp2.z - gridvisual;
												makeLine2(startp2, endp2, 255,0,0,gridt);
											}
										}
									}
								}
							}else{
								_gridTimer += _entThink;
							}
						}
						
						pEntity.pev.oldorigin = vecUpdated;
						pEntity.SetOrigin(vecUpdated);
						
						;
						pCustom.SetKeyvalue("$v_afbentofs", vecNewEnd);
						writeEntOfs2(pEntity, pCustom);
						
						if(pEntity.IsPlayer() || !pEntity.IsBSPModel())
							pEntity.pev.velocity = Vector(0,0,0);
							
						if(g_entWeapon.exists(pSearch.entindex()))
						{
							EntMoverData@ emd = cast<EntMoverData@>(g_entWeapon[pSearch.entindex()]);
							if(emd.bHolding)
							{
								makeBox(center, extent, pEntity.pev.angles, pEntity.IsBSPModel(), int(emd.vColor.x), int(emd.vColor.y), int(emd.vColor.z), 1);
							
								NetworkMessage msg(MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY, null);
									msg.WriteByte(TE_BEAMPOINTS);
									msg.WriteCoord(vecSrc.x);
									msg.WriteCoord(vecSrc.y);
									msg.WriteCoord(vecSrc.z-8);
									msg.WriteCoord(vecNewEnd.x);
									msg.WriteCoord(vecNewEnd.y);
									msg.WriteCoord(vecNewEnd.z);
									msg.WriteShort(g_EngineFuncs.ModelIndex("sprites/zbeam4.spr"));
									msg.WriteByte(0);
									msg.WriteByte(0);
									msg.WriteByte(1);
									msg.WriteByte(32);
									msg.WriteByte(0);
									//rgb->rbg because of zbeam4.spr
									msg.WriteByte(int(emd.vColor.x));
									msg.WriteByte(int(emd.vColor.z));
									msg.WriteByte(int(emd.vColor.y));
									msg.WriteByte(200);
									msg.WriteByte(0);
								msg.End();
							}else{ //edge case: mover in hand but using +grab
								Vector vecColor = pEntity.IsBSPModel() ? pEntity.pev.rendercolor : Vector(0,64,128);
								//invert R for clarity
								makeBox(center, extent, pEntity.pev.angles, pEntity.IsBSPModel(), 255-int(vecColor.x), int(vecColor.z), int(vecColor.y), 1);
							}
						}else{
							Vector vecColor = pEntity.IsBSPModel() ? pEntity.pev.rendercolor : Vector(0,64,128);
							makeBox(center, extent, pEntity.pev.angles, pEntity.IsBSPModel(), 255-int(vecColor.x), int(vecColor.z), int(vecColor.y), 1);
						}
					}
				}
			}
		}
	}

	void pushEntRenderSettings(CBaseEntity@ pEntity)
	{
		CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
		pCustom.SetKeyvalue("$i_afborendermode", pEntity.pev.rendermode);
		pCustom.SetKeyvalue("$i_afborenderfx", pEntity.pev.renderfx);
		pCustom.SetKeyvalue("$f_afborenderamt", pEntity.pev.renderamt);
		pCustom.SetKeyvalue("$v_afborendercolor", pEntity.pev.rendercolor);
	}
	
	void popEntRenderSettings(CBaseEntity@ pEntity)
	{
		CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
		if(!pCustom.GetKeyvalue("$i_afborendermode").Exists())
			return;
			
		pEntity.pev.rendermode = pCustom.GetKeyvalue("$i_afborendermode").GetInteger();
		pEntity.pev.renderfx = pCustom.GetKeyvalue("$i_afborenderfx").GetInteger();
		pEntity.pev.renderamt = pCustom.GetKeyvalue("$f_afborenderamt").GetFloat();
		pEntity.pev.rendercolor = pCustom.GetKeyvalue("$v_afborendercolor").GetVector();
	}
	
	CBaseEntity@ entCopy(CBaseEntity@ pEntity, CBasePlayer@ pUser)
	{
		if(g_EngineFuncs.NumberOfEntities() >= g_Engine.maxEntities-15*g_Engine.maxClients-100)
		{
			af2entity.Tell("Копирование невозможно: достигнуто максимум лимит объектов!", pUser, HUD_PRINTTALK);
			return null;
		}
		
		string sClass = pEntity.pev.classname;
		dictionary dKeyvalues = AF2LegacyCode::prunezero(AF2LegacyCode::cleancopy(AF2LegacyCode::reverseGetKeyvalue(pEntity)));
		
		CBaseEntity@ pCopiedEntity = g_EntityFuncs.CreateEntity(sClass, dKeyvalues, false);
		if(pCopiedEntity is null || !g_EntityFuncs.IsValidEntity(pCopiedEntity.edict()))
			return null;
			
		g_EntityFuncs.DispatchSpawn(pCopiedEntity.edict());
		pCopiedEntity.SetOrigin(pEntity.pev.origin);
		pCopiedEntity.pev.oldorigin = pEntity.pev.origin;
		pCopiedEntity.pev.angles = pEntity.pev.angles;
		pCopiedEntity.pev.v_angle = pEntity.pev.angles;
		return pCopiedEntity;
	}
	
	void entActualMove(AFBaseArguments@ AFArgs, int iMode)
	{
		bool bUsing = g_entMoving.exists(AFArgs.User.entindex()) ? true : false;
		bool bUsing2 = false;
		if(g_entWeapon.exists(AFArgs.User.entindex()))
		{
			EntMoverData@ emd = cast<EntMoverData@>(g_entWeapon[AFArgs.User.entindex()]);
			bUsing2 = emd.bHolding;
		}
		
		if(iMode == 0 && bUsing && !bUsing2)
		{
			Vector grabIndex = Vector(g_entMoving[AFArgs.User.entindex()]);
			CBaseEntity@ pEntity = g_EntityFuncs.Instance(int(grabIndex.x));
			if(pEntity !is null)
			{
				popEntRenderSettings(pEntity);
				CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
				pCustom.SetKeyvalue("$i_afbentgrab", 0);
				if(pEntity.IsPlayer())
				{
					if(pEntity.pev.movetype != MOVETYPE_WALK)
						pEntity.pev.movetype = MOVETYPE_WALK;
					
					if(pEntity.pev.flags & FL_FROZEN > 0)
						pEntity.pev.flags &= ~FL_FROZEN;
					
					dictionary dData;
					EHandle ePlayer = cast<CBasePlayer@>(pEntity);
					dData["player"] = ePlayer;
					af2entity.SendMessage("AF2P", "RecheckPlayer", dData);
				}
			}
			
			g_entMoving.delete(AFArgs.User.entindex());
		}else if(iMode == 1 && !bUsing && !bUsing2)
		{
			g_EngineFuncs.MakeVectors(AFArgs.User.pev.v_angle);
			Vector vecStart = AFArgs.User.GetGunPosition();
			TraceResult tr;
			g_Utility.TraceLine(vecStart, vecStart+g_Engine.v_forward*4096, dont_ignore_monsters, AFArgs.User.edict(), tr);
			CBaseEntity@ pEntity = g_EntityFuncs.Instance(tr.pHit);
			if(pEntity is null || pEntity.pev.classname == "worldspawn")
			{
				af2entity.Tell("Нет объекта впереди (4096 юнитов)!", AFArgs.User, HUD_PRINTTALK);
				return;
			}
			
			CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
			if(pCustom.GetKeyvalue("$i_afbentgrab").GetInteger() == 1)
			{
				af2entity.Tell("Нельзя схватить: объект уже схвачен!", AFArgs.User, HUD_PRINTTALK);
				return;
			}
			
			pushEntRenderSettings(pEntity);
			pCustom.SetKeyvalue("$i_afbentgrab", 1);
			pEntity.pev.rendermode = 1;
			pEntity.pev.renderfx = 0;
			pEntity.pev.rendercolor = Vector(0, 255, 0);
			pEntity.pev.renderamt = 88;
			Vector vecOffset = tr.vecEndPos;
			float fDist = (vecOffset - vecStart).Length();
			pCustom.SetKeyvalue("$v_afbentofs", vecOffset);
			writeEntOfs2(pEntity, pCustom);
			g_entMoving[AFArgs.User.entindex()] = Vector(pEntity.entindex(), fDist, 0);
			if(pEntity.IsPlayer())
			{
				if(pEntity.pev.movetype != MOVETYPE_NOCLIP)
					pEntity.pev.movetype = MOVETYPE_NOCLIP;
					
				if(pEntity.pev.flags & FL_FROZEN == 0)
					pEntity.pev.flags |= FL_FROZEN;
			}
		}else if(iMode == 2 && !bUsing && !bUsing2)
		{
			g_EngineFuncs.MakeVectors(AFArgs.User.pev.v_angle);
			Vector vecStart = AFArgs.User.GetGunPosition();
			TraceResult tr;
			g_Utility.TraceLine(vecStart, vecStart+g_Engine.v_forward*4096, dont_ignore_monsters, AFArgs.User.edict(), tr);
			CBaseEntity@ pEntity = g_EntityFuncs.Instance(tr.pHit);
			if(pEntity is null || pEntity.pev.classname == "worldspawn")
			{
				af2entity.Tell("Нет объекта впереди (4096 юнитов)!", AFArgs.User, HUD_PRINTTALK);
				return;
			}
			
			CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
			if(pCustom.GetKeyvalue("$i_afbentgrab").GetInteger() == 1)
			{
				af2entity.Tell("Нельзя копировать: объект уже схвачен!", AFArgs.User, HUD_PRINTTALK);
				return;
			}
			
			if(pEntity.IsPlayer())
			{
				af2entity.Tell("Нельзя копировать: цель это игрок!", AFArgs.User, HUD_PRINTTALK);
				return;
			}
			
			CBaseEntity@ pCopyEntity = entCopy(pEntity, AFArgs.User);
			if(pCopyEntity is null)
			{
				af2entity.Tell("Нельзя копировать: результат копирования пустой!", AFArgs.User, HUD_PRINTTALK);
				return;
			}
			
			CustomKeyvalues@ pCustomCopy = pCopyEntity.GetCustomKeyvalues();
			pushEntRenderSettings(pCopyEntity);
			pCustomCopy.SetKeyvalue("$i_afbentgrab", 1);
			pCopyEntity.pev.rendermode = 1;
			pCopyEntity.pev.renderfx = 0;
			pCopyEntity.pev.rendercolor = Vector(255, 0, 255);
			pCopyEntity.pev.renderamt = 88;
			Vector vecOffset = tr.vecEndPos;
			float fDist = (vecOffset - vecStart).Length();
			pCustomCopy.SetKeyvalue("$v_afbentofs", vecOffset);
			writeEntOfs2(pCopyEntity, pCustomCopy);
			g_entMoving[AFArgs.User.entindex()] = Vector(pCopyEntity.entindex(), fDist, 0);
		}
		
		entThink();
	}

	void moveabsolute(AFBaseArguments@ AFArgs)
	{
		CBaseEntity@ pEntity = null;
		int iC = 0;
		while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, AFArgs.GetString(0))) !is null)
		{
			CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
			pEntity.SetOrigin(AFArgs.User.pev.origin);
			writeEntOfs2(pEntity, pCustom);
			iC++;
		}
		
		if(iC > 0)
			af2entity.Tell(string(iC)+" entities moved", AFArgs.User, HUD_PRINTCONSOLE);
		else
			af2entity.Tell("Такого объекта с именем не существует!", AFArgs.User, HUD_PRINTCONSOLE);
	}

	void create(AFBaseArguments@ AFArgs)
	{
		if(AFArgs.GetString(0) == "weapon_entmover")
		{
				af2entity.Tell("Нельзя создать ентмувер!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
		}
	
		string sKeyvalues = AFArgs.GetCount() >= 2 ? AFArgs.GetString(1) : "";
		dictionary dKeyvalues;
		bool bOriginDefined = false;
		Vector vecOrigin = AFArgs.User.pev.origin;
		if(sKeyvalues != "")
		{
			array<string> asParse = sKeyvalues.Split(":");
			for(uint i = 0; i < asParse.length(); i=i+2)
			{
				if(i+1 >= asParse.length())
					break;
					
				if(asParse[i] == "origin")
				{
					bOriginDefined = true;
					if(asParse[i+1] == "aim")
					{
						bOriginDefined = false;
						TraceResult tr;
						g_EngineFuncs.MakeVectors(AFArgs.User.pev.v_angle);
						Vector vecStart = AFArgs.User.pev.origin+AFArgs.User.pev.view_ofs;
						g_Utility.TraceLine(vecStart, vecStart+g_Engine.v_forward*4096, dont_ignore_monsters, AFArgs.User.edict(), tr);
						vecOrigin = tr.vecEndPos;
					}
				}
				
				if(asParse[i] == "angles")
				{
					if(asParse[i+1] == "self")
					{
						dKeyvalues[asParse[i]] = string(AFArgs.User.pev.angles.x)+" "+string(AFArgs.User.pev.angles.y)+" "+string(AFArgs.User.pev.angles.z);
					}else if(asParse[i+1] == "self180")
					{
						dKeyvalues[asParse[i]] = string(AFArgs.User.pev.angles.x)+" "+string(AFArgs.User.pev.angles.y+180)+" "+string(AFArgs.User.pev.angles.z);
					}else{
						dKeyvalues[asParse[i]] = string(asParse[i+1]);
					}
				}else{
					dKeyvalues[asParse[i]] = string(asParse[i+1]);
				}
			}
		}
		
		if(AFArgs.GetString(0) == "trigger_setcvar")
		{
			if(!AFBase::CheckAccess(AFArgs.User, ACCESS_C))
			{
				af2entity.Tell("Заблокировано: вам требуеться имметь доступ С чтобы зделать это (\"rcon\" доступ)!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
		}
		
		CBaseEntity@ pEntity = g_EntityFuncs.CreateEntity(AFArgs.GetString(0), dKeyvalues, false);
		if(pEntity is null)
		{
			af2entity.Tell("Нельзя создать: объект был пустой!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		if(!bOriginDefined)
			g_EntityFuncs.DispatchKeyValue(pEntity.edict(), "origin", string(vecOrigin.x)+" "+string(vecOrigin.y)+" "+string(vecOrigin.z));
		
		g_EntityFuncs.DispatchSpawn(pEntity.edict());
		af2entity.Tell("Объект создан!", AFArgs.User, HUD_PRINTCONSOLE);
	}

	void rotatefix(AFBaseArguments@ AFArgs)
	{
		string sTarget = AFArgs.GetCount() >= 1 ? AFArgs.GetString(0) : "";
		if(sTarget == "")
		{
			CBaseEntity@ pEntity = g_Utility.FindEntityForward(AFArgs.User, 4096);
			if(pEntity is null)
			{
				af2entity.Tell("Нет объекта впереди (4096 юнитов)!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
			
			attemptrotatefix(pEntity, AFArgs.User);
		}else{
			int iC = 0;
			CBaseEntity@ pEntity = null;
			while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, sTarget)) !is null)
			{
				if(attemptrotatefix(pEntity, AFArgs.User)) iC++;
			}
			
			if(iC > 0)
				af2entity.Tell(string(iC)+" entities fixed", AFArgs.User, HUD_PRINTCONSOLE);
			else
				af2entity.Tell("Такого объекта с именем не существует!", AFArgs.User, HUD_PRINTCONSOLE);
		}
	}
	
	bool attemptrotatefix(CBaseEntity@ pEntity, CBasePlayer@ user)
	{
		if(pEntity.IsPlayer())
		{
			af2entity.Tell("Нельзя исправить: цель это игрок!", user, HUD_PRINTCONSOLE);
			return false;
		}
	
		if(pEntity.IsBSPModel()){
			CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
			if(pCustom.GetKeyvalue("$i_afbentgrab").GetInteger() == 1)
			{
				af2entity.Tell("Нельзя исправить: объект схвачен!", user, HUD_PRINTCONSOLE);
				return false;
			}
			
			if(!pCustom.GetKeyvalue("$i_afbentisoriginless").Exists()){
				af2entity.Tell("Нельзя исправить: не знаю если у объекта есть источник или нет! (объект должен быть повернут хотябы один раз)", user, HUD_PRINTCONSOLE);
				return false;
			}
			
			if(pCustom.GetKeyvalue("$v_afbentofs3").Exists()){
				Vector afbMove = pCustom.GetKeyvalue("$v_afbentofs3").GetVector();
				pCustom.SetKeyvalue("$v_afbentofs2", Vector(0,0,0));
				pEntity.SetOrigin(afbMove);
				af2entity.Tell("Исправлен! Объект был отправлен на кординаты X:"+string(afbMove.x)+" Y:"+string(afbMove.y)+" Z:"+string(afbMove.z), user, HUD_PRINTCONSOLE);
				return true;
			}
			
			af2entity.Tell("Нельзя исправить: невозможная ошибка!", user, HUD_PRINTCONSOLE);
			return false;
			
		}else{
			af2entity.Tell("Нельзя исправить: объект не браш!", user, HUD_PRINTCONSOLE);
			return false;
		}
	}

	void rotateabsolute(AFBaseArguments@ AFArgs)
	{
		string sTarget = AFArgs.GetCount() >= 4 ? AFArgs.GetString(3) : "";
		Vector vecRotation = Vector(AFArgs.GetFloat(0), AFArgs.GetFloat(1), AFArgs.GetFloat(2));
		if(sTarget == "")
		{
			CBaseEntity@ pEntity = g_Utility.FindEntityForward(AFArgs.User, 4096);
			if(pEntity is null)
			{
				af2entity.Tell("Нет объекта впереди (4096 юнитов)!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
			
			actualRotate(AFArgs.User, pEntity, vecRotation, true);
		}else{
			int iC = 0;
			CBaseEntity@ pEntity = null;
			while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, sTarget)) !is null)
			{
				if(actualRotate(AFArgs.User, pEntity, vecRotation, true)) iC++;
			}
			
			if(iC > 0)
				af2entity.Tell(string(iC)+" объекты повернуты", AFArgs.User, HUD_PRINTCONSOLE);
			else
				af2entity.Tell("Такого объекта с именем не существует!", AFArgs.User, HUD_PRINTCONSOLE);
		}
	}
	
	void rotate(AFBaseArguments@ AFArgs)
	{
		string sTarget = AFArgs.GetCount() >= 4 ? AFArgs.GetString(3) : "";
		Vector vecRotation = Vector(AFArgs.GetFloat(0), AFArgs.GetFloat(1), AFArgs.GetFloat(2));
		if(sTarget == "")
		{
			CBaseEntity@ pEntity = g_Utility.FindEntityForward(AFArgs.User, 4096);
			if(pEntity is null)
			{
				af2entity.Tell("Нет объекта впереди (4096 юнитов)!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
			
			actualRotate(AFArgs.User, pEntity, vecRotation, false);
		}else{
			int iC = 0;
			CBaseEntity@ pEntity = null;
			while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, sTarget)) !is null)
			{
				if(actualRotate(AFArgs.User, pEntity, vecRotation, false)) iC++;
			}
			
			if(iC > 0)
				af2entity.Tell(string(iC)+" объекты повернуты", AFArgs.User, HUD_PRINTCONSOLE);
			else
				af2entity.Tell("Такого объекта с именем не существует!", AFArgs.User, HUD_PRINTCONSOLE);
		}
	}
	
	bool actualRotate(CBasePlayer@ user, CBaseEntity@ pEntity, Vector vecRotation, bool isAbsolute)
	{
		if(pEntity.IsPlayer())
		{
			af2entity.Tell("Нельзя повернуть: цель это игрок!", user, HUD_PRINTCONSOLE);
			return false;
		}
		CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
		if(pEntity.IsBSPModel()){
			if(pCustom.GetKeyvalue("$i_afbentgrab").GetInteger() == 1)
			{
				af2entity.Tell("Нельзя повернуть: объект схвачен!", user, HUD_PRINTTALK);
				return false;
			}
			
			//undo any +grab moves if any.
			if(pCustom.GetKeyvalue("$v_afbentofs2").Exists()){
				Vector afbMove = pCustom.GetKeyvalue("$v_afbentofs2").GetVector();
				if(afbMove.x != 0 || afbMove.y != 0 || afbMove.z != 0){
					pEntity.SetOrigin(Vector(0,0,0));
				}
			}
			
			//check if originless brush
			if(!pCustom.GetKeyvalue("$i_afbentisoriginless").Exists()){
				if(pEntity.pev.origin.x == 0 && pEntity.pev.origin.y == 0 && pEntity.pev.origin.z == 0){
					pCustom.SetKeyvalue("$i_afbentisoriginless", 1);
				}else{
					pCustom.SetKeyvalue("$i_afbentisoriginless", 0);
				}
			}
			
			//undo rotation if any
			if(pEntity.pev.angles.x != 0 || pEntity.pev.angles.y != 0 || pEntity.pev.angles.z != 0){
				pCustom.SetKeyvalue("$v_afbentrotation", pEntity.pev.angles);
				pEntity.pev.angles = Vector(0,0,0);
			}
			
			solveRotation(user, pEntity, vecRotation, isAbsolute, true);
			
			//redo movement
			if(pCustom.GetKeyvalue("$v_afbentofs2").Exists()){
				Vector afbMove = pCustom.GetKeyvalue("$v_afbentofs2").GetVector();
				Vector origin = pEntity.pev.origin;
				pCustom.SetKeyvalue("$v_afbentofs3", origin);
				pEntity.SetOrigin(origin + afbMove);
			}
		}else{
			//undo rotation if any
			if(pEntity.pev.angles.x != 0 || pEntity.pev.angles.y != 0 || pEntity.pev.angles.z != 0){
				pCustom.SetKeyvalue("$v_afbentrotation", pEntity.pev.angles);
				pEntity.pev.angles = Vector(0,0,0);
			}
			solveRotation(user, pEntity, vecRotation, isAbsolute, false);
		}
		
		return true;
	}
	
	void writeEntOfs2(CBaseEntity@ pEntity, CustomKeyvalues@ pCustom)
	{
		Vector offset = Vector(0,0,0);
		if(pCustom.GetKeyvalue("$v_afbentofs3").Exists()){
			offset = pCustom.GetKeyvalue("$v_afbentofs3").GetVector();
		}
	
		pCustom.SetKeyvalue("$v_afbentofs2", pEntity.pev.origin-offset);
	}
	
	
	//thanks to Admer for solving the actual originless rotation out
	void solveRotation(CBasePlayer@ user, CBaseEntity@ pEntity, Vector vecRotation, bool isAbsolute, bool isBrush)
	{
		CustomKeyvalues@ pCustom = pEntity.GetCustomKeyvalues();
		bool bBrushFuckery = false;
		bool unsupported = false;
		Vector vecBrushOrigin = Vector(0,0,0);
		if(isBrush && pCustom.GetKeyvalue("$i_afbentisoriginless").GetInteger() == 1){
			bBrushFuckery = true;
			af2entity.Tell("Пытаемся повернуть браш без источника..", user, HUD_PRINTCONSOLE);
			pEntity.SetOrigin(Vector(0,0,0));
			vecBrushOrigin = getBrushOrigin(pEntity, true);
			if(vecRotation.x != 0 || vecRotation.z != 0){
				unsupported = true;
				pCustom.SetKeyvalue("$i_afbrotunsupported", 1);
				af2entity.Tell("Предупреждение: багнутая операция на без-источникого браша: либо поверните, либо изпользуйте .ent_move", user, HUD_PRINTCONSOLE);
			}
		}
		
		Vector additionalRotation = Vector(0,0,0);
		
		if(pCustom.GetKeyvalue("$v_afbentrotation").Exists())
		{
			additionalRotation = pCustom.GetKeyvalue("$v_afbentrotation").GetVector();
		}
		
		Vector vecOrigin = isBrush ? getBrushOrigin(pEntity, false) : pEntity.pev.origin;
		Vector vecAngles = pEntity.pev.angles;
		Vector vecOldAngles = pEntity.pev.angles+additionalRotation;
		vecAngles = isAbsolute ? vecRotation : vecAngles+vecRotation+additionalRotation;
		
		if(bBrushFuckery && !unsupported){
			if(vecOldAngles.x != 0 || vecOldAngles.z != 0){
				unsupported = true;
				af2entity.Tell("Предупреждение: багнутая операция на без-источникого браша: исправление через одну из углов не получилось, - изпользуйте .ent_move", user, HUD_PRINTCONSOLE);
			}
		}
		
		pCustom.SetKeyvalue("$v_afbentrotation", vecAngles);
		pEntity.pev.angles = vecAngles;
		pEntity.pev.v_angle = vecAngles;
		pEntity.SetOrigin(vecOrigin); // attempt to fix brushes with no originbrush
		
		if(bBrushFuckery){
			Vector newOrigin = getBrushOrigin(pEntity, true);
			float absz = (pEntity.pev.absmin.z+pEntity.pev.absmax.z)*0.5f;
			float z = pEntity.pev.origin.z+(pEntity.pev.mins.z+pEntity.pev.maxs.z)*0.5f;
			//af2entity.Tell("z:"+string(z)+" absz:"+string(absz)+" zd:"+string(absz-z), user, HUD_PRINTCONSOLE);
			float r = vecBrushOrigin.Length();
			Vector anglesFromOrigin;
			vecBrushOrigin.z = unsupported ? 0.000001 : absz-z; // 0.000001 for fixing div by zero issue
			anglesFromOrigin.x = Math.RadiansToDegrees(asin(vecBrushOrigin.z / r));
			anglesFromOrigin.y = Math.RadiansToDegrees(atan2(vecBrushOrigin.y, vecBrushOrigin.x));
			anglesFromOrigin.z = 0;
			//af2entity.Tell("angles from origin x:"+string(anglesFromOrigin.x)+" y:"+string(anglesFromOrigin.y)+" z:"+string(anglesFromOrigin.z), user, HUD_PRINTCONSOLE);
			Vector endup = pEntity.pev.origin + polarcoords(r, vecAngles+anglesFromOrigin);
			//af2entity.Tell("endup x:"+string(endup.x)+" y:"+string(endup.y)+" z:"+string(endup.z), user, HUD_PRINTCONSOLE);
			Vector delta = endup - vecBrushOrigin;
			//af2entity.Tell("delta x:"+string(delta.x)+" y:"+string(delta.y)+" z:"+string(delta.z), user, HUD_PRINTCONSOLE);
			delta = pEntity.pev.origin - delta;
			//af2entity.Tell("pev.origin - delta x:"+string(delta.x)+" y:"+string(delta.y)+" z:"+string(delta.z), user, HUD_PRINTCONSOLE);
			pEntity.SetOrigin(delta);
		}
		
		af2entity.Tell("Повернули объект (старый угол x:"+string(vecOldAngles.x)+" y:"+string(vecOldAngles.y)+" z:"+string(vecOldAngles.z)+") (новый угол x:"+string(vecAngles.x)+" y:"+string(vecAngles.y)+" z:"+string(vecAngles.z)+") (pos x:"+string(pEntity.pev.origin.x)+" y:"+string(pEntity.pev.origin.y)+" z:"+string(pEntity.pev.origin.z)+")!", user, HUD_PRINTCONSOLE);
	}
	
	Vector polarcoords(float r, Vector ang)
	{
		Vector ret;
		ret.x = r * cos(Math.DegreesToRadians(ang.x)) * cos(Math.DegreesToRadians(ang.y));
		ret.y = r * cos(Math.DegreesToRadians(ang.x)) * sin(Math.DegreesToRadians(ang.y));
		ret.z = r * sin(Math.DegreesToRadians(ang.x));
		return ret;
	}
	
	float atan2angle(float x, float y, float a)
	{
		return atan2(x,y)+Math.DegreesToRadians(a);
	}
	
	Vector getBrushOrigin(CBaseEntity@ pEntity, bool bUseAbs)
	{
			Vector vOrigin = bUseAbs ? Vector(0,0,0) : pEntity.pev.origin;
			Vector vMins = bUseAbs ? pEntity.pev.absmin : pEntity.pev.mins;
			Vector vMaxs = bUseAbs ? pEntity.pev.absmax : pEntity.pev.maxs;
			
			for(int i = 0; i < 3; i++)
				vOrigin[i] += (vMins[i]+vMaxs[i])*0.5f;
			
			return vOrigin;
	}

	void triggerrange(AFBaseArguments@ AFArgs)
	{
		if(AFArgs.GetString(0) == "trigger_setcvar")
		{
			if(!AFBase::CheckAccess(AFArgs.User, ACCESS_C))
			{
				af2entity.Tell("Заблокировано: вам требуеться имметь доступ С чтобы зделать это (\"rcon\" доступ)!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
		}
	
		int iC = 0;
		CBaseEntity@ pEntity = null;
		while((@pEntity = g_EntityFuncs.FindEntityInSphere(pEntity, AFArgs.User.pev.origin, AFArgs.GetFloat(1), AFArgs.GetString(0), "classname")) !is null)
		{
			pEntity.Use(AFArgs.User, AFArgs.User, USE_TOGGLE, 0);
			iC++;
		}
		
		if(iC > 0)
			af2entity.Tell(string(iC)+" объектов активировано!", AFArgs.User, HUD_PRINTCONSOLE);
		else
			af2entity.Tell("Нету объекта с такми типом класса!", AFArgs.User, HUD_PRINTCONSOLE);
	}

	void trigger(AFBaseArguments@ AFArgs)
	{
		string sTarget = AFArgs.GetCount() >= 1 ? AFArgs.GetString(0) : "";
		if(sTarget == "")
		{
			CBaseEntity@ pEntity = g_Utility.FindEntityForward(AFArgs.User, 4096);
			if(pEntity is null)
			{
				af2entity.Tell("Нет объекта впереди (4096 юнитов)!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
			
			if(pEntity.IsPlayer())
			{
				af2entity.Tell("Нельзя активировать: цель это игрок!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
			
			pEntity.Use(AFArgs.User, AFArgs.User, USE_TOGGLE, 0);
			af2entity.Tell("Активировали объект!", AFArgs.User, HUD_PRINTCONSOLE);
		}else{
			if(AFArgs.GetString(0) == "trigger_setcvar")
			{
				if(!AFBase::CheckAccess(AFArgs.User, ACCESS_C))
				{
					af2entity.Tell("Заблокировано: вам требуеться имметь доступ С чтобы зделать это (\"rcon\" доступ)!", AFArgs.User, HUD_PRINTCONSOLE);
					return;
				}
			}
		
			int iC = 0;
			CBaseEntity@ pEntity = null;
			while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, sTarget)) !is null)
			{
				pEntity.Use(AFArgs.User, AFArgs.User, USE_TOGGLE, 0);
				iC++;
			}
			
			if(iC > 0)
				af2entity.Tell(string(iC)+" объектов активировано!", AFArgs.User, HUD_PRINTCONSOLE);
			else
				af2entity.Tell("Такого объекта с именем не существует!", AFArgs.User, HUD_PRINTCONSOLE);
		}
	}

	void kill(AFBaseArguments@ AFArgs)
	{
		string sTarget = AFArgs.GetCount() >= 1 ? AFArgs.GetString(0) : "";
		if(sTarget == "")
		{
			CBaseEntity@ pEntity = g_Utility.FindEntityForward(AFArgs.User, 4096);
			if(pEntity is null)
			{
				af2entity.Tell("Нет объекта впереди (4096 юнитов)!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
			
			if(pEntity.IsPlayer())
			{
				af2entity.Tell("Нельзя удалить: цель это игрок!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
			
			g_EntityFuncs.Remove(pEntity);
			af2entity.Tell("Объект удален!", AFArgs.User, HUD_PRINTCONSOLE);
		}else{
			if(AFArgs.GetString(0) == "trigger_setcvar")
			{
				if(!AFBase::CheckAccess(AFArgs.User, ACCESS_C))
				{
					af2entity.Tell("Заблокировано: вам требуеться имметь доступ С чтобы зделать это (\"rcon\" доступ)!", AFArgs.User, HUD_PRINTCONSOLE);
					return;
				}
			}
		
			int iC = 0;
			CBaseEntity@ pEntity = null;
			while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, sTarget)) !is null)
			{
				g_EntityFuncs.Remove(pEntity);
				iC++;
			}
			
			if(iC > 0)
				af2entity.Tell(string(iC)+" удалено объектов", AFArgs.User, HUD_PRINTCONSOLE);
			else
				af2entity.Tell("Такого объекта с именем не существует!", AFArgs.User, HUD_PRINTCONSOLE);
		}
	}

	void keyvaluerange(AFBaseArguments@ AFArgs)
	{
		CBaseEntity@ pEntity = null;
		int iC = 0;
		
		string sVal = AFArgs.GetCount() >= 4 ? AFArgs.GetString(3) : "";
		string sValY = AFArgs.GetCount() >= 5 ? AFArgs.GetString(4) : "";
		string sValZ = AFArgs.GetCount() >= 6 ? AFArgs.GetString(5) : "";
		string sValout = "";
		if(sVal != "" && sValY != "" && sValZ != "")
			sValout = sVal+" "+sValY+" "+sValZ;
		else
			sValout = sVal;
			
		bool bHasE = AFBase::CheckAccess(AFArgs.User, ACCESS_E);
		
		if(AFArgs.GetString(0) == "trigger_setcvar")
		{
			if(!AFBase::CheckAccess(AFArgs.User, ACCESS_C))
			{
				af2entity.Tell("Заблокировано: вам требуеться имметь доступ С чтобы зделать это (\"rcon\" доступ)!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
		}
		
		while((@pEntity = g_EntityFuncs.FindEntityInSphere(pEntity, AFArgs.User.pev.origin, AFArgs.GetFloat(1), AFArgs.GetString(0), "classname")) !is null)
		{
			if(pEntity.IsPlayer())
			{
				af2entity.Tell("Нельзя установить: цель это игрок!", AFArgs.User, HUD_PRINTCONSOLE);
				continue;
			}
		
			if(sValout == "")
			{
				string sReturn = AF2LegacyCode::getKeyValue(pEntity, AFArgs.GetString(2));
				if(sReturn != "§§§§N/A")
					af2entity.Tell("Значение объекта : \""+sReturn+"\"", AFArgs.User, HUD_PRINTCONSOLE);
				else
					af2entity.Tell("Неподдерживаемое значение", AFArgs.User, HUD_PRINTCONSOLE);
			}else{
				if(AFArgs.GetString(2) == "model" || AFArgs.GetString(2) == "viewmodel" || AFArgs.GetString(2) == "weaponmodel" || AFArgs.GetString(2) == "modelindex")
				{
					if(!bHasE)
					{
						af2entity.Tell("Заблокировано: вам требуеться имметь доступ Е чтобы зделать это (\"большой риск\" доступ)", AFArgs.User, HUD_PRINTCONSOLE);
						return;
					}
				}
				
				string sValHold = sValout;
				if(sValHold.ToLowercase() == "!null!")
					sValout = "";
				
				af2entity.Tell("Установлено значение объекта: \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
				g_EntityFuncs.DispatchKeyValue(pEntity.edict(), AFArgs.GetString(2), sValout);
			}
			iC++;
		}
		
		if(iC > 0)
			af2entity.Tell(string(iC)+" найдено объектов", AFArgs.User, HUD_PRINTCONSOLE);
		else
			af2entity.Tell("Нету объекта с такми типом класса!", AFArgs.User, HUD_PRINTCONSOLE);
	}

	void keyvaluename(AFBaseArguments@ AFArgs)
	{
		CBaseEntity@ pEntity = null;
		int iC = 0;
		
		string sVal = AFArgs.GetCount() >= 3 ? AFArgs.GetString(2) : "";
		string sValY = AFArgs.GetCount() >= 4 ? AFArgs.GetString(3) : "";
		string sValZ = AFArgs.GetCount() >= 5 ? AFArgs.GetString(4) : "";
		string sValout = "";
		if(sVal != "" && sValY != "" && sValZ != "")
			sValout = sVal+" "+sValY+" "+sValZ;
		else
			sValout = sVal;
			
		if(AFArgs.GetString(0) == "trigger_setcvar")
		{
			if(!AFBase::CheckAccess(AFArgs.User, ACCESS_C))
			{
				af2entity.Tell("Заблокировано: вам требуеться имметь доступ С чтобы зделать это (\"rcon\" доступ)!", AFArgs.User, HUD_PRINTCONSOLE);
				return;
			}
		}
			
		bool bHasE = AFBase::CheckAccess(AFArgs.User, ACCESS_E);
		while((@pEntity = g_EntityFuncs.FindEntityByTargetname(pEntity, AFArgs.GetString(0))) !is null)
		{
			if(pEntity.IsPlayer())
			{
				af2entity.Tell("Нельзя установить: цель это игрок!", AFArgs.User, HUD_PRINTCONSOLE);
				continue;
			}
		
			if(sValout == "")
			{
				string sReturn = AF2LegacyCode::getKeyValue(pEntity, AFArgs.GetString(1));
				if(sReturn != "§§§§N/A")
					af2entity.Tell("Значение объекта: \""+sReturn+"\"", AFArgs.User, HUD_PRINTCONSOLE);
				else
					af2entity.Tell("Неподдерживаемое значение", AFArgs.User, HUD_PRINTCONSOLE);
			}else{
				if(AFArgs.GetString(1) == "model" || AFArgs.GetString(1) == "viewmodel" || AFArgs.GetString(1) == "weaponmodel" || AFArgs.GetString(1) == "modelindex")
				{
					if(!bHasE)
					{
						af2entity.Tell("Заблокировано: вам требуеться имметь доступ Е чтобы зделать это (\"большой риск\" доступ)", AFArgs.User, HUD_PRINTCONSOLE);
						return;
					}
				}
				
				string sValHold = sValout;
				if(sValHold.ToLowercase() == "!null!")
					sValout = "";
				
				af2entity.Tell("Установлено значение объекта: \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
				g_EntityFuncs.DispatchKeyValue(pEntity.edict(), AFArgs.GetString(1), sValout);
			}
			iC++;
		}
		
		if(iC > 0)
			af2entity.Tell(string(iC)+" найдено объектов", AFArgs.User, HUD_PRINTCONSOLE);
		else
			af2entity.Tell("Такого объекта с именем не существует!", AFArgs.User, HUD_PRINTCONSOLE);
	}

	void keyvalue(AFBaseArguments@ AFArgs)
	{
		CBaseEntity@ pEntity = g_Utility.FindEntityForward(AFArgs.User, 4096);
		if(pEntity is null)
		{
			af2entity.Tell("Нет объекта впереди (4096 юнитов)!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		if(pEntity.IsPlayer())
		{
			af2entity.Tell("Нельзя установить: цель это игрок!", AFArgs.User, HUD_PRINTCONSOLE);
			return;
		}
		
		string sVal = AFArgs.GetCount() >= 2 ? AFArgs.GetString(1) : "";
		string sValY = AFArgs.GetCount() >= 3 ? AFArgs.GetString(2) : "";
		string sValZ = AFArgs.GetCount() >= 4 ? AFArgs.GetString(3) : "";
		string sValout = "";
		if(sVal != "" && sValY != "" && sValZ != "")
			sValout = sVal+" "+sValY+" "+sValZ;
		else
			sValout = sVal;
			
		bool bHasE = AFBase::CheckAccess(AFArgs.User, ACCESS_E);
		if(sValout == "")
		{
			string sReturn = AF2LegacyCode::getKeyValue(pEntity, AFArgs.GetString(0));
			if(sReturn != "§§§§N/A")
				af2entity.Tell("Значение объекта: \""+sReturn+"\"", AFArgs.User, HUD_PRINTCONSOLE);
			else
				af2entity.Tell("Неподдерживаемое значение", AFArgs.User, HUD_PRINTCONSOLE);
		}else{
			if(AFArgs.GetString(0) == "model" || AFArgs.GetString(0) == "viewmodel" || AFArgs.GetString(0) == "weaponmodel" || AFArgs.GetString(0) == "modelindex")
			{
				if(!bHasE)
				{
					af2entity.Tell("Заблокировано: вам требуеться имметь доступ Е чтобы зделать это (\"большой риск\" доступ)", AFArgs.User, HUD_PRINTCONSOLE);
					return;
				}
			}
			
			string sValHold = sValout;
			if(sValHold.ToLowercase() == "!null!")
				sValout = "";
			
			af2entity.Tell("Установлено значение объекта: \""+sValout+"\"", AFArgs.User, HUD_PRINTCONSOLE);
			g_EntityFuncs.DispatchKeyValue(pEntity.edict(), AFArgs.GetString(0), sValout);
		}
	}

	void damage(AFBaseArguments@ AFArgs)
	{
		float fDamage = AFArgs.GetCount() >= 1 ? AFArgs.GetFloat(0) : 5000.0f;
		string sTarget = AFArgs.GetCount() >= 2 ? AFArgs.GetString(1) : "";
		if(sTarget == "")
		{
			CBaseEntity@ pEntity = g_Utility.FindEntityForward(AFArgs.User, 4096);
			if(pEntity !is null)
			{
				if(pEntity.IsPlayer())
				{
					af2entity.Tell("Нельзя поранить: цель это игрок!", AFArgs.User, HUD_PRINTCONSOLE);
					return;
				}
				pEntity.TakeDamage(AFArgs.User.pev, AFArgs.User.pev, fDamage, DMG_BLAST);
			
			}else{
				af2entity.Tell("Нет объекта впереди (4096 юнитов)!", AFArgs.User, HUD_PRINTCONSOLE);
			}
		}else{
			int iC = 0;
			CBaseEntity@ eSearch = null;
			while((@eSearch = g_EntityFuncs.FindEntityByTargetname(eSearch, sTarget)) !is null)
			{
				eSearch.TakeDamage(AFArgs.User.pev, AFArgs.User.pev, fDamage, DMG_BLAST);
				iC++;
			}
			
			if(iC > 0)
				af2entity.Tell("Поранили "+string(iC)+" объектов", AFArgs.User, HUD_PRINTCONSOLE);
			else
				af2entity.Tell("Такого объекта с именем не существует!", AFArgs.User, HUD_PRINTCONSOLE);
		}
	}
}