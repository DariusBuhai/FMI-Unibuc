#include <iostream>
#include <cmath>
#include <vector>
#include <numeric>
#include <algorithm>
#include <unordered_map>

class I_IO {
public:
    friend std::ostream &operator<<(std::ostream &os, const I_IO &ob) {
        ob.print(os);
        return os;
    }

    friend std::istream &operator>>(std::istream &is, I_IO &ob) {
        ob.read(is);
        return is;
    }

    virtual void print(std::ostream &os) const = 0;

    virtual void read(std::istream &is) = 0;

    virtual ~I_IO() {

    }
};

template<class T>
void checkIfPositive(T value) {
    if (value < 0) {
        throw std::runtime_error("Nu poate fi negativ !");
    }
}

template<class T>
void checkIfStrictPositive(T value) {
    if (value <= 0) {
        throw std::runtime_error("Nu poate fi mai mic sau egal cu 0 !");
    }
}

class Masina : public I_IO {
protected:
    double viteza, greutate;
    std::string nume;
    int an;

public:
    Masina(double viteza, double greutate, const std::string &nume, int an) : viteza(viteza), greutate(greutate),
                                                                              nume(nume), an(an) {
        checkIfStrictPositive(greutate);
        checkIfPositive(viteza);
        checkIfPositive(an);
    }

    bool operator<(const Masina &rhs) const {
        return viteza < rhs.viteza;
    }

    bool operator>(const Masina &rhs) const {
        return rhs < *this;
    }

    bool operator<=(const Masina &rhs) const {
        return !(rhs < *this);
    }

    bool operator>=(const Masina &rhs) const {
        return !(*this < rhs);
    }

    bool operator==(const Masina &rhs) const {
        return this == &rhs ||
               (viteza == rhs.viteza &&
                greutate == rhs.greutate &&
                nume == rhs.nume &&
                an == rhs.an);
    }

    bool operator!=(const Masina &rhs) const {
        return !(rhs == *this);
    }

    Masina() {}

    virtual double autonomie() const = 0;

    void print(std::ostream &os) const override {
        os << " viteza: " << viteza << " greutate: " << greutate
           << " nume: " << nume << " an: " << an;
    }

    void read(std::istream &is) override {
        std::cout << " viteza: ";
        is >> viteza;
        checkIfPositive(viteza);
        std::cout << " greutate: ";
        is >> greutate;
        checkIfStrictPositive(greutate);
        std::cout << " nume: ";
        is >> nume;
        std::cout << " an: ";
        is >> an;
        checkIfPositive(an);
    }

    double getViteza() const {
        return viteza;
    }

    void setViteza(double viteza) {
        checkIfPositive(viteza);
        Masina::viteza = viteza;
    }

    double getGreutate() const {
        return greutate;
    }

    void setGreutate(double greutate) {
        checkIfStrictPositive(greutate);
        Masina::greutate = greutate;
    }

    const std::string &getNume() const {
        return nume;
    }

    void setNume(const std::string &nume) {
        Masina::nume = nume;
    }

    int getAn() const {
        return an;
    }

    void setAn(int an) {
        checkIfPositive(an);
        Masina::an = an;
    }

    virtual ~Masina() {

    }
};

class MasinaFosil : public virtual Masina {
protected:
    std::string combustibil;
    double rezervor;
public:

    MasinaFosil(double viteza, double greutate, const std::string &nume, int an, const std::string &combustibil,
                double rezervor) : Masina(viteza, greutate, nume, an), combustibil(combustibil), rezervor(rezervor) {
        checkIfPositive(rezervor);
        checkIfCombustibilIsValid(combustibil);
    }

    MasinaFosil() {}

    const std::string &getCombustibil() const {
        return combustibil;
    }

    void setCombustibil(const std::string &combustibil) {
        checkIfCombustibilIsValid(combustibil);
        MasinaFosil::combustibil = combustibil;
    }

    double getRezervor() const {
        return rezervor;
    }

    static void checkIfCombustibilIsValid(std::string combustibil) {
        if (combustibil != "benzina" && combustibil != "motorina") {
            throw std::runtime_error("Combustibil invalid !");
        }
    }

    void setRezervor(double rezervor) {
        checkIfPositive(rezervor);
        MasinaFosil::rezervor = rezervor;
    }

    void print(std::ostream &os) const override {
        Masina::print(os);
        os << " combustibil: " << combustibil << " rezervor: " << rezervor;
    }

    void read(std::istream &is) override {
        Masina::read(is);
        std::cout << " combustibil: ";
        is >> combustibil;
        checkIfCombustibilIsValid(combustibil);
        std::cout << " rezervor: ";
        is >> rezervor;
        checkIfPositive(rezervor);
    }

    double autonomie() const override {
        return rezervor / ::sqrt(greutate);
    }

    virtual ~MasinaFosil() {

    }
};

class MasinaElectrica : public virtual Masina {
protected:
    double baterie;
public:
    MasinaElectrica(double viteza, double greutate, const std::string &nume, int an, double baterie) : Masina(viteza,
                                                                                                              greutate,
                                                                                                              nume, an),
                                                                                                       baterie(baterie) {
        checkIfPositive(baterie);
    }

    MasinaElectrica() {}

    double getBaterie() const {
        return baterie;
    }

    void setBaterie(double baterie) {
        checkIfPositive(baterie);
        MasinaElectrica::baterie = baterie;
    }

    double autonomie() const override {
        return baterie / (greutate * greutate);
    }

    void print(std::ostream &os) const override {
        Masina::print(os);
        std::cout << " baterie: " << baterie;
    }

    void read(std::istream &is) override {
        Masina::read(is);
        std::cout << " baterie: ";
        is >> baterie;
        checkIfPositive(baterie);
    }

    virtual ~MasinaElectrica() {

    }
};

class MasinaHibrid : public MasinaElectrica, public MasinaFosil {
public:

    MasinaHibrid(double viteza, double greutate, const std::string &nume, int an, double baterie, double viteza1,
                 double greutate1, const std::string &nume1, int an1, const std::string &combustibil, double rezervor)
            : MasinaElectrica(viteza, greutate, nume, an, baterie),
              MasinaFosil(viteza1, greutate1, nume1, an1, combustibil, rezervor) {}

    MasinaHibrid() {}

    double autonomie() const override {
        return MasinaFosil::autonomie() + MasinaElectrica::autonomie();
    }

    void print(std::ostream &os) const override {
        MasinaFosil::print(os);
        std::cout << " baterie: " << baterie;
    }

    void read(std::istream &is) override {
        MasinaFosil::read(is);
        std::cout << " baterie: ";
        is >> baterie;
    }

    virtual ~MasinaHibrid() {

    }
};

template<class X, class Y, class Z>
class Triplet : public I_IO {
    X x = 0;
    Y y = 0;
    Z z = 0;
public:

    Triplet(X x, Y y, Z z) : x(x), y(y), z(z) {
        checkIfPositive(x);
        checkIfPositive(y);
        checkIfPositive(z);
    }

    Triplet() {}

    X getX() const {
        return x;
    }

    void setX(X x) {
        checkIfPositive(x);
        Triplet::x = x;
    }

    Y getY() const {
        return y;
    }

    void setY(Y y) {
        checkIfPositive(y);
        Triplet::y = y;
    }

    Z getZ() const {
        return z;
    }

    void setZ(Z z) {
        checkIfPositive(z);
        Triplet::z = z;
    }

    void print(std::ostream &os) const override {
        os << " x: " << x << " y: " << y << " z: " << z;
    }

    void read(std::istream &is) override {
        std::cout << " x: ";
        is >> x;
        checkIfPositive(x);
        std::cout << " y: ";
        is >> y;
        checkIfPositive(y);
        std::cout << " z: ";
        is >> z;
        checkIfPositive(z);
    }

    virtual ~Triplet() {

    }
};

using Data = Triplet<int, int, int>;

class MasinaFactory {
    MasinaFactory() = default;

public:
    static Masina *copyInstance(Masina *masina) {
        if (auto var = dynamic_cast<MasinaHibrid *>(masina)) {
            return new MasinaHibrid(*var);
        } else if (auto var = dynamic_cast<MasinaFosil *>(masina)) {
            return new MasinaFosil(*var);
        } else if (auto var = dynamic_cast<MasinaElectrica *>(masina)) {
            return new MasinaElectrica(*var);
        } else if (masina == nullptr) {
            return nullptr;
        } else {
            throw std::runtime_error("Masina invalida !");
        }
    }

    static Masina *newInstance(const std::string &tip) {
        if (tip == "fosil") {
            return new MasinaFosil();
        } else if (tip == "electrica") {
            return new MasinaElectrica();
        } else if (tip == "hibrid") {
            return new MasinaHibrid();
        } else {
            throw std::runtime_error("Masina invalida !");
        }
    }
};

class Tranzactie : public I_IO {
    std::vector<Masina *> masini;
    std::string client;
    Data data;
public:

    Tranzactie(const std::vector<Masina *> &masini, const std::string &client, const Data &data) : masini(masini),
                                                                                                   client(client),
                                                                                                   data(data) {}

    Tranzactie() {}

    Tranzactie(const Tranzactie &tranzactie)
            : client(tranzactie.client), data(tranzactie.data) {
        for (int i = 0; i < tranzactie.masini.size(); ++i) {
            masini.push_back(MasinaFactory::copyInstance(tranzactie.masini[i]));
        }
    }

    Tranzactie &operator+=(Masina *masina) {
        masini.push_back(masina);
        return *this;
    }

    Tranzactie &operator=(const Tranzactie &tranzactie) {
        if (this == &tranzactie) {
            return *this;
        }

        clearMasini();
        client = tranzactie.client;
        data = tranzactie.data;
        for (int j = 0; j < tranzactie.masini.size(); ++j) {
            masini.push_back(MasinaFactory::copyInstance(tranzactie.masini[j]));
        }

        return *this;
    }

    const std::vector<Masina *> &getMasini() const {
        return masini;
    }

    void setMasini(const std::vector<Masina *> &masini) {
        clearMasini();
        Tranzactie::masini = masini;
    }

    void clearMasini() {
        if (masini.size() != 0) {
            for (int i = 0; i < masini.size(); ++i) {
                delete masini[i];
            }
            masini.clear();
        }
    }

    const std::string &getClient() const {
        return client;
    }

    void setClient(const std::string &client) {
        Tranzactie::client = client;
    }

    const Data &getData() const {
        return data;
    }

    void setData(const Data &data) {
        Tranzactie::data = data;
    }

    void print(std::ostream &os) const override {
        os << " masini: ";
        for (int i = 0; i < masini.size(); ++i) {
            std::cout << *masini[i] << "\n";
        }
        os << " client: " << client << " data: " << data;
    }

    void read(std::istream &is) override {
        clearMasini();
        std::cout << "Numar masini: ";
        int n;
        is >> n;
        for (int j = 0; j < n; ++j) {
            std::cout << "Tip masina(fosil/electrica/hibrid): ";
            std::string tip;
            is >> tip;
            masini.push_back(MasinaFactory::newInstance(tip));
            is >> *masini[j];
            std::cout << '\n';
        }
        std::cout << " client: ";
        is >> client;
        std::cout << " data: ";
        is >> data;
    }

    virtual ~Tranzactie() {
        clearMasini();
    }

};

class Producator : public I_IO {
    Producator() = default;

    Producator(const Producator &producator) = delete;

    Producator(Producator &&producator) noexcept = delete;

    Producator &operator=(const Producator &producator) = delete;

    Producator &operator=(Producator &&producator) = delete;

    std::vector<Tranzactie> tranzactii;

    inline static Producator *producator;

public:

    static Producator *getInstance() {
        if (producator == nullptr) {
            producator = new Producator();
        }
        return producator;
    }

    void best() {
        double autonomie = 0.0;
        Masina *masina = nullptr;
        std::cout << "Masina cu cea mai buna autonomie este: ";
        for (const auto &tranzactie : tranzactii) {
            for (const auto &masinaAuto : tranzactie.getMasini()) {
                if (masinaAuto != nullptr && masinaAuto->autonomie() > autonomie) {
                    autonomie = masinaAuto->autonomie();
                    masina = masinaAuto;
                }
            }
        }

        if (masina != nullptr) {
            std::cout << *masina << "\nCu autonomia: " << autonomie;
        } else {
            std::cout << "NU AVEM !";
        }
    }

    void top() {
        std::unordered_map<std::string, int> soldMap;
        for (const auto &tranzactie : tranzactii) {
            for (const auto &masinaAuto : tranzactie.getMasini()) {
                if (masinaAuto != nullptr) {
                    soldMap[masinaAuto->getNume()]++;
                }
            }
        }

        std::string model;
        int count = 0;

        for (const auto&[nume, numar] : soldMap) {
            if (count < numar) {
                count = numar;
                model = nume;
            }
        }

        std::cout << "Cea mai vanduta masina este: " << model;
    }

    void turing(double procent, std::string model) {
        checkIfPositive(procent);

        for (const auto &tranzactie : tranzactii) {
            for (const auto &masinaAuto : tranzactie.getMasini()) {
                if (masinaAuto != nullptr && masinaAuto->getNume() == model) {
                    masinaAuto->setViteza((1 + procent) * masinaAuto->getViteza());
                }
            }
        }

        std::cout << "Leam turat >:)";
    }

    void print(std::ostream &os) const override {
        os << " tranzactii: ";
        for (int i = 0; i < tranzactii.size(); ++i) {
            os << i << ". " << tranzactii[i] << "\n";
        }
        os << "\n";
    }

    void read(std::istream &is) override {
        std::cout << "Numar tranzactii: ";
        int n;
        is >> n;
        Tranzactie tranzactie;
        for (int i = 0; i < n; ++i) {
            std::cout << "Introduceti tranzactia: \n";
            is >> tranzactie;
            tranzactii.push_back(tranzactie);
        }
    }

    Producator &operator++() {
        if (tranzactii.size() == 0) {
            std::cout << "Trebuie sa introduci o tranzactie in care se va pune masina: ";
            Tranzactie tranzactie;
            std::cin >> tranzactie;
            tranzactii.push_back(tranzactie);
        } else {
            std::cout << "Alege o tranzactie de la 0 - " << tranzactii.size() - 1;
            int index;
            std::cin >> index;

            if (index < 0 || index > tranzactii.size() - 1) {
                throw std::out_of_range("OUT OF BOUNDS");
            }

            std::cout << "Tip masina(fosil/electrica/hibrid): ";
            std::string tip;
            std::cin >> tip;

            tranzactii[index] += MasinaFactory::newInstance(tip);
            std::cout << "Citeste masina: ";
            std::cin >> *tranzactii[index].getMasini().back();
        }

        return *this;
    }

    Producator &operator+=(const Tranzactie &tranzactie) {
        tranzactii.push_back(tranzactie);
        return *this;
    }

    virtual ~Producator() {
    }
};

void menu() {
    loop:

    std::cout
            << "1. Adauga masina\n2. Adauga tranzactie\n3. Cel mai bine vandut model\n4. Best autonomy\n5. Optimizare";

    int n;
    std::cin >> n;

    switch (n) {
        case 1:
            Producator::getInstance()->operator++();
            break;
        case 2: {
            Tranzactie tranzactie;
            std::cin >> tranzactie;

            Producator::getInstance()->operator+=(tranzactie);
        }
            break;
        case 3:
            Producator::getInstance()->top();
            break;
        case 4:
            Producator::getInstance()->best();
            break;
        case 5: {
            double op;
            std::string mode;
            std::cout << "Optimizare: ";
            std::cin >> op;
            std::cout << "Model: ";
            std::cin >> mode;
            Producator::getInstance()->turing(op, mode);
        }
            break;

    }

    goto loop;
}

int main() {

    try {

        //menu(); //Nu l-am testat.

        Tranzactie tranzactie;
        std::cin >> tranzactie;

        Producator::getInstance()->operator+=(tranzactie);
        std::cout << *Producator::getInstance();

        std::cin >> *Producator::getInstance();
        std::cout << *Producator::getInstance();

        Producator::getInstance()->top();
        Producator::getInstance()->best();
        Producator::getInstance()->turing(0.34, "Mercedes");

    } catch (const std::exception &ex) {
        std::cout << "Oopsie, am gresit ! (" << ex.what() << ")";
    }

    if (Producator::getInstance() != nullptr) {
        delete Producator::getInstance();
    }

    return 0;
}