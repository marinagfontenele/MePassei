#question_formulation_wait.gd
# Anexe na raiz da cena QuestionFormulationWait.
# Só mostra "X de Y jogadores enviaram suas perguntas".
# Quem libera a próxima tela é o host, no GameManager (quando todos enviaram).
extends Node

@onready var label_enviadas: Label = _find_label("MarginContainer/VBoxContainer/HBoxContainer/PerguntasEnviadas", "PerguntasEnviadas")
@onready var label_totais: Label = _find_label("MarginContainer/VBoxContainer/HBoxContainer/PerguntasTotais", "PerguntasTotais")


func _find_label(path: String, node_name: String) -> Label:
	var n = get_node_or_null(path)
	if n == null:
		n = find_child(node_name, true, false)
	return n as Label


func _ready() -> void:
	# Atualiza a cada pacote que chega (perguntas dos outros, jogadores entrando/saindo)
	if not GameManager.lobby_updated.is_connected(_refresh):
		GameManager.lobby_updated.connect(_refresh)
	_refresh()


func _exit_tree() -> void:
	if GameManager.lobby_updated.is_connected(_refresh):
		GameManager.lobby_updated.disconnect(_refresh)


func _refresh() -> void:
	if label_enviadas:
		label_enviadas.text = "%d" % GameManager.get_questions_submitted_count()
	if label_totais:
		label_totais.text = "%d" % GameManager.get_questions_expected_count()
