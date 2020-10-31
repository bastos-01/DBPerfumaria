using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Perfumaria
{
	[Serializable()]
	class Produto
    {
		private int id;
		private double preco;
		private String familiaolfativa;
		private String categoria;
		private String nome;
		private String marca;
		private String linha;
		private int tamanho;
		private String descricao;
		private String imagem;
		private int stock;
		private String destinatario;
		private bool deleted;
		private int unidades;



		public Produto() : base()
			{
			}

		public int Id { get => id; set => id = value; }
		public double Preco { get => preco; set => preco = value; }
		public string Familiaolfativa { get => familiaolfativa; set => familiaolfativa = value; }
		public string Categoria { get => categoria; set => categoria = value; }
		public string Nome { get => nome; set => nome = value; }
		public string Marca { get => marca; set => marca = value; }
		public string Linha { get => linha; set => linha = value; }
		public int Tamanho { get => tamanho; set => tamanho = value; }
		public string Descricao { get => descricao; set => descricao = value; }
		public string Imagem { get => imagem; set => imagem = value; }
		public int Stock { get => stock; set => stock = value; }
		public string Destinatario { get => destinatario; set => destinatario = value; }
		public bool Deleted { get => deleted; set => deleted = value; }
		public int Unidades { get => unidades; set => unidades = value; }
	}
	}

