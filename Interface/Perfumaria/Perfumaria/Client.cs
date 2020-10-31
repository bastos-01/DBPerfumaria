using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Perfumaria
{
	[Serializable()]
	class Client
    {
			private String email;
			private String contribuinte;
			private String fname;
			private String lname;
			private bool sexo;
			private String dataNasc;
			private String foto;
			private int contacto_default_id;
			private int pontos;
			private bool newsletter;
			private String pagamento;
			private bool deleted;


		public String Email
		{
			get { return email; }
			set { email = value; }
		}

		public bool Deleted
		{
			get { return deleted; }
			set { deleted = value; }
		}

		public String Contribuinte
		{
			get { return contribuinte; }
			set { contribuinte = value; }
		}

		public String Fname
		{
			get { return fname; }
			set { fname = value; }
		}

		public String Foto
		{
			get { return foto; }
			set { foto = value; }
		}

		public String Lname
		{
			get { return lname; }
			set { lname = value; }
		}

		public bool Sexo
		{
			get { return sexo; }
			set { sexo = value; }
		}

		public String DataNasc
		{
			get { return dataNasc; }
			set { dataNasc = value; }
		}

		public int Pontos
		{
			get { return pontos; }
			set { pontos = value; }
		}

		public bool Newsletter
		{
			get { return newsletter; }
			set { newsletter = value; }
		}

		public int ContactoDefault
		{
			get { return contacto_default_id; }
			set { contacto_default_id = value; }
		}

		public String Pagamento
		{
			get { return pagamento; }
			set { pagamento = value; }
		}



		public Client() : base()
			{
			}

		}
	}

