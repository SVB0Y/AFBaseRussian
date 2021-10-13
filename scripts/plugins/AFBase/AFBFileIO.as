namespace AFBase
{
	void UpdateAccessFile(string sId, string sAccess)
	{
		array<string> aSHold;
		File@ file = g_FileSystem.OpenFile("scripts/plugins/store/AFBaseAccess.txt", OpenFile::READ);
		bool bUpdateEntry = false;
		bool bReadFile = false;
		if(file !is null && file.IsOpen())
		{
			while(!file.EOFReached())
			{
				string sLine;
				file.ReadLine(sLine);
				//fix for linux
				string sFix = sLine.SubString(sLine.Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					sLine = sLine.SubString(0, sLine.Length()-1);
					
				if(sLine.SubString(0,1) == "#" || sLine.IsEmpty())
				{
					aSHold.insertLast(sLine);
					continue;
				}
					
				array<string> parsed = sLine.Split(" ");
				if(parsed.length() < 2)
				{
					aSHold.insertLast(sLine);
					continue;
				}
					
				if(parsed[0] != sId)
				{
					aSHold.insertLast(sLine);
					continue;
				}
					
				//just makin sure linux wont fuck
				sFix = parsed[1].SubString(parsed[1].Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					parsed[1] = parsed[1].SubString(0, parsed[1].Length()-1);
					
				if(sAccess != "")
				{
					aSHold.insertLast(parsed[0]+" "+sAccess);
					BaseLog("Обновлен доступ ("+sAccess+"z) на "+sId);
					bUpdateEntry = true;
				}else{
					BaseLog("Обновлен доступ (z) на "+sId);
					bUpdateEntry = true;
				}
			}
			
			bReadFile = true;
			file.Close();
		}else{
			BaseLog("Ошибка инсталляции: не найден файл доступа");
			return;
		}
		
		if(bReadFile)
			if(!bUpdateEntry)
			{
				aSHold.insertLast(sId+" "+sAccess);
				BaseLog("Добавлен новый доступ("+sAccess+"z) на "+sId);
			}
		
		@file = g_FileSystem.OpenFile("scripts/plugins/store/AFBaseAccess.txt", OpenFile::WRITE);
		if(file !is null && file.IsOpen())
		{
			for(uint i = 0; i < aSHold.length(); i++)
			{
				if(i < aSHold.length()-1)
					file.Write(aSHold[i]+"\n");
				else
					file.Write(aSHold[i]);
			}
			
			file.Close();
		}
	}
	
	void UpdateSprayFile(string sId, bool bMode)
	{
		array<string> aSHold;
		File@ file = g_FileSystem.OpenFile("scripts/plugins/store/AFBaseSprayBans.txt", OpenFile::READ);
		bool bUpdateEntry = false;
		bool bReadFile = false;
		if(file !is null && file.IsOpen())
		{
			while(!file.EOFReached())
			{
				string sLine;
				file.ReadLine(sLine);
				//fix for linux
				string sFix = sLine.SubString(sLine.Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					sLine = sLine.SubString(0, sLine.Length()-1);
					
				if(sLine.SubString(0,1) == "#" || sLine.IsEmpty())
				{
					aSHold.insertLast(sLine);
					continue;
				}
					
				if(sLine != sId)
				{
					aSHold.insertLast(sLine);
					continue;
				}
					
				if(!bMode)
				{
					BaseLog("Обновлен файл спрей бана: разбаннен "+sId);
					bUpdateEntry = true;
				}
			}
			
			bReadFile = true;
			file.Close();
		}else{
			BaseLog("Ошибка инсталляции: не найден файл спрей банов");
			return;
		}
		
		if(bReadFile)
			if(!bUpdateEntry && bMode)
			{
				aSHold.insertLast(sId);
				BaseLog("Обновлен файл спрей бана: забаннен "+sId);
			}
		
		@file = g_FileSystem.OpenFile("scripts/plugins/store/AFBaseSprayBans.txt", OpenFile::WRITE);
		if(file !is null && file.IsOpen())
		{
			for(uint i = 0; i < aSHold.length(); i++)
			{
				if(i < aSHold.length()-1)
					file.Write(aSHold[i]+"\n");
				else
					file.Write(aSHold[i]);
			}
			
			file.Close();
		}
	}
	
	void UpdateGagFile(string sId, int iMode)
	{
		array<string> aSHold;
		File@ file = g_FileSystem.OpenFile("scripts/plugins/store/AFBaseGagBans.txt", OpenFile::READ);
		bool bUpdateEntry = false;
		bool bReadFile = false;
		if(file !is null && file.IsOpen())
		{
			while(!file.EOFReached())
			{
				string sLine;
				file.ReadLine(sLine);
				//fix for linux
				string sFix = sLine.SubString(sLine.Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					sLine = sLine.SubString(0, sLine.Length()-1);
					
				if(sLine.SubString(0,1) == "#" || sLine.IsEmpty())
				{
					aSHold.insertLast(sLine);
					continue;
				}
				
				array<string> parsed = sLine.Split(" ");
					
				if(parsed.length() < 2)
				{
					aSHold.insertLast(sLine);
					continue;
				}
					
				if(parsed[0] != sId)
				{
					aSHold.insertLast(sLine);
					continue;
				}
					
				if(iMode == -1)
				{
					BaseLog("Обновлен файл мьюутов: размучен "+sId);
					bUpdateEntry = true;
				}
			}
			
			bReadFile = true;
			file.Close();
		}else{
			BaseLog("Ошибка инсталляции: не найден файл мьюутов");
			return;
		}
		
		if(bReadFile)
			if(!bUpdateEntry && iMode != -1)
			{
				aSHold.insertLast(sId+" "+string(iMode));
				BaseLog("Обновлен файл мьюутов: замучен "+sId);
			}
		
		@file = g_FileSystem.OpenFile("scripts/plugins/store/AFBaseGagBans.txt", OpenFile::WRITE);
		if(file !is null && file.IsOpen())
		{
			for(uint i = 0; i < aSHold.length(); i++)
			{
				if(i < aSHold.length()-1)
					file.Write(aSHold[i]+"\n");
				else
					file.Write(aSHold[i]);
			}
			
			file.Close();
		}
	}
	
	bool UpdateBanFile(string sInput, int iMinutes, string sReason, bool bIsIp)
	{
		array<string> aSHold;
		string sFileToUse = bIsIp ? "scripts/plugins/store/AFBaseIPBans.txt" : "scripts/plugins/store/AFBaseIDBans.txt";
		File@ file = g_FileSystem.OpenFile(sFileToUse, OpenFile::READ);
		bool bUpdateEntry = false;
		bool bReadFile = false;
		bool bOutput = false;
		
		if(file !is null && file.IsOpen())
		{
			while(!file.EOFReached())
			{
				string sLine;
				file.ReadLine(sLine);
				//fix for linux
				string sFix = sLine.SubString(sLine.Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					sLine = sLine.SubString(0, sLine.Length()-1);
					
				if(sLine.SubString(0,1) == "#" || sLine.IsEmpty())
				{
					aSHold.insertLast(sLine);
					continue;
				}
				
				array<string> parsed = sLine.Split(" ");
					
				if(parsed.length() < 3)
				{
					aSHold.insertLast(sLine);
					continue;
				}
					
				if(parsed[0] != sInput)
				{
					aSHold.insertLast(sLine);
					continue;
				}
					
				if(iMinutes == -1)
				{
					if(bIsIp)
						BaseLog("Обновлен файл IP банов: разбаннен "+sInput);
					else
						BaseLog("Обновлен файл ID банов: разбаннен "+sInput);
					bUpdateEntry = true;
					bOutput = true;
				}
			}
			
			bReadFile = true;
			file.Close();
		}else{
			if(bIsIp)
				BaseLog("Ошибка инсталляции: не найден файл IP банов");
			else
				BaseLog("Ошибка инсталляции: не найден файл ID банов");
			return false;
		}
		
		if(bReadFile)
			if(!bUpdateEntry && iMinutes != -1)
			{
				if(iMinutes == 0)
				{
					aSHold.insertLast(sInput+" 0 "+sReason);
				}else{
					DateTime datetime;
					time_t unixtime = datetime.ToUnixTimestamp();
					datetime.SetUnixTimestamp(unixtime + (iMinutes*60));
					string unixTime = datetime.ToUnixTimestamp();
					aSHold.insertLast(sInput+" "+string(unixTime)+" "+sReason);
				}
				
				if(bIsIp)
					BaseLog("Обновлен IP бан: забаннен "+sInput);
				else
					BaseLog("Обновлен ID бан: забаннен "+sInput);
			}
		
		@file = g_FileSystem.OpenFile(sFileToUse, OpenFile::WRITE);
		if(file !is null && file.IsOpen())
		{
			for(uint i = 0; i < aSHold.length(); i++)
			{
				if(i < aSHold.length()-1)
					file.Write(aSHold[i]+"\n");
				else
					file.Write(aSHold[i]);
			}
			
			file.Close();
		}
		
		return bOutput;
	}
	
	void HandleAccess(string sID, int iIndex)
	{
		if(g_cvar_afb_ignoreAccess.GetInt() >= 1)
		{
			if(g_PlayerFuncs.AdminLevel(cast<CBasePlayer@>(g_EntityFuncs.Instance(g_EntityFuncs.IndexEnt(iIndex)))) >= ADMIN_YES)
			{
				BaseLog("Выдан полный доступ пользователю "+sID);
				AFBaseUser afbUser = cast<AFBaseUser@>(g_afbUserList[iIndex]);
				afbUser.bLock = false;
				afbUser.iAccess = 33554431;
				afbUser.sAccess = "bcdefghijklmnopqrstuvwxyz";
				afbUser.bLock = true;
				g_afbUserList[iIndex] = afbUser;
			}
			
			return;
		}
	
		File@ file = g_FileSystem.OpenFile("scripts/plugins/store/AFBaseAccess.txt", OpenFile::READ);
		if(file !is null && file.IsOpen())
		{
			while(!file.EOFReached())
			{
				string sLine;
				file.ReadLine(sLine);
				//fix for linux
				string sFix = sLine.SubString(sLine.Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					sLine = sLine.SubString(0, sLine.Length()-1);
					
				if(sLine.SubString(0,1) == "#" || sLine.IsEmpty())
					continue;
					
				array<string> parsed = sLine.Split(" ");
				if(parsed.length() < 2)
					continue;
					
				if(parsed[0] != sID)
					continue;
					
				//just makin sure linux wont fuck
				sFix = parsed[1].SubString(parsed[1].Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					parsed[1] = parsed[1].SubString(0, parsed[1].Length()-1);
					
				string sHacc = "";
				int iHacc = 0;
				translateAccess(parsed[1], sHacc, iHacc);
				array<string> sHold = ExplodeString(sHacc, "z"); // hackfix: remove extra z:s
				sHacc = ImplodeString(sHold);
				sHacc += "z";
				
				BaseLog("Выдан доступ ("+sHacc+") to "+sID);
				AFBaseUser afbUser = cast<AFBaseUser@>(g_afbUserList[iIndex]);
				afbUser.bLock = false;
				afbUser.iAccess = iHacc;
				afbUser.sAccess = sHacc;
				afbUser.bLock = true;
				g_afbUserList[iIndex] = afbUser;
				file.Close();
				break;
			}
			
			file.Close();
		}else{
			BaseLog("Ошибка инсталляции: не найден файл доступа");
		}
	}
	
	void HandleSprayban(string sID, int iIndex)
	{
		File@ file = g_FileSystem.OpenFile("scripts/plugins/store/AFBaseSprayBans.txt", OpenFile::READ);
		if(file !is null && file.IsOpen())
		{
			while(!file.EOFReached())
			{
				string sLine;
				file.ReadLine(sLine);
				//fix for linux
				string sFix = sLine.SubString(sLine.Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					sLine = sLine.SubString(0, sLine.Length()-1);
					
				if(sLine.SubString(0,1) == "#" || sLine.IsEmpty())
					continue;
					
				if(sLine != sID)
					continue;
				
				BaseLog("Применен спрей бан для "+sID);
				AFBaseUser afbUser = cast<AFBaseUser@>(g_afbUserList[iIndex]);
				afbUser.bLock = false;
				afbUser.bSprayBan = true;
				afbUser.bLock = true;
				g_afbUserList[iIndex] = afbUser;
				file.Close();
				break;
			}
			
			file.Close();
		}else{
			BaseLog("Ошибка инсталляции: не найден файл спрей банов");
		}
	}
	
	void HandleGagban(string sID, int iIndex)
	{
		File@ file = g_FileSystem.OpenFile("scripts/plugins/store/AFBaseGagBans.txt", OpenFile::READ);
		if(file !is null && file.IsOpen())
		{
			while(!file.EOFReached())
			{
				string sLine;
				file.ReadLine(sLine);
				//fix for linux
				string sFix = sLine.SubString(sLine.Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					sLine = sLine.SubString(0, sLine.Length()-1);
					
				if(sLine.SubString(0,1) == "#" || sLine.IsEmpty())
					continue;
					
				array<string> parsed = sLine.Split(" ");
				if(parsed.length() < 2)
					continue;
					
				if(parsed[0] != sID)
					continue;
					
				//just makin sure linux wont fuck
				sFix = parsed[1].SubString(parsed[1].Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					parsed[1] = parsed[1].SubString(0, parsed[1].Length()-1);
				
				BaseLog("Применен мьюут для "+sID);
				AFBaseUser afbUser = cast<AFBaseUser@>(g_afbUserList[iIndex]);
				afbUser.bLock = false;
				afbUser.iGagMode = atoi(parsed[1]);
				afbUser.bLock = true;
				g_afbUserList[iIndex] = afbUser;
				file.Close();
				break;
			}
			
			file.Close();
		}else{
			BaseLog("Ошибка инсталляции: не найден файл gagban file");
		}
	}
	
	void ReadBanString(string &in sInput, int &out iMinutes, string &out sReason)
	{
		array<string> parsed = sInput.Split("§§§§");
		sReason = parsed[1];
		//BaseLog("reading: time is "+parsed[0]);
		//BaseLog("reading: reason is "+parsed[1]);
		
		
		if(parsed[0] != "-1" && parsed[0] != "0")
		{
			DateTime datetime;
			time_t unixtime = datetime.ToUnixTimestamp();
			DateTime datetime2 = datetime;
			datetime2.SetUnixTimestamp(atoi(parsed[0]));
			time_t unixtime2 = datetime2.ToUnixTimestamp();
			time_t unixtimeleft = unixtime2-unixtime;
			bool bPass = unixtime2 < unixtime ? true : false;
			if(bPass)
			{
				iMinutes = -2;
			}else{
				int iWanted = int(unixtimeleft/60);
				if(iWanted < 1)
					iWanted = 1; // fix: dont show "Permanent ban" for last minute lmao
				iMinutes = iWanted;
			}
		}else if(parsed[0] == "0")
		{
			iMinutes = 0;
		}else{
			iMinutes = -1;
		}
		
	}
	
	string HandleBan(string sInput, bool bIsIp) // special!
	{
		string sFileToUse = bIsIp ? "scripts/plugins/store/AFBaseIPBans.txt" : "scripts/plugins/store/AFBaseIDBans.txt";
		string sOutput = "-1§§§§N/A";
		File@ file = g_FileSystem.OpenFile(sFileToUse, OpenFile::READ);
		if(file !is null && file.IsOpen())
		{
			while(!file.EOFReached())
			{
				string sLine;
				file.ReadLine(sLine);
				//fix for linux
				string sFix = sLine.SubString(sLine.Length()-1,1);
				if(sFix == " " || sFix == "\n" || sFix == "\r" || sFix == "\t")
					sLine = sLine.SubString(0, sLine.Length()-1);
					
				if(sLine.SubString(0,1) == "#" || sLine.IsEmpty())
					continue;
					
				array<string> parsed = sLine.Split(" ");
				if(parsed.length() < 3)
					continue;
					
				if(parsed[0] != sInput)
					continue;
					
				string sMinutes = parsed[1];
				string sReason = "";
				for(uint i = 2; i < parsed.length(); i++)
					if(i > 2)
						sReason += " "+parsed[i];
					else
						sReason += parsed[i];
					
				sOutput = sMinutes+"§§§§"+sReason;
				file.Close();
				break;
			}
			
			file.Close();
		}else{
			if(bIsIp)
				BaseLog("Ошибка инсталляции: не найден файл IP банов");
			else
				BaseLog("Ошибка инсталляции: не найден файл ID банов");
		}
		
		return sOutput;
	}
}