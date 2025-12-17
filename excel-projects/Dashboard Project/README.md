📊 Data Science Salary Dashboard Project
Bu proje, veri bilimi dünyasındaki maaş trendlerini ve iş piyasası dinamiklerini analiz etmek için geliştirilmiş, tamamen etkileşimli bir Excel Dashboard çalışmasıdır. Projenin en güçlü yanı, statik raporlar yerine ileri seviye Excel mimarisi kullanılarak oluşturulmuş dinamik yapısıdır.

🛠️ Teknik Hazırlık Süreci
Dashboard'u oluştururken izlediğim adımlar ve kullandığım teknikler aşağıdadır:

1. Veri Yapılandırma ve Veri Modeli
Projenin temeli, binlerce satırlık ham verinin işlenmesine dayanıyor. Verileri daha yönetilebilir kılmak ve formüllerde dinamik referanslar oluşturabilmek için ham veri setini Excel Table formatına dönüştürdüm.

Veri Standardizasyonu: Maaş verileri yıllık bazda standardize edildi.

Temizleme: Eksik veya hatalı değerler (0 olanlar vb.) analiz dışında bırakılacak şekilde formüle edildi.

2. İleri Seviye Formülasyon Mimarisi
Bu dashboard'un "motoru" Pivot tablolar değil, İleri Seviye Dinamik Dizi Formülleri'dir. Tabloları ve görselleri birbirine bağlamak için karmaşık mantıksal sorgular kullandım.

Özellikle görselde de görebileceğin gibi, medyan maaşı belirli kriterlere (Ülke, İş Unvanı, Çalışma Tipi) göre filtrelemek için aşağıdaki mantığı kullandım:

Excel

=MEDIAN(IF((jobs[job_country]=A2)*(jobs[salary_year_avg]<>0)*(ISNUMBER(SEARCH(type;jobs[job_schedule_type])))*(jobs[job_title_short]=title); jobs[salary_year_avg]))
Boolean Mantığı: * operatörü ile "AND" (VE) koşullarını dizi içerisinde birleştirdim.

SEARCH & ISNUMBER: Kısmi metin eşleşmeleri üzerinden dinamik filtreleme sağladım.

Dinamik Filtreleme: Kullanıcı dashboard üzerinde bir seçim yaptığında, arka plandaki bu formüller anlık olarak tüm grafikleri tetikler.

3. Kullanıcı Arayüzü ve Görselleştirme
Analiz sonuçlarını son kullanıcıya en net şekilde sunmak için çeşitli görselleştirme teknikleri uyguladım:

Dinamik KPI Kartları: Toplam iş sayısı ve medyan maaş gibi kritik veriler için özel tasarım kartlar.

Coğrafi Dağılım: Ülke bazlı maaş farklılıklarını gösteren harita entegrasyonu.

Platform Analizi: En çok ilan yayınlayan platformların (LinkedIn, Indeed vb.) tespiti.

🚀 Nasıl Kullanılır?
Repoda bulunan Dashboard Project.xlsx dosyasını indirin.

Excel'i açıp "Düzenlemeyi Etkinleştir" diyerek formülleri aktif hale getirin.

Dashboard sekmesindeki filtre kutularını kullanarak istediğiniz pozisyon veya ülke için analiz yapın.
