#include <iostream>
#include <string>
#include <exception>
#include <vector>

/**
 * Creat de Buhai Darius
 * Grupa 135
 *
 * Compilator g++17 ( din Xcode - MacOs )
 *
 * Multumesc persoanei care are timp sa verifice acest subiect
 * PS: Sorry pentru romgleza
 *
 */


/**
 * Clase utile
 */

/// O clasa abstracta care implementeaza functiile de citire si de afisare, preluate din std
/// Clasa ne-a fost aratata la laborator, de catre domnul Lupascu
class Stream {
public:
    Stream() = default;
    virtual ~Stream() = default;

    friend std::istream &operator>>(std::istream &in, Stream &ob) {
        ob.read(in);
        return in;
    }

    friend std::ostream &operator<<(std::ostream &out, const Stream &ob) {
        ob.write(out);
        return out;
    }

    virtual void read(std::istream &in){}
    virtual void write(std::ostream &out) const {}
};

/// O clasa de tip template cu care verific diverse variabile
template <class T>
class Checker{
public:
    Checker() = default;
    virtual ~Checker() = default;

    static void throwIfNotPositive(T value) {
        if (value < 0) {
            throw std::runtime_error("Numarul trebuie sa fie pozitiv!");
        }
    }

    static void throwIfNotStrictPositive(T value) {
        if (value <= 0) {
            throw std::runtime_error("Numarul trebuie sa fie strict pozitiv!");
        }
    }

    static void throwIfNotInRange(T value, T a, T b, std::string ob_name = "Numarul") {
        if (value<a || value>b) {
            throw std::runtime_error(ob_name+" trebuie sa fie in intervaulul ["+std::to_string(a)+", "+std::to_string(b)+"]");
        }
    }

    static void throwIfGreaterThan(T value, T a, std::string ob_name = "Numarul") {
        if (value>a) {
            throw std::runtime_error(ob_name+" trebuie sa fie < "+std::to_string(a));
        }
    }
};

/// Clasa date implementeaza toate functiile necesare unei date (cu luna si an)
class Date: public Stream{
    int year, month;
public:
    Date(int _an, int _luna): year(_an), month(_luna){
        Checker<int>::throwIfNotInRange(_an, 1800, 2080, "Anul");
        Checker<int>::throwIfNotInRange(_luna, 1, 12, "Luna");
    }

    Date(): year(2020), month(1){}

    int getMonthDiff(Date other_date){
        if(other_date.getAn() < year || (other_date.getAn() == year && other_date.month < month))
            return other_date.getMonthDiff(*this);
        if(other_date.getAn() == year)
            return other_date.month - month;
        int left1 = 12 - month;
        int left2 = other_date.month;
        return (other_date.year - year - 1) * 12 + left1 + left2;
    }

    bool isEqual(const Date& other_date) const{
        return year == other_date.year && month == other_date.month;
    }

    bool operator==(Date &other_date) const{
        return this->isEqual(other_date);
    }

    bool operator<=(Date &other_date) const{
        if(*this==other_date) return true;
        if(this->year < other_date.year) return true;
        return (this->year == other_date.year && this->month <= other_date.month);
    }

    bool operator<(Date &other_date) const{
        if(*this==other_date) return true;
        if(this->year < other_date.year) return true;
        return (this->year == other_date.year && this->month < other_date.month);
    }

    bool operator>=(Date &other_date) const{
        if(*this==other_date) return true;
        if(this->year > other_date.year) return true;
        return (this->year == other_date.year && this->month >= other_date.month);
    }

    bool operator>(Date &other_date) const{
        if(*this==other_date) return true;
        if(this->year > other_date.year) return true;
        return (this->year == other_date.year && this->month > other_date.month);
    }

    void setLuna(int _luna){
        Checker<int>::throwIfNotInRange(_luna, 1, 12);
        month = _luna;
    }

    void setAn(int _an){
        Checker<int>::throwIfNotInRange(_an, 1800, 2080);
        year = _an;
    }

    int getAn() const{
        return year;
    }

    int getLuna() const{
        return month;
    }

    void read(std::istream& io) override{
        std::cout<<"(year, month):";
        io >> year >> month;
    }

    void write(std::ostream& out) const override{
        out << year << " " << month;
    }
};

/**
 * Clase axate pe subiect
 */

class Proprietate: public Stream{
protected:
    std::string adresa;
    int suprafata_locuibila;
    double valoare_chirie_per_mp;
public:
    Proprietate() {}
    virtual ~Proprietate() {}

    std::string getAdresa() const{
        return adresa;
    }

    int getSuprafataLocuibila() const{
        return suprafata_locuibila;
    }

    double getValoareChiriePerMp() const{
        return valoare_chirie_per_mp;
    }

    void read(std::istream &in) override {
        std::cout<<"Adresa: ";
        in>>adresa;
        std::cout<<"Suprafata locuibila: ";
        in>>suprafata_locuibila;
        std::cout<<"Valoare chirie (per mp): ";
        in>>valoare_chirie_per_mp;
    }

    void write(std::ostream &out) const override {
        out<<"Adresa: "<<adresa<<'\n';
        out<<"Suprafata locuibila: "<<suprafata_locuibila<<'\n';
        out<<"aloare chirie (per mp): "<<valoare_chirie_per_mp<<'\n';
    }
};

class Casa: public virtual Proprietate{
protected:
    int niveluri{}, suprafata_curte{};
public:
    int getNiveluri() const{
        return niveluri;
    }

    int getSuprafataCurte() const{
        return suprafata_curte;
    }

    void read(std::istream &in) override {
        Proprietate::read(in);
        std::cout<<"Niveluri: ";
        in>>niveluri;
        std::cout<<"Suprafata curte: ";
        in>>suprafata_curte;
    }

    void write(std::ostream &out) const override{
        Proprietate::write(out);
        out<<"Niveluri: "<<niveluri<<'\n';
        out<<"Suprafata curte: "<<suprafata_curte<<'\n';
    }
};

class Apartament: public virtual Proprietate{
protected:
    int etaj{}, numar_camere{};
public:
    int getEtaj() const{
        return etaj;
    }

    int getNumarCamere() const{
        return numar_camere;
    }

    void read(std::istream &in) override{
        Proprietate::read(in);
        std::cout<<"Etaj: ";
        in>>etaj;
        std::cout<<"Numar camere: ";
        in>>numar_camere;
    }

    void write(std::ostream &out) const override{
        Proprietate::write(out);
        out<<"Etaj: "<<etaj<<'\n';
        out<<"Numar camere: "<<numar_camere<<'\n';
    }
};

/// Factory
class ProprietateFactory{
    ProprietateFactory() = default;

public:
    static Proprietate *copyInstance(Proprietate *proprietate) {
        if (auto var = dynamic_cast<Casa *>(proprietate))
            return new Casa(*var);
        else if (auto var = dynamic_cast<Apartament *>(proprietate))
            return new Apartament(*var);
        else if (proprietate == nullptr)
            return nullptr;
        throw std::runtime_error("Tipul proprietatii este invalid!");
    }

    static Proprietate *newInstance(const std::string &tip) {
        if (tip == "casa")
            return new Casa();
        else if (tip == "apartament")
            return new Apartament();
        throw std::runtime_error("Tipul proprietatii este invalid!");
    }
};

class Contract: public Stream{
protected:
    std::string nume_client;
    Proprietate* proprietate;
public:

    Contract(){}
    Contract(Proprietate* _proprietate): proprietate(_proprietate){}

    std::string getNumeClient() const{
        return nume_client;
    }

    Proprietate* getProprietate() const{
        return proprietate;
    }

    virtual double getChirie() {
        return 0;
    }

    virtual double getProfit(Date data){
        return 0;
    }

    void read(std::istream& io) override {
        std::cout<<"Nume client: ";
        io>>nume_client;
    }

    void write(std::ostream& out) const override {
        std::cout<<"Nume client: "<<nume_client<<'\n';
        std::cout<<"Detalii proprietate: "<<proprietate<<'\n';
    }

    void setProprietate(Proprietate* _proprietate){
        proprietate = _proprietate;
    }
};

class ContractInchiriere: public Contract{
protected:
    Date inceput, sfarsit;
public:
    ContractInchiriere() = default;
    double getDiscount(){
        if(inceput.getMonthDiff(sfarsit)>24) return .1;
        else if(inceput.getMonthDiff(sfarsit)>12) return .05;
        return 0;
    }

    double getChirie(){
        if(auto casa = dynamic_cast<Casa*>(proprietate))
            return casa->getValoareChiriePerMp()*(casa->getSuprafataLocuibila()+.2*casa->getSuprafataCurte())*(1-getDiscount());
        else if(auto apartament = dynamic_cast<Apartament*>(proprietate))
            return apartament->getValoareChiriePerMp()*apartament->getSuprafataLocuibila()*(1-getDiscount());
        throw std::runtime_error("Ups, am gresit ceva!");
    }

    double getProfit(Date data){
        if(data>=inceput && data<=sfarsit)
            return getChirie();
        return 0;
    }

    void read(std::istream& io) override {
        Contract::read(io);
        std::cout<<"Date inceput: ";
        io>>inceput;
        std::cout<<"Date sfarsit: ";
        io>>sfarsit;
    }

    void write(std::ostream& out) const override {
        Contract::write(out);
        std::cout<<"Date de inceput: "<<inceput<<'\n';
        std::cout<<"Date de sfarsit: "<<sfarsit<<'\n';
    }
};

class ContractVanzareCumparare: public Contract{
protected:
    Date tranzactie, achitare;
public:
    ContractVanzareCumparare()= default;
    bool achitatIntegral(){
        return tranzactie.isEqual(achitare);
    }

    int getNumarRate(){
        int nr_rate = tranzactie.getMonthDiff(achitare);
        Checker<int>::throwIfGreaterThan(nr_rate, 240, "Ratele");
        return nr_rate;
    }

    double getDiscount(){
        if(achitatIntegral()) return .1;
        else if(getNumarRate()<=60) return .07;
        else if(getNumarRate()<=120) return .05;
        return 0;
    }

    double getProfit(Date data){
        if(achitatIntegral()){
            if(data==tranzactie) return getChirie();
            return 0;
        }
        if(data>=tranzactie && data<=achitare)
            return getChirie()/getNumarRate();
        return 0;
    }

    double getChirie(){
        if(auto casa = dynamic_cast<Casa*>(proprietate))
            return 240*casa->getValoareChiriePerMp()*(casa->getSuprafataLocuibila()+.2*casa->getSuprafataCurte())*(1-getDiscount());
        else if(auto apartament = dynamic_cast<Apartament*>(proprietate))
            return 240*apartament->getValoareChiriePerMp()*apartament->getSuprafataLocuibila()*(1-getDiscount());
        throw std::runtime_error("Ups, am gresit ceva!");
    }

    void read(std::istream& io) override {
        Contract::read(io);
        std::cout<<"Date tranzactie: ";
        io>>tranzactie;
        std::cout<<"Date achitare: ";
        io>>achitare;
    }

    void write(std::ostream& out) const override {
        Contract::write(out);
        std::cout<<"Date tranzacite: "<<tranzactie<<'\n';
        std::cout<<"Date achitarii: "<<achitare<<'\n';
    }
};

/// Factory
class ContractFactory{
    ContractFactory() = default;

public:
    static Contract *copyInstance(Contract *contract) {
        if (auto var = dynamic_cast<ContractInchiriere *>(contract))
            return new ContractInchiriere(*var);
        else if (auto var = dynamic_cast<ContractVanzareCumparare *>(contract))
            return new ContractVanzareCumparare(*var);
        else if (contract == nullptr)
            return nullptr;
        throw std::runtime_error("Tipul contractului este invalid!");
    }

    static Contract *newInstance(const std::string &tip) {
        if (tip == "inchiriere")
            return new ContractInchiriere();
        else if (tip == "vanzare" || tip == "cumparare")
            return new ContractVanzareCumparare();
        throw std::runtime_error("Tipul proprietatii este invalid!");
    }
};

/// Singleton
class Agentie{
    Agentie() = default;

    Agentie(const Agentie &agentie) = delete;
    Agentie(Agentie &&agentie) noexcept = delete;

    Agentie &operator=(const Agentie &agentie) = delete;
    Agentie &operator=(Agentie &&agentie) = delete;

    std::vector<Contract*> contracte;
    std::vector<Proprietate*> proprietati;

    inline static Agentie *agentie;
public:

    static Agentie *getInstance() {
        if (agentie == nullptr)
            agentie = new Agentie();
        return agentie;
    }

    Agentie &operator++(){
        std::string tip;
        do{
            std::cout<<"Ce doresti sa adaugi? (proprietate/contract):\n";
            std::cin>>tip;
        }while(tip!="proprietate" && tip!="contract");
        if(tip=="contract" && !proprietati.empty()){
            int nr_p = 1;
            if(proprietati.size()>1){
                std::cout<<"Alege o proprietate de la 1 la "<<proprietati.size();
                std::cin>>nr_p;
            }
            Checker<int>::throwIfNotInRange(nr_p, 1, proprietati.size());
            std::string tip_c;
            std::cout<<"Tip contract (inchiriere/cumparare):\n";
            std::cin>>tip_c;
            Contract* contract = ContractFactory::newInstance(tip_c);
            contract->setProprietate(proprietati[nr_p-1]);
            std::cin>>*contract;
            contracte.push_back(contract);
            return *this;
        }else if(tip=="contract" && proprietati.empty())
            std::cout<<"Mai intai trebuie sa adaugi o proprietate!\n";
        std::string tip_p;
        std::cout<<"Tip proprietate: (casa/apartament):\n";
        std::cin>>tip_p;
        Proprietate* proprietate = ProprietateFactory::newInstance(tip_p);
        std::cin>>*proprietate;
        proprietati.push_back(proprietate);
        return *this;
    }

    Agentie &operator+=(int n){
        while(n--)
            this->operator++();
        return *this;
    }

    double getSumaTotala(Date data){
        double result = 0;
        for(auto &contract: contracte)
            result += contract->getProfit(data);
        return result;
    }

    void showProprietati(){
        if(proprietati.empty()){
            std::cout<<"Nu exista nicio proprietate!\n";
            return;
        }
        std::vector<Proprietate*> locuinte, apartamente;
        for(auto &p: proprietati)
            if(dynamic_cast<Casa*>(p))
                locuinte.push_back(p);
            else
                apartamente.push_back(p);
        std::cout<<"Locuinte: \n";
        if(!locuinte.empty()){
            std::cout<<"Case: \n";
            for(auto &l: locuinte)
                std::cout<<*l;
        }
        if(!apartamente.empty()){
            std::cout<<"Apartamente: \n";
            for(auto &l: apartamente)
                std::cout<<*l;
        }
        if(contracte.empty()) return;
        std::vector<Contract*> inchiriat, vanzare;
        for(auto &c: contracte)
            if(dynamic_cast<ContractInchiriere*>(c))
                inchiriat.push_back(c);
            else
                vanzare.push_back(c);
        std::cout<<"\nContracte: \n";
        if(!inchiriat.empty()){
            std::cout<<"Proprietati de inchiriat: \n";
            for(auto &l: inchiriat)
                std::cout<<*l;
        }
        if(!vanzare.empty()){
            std::cout<<"Proprietati de vanzare: \n";
            for(auto &l: vanzare)
                std::cout<<*l;
        }
    }

};

/// Functia menu, care implementeaza toate cerintele
void menu(){
    try{
        std::cout<< "\nAlege operatie: \n1. Adauga\n2. Afiseaza dupa tip\n3. Afiseaza dupa situatie\n4. Afiseaza suma totala\n5. Iesire\n";
        int op;
        std::cin>>op;
        Checker<int>::throwIfNotInRange(op, 1, 5, "Operatia");
        switch (op) {
            case 1: {
                int n;
                std::cout << "n = ";
                std::cin >> n;
                Agentie::getInstance()->operator+=(n);
            }
                break;
            case 2: {
                Agentie::getInstance()->showProprietati();
            }
                break;
            case 3:{
                ///de implementat
            }
                break;
            case 4:{
                Date data;
                std::cin>>data;
                std::cout<<Agentie::getInstance()->getSumaTotala(data)<<" lei";
            }
                break;
            default:
                return;
        }
    }catch (const std::exception &ex) {
        std::cout <<ex.what();
    }
    menu();
}

int main() {

    menu();

    return 0;
}
