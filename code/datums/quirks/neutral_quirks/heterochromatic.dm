/datum/quirk/heterochromatic
	name = "Heterochromatic"
	desc = "One of your eyes is a different color than the other!"
	icon = FA_ICON_LOW_VISION // Ignore the icon name, its actually a fairly good representation of different color eyes
	quirk_flags = QUIRK_HUMAN_ONLY | QUIRK_CHANGES_APPEARANCE
	value = 0
	mail_goodies = list(/obj/item/clothing/glasses/eyepatch)
	var/color

// Only your first eyes are heterochromatic
// If someone comes and says "well mr coder you can have DNA bound heterochromia so it's not unrealistic
// to allow all inserted replacement eyes to become heterochromatic or for it to transfer between mobs"
// Then just change this to [proc/add] I really don't care
/datum/quirk/heterochromatic/add_unique(client/client_source)
	color ||= client_source?.prefs?.read_preference(/datum/preference/color/heterochromatic)
	apply_heterochromatic_eyes()

/datum/quirk/heterochromatic/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.eye_color_heterochromatic = FALSE
	human_holder.eye_color_right = human_holder.eye_color_left
	UnregisterSignal(human_holder, COMSIG_CARBON_LOSE_ORGAN)

/datum/quirk/heterochromatic/clone_data()
	return color

/datum/quirk/heterochromatic/on_clone(mob/living/carbon/human/cloned_mob, client/client_source, data)
	color = data
	. = ..()
	apply_heterochromatic_eyes() // this won't be run due to add_unique, so let's run it ourselves

/// Applies the passed color to this mob's eyes
/datum/quirk/heterochromatic/proc/apply_heterochromatic_eyes()
	if(!color)
		return
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/was_not_hetero = !human_holder.eye_color_heterochromatic
	human_holder.eye_color_heterochromatic = TRUE
	human_holder.eye_color_right = color

	var/obj/item/organ/internal/eyes/eyes_of_the_holder = quirk_holder.get_organ_by_type(/obj/item/organ/internal/eyes)
	if(!eyes_of_the_holder)
		return

	eyes_of_the_holder.eye_color_right = color
	eyes_of_the_holder.old_eye_color_right = color
	eyes_of_the_holder.refresh()

	if(was_not_hetero)
		RegisterSignal(human_holder, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(check_eye_removal))

/datum/quirk/heterochromatic/proc/check_eye_removal(datum/source, obj/item/organ/internal/eyes/removed)
	SIGNAL_HANDLER

	if(!istype(removed))
		return

	// Eyes were removed, remove heterochromia from the human holder and bid them adieu
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.eye_color_heterochromatic = FALSE
	human_holder.eye_color_right = human_holder.eye_color_left
	UnregisterSignal(human_holder, COMSIG_CARBON_LOSE_ORGAN)
