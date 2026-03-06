import os
import zipfile
import pandas as pd
import xml.etree.ElementTree as ET
from tqdm import tqdm

def get_latest_xml_root(zip_path):
    """Abre o ZIP e retorna o XML mais recente já parseado. Ignora arquivos corrompidos."""
    latest_time = ""
    latest_root = None
    
    with zipfile.ZipFile(zip_path, 'r') as z:
        xml_files = [f for f in z.namelist() if f.lower().endswith('.xml')]
        
        for xml_name in xml_files:
            with z.open(xml_name) as f:
                try:
                    tree = ET.parse(f)
                    root = tree.getroot()
                    
                    # Busca a tag de data de criação ignorando o namespace
                    cre_dt_tm = root.find('.//{*}CreDtTm')
                    dt_str = cre_dt_tm.text if cre_dt_tm is not None else xml_name
                    
                    if dt_str > latest_time:
                        latest_time = dt_str
                        latest_root = root
                        
                except ET.ParseError:
                    # Se o XML estiver pela metade ou corrompido, apenas avisa e pula para o próximo
                    print(f"\n  -> [Aviso] XML corrompido ignorado em {os.path.basename(zip_path)} ({xml_name})")
                    continue
                    
    return latest_root

def parse_b3_cadastro(root):
    """Mesmo tratamento de cadastro do lixo.ipynb usando wildcards de namespace."""
    data = []
    
    for instrm in root.findall('.//{*}Instrm'):
        # 1. Ticker
        ticker = None
        possible_ticker_paths = [
            './/{*}FutrCtrctsInf/{*}TckrSymb',
            './/{*}ExrcEqtsInf/{*}TckrSymb',
            './/{*}OptnOnSpotAndFutrsInf/{*}TckrSymb',
            './/{*}SctyId/{*}TckrSymb'
        ]
        for path in possible_ticker_paths:
            node = instrm.find(path)
            if node is not None:
                ticker = node.text
                break
        
        # 2. Vencimento (Maturity)
        maturity = None
        possible_date_paths = [
            './/{*}FutrCtrctsInf/{*}XprtnDt',   
            './/{*}ExrcEqtsInf/{*}TradgEndDt', 
            './/{*}OptnOnSpotAndFutrsInf/{*}XprtnDt', 
            './/{*}DerivInstrmAttrbts/{*}XpirtnDt'    
        ]
        for path in possible_date_paths:
            node = instrm.find(path)
            if node is not None:
                maturity = node.text
                break

        # 3. ID do Ativo (AssetID)
        asset_id_node = instrm.find('.//{*}FinInstrmId/{*}OthrId/{*}Id')
        asset_id = asset_id_node.text if asset_id_node is not None else None

        if ticker and ticker.startswith('DI1'):
            data.append({
                'Ticker': ticker,
                'AssetID': asset_id,
                'Maturity': maturity
            })

    df = pd.DataFrame(data)
    if not df.empty and 'Maturity' in df.columns:
        df['Maturity'] = pd.to_datetime(df['Maturity'], errors='coerce')
    return df

def parse_b3_precos(root):
    """Mesmo tratamento de preços do lixo.ipynb usando wildcards de namespace."""
    data = []
    
    for pric_rpt in root.findall('.//{*}PricRpt'):
        ticker_node = pric_rpt.find('.//{*}SctyId/{*}TckrSymb')
        ticker = ticker_node.text if ticker_node is not None else None

        if ticker and ticker.startswith('DI1'):
            trade_date_node = pric_rpt.find('.//{*}TradDt/{*}Dt')
            attrs = pric_rpt.find('.//{*}FinInstrmAttrbts')
            
            adjstdqt = None
            if attrs is not None:
                adj_node = attrs.find('.//{*}AdjstdQt')
                adjstdqt = adj_node.text if adj_node is not None else None

            data.append({
                'TradeDate': trade_date_node.text if trade_date_node is not None else None,
                'Ticker': ticker,
                'AdjstdQt': adjstdqt
            })

    df = pd.DataFrame(data)
    if not df.empty:
        df['TradeDate'] = pd.to_datetime(df['TradeDate'], errors='coerce')
        df['AdjstdQt'] = pd.to_numeric(df['AdjstdQt'], errors='coerce')
    return df


# --- FLUXO PRINCIPAL ---
zip_folder = 'B3_Zips'
output_name = 'DI_Historico_Consolidado.csv'

# --- CONFIGURAÇÃO DA DATA INICIAL ---
# Defina a data a partir da qual você quer começar a processar (Formato: YYYY-MM-DD)
DATA_INICIAL = '2024-10-01' 

all_data = []

if not os.path.exists(zip_folder):
    print(f"A pasta '{zip_folder}' não foi encontrada!")
else:
    # Identifica todas as datas baseadas no nome dos arquivos
    todas_datas = sorted({f.split('_')[0] for f in os.listdir(zip_folder) if f.endswith('.zip') and len(f.split('_')[0]) == 10})
    
    # Filtra apenas as datas a partir da DATA_INICIAL escolhida
    dates = [d for d in todas_datas if d >= DATA_INICIAL]
    
    print(f"Encontrados arquivos para {len(dates)} pregões a partir de {DATA_INICIAL}. Iniciando extração...\n")

    try:
        for date_str in tqdm(dates, desc="Processando XMLs"):
            in_file = next((os.path.join(zip_folder, f) for f in os.listdir(zip_folder) if f.startswith(date_str) and '_IN' in f), None)
            pr_file = next((os.path.join(zip_folder, f) for f in os.listdir(zip_folder) if f.startswith(date_str) and '_PR' in f), None)

            if in_file and pr_file:
                try:
                    # 1. Parse do Cadastro (IN)
                    root_in = get_latest_xml_root(in_file)
                    df_cad = parse_b3_cadastro(root_in) if root_in is not None else pd.DataFrame()
                    
                    # 2. Parse dos Preços (PR)
                    root_pr = get_latest_xml_root(pr_file)
                    df_precos = parse_b3_precos(root_pr) if root_pr is not None else pd.DataFrame()

                    # 3. Merge e Tratamento
                    if not df_cad.empty and not df_precos.empty:
                        df_merged = pd.merge(df_cad, df_precos[['Ticker', 'AdjstdQt']], on='Ticker', how='left')
                        
                        df_merged.sort_values(by='Maturity', inplace=True)
                        df_merged.dropna(subset=['AdjstdQt', 'Maturity'], inplace=True)
                        df_merged['Data_Referencia'] = pd.to_datetime(date_str)
                        
                        if 'AssetID' in df_merged.columns:
                            df_merged.drop(columns=['AssetID'], inplace=True)

                        all_data.append(df_merged)

                except Exception as e:
                    print(f"\nErro no pregão {date_str}: {e}")

    except KeyboardInterrupt:
        print("\n\n[!] Execução interrompida pelo usuário! Salvando os dados processados até agora...")

    # --- SALVAMENTO DOS DADOS (INCREMENTAL) ---
    if all_data:
        df_lote = pd.concat(all_data, ignore_index=True)
        df_lote.sort_values(by=['Data_Referencia', 'Maturity'], inplace=True)
        
        # Verifica se o arquivo final já existe para não escrever o cabeçalho novamente
        arquivo_existe = os.path.isfile(output_name)
        
        # O mode='a' (append) anexa os dados no final do arquivo sem sobrescrever
        df_lote.to_csv(output_name, mode='a', index=False, header=not arquivo_existe)
        
        print(f"\nSucesso! Lote com {len(df_lote)} registros foi adicionado ao arquivo '{output_name}'.")
    else:
        print("\nNenhum dado válido pôde ser extraído neste lote.")