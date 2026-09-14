class_name WaveResource
extends Resource


@export var entries: Array[EnemyWaveEntry] = []


func to_wave_info() -> Array[Dictionary]:
	var wave_info: Array[Dictionary] = []
	for entry in entries:
		if entry == null:
			continue
		wave_info.append({
			entry.get_enemy_key(): {
				"level": entry.level,
				"amount": entry.amount,
			}
		})
	return wave_info
