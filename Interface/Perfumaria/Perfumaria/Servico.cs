using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Perfumaria
{
	[Serializable()]
	class Servico
	{
		private int id;
		private double preco;
		private String tipo;





		public Servico() : base()
		{
		}

		public int Id { get => id; set => id = value; }
		public double Preco { get => preco; set => preco = value; }
		public string Tipo { get => tipo; set => tipo = value; }
	}
}
