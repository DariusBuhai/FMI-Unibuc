#include <iostream>
#include <fstream>
#include <string>
#include <vector>

class Exception: public std::exception{
    std::string error_name;
public:
    Exception(std::string _error_name): error_name(_error_name){}
    ~Exception() throw() {}

    virtual const char* what() throw(){
        return error_name.c_str();
    }
};

class Formular{
    int fid;
    std::string nume;
    double venit_obtinut_anterior;
    double suma_data_statului_anterior;
public:
    Formular(std::string _n, double _v, double _s): nume(std::move(_n)), venit_obtinut_anterior(_v), suma_data_statului_anterior(_s){}
    virtual ~Formular(){}
};

class Formular1: public Formular{
public:
    Formular1(std::string _n, double _v, double _s): Formular(std::move(_n), _v, _s){}
};

class Formular2: public Formular{
    double venit_preconizat_an_curent;
    double suma_data_statului_curent;
public:
    Formular2(std::string _n, double _v, double _s, double _vc, double _sc): Formular(std::move(_n), _v, _s),  venit_preconizat_an_curent(_vc), suma_data_statului_curent(_sc){}
};

class Formular3: public Formular{
    int numar_angajati;
    int salariu_mediu;
    double venit_preconizat_an_curent;
    double suma_data_statului_curent;
public:
    Formular3(std::string _n, double _v, double _s, int _na, int _sm, double _vc, double _sc): Formular(std::move(_n), _v, _s), numar_angajati(_na), salariu_mediu(_sm), venit_preconizat_an_curent(_vc), suma_data_statului_curent(_sc){}
};

class CerereImpozitare{
    int valoare_de_control;
    double valoare_totala_venit;
public:
    CerereImpozitare(double _vt): valoare_totala_venit(_vt){}

    int getValoareDeControl(int _fid){
        this->valoare_de_control = (_fid<<3)+this->valoare_totala_venit;
        return this->valoare_de_control;
    }

};

class SPF{
    std::vector<Formular*> formulare;
public:
    CerereImpozitare colectare(Formular* _formular){
        CerereImpozitare cerereImpozitare(1);
        //cerereImpozitare
        return cerereImpozitare;
    }
};

class SPC{

};

class ACTI: public SPF, public SPC{

};



int main() {

    return 0;
}
