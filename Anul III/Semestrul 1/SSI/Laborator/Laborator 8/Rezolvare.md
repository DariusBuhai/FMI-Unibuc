## Ex 1

 - A -> Nicio eroare nu a aparut
 - B ->
 - C ->
 - D ->
 - E ->
 - F ->

## Ex 2

```C
#include <iostream>
#include <string.h>
using namespace std; 

int main()
{
	char pass[7] = "fmiSSI";
	char input[7];
	int passLen = strlen(pass); 

	cout<<"Introduceti parola: ";
	cin>>input;

	if (strncmp(input,pass,passLen)==0){
	   cout<<"Parola introdusa este corecta!\n"; 
	}
	else{
	   cout<<"Ati introdus o parola gresita :(\n";
	}
	return 0;
}
```

Exemplu parola corecta diferita de ```fmiSSI```: ```fmiSSIhelloworld```


## Ex 3 (de verificat)

```
def getFileSha256(file_path):
    with open(file_path, "rb") as f:
        readable_hash = hashlib.sha256(f.read()).hexdigest()
    return readable_hash
```

```
def getFileInfo(file_path):
    api_url = 'https://www.virustotal.com/api/v3/files'
    headers = {'x-apikey': '104855077ddf5881a40aa80187c251e63c2315b1540acf5dde0a2e02ac756554'}
    with open(file_path, 'rb') as file:
        files = {'file': ('malware.png', file)}
        response = requests.post(api_url, headers=headers, files=files)
        if response.status_code == 200:
            file_identifier = getFileSha256(file_path)
            url = f"https://www.virustotal.com/api/v3/files/{file_identifier}"
            response2 = requests.request("GET", url, headers=headers)
            if response2.status_code == 200:
                return response2.json()
    return None
```

## Ex 4



```
7D AB AF 61
```



