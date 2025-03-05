from robot.api.deco import keyword
import yaml

@keyword
def READ_YAML(file):
    """Lê o arquivo YAML e retorna os dados."""
    with open(file, 'r') as stream:
        try:
            return yaml.safe_load(stream)  # Retorna o conteúdo do YAML como um dicionário
        except yaml.YAMLError as exc:
            print(f"Erro ao carregar o YAML: {exc}")
            return None
