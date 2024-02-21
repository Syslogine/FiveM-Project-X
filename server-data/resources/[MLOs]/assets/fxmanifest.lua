fx_version 'cerulean'
game 'gta5'

-- Client Scripts
client_script "@ethical-errorlog/client/cl_errorlog.lua"
client_script 'client_script.lua'

-- Map Declarations
this_is_a_map 'yes'

-- Files used by data_file directives
files {
    "handling.meta",
    'burgerUPDATE/iv_int_1_timecycle_mods_1.xml',
    'burgerUPDATE/interiorproxies.meta',
    'burgerUPDATE/minimap/int2056887296.gfx',
    'gabz_bennys_timecycle.xml',
    'client/mph4_gtxd.meta',
    'missionrowpdv2/int_corporate.ytyp',
    'missionrowpdv2/v_kitch.ytyp',
    'missionrowpdv2/interiorproxies.meta',
    'audio/ivbsoverride_game.dat151.rel'
}

-- Data Files
data_file 'DLC_ITYP_REQUEST' 'stream/misc/shell-mansion/v_int_44.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/slbBuildings/def_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'ls_blackwhite/portels_1a.ytyp'
data_file 'DLC_ITYP_REQUEST' 'ls_blackwhite/portels_2a.ytyp'
data_file 'DLC_ITYP_REQUEST' 'ls_blackwhite/portels_3a.ytyp'
data_file 'DLC_ITYP_REQUEST' 'ls_blackwhite/portels_4a.ytyp'
data_file 'DLC_ITYP_REQUEST' 'missionrowpdv2/int_corporate.ytyp'
data_file 'DLC_ITYP_REQUEST' 'missionrowpdv2/v_kitch.ytyp'

data_file 'TIMECYCLEMOD_FILE' 'burgerUPDATE/iv_int_1_timecycle_mods_1.xml'
data_file 'TIMECYCLEMOD_FILE' 'gabz_bennys_timecycle.xml'

data_file 'INTERIOR_PROXY_ORDER_FILE' 'burgerUPDATE/interiorproxies.meta'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'missionrowpdv2/interiorproxies.meta'

data_file 'SCALEFORM_DLC_FILE' 'burgerUPDATE/minimap/int2056887296.gfx'

data_file "HANDLING_FILE" "handling.meta"

data_file 'GTXD_PARENTING_DATA' 'client/mph4_gtxd.meta'

-- Optional: If you have custom audio, handling, or other specific files
data_file 'AUDIO_GAMEDATA' 'audio/ivbsoverride_game.dat151.rel'
