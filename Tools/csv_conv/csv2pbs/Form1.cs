using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Newtonsoft.Json;
using System.IO;

namespace csv2pbs
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        public class PokemonData
        {
            //Important
            string ID;
            string Name;
            string Types;
            string Abilities;
            string HiddenAbilites;
            string BaseStats;
            string DexEntry;
            string EggGroups;
            string GrowthRate;
            string Evolutions;
            string GenderRatio;
            string BaseEXP;
            string EVs;
            string Category;
            //Sometimes important
            string CatchRate;
            string Happiness;
            string WildItemCommon;
            string WildItemUncommon;
            string WildItemRare;
            string Offspring;
            string Incense;
            string HatchSteps;
            string Flags;
            string GermanName;
            //honestly cosmetic at best
            string Color;
            string Shape;
            string Habitat;
            string Weight;

            public override string ToString()
            {
                string PBSOutput ="";
                PBSOutput = "#---------------------------------------------------\r" +
                    "[" + ID + "]\r";
                // "Name = " + Name + "\r" +
                // "Types = " + Types.ToUpper() + "\r" +
                // "BaseStats = " + BaseStats + "\r" +
                // "Abilities = "+ Abilities.ToUpper().Replace(" ","") + "\r"+
                // "HiddenAbilities = "+HiddenAbilites.ToUpper().Replace(" ", "") + "\r"+
                // "EggGroups = "+EggGroups +"\r"+
                // "GrowthRate = "+GrowthRate+"\r" +
                // "Category = " + Category + "\r" +
                //"GenderRatio = " + GenderRatio + "\r";
                if (Name != null && Name != "")
                    PBSOutput += "Name = " + Name + "\r";
                if (Types != null && Types != "")
                    PBSOutput += "Types = " + Types.ToUpper() + "\r";
                if (BaseStats != null && BaseStats != "")
                    PBSOutput += "BaseStats = " + BaseStats + "\r";
                if (Abilities != null && Abilities != "")
                    PBSOutput += "Abilities = " + Abilities.ToUpper().Replace(" ", "") + "\r";
                if (HiddenAbilites != null && HiddenAbilites != "")
                    PBSOutput += "HiddenAbilities = " + HiddenAbilites.ToUpper().Replace(" ", "") + "\r";
                //i fucked up in the table
                //if (EggGroups != null && EggGroups != "")
                //    PBSOutput += "EggGroups = " + EggGroups + "\r";
                if (GrowthRate != null && GrowthRate != "")
                    PBSOutput += "GrowthRate = " + GrowthRate + "\r";
                if (Category != null && Category != "")
                    PBSOutput += "Category = " + Category + "\r";
                if (GenderRatio != null && GenderRatio != "")
                    PBSOutput += "GenderRatio = " + GenderRatio + "\r";
                if (Evolutions != null && Evolutions != "")
                    PBSOutput += "Evolutions = " + Evolutions + "\r";
                if (BaseEXP != null && BaseEXP != "")
                    PBSOutput += "BaseExp = " + BaseEXP + "\r";
                if (DexEntry != null && DexEntry != "")
                    PBSOutput += "DexEntry = " + DexEntry + "\r";
                if (CatchRate != null && CatchRate != "")
                    PBSOutput += "CatchRate = " + CatchRate + "\r";
                if (Happiness != null && Happiness != "")
                    PBSOutput += "Happiness = " + Happiness + "\r";
                if (EVs != null && EVs != "")
                    PBSOutput += "EVs = " + EVs.ToUpper().Replace(" ", "") + "\r";
                if (WildItemCommon != null && WildItemCommon != "")
                    PBSOutput += "WildItemCommon = " + WildItemCommon + "\r";
                if (WildItemUncommon != null && WildItemUncommon != "")
                    PBSOutput += "WildItemUncommon = " + WildItemUncommon + "\r";
                if (WildItemRare != null && WildItemRare != "")
                    PBSOutput += "WildItemRare = " + WildItemRare + "\r";
                if (Offspring != null && Offspring != "")
                    PBSOutput += "Offspring = " + Offspring + "\r";
                if (Incense != null && Incense != "")
                    PBSOutput += "Incense = " + Incense + "\r";
                if (HatchSteps != null && HatchSteps != "")
                    PBSOutput += "HatchSteps = " + HatchSteps + "\r";
                if (Color != null && Color != "")
                    PBSOutput += "Color = " + Color + "\r";
                if (Shape != null && Shape != "")
                    PBSOutput += "Shape = " + Shape + "\r";
                if (Habitat != null && Habitat != "")
                    PBSOutput += "Habitat = " + Habitat + "\r";
                if (Weight != null && Weight != "")
                    PBSOutput += "Weight = " + Weight + "\r";
                if (Flags != null && Flags != "")
                    PBSOutput += "Flags = " + Flags + "\r";


                return PBSOutput;
            }
            public PokemonData(string CSVLine)
            {
                string[] CSV = CSVLine.Split(";") ;
                ID = CSV[0];
                Name = CSV[1];
                Types = CSV[2];
                Abilities = CSV[3];
                HiddenAbilites = CSV[4];
                Evolutions = CSV[5];
                BaseStats = CSV[6];
                GenderRatio = CSV[7];
                GrowthRate = CSV[8];
                BaseEXP = CSV[9];
                EVs = CSV[10];
                CatchRate = CSV[11];
                Happiness = CSV[12];
                DexEntry = CSV[13];
                Category = CSV[14];
                EggGroups = CSV[15];
                Flags = CSV[16];
                Offspring = CSV[17];
                Color = CSV[18];
                Shape = CSV[19];
                WildItemCommon = CSV[20];
                WildItemUncommon = CSV[21];
                WildItemRare = CSV[22];
                Habitat = CSV[23];
                Weight = CSV[24];

                
                
            }


        }

        void Convert()
        {
            string CSVFile = Directory.GetCurrentDirectory() + "/export.csv";
            List<string> Lines = new List<string>();   
            StreamReader streamReader = new StreamReader(CSVFile);
            List<PokemonData> Mons = new List<PokemonData>();
            while(!streamReader.EndOfStream)
            {
                Lines.Add(streamReader.ReadLine());
            }
            foreach(string Line in Lines)
            {
                Mons.Add(new PokemonData(Line));
            }
            streamReader.Close();
            StreamWriter streamWriter= new StreamWriter(Directory.GetCurrentDirectory()+"\\pokemon_argon.pbs");
            foreach(PokemonData mon in Mons)
            {
                streamWriter.Write(mon.ToString());
            }
            streamWriter.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Convert();
        }
    }
}
