using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Perfumaria
{


    public partial class Cliente : Form
    {
        private SqlConnection cn;
        private Client C = new Client();
        private Compra Compra = new Compra();
        private Contacto Contacto = new Contacto();
        List<Contacto> ContactosList = new List<Contacto>();
        List<Produto> ProdutosList = new List<Produto>();
        List<Produto> Carrinho = new List<Produto>();
        List<Servico> ServicesList = new List<Servico>();
        List<String> FuncMailList = new List<String>();
        bool typeofbuy;
        bool active;
        int selectedProductIndex;

        public Cliente()
        {
            InitializeComponent();
            tabControl1.SelectedIndexChanged += new EventHandler(tabControl1_SelectedIndexChanged);
            tabControl2.SelectedIndexChanged += new EventHandler(tabControl2_SelectedIndexChanged);
            historico.SelectedIndexChanged += new EventHandler(historico_SelectedIndexChanged);
            marcacoes.SelectedIndexChanged += new EventHandler(marcacoes_SelectedIndexChanged);
            onlinetab.SelectedIndexChanged += new EventHandler(onlinetab_SelectedIndexChanged);
            offlinetab.SelectedIndexChanged += new EventHandler(offlinetab_SelectedIndexChanged);
            pesquisa.GotFocus += new EventHandler(RemoveText);
            pesquisa.LostFocus += new EventHandler(AddText);
            cupontextbox.GotFocus += new EventHandler(RemoveText);
            cupontextbox.LostFocus += new EventHandler(AddText);
        }

    



    private void Cliente_Load(object sender, EventArgs e)
        {

            cn = getSGBDConnection();

            if (verifySGBDConnection())
            {
                loadInfo(Program.ClientMail);
                showMainInfo();
            }

            cn.Close();

            


        }

        private SqlConnection getSGBDConnection()
        {
            String dbServer = "tcp:mednat.ieeta.pt\\SQLSERVER,8101";
            String dbName = "p6g1";
            String userName = "p6g1";
            String userPass = "almeidapaiva1@Bd";
            return new SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName + "; uid = " + userName + ";" + "password = " + userPass);
        }

        private bool verifySGBDConnection()
        {
            if (cn == null)
                cn = getSGBDConnection();

            if (cn.State != ConnectionState.Open)
                cn.Open();

            return cn.State == ConnectionState.Open;
        }

        private void showMainInfo()
        {
            emailbox.Text = C.Email;
            namebox.Text = C.Fname;
            lnamebox.Text = C.Lname;
            if (C.Newsletter)
                newsletter.Checked = true;
            else
                newsletter.Checked = false;
            pontosbox.Text = C.Pontos.ToString();
            selectPayment();
            pictureBox1.Load(C.Foto);
            pictureBox1.SizeMode = PictureBoxSizeMode.StretchImage;

        }

        public void selectPayment()
        {

            switch (C.Pagamento)
            {
                case "Paypal":
                    pagamentobox.SelectedIndex = 0;
                    break;
                case "MasterCard":
                    pagamentobox.SelectedIndex = 1;
                    break;
                case "Visa":
                    pagamentobox.SelectedIndex = 2;
                    break;
                case "MB Way":
                    pagamentobox.SelectedIndex = 3;
                    break;
                default:
                    pagamentobox.ResetText();
                    pagamentobox.SelectedIndex = -1;
                    break;
            }

        }

        private void loadInfo(String mail)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getClientInfo ('" + mail + "')", cn);
            SqlDataReader reader = cmd.ExecuteReader();

            reader.Read();

            C.Email = reader["email"].ToString();
            C.Contribuinte = reader["contribuinte"].ToString();
            C.Fname = reader["fname"].ToString();
            C.Lname = reader["lname"].ToString();
            C.Sexo = (bool)reader["sexo"];
            C.DataNasc = reader["dataNasc"].ToString();
            if (!DBNull.Value.Equals(reader["contacto_default_id"]))
                C.ContactoDefault = (int)reader["contacto_default_id"];
            C.Pontos = (int)reader["pontos"];
            C.Newsletter = (bool)reader["newsletter"];
            C.Pagamento = reader["pagamento"].ToString();
            C.Foto = reader["foto"].ToString();

            cn.Close();

        }

        private void button1_Click(object sender, EventArgs e)
        {
            changepw.Visible = true;
        }

        private void cancel_Click(object sender, EventArgs e)
        {
            changepw.Visible = false;
        }

        private void change_Click(object sender, EventArgs e)
        {
            changepw.Visible = false;
            if (pw2.Text.Equals(confirmpw2.Text))
            {
                if (!verifySGBDConnection())
                    return;

                SqlCommand cmd = new SqlCommand("perf.updateClient", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@email", C.Email);
                cmd.Parameters.AddWithValue("@password", confirmpw2.Text);
                cmd.Parameters.Add("@responseMsg", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

                String rm = "";

                try
                {
                    cmd.ExecuteNonQuery();
                    rm = cmd.Parameters["@responseMsg"].Value.ToString();

                }
                catch (Exception ex)
                {
                    throw new Exception("Failed to Execute.");
                }
                finally
                {

                    MessageBox.Show(rm);


                }


                cn.Close();

            }
            else
                MessageBox.Show("Palavra-Passes diferentes!");
        }

        // TAB PRINCIPAL
        private void tabControl1_SelectedIndexChanged(Object sender, EventArgs e)
        {

            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    tabControl2_SelectedIndexChanged(tabControl2, null);
                    break;
                case 1:
                    historico_SelectedIndexChanged(historico, null);
                    break;
                case 2:
                    getProductsProperties();
                    orderdescasc.SelectedIndex = 0;
                    orderby.SelectedIndex = 0;
                    categoriacombo.SelectedIndex = 0;
                    marcacombo.SelectedIndex = 0;
                    searchProducts();
                    lojagrid.DataSource = ProdutosList.Select(o => new
                    {Nome = o.Nome, Marca = o.Marca, Categoria = o.Categoria, Destinatário = o.Destinatario, Preço = o.Preco }).ToList();
                    break;
                case 3:
                    marcacoes_SelectedIndexChanged(marcacoes, null);
                    break;
                case 4:
                    cupoespontos.Text = C.Pontos.ToString();
                    cupoesgrid.DataSource = getClientCupons();
                    break;
                case 5:
                    getClientFavourites();
                    Favourites.DataSource = ProdutosList.Select(o => new
                    { Nome = o.Nome, Marca = o.Marca, Categoria = o.Categoria, Destinatário = o.Destinatario, Preço = o.Preco }).ToList();
                    break;
                case 6:
                    int countunit = 0;
                    double countprice = 0;
                    foreach (Produto p in Carrinho) { 
                        countunit += p.Unidades;
                        countprice += p.Unidades * p.Preco;
                            }
                    itemscarrinho.Text = countunit.ToString();
                    totalcarrinho.Text = countprice.ToString() + " €";
                    carrinhogrid.DataSource = Carrinho.Select(o => new
                    { Nome = o.Nome, Marca = o.Marca, Categoria = o.Categoria, Preço = o.Preco, Unidades = o.Unidades }).ToList();
                    break;

            }
        }

        //TAB MAIN INFORMÇÕES CLIENTE
        private void tabControl2_SelectedIndexChanged(Object sender, EventArgs e)
        {
            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    loadInfo(C.Email);
                    showMainInfo();
                    break;
                case 1:
                    getClientContacts();
                    contactsgrid.DataSource = ContactosList.Select(o => new
                    { Predefinido = o.Default, Telemóvel = o.Telemovel, CódigoPostal = o.Codigopostal, País = o.Pais, Endereço = o.Endereco, Apartamento = o.Apartamento, Localidade = o.Localidade }).ToList();
                    break;
            }
        }

        private void historico_SelectedIndexChanged(Object sender, EventArgs e)
        {
            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    buyHistory.DataSource = getClientBuyHistory();
                    if(!typeofbuy && active)
                        onlinetab_SelectedIndexChanged(onlinetab, null);
                    else if(typeofbuy && active)
                        offlinetab_SelectedIndexChanged(offlinetab, null);
                    break;
                case 1:
                    servicosgrid.DataSource = getClientServicesHistory();
                    break;
            }

            
        }

        private void marcacoes_SelectedIndexChanged(Object sender, EventArgs e)
        {
            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    datamarc.Format = DateTimePickerFormat.Custom;
                    datamarc.CustomFormat = "yyyy-MM-dd HH:mm:ss";
                    datamarc.MinDate = DateTime.Now;
                    getServicos();
                    break;
                case 1:
                    futureMarcGrid.DataSource = getClientFutureMarc();
                    break;
            }


        }

        private void getServicos()
        {

            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getServicesType ()", cn);

            SqlDataReader reader = cmd.ExecuteReader();
            comboservico.SelectedIndex = -1;
            comboservico.Items.Clear();
            funcombo.SelectedIndex = -1;
            ServicesList.Clear();
            while (reader.Read())
            {
                Servico s = new Servico();
                s.Tipo = (reader["tipo"].ToString());
                comboservico.Items.Add(s.Tipo);
                s.Preco = (Convert.ToDouble(reader["preco"]));
                s.Id = (int)(reader["id"]);
                ServicesList.Add(s);
            };

            cn.Close();
        }

        private void onlinetab_SelectedIndexChanged(Object sender, EventArgs e)
        {
            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    compraOnlineDetalhes();
                    break;
                case 1:
                    getCompraProducts();
                    compraonlinegrid.DataSource = ProdutosList.Select(o => new
                    { Nome = o.Nome, Marca = o.Marca, Categoria = o.Categoria, Preço = o.Preco, Unidades = o.Unidades }).ToList();
                    break;
            }


        }

        private void offlinetab_SelectedIndexChanged(Object sender, EventArgs e)
        {
            switch ((sender as TabControl).SelectedIndex)
            {
                case 0:
                    compraPresencialDetalhes();
                    break;
                case 1:
                    getCompraProducts();
                    compraofflinegrid.DataSource = ProdutosList.Select(o => new
                    { Nome = o.Nome, Marca = o.Marca, Categoria = o.Categoria, Preço = o.Preco, Unidades = o.Unidades }).ToList();
                    break;
            }


        }


        private void getProductsProperties()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT DISTINCT marca FROM perf.getAllProducts ()", cn);

            SqlDataReader reader = cmd.ExecuteReader();
            marcacombo.Items.Clear();
            marcacombo.Items.Add("Todos");
            while (reader.Read())
            {
                marcacombo.Items.Add(reader["marca"].ToString());
            };

            reader.Close();

            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            cmd = new SqlCommand("SELECT DISTINCT categoria FROM perf.getAllProducts ()", cn);

            reader = cmd.ExecuteReader();

            categoriacombo.Items.Clear();
            categoriacombo.Items.Add("Todos");
            while (reader.Read())
            {
                categoriacombo.Items.Add(reader["categoria"].ToString());
            };

            reader.Close();

            cn.Close();
        }

        private DataTable getClientBuyHistory()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.clientBuyHistory ('" + C.Email + "')", cn);
   
            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;  

        }

        private DataTable getClientCupons()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getClientCupon ('" + C.Email + "')", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;

        }

        private DataTable getClientServicesHistory()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.clientServicesHistory ('" + C.Email + "')", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;

        }

        private void getClientContacts()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmdDefault = new SqlCommand("SELECT * FROM perf.clientDefaultContact ('" + C.Email + "')", cn);
            SqlDataReader readerdef = cmdDefault.ExecuteReader();
            readerdef.Read();
            int contactid = -1;
            try
            {
               contactid = (int)readerdef["id"];
            }
            catch (InvalidOperationException)
            {
            }

            cn.Close();

            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.clientContacts ('" + C.Email + "')", cn);

            SqlDataReader reader = cmd.ExecuteReader();
            ContactosList.Clear();

            while (reader.Read())
            {
                Contacto C = new Contacto();
                C.Id = (int)reader["id"];
                if (contactid == C.Id)
                    C.Default = true;
                else
                    C.Default = false;
                C.Telemovel = reader["telemovel"].ToString();
                C.Codigopostal = reader["codigo_postal"].ToString();
                C.Pais = reader["pais"].ToString();
                C.Endereco = reader["endereco"].ToString();
                C.Apartamento = reader["apartamento"].ToString();
                C.Localidade = reader["localidade"].ToString();
   
                ContactosList.Add(C);
            }


            cn.Close();

        }



        private DataTable getClientFutureMarc()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.clientFutureMarc ('" + C.Email + "')", cn);

            SqlDataAdapter sqlDataAdap = new SqlDataAdapter(cmd);

            DataTable dtRecord = new DataTable();
            sqlDataAdap.Fill(dtRecord);
            cn.Close();
            return dtRecord;
        }

        private void getClientFavourites()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.clientFavourites ('" + C.Email + "')", cn);

            ProdutosList.Clear();

            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {

                Produto P = new Produto();

                P.Id = (int)reader["id"];
                P.Preco = (double)reader["preco"];
                if (!DBNull.Value.Equals(reader["tamanho"]))
                    P.Familiaolfativa = reader["familiaolfativa"].ToString();
                P.Categoria = reader["categoria"].ToString();
                P.Nome = reader["nome"].ToString();
                P.Marca = reader["marca"].ToString();
                P.Linha = reader["linha"].ToString();
                if (!DBNull.Value.Equals(reader["tamanho"]))
                    P.Tamanho = Convert.ToInt16(reader["tamanho"]);
                P.Descricao = reader["descricao"].ToString();
                P.Imagem = reader["imagem"].ToString();
                P.Stock = Convert.ToInt16(reader["stock"]);
                P.Destinatario = reader["destinatario"].ToString();

                ProdutosList.Add(P);
            }
            cn.Close();

        }

        private void getCompraProducts()
        {
            if (!verifySGBDConnection())
                throw new Exception("Failed to connect to database. \n ERROR");

            SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getProductsFromBuy ('" + Compra.Numero + "')", cn);

            SqlDataReader reader = cmd.ExecuteReader();


            ProdutosList.Clear();

            while (reader.Read())
            {

                Produto P = new Produto();

                P.Id = (int)reader["id"];
                P.Preco = (double)reader["preco"];
                if (!DBNull.Value.Equals(reader["tamanho"]))
                    P.Familiaolfativa = reader["familiaolfativa"].ToString();
                P.Categoria = reader["categoria"].ToString();
                P.Nome = reader["nome"].ToString();
                P.Marca = reader["marca"].ToString();
                P.Linha = reader["linha"].ToString();
                if (!DBNull.Value.Equals(reader["tamanho"]))
                    P.Tamanho = Convert.ToInt16(reader["tamanho"]);
                P.Descricao = reader["descricao"].ToString();
                P.Imagem = reader["imagem"].ToString();
                P.Stock = Convert.ToInt16(reader["stock"]);
                P.Destinatario = reader["destinatario"].ToString();
                P.Deleted = (bool)reader["deleted"];
                P.Unidades = (int)reader["unidades"];

                ProdutosList.Add(P);
            }

            cn.Close();
            
        }

        private void buyHistory_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            // Ignore clicks that are not in our 
            if (e.ColumnIndex == buyHistory.Columns["Detalhes"].Index && e.RowIndex >= 0)
            {
                selectPanel((int)buyHistory.Rows[e.RowIndex].Cells[3].Value);
                
            }

        }

        private void lojagrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            // Ignore clicks that are not in our 
            if (e.ColumnIndex == 0 && e.RowIndex >= 0)
            {
                selectedProductIndex = e.RowIndex;
                Produto p = ProdutosList.ElementAt(e.RowIndex);
                Produto.Visible = true;
                fotoproduto.Load(p.Imagem);
                fotoproduto.SizeMode = PictureBoxSizeMode.StretchImage;
                descricaoproduto.Text = p.Descricao;
                nomeproduto.Text = p.Nome;
                marcaproduto.Text = p.Marca;
                categoriaproduto.Text = p.Categoria;
                linhaproduto.Text = p.Linha;
                tamanhoproduto.Text = p.Tamanho.ToString();
                familiaproduto.Text = p.Familiaolfativa;
                destinatarioproduto.Text = p.Destinatario;
                precoproduto.Text = p.Preco.ToString() + "€";


            }

        }

        private void compraonlinegrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            // Ignore clicks that are not in our 
            if (e.ColumnIndex == 0 && e.RowIndex >= 0)
            {
                active = true;
                selectedProductIndex = e.RowIndex;
                Produto p = ProdutosList.ElementAt(e.RowIndex);
                compraonline.Visible = false;
                produtocompra.Visible = true;
                produtofoto.Load(p.Imagem);
                produtofoto.SizeMode = PictureBoxSizeMode.StretchImage;
                produtodescricao.Text = p.Descricao;
                produtonome.Text = p.Nome;
                produtomarca.Text = p.Marca;
                produtocategoria.Text = p.Categoria;
                produtolinha.Text = p.Linha;
                produtotamanho.Text = p.Tamanho.ToString();
                produtofamilia.Text = p.Familiaolfativa;
                produtodestinatario.Text = p.Destinatario;
                produtopreco.Text = p.Preco.ToString() + "€";


            }

        }

        private void compraofflinegrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            // Ignore clicks that are not in our 
            if (e.ColumnIndex == 0 && e.RowIndex >= 0)
            {
                active = true;
                selectedProductIndex = e.RowIndex;
                Produto p = ProdutosList.ElementAt(e.RowIndex);
                compraoffline.Visible = false;
                produtocompra.Visible = true;
                produtofoto.Load(p.Imagem);
                produtofoto.SizeMode = PictureBoxSizeMode.StretchImage;
                produtodescricao.Text = p.Descricao;
                produtonome.Text = p.Nome;
                produtomarca.Text = p.Marca;
                produtocategoria.Text = p.Categoria;
                produtolinha.Text = p.Linha;
                produtotamanho.Text = p.Tamanho.ToString();
                produtofamilia.Text = p.Familiaolfativa;
                produtodestinatario.Text = p.Destinatario;
                produtopreco.Text = p.Preco.ToString() + "€";
            }
        }




        private void selectPanel(int compra)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("perf.getDetailsFromBuy", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@numero", compra);
            

            try
            {
                SqlDataReader reader = cmd.ExecuteReader();

                reader.Read();
                

                Compra.Pagamento = reader["pagamento"].ToString();
                Compra.Contribuinte = reader["contribuinte"].ToString();
                Compra.Numero = (int)reader["numero"];
                Compra.Datacompra = reader["datacompra"].ToString();


                if (reader.GetName(2).Equals("fname", StringComparison.InvariantCultureIgnoreCase))
                {
                    Compra.Funcionario = reader["fname"].ToString();
                    compraPresencialDetalhes();
                    
                } else
                {

                Compra.Rating = reader["rating"].ToString();
                Compra.Observacao = reader["observacao"].ToString();
                Compra.Rastreamento = reader["rastreamento"].ToString();
                Compra.Presente = (bool)reader["presente"];
                Contacto.Telemovel = reader["telemovel"].ToString();
                Contacto.Codigopostal = reader["codigo_postal"].ToString();
                Contacto.Endereco = reader["endereco"].ToString();
                    if (reader["pontosacumulados"] != DBNull.Value)
                    {
                        Compra.Pontosacumulados = (int)reader["pontosacumulados"];
                    }
                    if (reader["pontosgastos"] != DBNull.Value)
                    {
                        Compra.Pontosgastos = (int)reader["pontosgastos"];
                    }
                    
                compraOnlineDetalhes();
                }


            }
            catch (Exception ex)
            {
                throw new Exception("Failed to get Compra. \n ERROR MESSAGE: \n" + ex.Message);
            }
           
           

            cn.Close();

        }

        public void compraPresencialDetalhes()
        {
            typeofbuy = true;
            compraoffline.Visible = true;
            datacompraoff.Text = Compra.Datacompra;
            numcompraoff.Text = Compra.Numero.ToString();
            funcionariocompraoff.Text = Compra.Funcionario;
            contribuintecompraoff.Text = Compra.Contribuinte;
            pagamentocompraoff.Text = Compra.Pagamento;
        }

        public void compraOnlineDetalhes()
        {
            typeofbuy = false;
            compraonline.Visible = true;
            datacompraon.Text = Compra.Datacompra;
            numerocompraon.Text = Compra.Numero.ToString();
            if(!String.IsNullOrEmpty(Compra.Rating))
                rating.SelectedIndex = (int)(Int32.Parse(Compra.Rating) - 1);
            telmcompraon.Text = Contacto.Telemovel;
            enderecocompraon.Text = Contacto.Endereco;
            postalcompraon.Text = Contacto.Codigopostal;
            observacaocompraon.Text = Compra.Observacao;
            presentecompraon.Checked = (bool)Compra.Presente;
            rastreamentocompraon.Text = Compra.Rastreamento;
            contribuintecompraon.Text = Compra.Contribuinte;
            pagamentocompraon.Text = Compra.Pagamento;


        }

        private void fecharonline_Click(object sender, EventArgs e)
        {
            compraonline.Visible = false;
        }


        private void fecharoffline_Click_1(object sender, EventArgs e)
        {
            compraoffline.Visible = false;
        }

        public void RemoveText(object sender, EventArgs e)
        {
            if (pesquisa.Text == "Pesquisar...")
            {
                pesquisa.Text = "";
            }

            if (cupontextbox.Text == "Inserir Cupão...")
            {
                cupontextbox.Text = "";
            }
        }

        public void AddText(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(pesquisa.Text))
                pesquisa.Text = "Pesquisar...";

            if (string.IsNullOrWhiteSpace(cupontextbox.Text))
                cupontextbox.Text = "Inserir Cupão...";
        }

        private void addcupon_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("perf.clientUsesCupon", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@cupao_id", cupontextbox.Text);
            cmd.Parameters.AddWithValue("@cliente_email", C.Email);
            cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

            String rm = "" ;

            try
            {
                cmd.ExecuteNonQuery();
                rm = cmd.Parameters["@responseMessage"].Value.ToString();

            }
            catch (Exception ex)
            {
                throw new Exception("Failed to login. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                if (rm.Equals("Success"))
                {
                    tabControl1_SelectedIndexChanged(tabControl1, null);
                    loadInfo(C.Email);
                    MessageBox.Show("Cupão Adicionado com sucesso!");
                }
                else
                    MessageBox.Show("Cupão Inválido!");
            }

            tabControl1_SelectedIndexChanged(tabControl1, null);
            cn.Close();
        }

        private void fecharproduto_Click(object sender, EventArgs e)
        {
            Produto.Visible = false;
        }

        private void searchProducts()
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("perf.getProductFilters", cn);
            cmd.CommandType = CommandType.StoredProcedure;

            if (!pesquisa.Text.Equals("") && !pesquisa.Text.Equals("Pesquisar..."))
            {
                cmd.Parameters.AddWithValue("@nome", pesquisa.Text);
            }

            if (marcacombo.SelectedIndex > 0)
            {
                cmd.Parameters.AddWithValue("@marca", marcacombo.SelectedItem.ToString());
            }

            if (categoriacombo.SelectedIndex > 0)
            {
                cmd.Parameters.AddWithValue("@categoria", categoriacombo.SelectedItem.ToString());
            }

            if (orderby.SelectedIndex > -1)
            {
                cmd.Parameters.AddWithValue("@orderby", orderby.SelectedItem.ToString());
            }

            if (orderdescasc.SelectedIndex > -1)
            {
                cmd.Parameters.AddWithValue("@ordem", orderdescasc.SelectedItem.ToString());
            }

            SqlDataReader reader = cmd.ExecuteReader();


            ProdutosList.Clear();

            while(reader.Read())
            {

                Produto P = new Produto();
                
                P.Id = (int)reader["id"];
                P.Preco = (double)reader["preco"];
                 if (!DBNull.Value.Equals(reader["tamanho"]))
                P.Familiaolfativa = reader["familiaolfativa"].ToString();
                P.Categoria = reader["categoria"].ToString();
                P.Nome = reader["nome"].ToString();
                P.Marca = reader["marca"].ToString();
                P.Linha = reader["linha"].ToString();
                if (!DBNull.Value.Equals(reader["tamanho"]))
                    P.Tamanho = Convert.ToInt16(reader["tamanho"]);
                P.Descricao = reader["descricao"].ToString();
                P.Imagem = reader["imagem"].ToString();
                P.Stock = Convert.ToInt16(reader["stock"]);
                P.Destinatario = reader["destinatario"].ToString();
                P.Deleted = (bool)reader["deleted"];

                ProdutosList.Add(P);
        }



        cn.Close();
        }

        private void search_Click(object sender, EventArgs e)
        {
            searchProducts();
            lojagrid.DataSource = ProdutosList.Select(o => new
            { Nome = o.Nome, Marca = o.Marca, Categoria = o.Categoria, Destinatário = o.Destinatario, Preço = o.Preco }).ToList();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            produtocompra.Visible = false;
            active = false;
            if (typeofbuy)
                compraoffline.Visible = true;
            else
                compraonline.Visible = true;
        }

        private void comboservico_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(comboservico.SelectedIndex >= 0)
            {
                if (!verifySGBDConnection())
                    throw new Exception("Failed to connect to database. \n ERROR");

                SqlCommand cmd = new SqlCommand("SELECT * FROM perf.getFuncService (" + ServicesList[comboservico.SelectedIndex].Id + ")", cn);

                SqlDataReader reader = cmd.ExecuteReader();
                funcombo.SelectedIndex = -1;
                funcombo.Items.Clear();

                FuncMailList.Clear();
                while (reader.Read()) {
                    funcombo.Items.Add(reader["fname"].ToString() + " " + reader["lname"].ToString());
                    FuncMailList.Add(reader["funcionario_email"].ToString());

                }
                
              
       

                precoservico.Text = ServicesList[comboservico.SelectedIndex].Preco.ToString() + "€";
                erroservico.Visible = false;
                

                cn.Close();
            }
            else {
                erroservico.Visible = true;
                precoservico.Text = "";
                funcombo.Items.Clear();
                funcombo.SelectedIndex = -1;
            }
                

        }

        private void marcarbutton_Click(object sender, EventArgs e)
        {

            if (comboservico.SelectedIndex > -1 && funcombo.SelectedIndex > -1)
            {
                if (!verifySGBDConnection())
                    return;

                SqlCommand cmd = new SqlCommand("perf.addMarc", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@cliente_email", C.Email);
                cmd.Parameters.AddWithValue("@servico_id", ServicesList[comboservico.SelectedIndex].Id);
                cmd.Parameters.AddWithValue("@funcionario_email", FuncMailList[funcombo.SelectedIndex]);
                cmd.Parameters.AddWithValue("@dataMarc", datamarc.Value);
                cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;
                
                cmd.ExecuteNonQuery();

               

                 MessageBox.Show(cmd.Parameters["@responseMessage"].Value.ToString());


                

                cn.Close();
            }
            else
                MessageBox.Show("Selecione as opções.");

            funcombo.SelectedIndex = -1;

        }


        private void button5_Click(object sender, EventArgs e)
        {

            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("perf.updateClient", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@fname", namebox.Text);
            cmd.Parameters.AddWithValue("@email", C.Email);
            cmd.Parameters.AddWithValue("@lname", lnamebox.Text);

            if(newsletter.Checked)
                cmd.Parameters.AddWithValue("@newsletter", 1);
            else
                cmd.Parameters.AddWithValue("@newsletter", 0);
            cmd.Parameters.AddWithValue("@pagamento", pagamentobox.Text);
            cmd.Parameters.Add("@responseMsg", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

            String rm = "";

            try
            {
                cmd.ExecuteNonQuery();
                rm = cmd.Parameters["@responseMsg"].Value.ToString();

            }
            catch (Exception ex)
            {
                throw new Exception("Failed to Execute");
            }
            finally
            {
                MessageBox.Show(rm);
            }


            cn.Close();

            tabControl2_SelectedIndexChanged(tabControl2, null);

        }

        private void contactsgrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == 0 && e.RowIndex >= 0)
            {
                if (!verifySGBDConnection())
                    return;

                SqlCommand cmd = new SqlCommand("perf.removeContact", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id", ContactosList[e.RowIndex].Id);
                cmd.Parameters.AddWithValue("@email", C.Email);


                cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

                String rm = "";

                try
                {
                    cmd.ExecuteNonQuery();
                    rm = cmd.Parameters["@responseMessage"].Value.ToString();

                }
                catch (Exception ex)
                {
                    throw new Exception("Failed to Execute");
                }
                finally
                {
                    MessageBox.Show(rm);
                    tabControl2_SelectedIndexChanged(tabControl2, null);
                }


                cn.Close();

            }

            if (e.ColumnIndex == 1 && e.RowIndex >= 0)
            {
                if (!verifySGBDConnection())
                    return;

                SqlCommand cmd = new SqlCommand("perf.changeDefaultContact", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id", ContactosList[e.RowIndex].Id);
                cmd.Parameters.AddWithValue("@email", C.Email);


                cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

                String rm = "";

                try
                {
                    cmd.ExecuteNonQuery();
                    rm = cmd.Parameters["@responseMessage"].Value.ToString();

                }
                catch (Exception ex)
                {
                    throw new Exception("Failed to Execute");
                }
                finally
                {
                    MessageBox.Show(rm);
                    tabControl2_SelectedIndexChanged(tabControl2, null);
                }


                cn.Close();

            }
        }

        private void contactcreate_Click(object sender, EventArgs e)
        {

            if (telele.Text.Length != 9)
                MessageBox.Show("O número de telemóvel necessita 9 dígitos!");
            else if(codigopostal.Text.Length != 8 && codigopostal.Text.IndexOf("-") == -1)
                MessageBox.Show("Formato do código-postal incorreto!");
            else if (!(country.Text.Length<=20 && country.Text.Length>0))
                MessageBox.Show("País necessita de ser entre 1 e 20 caractéres!");
            else  if (!(endereco.Text.Length <= 50 && endereco.Text.Length > 0))
                MessageBox.Show("Endereço necessita de ser entre 1 e 50 caractéres!");
            else if (!(apartment.Text.Length <= 50))
                MessageBox.Show("Apartamento necessita de ser entre 0 e 50 caractéres!");
            else if (!(locality.Text.Length <= 20 && locality.Text.Length > 0))
                MessageBox.Show("Localidade necessita de ser entre 1 e 20 caractéres!");
            else
            {
                if (!verifySGBDConnection())
                    return;

                SqlCommand cmd = new SqlCommand("perf.addContact", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@utilizador_email", C.Email);
                cmd.Parameters.AddWithValue("@telemovel", telele.Text);
                cmd.Parameters.AddWithValue("@codigo_postal", codigopostal.Text);
                cmd.Parameters.AddWithValue("@pais", country.Text);
                cmd.Parameters.AddWithValue("@endereco", endereco.Text);
                if (apartment.Text.Length > 0)
                    cmd.Parameters.AddWithValue("@apartamento", apartment.Text);
                cmd.Parameters.AddWithValue("@localidade", locality.Text);


                cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

                String rm = "";

                try
                {
                    cmd.ExecuteNonQuery();
                    rm = cmd.Parameters["@responseMessage"].Value.ToString();

                }
                catch (Exception ex)
                {
                    throw new Exception("Failed to Execute");
                }
                finally
                {
                    MessageBox.Show(rm);
                }


                cn.Close();
            }
        }

        private void button8_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("perf.clientAddFavourite", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@produtoid", ProdutosList[selectedProductIndex].Id);
            cmd.Parameters.AddWithValue("@clienteemail", C.Email);


            cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

            String rm = "";

            try
            {
                cmd.ExecuteNonQuery();
                rm = cmd.Parameters["@responseMessage"].Value.ToString();

            }
            catch (Exception ex)
            {
                throw new Exception("Failed to Execute");
            }
            finally
            {
                MessageBox.Show(rm);
            }


            cn.Close();

        }

        private void button9_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("perf.clientAddFavourite", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@produtoid", ProdutosList[selectedProductIndex].Id);
            cmd.Parameters.AddWithValue("@clienteemail", C.Email);


            cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

            String rm = "";

            try
            {
                cmd.ExecuteNonQuery();
                rm = cmd.Parameters["@responseMessage"].Value.ToString();

            }
            catch (Exception ex)
            {
                throw new Exception("Failed to Execute");
            }
            finally
            {
                MessageBox.Show(rm);
            }


            cn.Close();
        }

        private void unidades_ValueChanged(object sender, EventArgs e)
        {
            if (unidades.Value > ProdutosList[selectedProductIndex].Stock)
                semstock.Visible = true;
            else
                semstock.Visible = false;
        }

        private void numericUpDown1_ValueChanged(object sender, EventArgs e)
        {
            if (numericUpDown1.Value > ProdutosList[selectedProductIndex].Stock)
                semstoock.Visible = true;
            else
                semstoock.Visible = false;

        }

        private void carrinhobutton_Click(object sender, EventArgs e)
        {
            if (!semstoock.Visible && numericUpDown1.Value > 0)
            {
                Carrinho.RemoveAll(x => x.Id == ProdutosList[selectedProductIndex].Id);
                ProdutosList[selectedProductIndex].Unidades = (int)numericUpDown1.Value;
                Carrinho.Add(ProdutosList[selectedProductIndex]);
                MessageBox.Show("Adicionado com sucesso!");

            }
            else
                MessageBox.Show("Verifique as unidades!");
        }

        private void carrinhobutton2_Click(object sender, EventArgs e)
        {
            if (!semstock.Visible && unidades.Value>0)
            {
                Carrinho.RemoveAll(x => x.Id == ProdutosList[selectedProductIndex].Id);
                ProdutosList[selectedProductIndex].Unidades = (int)unidades.Value;
                Carrinho.Add(ProdutosList[selectedProductIndex]);
                MessageBox.Show("Adicionado com sucesso!");

            }
            else
                MessageBox.Show("Verifique as unidades!");
        }

        private void Favourites_CellContentClick_1(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == 0 && e.RowIndex >= 0)
            {
                if (!verifySGBDConnection())
                    return;

                SqlCommand cmd = new SqlCommand("perf.clientRemoveFavourite", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@produtoid", ProdutosList[e.RowIndex].Id);
                cmd.Parameters.AddWithValue("@clienteemail", C.Email);


                cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

                String rm = "";

                try
                {
                    cmd.ExecuteNonQuery();
                    rm = cmd.Parameters["@responseMessage"].Value.ToString();

                }
                catch (Exception ex)
                {
                    throw new Exception("Failed to Execute");
                }
                finally
                {
                    MessageBox.Show(rm);
                    tabControl1_SelectedIndexChanged(tabControl1, null);
                }


                cn.Close();

            } else if(e.ColumnIndex == 1 && e.RowIndex >=0 )
            {
                selectedProductIndex = e.RowIndex;
                Produto p = ProdutosList.ElementAt(e.RowIndex);
                comprafav.Visible = true;
                favpic.Load(p.Imagem);
                favpic.SizeMode = PictureBoxSizeMode.StretchImage;
                favdesc.Text = p.Descricao;
                favnome.Text = p.Nome;
                favmarca.Text = p.Marca;
                favcategoria.Text = p.Categoria;
                favlinha.Text = p.Linha;
                favtamanho.Text = p.Tamanho.ToString();
                favfamilia.Text = p.Familiaolfativa;
                favdestinatario.Text = p.Destinatario;
                favpreco.Text = p.Preco.ToString() + "€";

            }

        }

        private void ratingbutton_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("perf.changeRating", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@compranum", numerocompraon.Text);
            cmd.Parameters.AddWithValue("@clienteemail", C.Email);
            cmd.Parameters.AddWithValue("@rating", rating.Text);


            cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

            String rm = "";

            try
            {
                cmd.ExecuteNonQuery();
                rm = cmd.Parameters["@responseMessage"].Value.ToString();

            }
            catch (Exception ex)
            {
                throw new Exception("Failed to Execute");
            }
            finally
            {
                MessageBox.Show(rm);
                tabControl1_SelectedIndexChanged(tabControl1, null);
            }


            cn.Close();
        }

        private void carrinhogrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == 0 && e.RowIndex >= 0)
            {
                Carrinho[e.RowIndex].Unidades -= 1;
                if (Carrinho[e.RowIndex].Unidades == 0)
                    Carrinho.RemoveAt(e.RowIndex);
                tabControl1_SelectedIndexChanged(tabControl1, null);

            }

        }

        private void button7_Click(object sender, EventArgs e)
        {
            if(Carrinho.Count > 0) { 
                comprafinal.Visible = true;
                totaltotal.Text = totalcarrinho.Text;
            }
        }

        private void cloose_Click(object sender, EventArgs e)
        {
            comprafinal.Visible = false;
        }

        private void finalcompra_Click(object sender, EventArgs e)
        {
            if (Carrinho.Count > 0 && contribuinte.Text.Length == 9)
            {
                if (!verifySGBDConnection())
                    return;

                SqlCommand cmd = new SqlCommand("perf.verifyPaymentContact", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@utilizador_email", C.Email);
                cmd.Parameters.Add("@result", SqlDbType.Bit).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("@contacto", SqlDbType.Int).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("@pagamento", SqlDbType.VarChar,10).Direction = ParameterDirection.Output;

                int contactoid = 0;
                String pagamento = null;

                bool result = false;

               
                    cmd.ExecuteNonQuery();
                    result = (bool)cmd.Parameters["@result"].Value;

                    if (result)
                    {
                    if (cmd.Parameters["@contacto"].Value != DBNull.Value)
                    {
                        contactoid = (int)cmd.Parameters["@contacto"].Value;
                    } else
                        result = false;

                    if (cmd.Parameters["@pagamento"].Value != DBNull.Value)
                    {
                        pagamento = cmd.Parameters["@pagamento"].Value.ToString();
                    }
                    else
                        result = false;
                    
                    }

             


                if (!result)
                {
                    MessageBox.Show("Verifique o contacto e pagamento da sua conta.");
                    return;
                }

                cmd = new SqlCommand("perf.newBuy", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@clienteemail", C.Email);
                cmd.Parameters.AddWithValue("@contribuinte", contribuinte.Text);
                cmd.Parameters.AddWithValue("@pagamento", pagamento);
                cmd.Parameters.AddWithValue("@contacto", contactoid);
                cmd.Parameters.AddWithValue("@presente", present.Checked);

                cmd.Parameters.Add("@compra", SqlDbType.Int).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

                String rm = "";
                int compra;
              
                
                cmd.ExecuteNonQuery();
                rm = cmd.Parameters["@responseMessage"].Value.ToString();

                compra = (int)cmd.Parameters["@compra"].Value;





                foreach (Produto p in Carrinho)
                {
                    cmd = new SqlCommand("perf.buyProduct", cn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@compranumero", compra);
                    cmd.Parameters.AddWithValue("@produtoid", p.Id);
                    cmd.Parameters.AddWithValue("@unidades", p.Unidades);

                    cmd.Parameters.Add("@responseMessage", SqlDbType.VarChar, 250).Direction = ParameterDirection.Output;

                    
                    cmd.ExecuteNonQuery();
                    rm = cmd.Parameters["@responseMessage"].Value.ToString();


                  

                    MessageBox.Show(rm);

                }



                cn.Close();
            }
            else
                MessageBox.Show("Sem produtos ou contribuinte!");
        }

        private void numericUpDown2_ValueChanged(object sender, EventArgs e)
        {
            if (numericUpDown2.Value > ProdutosList[selectedProductIndex].Stock)
                warningstock.Visible = true;
            else
                warningstock.Visible = false;
        }

        private void button4_Click(object sender, EventArgs e)
        {
            comprafav.Visible = false;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (!warningstock.Visible && numericUpDown2.Value > 0)
            {
                Carrinho.RemoveAll(x => x.Id == ProdutosList[selectedProductIndex].Id);
                ProdutosList[selectedProductIndex].Unidades = (int)numericUpDown2.Value;
                Carrinho.Add(ProdutosList[selectedProductIndex]);
                MessageBox.Show("Adicionado com sucesso!");

            }
            else
                MessageBox.Show("Verifique as unidades!");

        }
    }
}
