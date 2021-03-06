MOD_NAME = "beevee_mod"
BEEVEE_MOD_OBJ_OID = "beevee_mod_pokemon_131"
BEEVE_XPOS_STEP_SIZE = 8
CURRENT_BEEVEE_INST = nil

-- spr_beevee = nil

function register()
	return {
		name = MOD_NAME,
		hooks = {"step", "ready"},
		modules = {}
	}
end	

function init()
	api_set_devmode(true)
	define_beevee_obj()
	return "Success"
end

function ready()
	player = api_get_player_instance()
	ppos_x = api_gp(player, "x")
	ppos_y = api_gp(player, "y")

	api_log("ready", "initializing beevee position")
	api_create_obj("beevee_mod_pokemon_131_left", ppos_x + BEEVE_XPOS_STEP_SIZE, ppos_y)
	CURRENT_BEEVEE_INST = api_get_objects(nil, "beevee_mod_pokemon_131_left")
	reset_beevees_on_load()
	beevee_position_callback()
end

function reset_beevees_on_load()
	objs_left = api_get_objects(nil, "beevee_mod_pokemon_131_left")
	if #objs_left ~= 0 then
		for i=1, #objs_left do
			api_destroy_inst(objs_left[i]["id"])
		end
	end
	objs_right = api_get_objects(nil, "beevee_mod_pokemon_131_right")
	if #objs_right ~= 0 then
		for i=1, #objs_right do
			api_destroy_inst(objs_right[i]["id"])
		end
	end
end

function beevee_position_callback()
	player = api_get_player_instance()

	-- if beevee in inventory then return 
	inventory_check = api_slot_match(player, {"beevee_mod_pokemon_131_left", "beevee_mod_pokemon_131_right"}, true)
	if inventory_check ~= nil then
		return
	end

	ppos_x = api_gp(player, "x")
	ppos_y = api_gp(player, "y")
	pdir = api_gp(player, "dir")

	if pdir == "right" then 
		beevee_xpos = ppos_x - (BEEVE_XPOS_STEP_SIZE*4)
		beevee_object_to_use = "beevee_mod_pokemon_131_right"
	else
		beevee_xpos = ppos_x + BEEVE_XPOS_STEP_SIZE
		beevee_object_to_use = "beevee_mod_pokemon_131_left"
	end

	objs_left = api_get_objects(nil, "beevee_mod_pokemon_131_left")
	objs_right = api_get_objects(nil, "beevee_mod_pokemon_131_right")
	if #objs_left == 0 and #objs_right == 0 then
		api_create_obj("beevee_mod_pokemon_131_left", ppos_x + BEEVE_XPOS_STEP_SIZE, ppos_y)
		CURRENT_BEEVEE_INST = api_get_objects(nil, "beevee_mod_pokemon_131_left")
	else

		reset_beevees_on_load()
		api_create_obj(beevee_object_to_use, beevee_xpos, ppos_y)
		CURRENT_BEEVEE_INST = api_get_objects(nil, beevee_object_to_use)
	end
end

function step()
	-- check player coords and adjust pos of beevee
	update_beevee_pos()
end

function define_beevee_obj() 
	beevee_obj_right_def = {
		id = "pokemon_131_right",
		name = "eevee",
		category = "friend",
		tooltip = "evoiiiii",
		shop_key = false,
		tools = {"hammer1"},
		placeable = true,
		durability = false,
		singular = true,
		honeycore = false,
		invisible = false,
		has_shadow = true,
		pickable = false,
		item_sprite = "sprites/beevee_item.png"
	}
	api_define_object(beevee_obj_right_def, "sprites/beevee_walking_right.png", "update_beevee_pos")

	beevee_obj_left_def = {
		id = "pokemon_131_left",
		name = "eevee",
		category = "friend",
		tooltip = "evoiiiii",
		shop_key = true,
		tools = {"hammer1"},
		placeable = true,
		durability = false,
		singular = true,
		honeycore = false,
		invisible = false,
		has_shadow = true,
		pickable = false,
		item_sprite = "sprites/beevee_item.png"
	}
	api_define_object(beevee_obj_left_def, "sprites/beevee_walking_left.png", "update_beevee_pos")
end

function update_beevee_pos(obj_id) 
	if api_gp(player, "walking") == true then
		beevee_position_callback()
	end
end

-- function define_beevee_npc() 
-- 	beevee_npc_def = {
-- 		id = 131,
-- 		name = "eevee",
-- 		pronouns = "ee/vee",
-- 		tooltip = "Evoii?",
-- 		shop = false,
-- 		walking = true,
-- 		stock = {},
-- 		specials = {"flower1", "flower2", "flower3"},
-- 		dialogue = {
-- 			"Evoii??",
-- 			":3",
-- 			"<3"
-- 		},
-- 		greeting = "Evoii!"
-- 	}
-- end

-- function define_beevee_sprite()
-- 	spr_beevee_frame = api_random(3) + 1
-- 	spr_beevee = api_define_sprite("pokemon_131", "sprites/beevee_walking.png", spr_beevee_frame)
	
-- end
