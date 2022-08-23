#include <sourcemod>
#include <cstrike>

int dmg[MAXPLAYERS+1];

ConVar hCvar;
bool bScoresMode;

public Plugin myinfo = 
{
    name = "Total Damage In Tab",
    author = "Quake1011",
    description = "Total damage instead tab scores",
    version = "1.1",
    url = "https://github.com/Quake1011/"
}

public void OnPluginStart()
{
    HookEvent("player_hurt", PlayerHurt, EventHookMode_Post);
    HookEvent("round_start", RoundStart, EventHookMode_Post);

    HookConVarChange((hCvar = CreateConVar("sm_td_updater_mode", "0", "Update the damage display [0 - after player Hurt | 1 - after the round]")), OnConVarChanged);
    bScoresMode = hCvar.BoolValue;

    AutoExecConfig(true, "tabdmg");
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
    bScoresMode = convar.BoolValue;
}

public void RoundStart(Event hEvent, const char[] sEvent, bool bdb)
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if(IsClientInGame(i) && IsPlayerAlive(i)) CS_SetClientContributionScore(i, dmg[i]);
    }
}

public void PlayerHurt(Event hEvent, const char[] sEvent, bool bdb)
{ 
    int attacker = GetClientOfUserId(hEvent.GetInt("attacker"));
    if(attacker && !IsFakeClient(attacker))
    {
        dmg[attacker] += hEvent.GetInt("dmg_health") + hEvent.GetInt("dmg_armor");
        if(!bScoresMode) CS_SetClientContributionScore(attacker, dmg[attacker]);
    }
}
