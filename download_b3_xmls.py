import requests
import zipfile
import io
import pandas as pd
import xml.etree.ElementTree as ET
from datetime import datetime, timedelta
from pathlib import Path
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class B3DataProcessor:
    def __init__(self):
        self.base_url = "https://www.b3.com.br/pesquisapregao/download?filelist="
        self.headers = {"User-Agent": "Mozilla/5.0"}
        # Pasta onde os ZIPs serão salvos
        self.zip_folder = Path('B3_Zips')
        self.zip_folder.mkdir(parents=True, exist_ok=True)

    def get_latest_xml_content(self, zip_data):
        """
        Lê um ZIP e retorna o conteúdo do XML mais recente se houver vários.
        """
        latest_xml = None
        latest_time = ""

        with zipfile.ZipFile(io.BytesIO(zip_data)) as z:
            xml_files = [f for f in z.namelist() if f.lower().endswith('.xml')]
            
            for xml_name in xml_files:
                with z.open(xml_name) as f:
                    content = f.read()
                    tree = ET.parse(io.BytesIO(content))
                    root = tree.getroot()
                    ns = {'n': root.tag.split('}')[0].strip('{')} if '}' in root.tag else {}
                    
                    # Busca a data de criação no cabeçalho do XML
                    cre_dt_tm = root.find(".//n:CreDtTm", ns)
                    dt_str = cre_dt_tm.text if cre_dt_tm is not None else xml_name
                    
                    if dt_str > latest_time:
                        latest_time = dt_str
                        latest_xml = (xml_name, content, ns)
        
        return latest_xml

    def process_day(self, date_obj):
        date_b3 = date_obj.strftime("%y%m%d")
        url = f"{self.base_url}PR{date_b3}.zip,IN{date_b3}.zip"
        
        inst_data = {}
        price_data = {}

        try:
            response = requests.get(url, headers=self.headers, timeout=30)
            if response.status_code != 200 or len(response.content) < 500:
                logger.info(f"Sem arquivo disponível em {date_obj.strftime('%d/%m/%Y')} (status {response.status_code})")
                return None

            # Salva o ZIP externo recebido (pesquisapregao.zip) com a data
            outer_name = f"{date_obj.strftime('%Y-%m-%d')}_pesquisapregao.zip"
            outer_path = self.zip_folder / outer_name
            with open(outer_path, 'wb') as f:
                f.write(response.content)
            logger.info(f"Salvo outer ZIP: {outer_path}")

            # 1. Abre o ZIP principal (pesquisa-pregao.zip) e salva os ZIPs internos
            with zipfile.ZipFile(io.BytesIO(response.content)) as outer_zip:
                for inner_zip_name in outer_zip.namelist():
                    inner_zip_data = outer_zip.read(inner_zip_name)
                    # salva o ZIP interno com prefixo da data (usa apenas o nome do arquivo interno)
                    inner_basename = Path(inner_zip_name).name
                    inner_path = self.zip_folder / f"{date_obj.strftime('%Y-%m-%d')}_{inner_basename}"
                    with open(inner_path, 'wb') as f:
                        f.write(inner_zip_data)
                    logger.info(f"Salvo inner ZIP: {inner_path}")

                    # 2. Processa o conteúdo do ZIP interno (IN ou PR)
                    result = self.get_latest_xml_content(inner_zip_data)
                    if not result:
                        continue
                    
                    xml_name, xml_content, ns = result
                    root = ET.fromstring(xml_content)

                    # Extração DI1
                    if "BVBG.028" in xml_name: # Instruments
                        for inst in root.findall(".//n:Instrm", ns):
                            symb = inst.find(".//n:TckrSymb", ns)
                            expiry = inst.find(".//n:XpryDt", ns)
                            if symb is not None and expiry is not None and symb.text.startswith("DI1"):
                                inst_data[symb.text] = expiry.text
                                
                    elif "BVBG.086" in xml_name: # Price Report
                        for rpt in root.findall(".//n:PricRpt", ns):
                            symb = rpt.find(".//n:TckrSymb", ns)
                            settl = rpt.find(".//n:SettlPric", ns)
                            if symb is not None and settl is not None and symb.text.startswith("DI1"):
                                price_data[symb.text] = settl.text

            # Merge
            day_results = []
            for ticker, expiry in inst_data.items():
                if ticker in price_data:
                    day_results.append({
                        "Data_Pregao": date_obj.strftime("%d/%m/%Y"),
                        "Ticker": ticker,
                        "Vencimento": expiry,
                        "Ajuste_Taxa": price_data[ticker]
                    })
            return day_results

        except Exception as e:
            logger.error(f"Erro em {date_obj.strftime('%d/%m/%Y')}: {e}")
            return None

    def run(self, start, end):
        current = datetime.strptime(start, "%d/%m/%Y")
        stop = datetime.strptime(end, "%d/%m/%Y")
        final_list = []
        output_file = Path("DI_B3_Final.csv")

        # carrega arquivo existente para continuar se necessário
        if output_file.exists():
            try:
                df_existing = pd.read_csv(output_file, sep=';')
                for _, row in df_existing.iterrows():
                    final_list.append(row.to_dict())
                logger.info(f"Carregados {len(final_list)} registros do arquivo existente.")
            except Exception as e:
                logger.warning(f"Falha ao carregar arquivo existente: {e}")

        try:
            while current <= stop:
                if current.weekday() < 5:
                    try:
                        res = self.process_day(current)
                        if res:
                            final_list.extend(res)
                            logger.info(f"Sucesso: {current.strftime('%d/%m/%Y')} | Contratos: {len(res)}")

                            # salvar progresso imediatamente após cada dia bem sucedido
                            pd.DataFrame(final_list).to_csv(output_file, index=False, sep=';')
                            logger.info(f"Progresso salvo ({len(final_list)} registros)")
                    except Exception as e:
                        logger.error(f"Erro geral no dia {current.strftime('%d/%m/%Y')}: {e}")
                current += timedelta(days=1)
        except KeyboardInterrupt:
            logger.info("Processo interrompido pelo teclado. Salvando progresso e saindo...")
        
        # fim do try/except loop

        if final_list:
            # salvar novamente ao final
            pd.DataFrame(final_list).to_csv(output_file, index=False, sep=';')
            logger.info("Processo finalizado. Arquivo 'DI_B3_Final.csv' gerado.")

if __name__ == "__main__":
    processor = B3DataProcessor()
    processor.run("21/06/2024", "27/02/2026")