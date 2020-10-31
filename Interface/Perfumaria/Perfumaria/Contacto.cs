using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Perfumaria
{
	[Serializable()]
	class Contacto
	{
		private int id;
		private bool predefinido;
		private String telemovel;
		private String codigopostal;
		private String pais;
		private String endereco;
		private String apartamento;
		private String localidade;





		public Contacto() : base()
		{
		}

		public int Id { get => id; set => id = value; }

		public bool Default { get => predefinido; set => predefinido = value; }
		public string Telemovel { get => telemovel; set => telemovel = value; }
		public string Codigopostal { get => codigopostal; set => codigopostal = value; }
		public string Pais { get => pais; set => pais = value; }
		public string Endereco { get => endereco; set => endereco = value; }
		public string Apartamento { get => apartamento; set => apartamento = value; }
		public string Localidade { get => localidade; set => localidade = value; }
	}
}
