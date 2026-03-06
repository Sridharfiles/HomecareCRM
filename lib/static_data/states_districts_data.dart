class StateData {
  final String name;
  final List<String> districts;

  StateData({
    required this.name,
    required this.districts,
  });
}

// Map of countries to states with their districts
final Map<String, List<StateData>> statesByCountry = {
  'India': [
    StateData(
      name: 'Andhra Pradesh',
      districts: [
        'Adilabad', 'Anantapur', 'Anjani', 'Antaragaon', 'Antur', 'Aravalli', 'Armoor',
        'Asifabad', 'Atmakur', 'Attili', 'Aurangabad', 'Aurangabad', 'Auvasi', 'Avadi',
        'Awinpur', 'Ayodhya Nagar', 'Ayyana', 'Azad Nagar', 'Azatnagar', 'Azizabad', 'Azizpur',
        'Badami', 'Badarpur', 'Badhani', 'Badhra', 'Badhripur', 'Badhua', 'Badkhal',
        'Badlapur', 'Badnapur', 'Badnera', 'Badpura', 'Badshahnagar', 'Badshahpur', 'Badshahpura',
        'Baduria', 'Badvel', 'Bagair', 'Bagarh', 'Bagari', 'Bagaspur', 'Bagat Kherda',
        'Bagatalak', 'Bagaunn', 'Bagawati', 'Bagdara', 'Bagda', 'Bagduni', 'Bageshwar'
      ],
    ),
    StateData(
      name: 'Arunachal Pradesh',
      districts: ['Papum Pare', 'Changlang', 'Lohit', 'West Kameng', 'East Siang'],
    ),
    StateData(
      name: 'Assam',
      districts: ['Kamrup', 'Nagaon', 'Barpeta', 'Sonitpur', 'Dhubri', 'Goalpara'],
    ),
    StateData(
      name: 'Bihar',
      districts: ['Patna', 'East Champaran', 'West Champaran', 'Muzaffarpur', 'Darbhanga', 'Madhubani'],
    ),
    StateData(
      name: 'Chhattisgarh',
      districts: ['Raipur', 'Bilaspur', 'Durg', 'Rajnandgaon', 'Bastar', 'Jagdalpur'],
    ),
    StateData(
      name: 'Delhi',
      districts: ['New Delhi', 'North Delhi', 'South Delhi', 'East Delhi', 'West Delhi'],
    ),
    StateData(
      name: 'Goa',
      districts: ['North Goa', 'South Goa'],
    ),
    StateData(
      name: 'Gujarat',
      districts: ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Gandhinagar', 'Bhavnagar'],
    ),
    StateData(
      name: 'Haryana',
      districts: ['Faridabad', 'Gurgaon', 'Hisar', 'Rohtak', 'Karnal', 'Ambala'],
    ),
    StateData(
      name: 'Himachal Pradesh',
      districts: ['Kangra', 'Mandi', 'Shimla', 'Solan', 'Kinnaur', 'Spiti'],
    ),
    StateData(
      name: 'Jharkhand',
      districts: ['Ranchi', 'Dhanbad', 'Giridih', 'Bokaro', 'West Singhbum', 'Hazaribagh'],
    ),
    StateData(
      name: 'Karnataka',
      districts: [
        'Bagalkot', 'Ballari', 'Belagavi', 'Bengaluru', 'Bengaluru Rural', 'Bidar',
        'Bijapur', 'Chamarajanagar', 'Chikballapur', 'Chikmagalur', 'Chitradurga', 'Davanagere',
        'Dharwad', 'Gadag', 'Gulbarga', 'Hassan', 'Haveri', 'Kalaburagi',
        'Kodagu', 'Kolar', 'Koppal', 'Mandya', 'Mangalore', 'Mysore',
        'Raichur', 'Ramanagara', 'Shivamogga', 'Tumkur', 'Udupi', 'Uttara Kannada', 'Yadgir'
      ],
    ),
    StateData(
      name: 'Kerala',
      districts: ['Thiruvananthapuram', 'Kollam', 'Pathanamthitta', 'Alappuzha', 'Kottayam', 'Ernakulam'],
    ),
    StateData(
      name: 'Madhya Pradesh',
      districts: ['Indore', 'Bhopal', 'Jabalpur', 'Ujjain', 'Gwalior', 'Chhindwara'],
    ),
    StateData(
      name: 'Maharashtra',
      districts: [
        'Ahmednagar', 'Akola', 'Amravati', 'Aurangabad', 'Beed', 'Bhandara',
        'Buldhana', 'Chandrapur', 'Dhule', 'Gadchiroli', 'Gondia', 'Hingoli',
        'Jalgaon', 'Jalna', 'Kolhapur', 'Latur', 'Mumbai', 'Mumbai Suburban',
        'Nagpur', 'Nanded', 'Nashik', 'Navi Mumbai', 'Pardhani', 'Parbhani',
        'Pimpri Chinchwad', 'Pune', 'Raigarh', 'Raigad', 'Ramtek', 'Satara',
        'Sangli', 'Sindhudurg', 'Solapur', 'Thane', 'Wardha', 'Washim', 'Yavatmal'
      ],
    ),
    StateData(
      name: 'Manipur',
      districts: ['Imphal East', 'Imphal West', 'Thoubal', 'Churachandpur'],
    ),
    StateData(
      name: 'Meghalaya',
      districts: ['Shillong', 'East Khasi Hills', 'West Khasi Hills', 'Ri-Bhoi'],
    ),
    StateData(
      name: 'Mizoram',
      districts: ['Aizawl', 'Lunglei', 'Champhai', 'Serchhip'],
    ),
    StateData(
      name: 'Nagaland',
      districts: ['Kohima', 'Dimapur', 'Tuensang', 'Wokha'],
    ),
    StateData(
      name: 'Odisha',
      districts: ['Bhubaneswar', 'Cuttack', 'Rourkela', 'Sambalpur', 'Balasore', 'Dhenkanal'],
    ),
    StateData(
      name: 'Punjab',
      districts: ['Amritsar', 'Ludhiana', 'Jalandhar', 'Patiala', 'Bathinda', 'Sangrur'],
    ),
    StateData(
      name: 'Rajasthan',
      districts: ['Jaipur', 'Jodhpur', 'Udaipur', 'Ajmer', 'Bikaner', 'Alwar'],
    ),
    StateData(
      name: 'Sikkim',
      districts: ['East Sikkim', 'West Sikkim', 'North Sikkim', 'South Sikkim'],
    ),
    StateData(
      name: 'Tamil Nadu',
      districts: [
        'Ariyalur', 'Chengalpattu', 'Chennai', 'Coimbatore', 'Cuddalore', 'Dharmapuri',
        'Dindigul', 'Erode', 'Kallakurichi', 'Kanchipuram', 'Kanyakumari', 'Karur',
        'Krishnagiri', 'Madurai', 'Mayiladuthurai', 'Nagapattinam', 'Namakkal', 'Nilgiris',
        'Perambalur', 'Pudukkottai', 'Ranipet', 'Salem', 'Sivaganga', 'Tenkasi',
        'Thanjavur', 'Theni', 'Thoothukudi', 'Tiruchirappalli', 'Tirunelveli', 'Tirupathur',
        'Tiruppur', 'Tiruvallur', 'Tiruvannamalai', 'Tiruvarur', 'Vellore', 'Viluppuram',
        'Virudunagar'
      ],
    ),
    StateData(
      name: 'Telangana',
      districts: ['Hyderabad', 'Rangareddy', 'Medchal', 'Warangal', 'Nizamabad', 'Khammam'],
    ),
    StateData(
      name: 'Tripura',
      districts: ['Agartala', 'West Tripura', 'North Tripura', 'South Tripura'],
    ),
    StateData(
      name: 'Uttar Pradesh',
      districts: [
        'Agra', 'Aligarh', 'Allahabad', 'Ambedkar Nagar', 'Amethi', 'Amroha', 'Auraiya',
        'Ayodhya', 'Azamgarh', 'Badaun', 'Bagpat', 'Bahraich', 'Ballia', 'Balrampur',
        'Banda', 'Banke', 'Bareilly', 'Basti', 'Bijnor', 'Bithur', 'Buri',
        'Chandauli', 'Chandpur', 'Chhatarpur', 'Chhindwara', 'Chitrakoot', 'Chitraganj', 'Chitrangi',
        'Deoria', 'Dewas', 'Dhampur', 'Dhanpur', 'Dhaulpur', 'Dhaurahra', 'Didarganj',
        'Etah', 'Etawah', 'Faizabad', 'Farukhabad', 'Fatehabad', 'Fatehgarh', 'Fatehpur',
        'Firozabad', 'Gajraula', 'Ganaur', 'Ganj Dundwara', 'Gangoh', 'Garhmukteshwar', 'Gaziabad',
        'Gazipur', 'Ghazipur', 'Ghazipur City', 'Ghazipur District', 'Ghiaur', 'Ghiror', 'Ghorapur',
        'Giyan', 'Godda', 'Goona', 'Govandi', 'Gowha', 'Gyan Vihar', 'Gulab Chandpur',
        'Gulla', 'Gurha Musafirkhana', 'Hajipur', 'Hallan', 'Hamirpur', 'Hargaon', 'Hari Nagar',
        'Haridwar', 'Hataunda', 'Hathras', 'Hayat Nagar', 'Hazari Bag', 'Hazratganj', 'Hindon',
        'Hirapur', 'Hiron', 'Holda', 'Homi', 'Hoshangabad', 'Hoshiarpur', 'Hotampur',
        'Howrah', 'Humayun Nagar', 'Humiyana', 'Husainabad', 'Husainpur', 'Husainganj', 'Hyderabad',
        'Indore', 'Indri', 'Inhaal', 'Injapur', 'Innisfree', 'Irans', 'Irdiganj',
        'Isanpur', 'Itabari', 'Itamad', 'Itanagar', 'Itarsi', 'Ithak', 'Ithanagar',
        'Ithra', 'Izhaar', 'Jabalpur', 'Jadadpur', 'Jafarganj', 'Jagannathpur', 'Jagaur',
        'Jagdari', 'Jagdish Nagar', 'Jagjeet Nagar', 'Jagjeetpur', 'Jaglan', 'Jagmipur', 'Jagrit',
        'Jagriti Nagar', 'Jaguar', 'Jahaan Pur', 'Jahanbad', 'Jahangir Nagar', 'Jahangira', 'Jahazpur',
        'Jajmau', 'Jajpur', 'Jajpur Road', 'Jajpur Town', 'Jalal Pur', 'Jalalabad', 'Jalalpur',
        'Jalalpur Piali', 'Jalaun', 'Jaldhaka', 'Jaldi', 'Jalidha', 'Jaljira', 'Jall Nagar',
        'Jallal Pur', 'Jallali', 'Jallaun', 'Jallian', 'Jalman', 'Jalna', 'Jalnapur',
        'Jalol', 'Jalor', 'Jalpa Nagar', 'Jalphaiguri', 'Jalpiha', 'Jalrabandh', 'Jalsa Nagar',
        'Jalsinagar', 'Jaltan', 'Jaltanpur', 'Jaltar', 'Jaltarpur', 'Jaltari', 'Jaltaur'
      ],
    ),
    StateData(
      name: 'Uttarakhand',
      districts: ['Dehradun', 'Uttarkashi', 'Chamoli', 'Rudraprayag', 'Almora', 'Nainital'],
    ),
    StateData(
      name: 'West Bengal',
      districts: ['Kolkata', 'Darjeeling', 'Jalpaiguri', 'Hugli', 'Howrah', 'South 24 Parganas'],
    ),
  ],
  'United States': [
    StateData(
      name: 'California',
      districts: ['Los Angeles', 'San Francisco', 'San Diego', 'Sacramento', 'Oakland'],
    ),
    StateData(
      name: 'Texas',
      districts: ['Houston', 'Dallas', 'Austin', 'San Antonio', 'Fort Worth'],
    ),
    StateData(
      name: 'New York',
      districts: ['New York City', 'Buffalo', 'Rochester', 'Albany', 'Syracuse'],
    ),
    StateData(
      name: 'Florida',
      districts: ['Miami', 'Tampa', 'Jacksonville', 'Orlando', 'St. Petersburg'],
    ),
    StateData(
      name: 'Pennsylvania',
      districts: ['Philadelphia', 'Pittsburgh', 'Allentown', 'Erie', 'Scranton'],
    ),
  ],
  'United Kingdom': [
    StateData(
      name: 'England',
      districts: ['London', 'Manchester', 'Birmingham', 'Leeds', 'Liverpool'],
    ),
    StateData(
      name: 'Scotland',
      districts: ['Edinburgh', 'Glasgow', 'Aberdeen', 'Dundee', 'Stirling'],
    ),
    StateData(
      name: 'Wales',
      districts: ['Cardiff', 'Swansea', 'Newport', 'Wrexham', 'Caerphilly'],
    ),
  ],
};

List<String> getStatesForCountry(String country) {
  return statesByCountry[country]?.map((s) => s.name).toList() ?? [];
}

List<String> getDistrictsForState(String country, String state) {
  final states = statesByCountry[country];
  if (states == null) return [];
  final foundState = states.firstWhere(
    (s) => s.name == state,
    orElse: () => StateData(name: '', districts: []),
  );
  return foundState.districts;
}
