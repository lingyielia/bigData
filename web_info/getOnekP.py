from parsel import Selector
import requests
import os
import pandas as pd

def download():
    os.system('mkdir onekPdata')
    URL = "http://www.onekp.com/public_data.html"
    source = requests.get(URL)
    sel = Selector(text = source.text)

    loc = 2
    location = '/html/body/table/tr[' + str(loc) + ']/td[5]/a/@href'
    count = 0

    breakpoint = 0
    onekP_Code_list = []
    family_list = []
    species_list = []
    tissue_type_list = []

    while sel.xpath(location).get():
        down_url = sel.xpath(location).get()
        f_name = down_url[27:]

        os.system("curl -O " + down_url)
        os.system('mv ' + str(f_name) + ' onekPdata/')
        os.system('bzip2 -d onekPdata/' + str(f_name))

        onekP_loc = '/html/body/table/tr[' + str(loc) + ']/td[1]//text()'
        onekP_Code = sel.xpath(onekP_loc).get()
        onekP_Code_list.append(onekP_Code)

        family_loc = '/html/body/table/tr[' + str(loc) + ']/td[2]//text()'
        family = sel.xpath(family_loc).get()
        family_list.append(family)

        species_loc = '/html/body/table/tr[' + str(loc) + ']/td[3]//text()'
        species = sel.xpath(species_loc).get()
        species_list.append(species)

        tissue_type_loc = '/html/body/table/tr[' + str(loc) + ']/td[3]//text()'
        tissue_type = sel.xpath(tissue_type_loc).get()
        tissue_type_list.append(tissue_type)

        loc += 1
        location = '/html/body/table/tr[' + str(loc) + ']/td[5]/a/@href'
        count += 1
        print(count)

        # if breakpoint == 5:
        #     break
        # breakpoint += 1

    res = {'onekP_Code': onekP_Code_list,
           'family': family_list,
           'species': species_list,
           'tissue_type': tissue_type_list}
    df = pd.DataFrame.from_dict(res)
    df = df[['onekP_Code', 'family', 'species', 'tissue_type']]
    df.to_csv("onekPdata/all_file_info.csv", index=False)


if __name__ == "__main__":
    download()
