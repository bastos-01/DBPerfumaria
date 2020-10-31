using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Perfumaria
{
	[Serializable()]
	class Compra
	{
		private String pagamento;
		private String contribuinte;
		private String cliente;
		private String funcionario;
		private int numero;
		private String datacompra;
		private int pontosgastos;
		private int pontosacumulados;
		private String rating;
		private String observacao;
		private String rastreamento;
		private bool presente;
		private int contactoid;



		

		public Compra() : base()
		{
		}

		public string Pagamento { get => pagamento; set => pagamento = value; }
		public string Contribuinte { get => contribuinte; set => contribuinte = value; }
		public string Funcionario { get => funcionario; set => funcionario = value; }
		public int Numero { get => numero; set => numero = value; }
		public string Datacompra { get => datacompra; set => datacompra = value; }
		public int Pontosgastos { get => pontosgastos; set => pontosgastos = value; }
		public int Pontosacumulados { get => pontosacumulados; set => pontosacumulados = value; }
		public string Rating { get => rating; set => rating = value; }
		public string Observacao { get => observacao; set => observacao = value; }
		public string Rastreamento { get => rastreamento; set => rastreamento = value; }
		public bool Presente { get => presente; set => presente = value; }
		public int Contactoid { get => contactoid; set => contactoid = value; }
		public string Cliente { get => cliente; set => cliente = value; }
	}
}
