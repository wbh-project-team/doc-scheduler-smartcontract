// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Ownable.sol';

//https://remix.ethereum.org

contract DocScheduler is Ownable {

  //todo lege eine Struktur an die alle wichtigen Daten einer Arztpraxis enthält z.B. Name, öffnungszeiten, WalletAdresse des Arzt
  struct Doctor {
    string first_name;
    string last_name;
    address wallet_address; // https://dev.singularitynet.io/docs/concepts/ethereum-address/
    OfficeDay[] office_schedule;
    Description description; // evtl direkt in html Format oder besser verschiedene description variablen
    Specialization [] specialization;
    mapping(string => uint) consultationDuration;
  }

  struct OfficeDay {
    uint opening_time;  // 8:00 = 8* hours = 28800
    uint closing_time;  // 18:00 = 18*hours = 64800
    uint start_lunchbreak; // 12:00 = 12*hours = 43200
    uint stop_lunchbreak; // 13:00 = 13*houra = 46800
  }

  struct Description {
    string street;
    uint street_number;
    uint plz;
    string city;
    string phone_number;
    string free_text;
  }

  struct DateTime {
    uint day;
    uint month;
    uint year;
    uint hour;
    uint minute;
  }

  enum Specialization { HAUSARZT, ZAHNARZT, HNO_ARZT, ORTHOPAEDE, KARDIOLOGE, AUGENARZT}
  
  constructor() public {}

  //todo lege Mapping vom Datentyp address auf die Struktur an damit alle erzeugten Arztpraxen gespeichert werden können
  mapping(address => Doctor) doctors;

  //todo erstelle createDoctorsOffice Methode
  //diese soll aus der Website aufgerufen werden und die Struktur übergeben bekommen
  //die Struktur soll in das Mapping unter der addresse des Arztes geschrieben werden
  function createDoctorsOffice(Doctor memory _new_doctor) public  {
    // ist die Struktur _new_doctor schon mit Daten gefuellt?
    doctors[_new_doctor.wallet_address] = _new_doctor;
  }

  //todo erstelle reconfigureOffice Methode
  //diese soll aus der Website aufgerufen werden und die Struktur übergeben bekommen
  //eintrag im Mapping soll mit der übergebenen Struktur überschrieben werden
  function reconfigureOffice(Doctor memory _old_doctor) public {
    require(msg.sender == _old_doctor.wallet_address, "Sorry, you have no permission to make changes");
    doctors[_old_doctor.wallet_address] = _old_doctor;
  }

  //todo erstelle createAppointment
  // checke ob praxis offen (require)
  // methode sollte payable sein, da Geld an Appointment durchgereicht werden muss
  // es soll ein neues Appointment(contract) erzeugt werden
   
  event Appointment(address patient, address doctor, DateTime from_time, uint duration, uint value);

  //check if ethers deposited
  modifier ifEthersDeposited(uint _amount){
    require(msg.value >= _amount, "Not enough Ether");
    _;
  }

  function _createAppointment(address _doctorsAddress, DateTime memory _fromDateTime, uint _duration) payable public ifEthersDeposited(15 ether)  { 
    Doctor storage current_doc = doctors[_doctorsAddress];
    require(checkDoctorsTimeslot(current_doc.office_schedule, _fromDateTime, _duration), "Sorry, timeslot is not awailable");
    
    // how to check if timeslot is already blocked with other appointment?!

    emit Appointment(msg.sender, _doctorsAddress, _fromDateTime, _duration, msg.value);
  }

  // input zb: // [[28800, 64800, 43200, 46800], [28800, 64800, 43200, 46800], [28800, 64800, 43200, 46800], [28800, 64800, 43200, 46800], [28800, 64800, 43200, 46800], [28800, 28800, 28800, 28800], [28800, 28800, 28800, 28800]], [27,2,2023,10,10], 3600
  function checkDoctorsTimeslot(OfficeDay[] memory _officeSchedule, DateTime memory _fromDateTime, uint256 _duration_in_sec) public  view returns (bool){
    
    // ToDo: Ueberpruefung, ob Timeslot noch verfuegbar, noch nicht implementiert!!
    //       wie vorhandene Termine einlesen?

    uint256 fromTime = _fromDateTime.hour*1 hours +  _fromDateTime.minute* 1 minutes;
    uint256 toTime = fromTime + _duration_in_sec;
    //console.log( "Output: %s %s hour: %s", fromTime, toTime, 1 hours);

    // pruefe ob geoeffnet
    uint256 weekday = weekDay(_fromDateTime.day, _fromDateTime.month, _fromDateTime.year);
    //console.log( "openingtime: %s", _officeSchedule[weekday].opening_time);
    return ((fromTime > _officeSchedule[weekday].opening_time
            && toTime < _officeSchedule[weekday].start_lunchbreak)
            || (fromTime > _officeSchedule[weekday].stop_lunchbreak 
            && toTime < _officeSchedule[weekday].closing_time) ); 
  }

  function leapYear(uint _year) private pure returns (bool){
    if (!(((_year%4!=0) && (_year%100!=0)) || (_year%400==0))) return true;
    return false;
  }

  // gets real date as number of each _day, _month, _year  e.g. = 1, 7, 23 for 07.01.2023 (Saturday)
  // returns 0 for monday, 1 for tuesday, etc.
  function weekDay(uint _day, uint _month, uint _year) private pure returns (uint) {
    uint8[12] memory nums = [1,4,4,0,2,5,0,3,6,1,4,6];
    uint num = (_year % 100) + (_year %100) / 4 + _day + nums[_month-1];
    if (leapYear(_year) && _month <= 2) num -= 1;
    return (num-1-2)%7; // gilt nur zwischen 2000 und 2099
  }
}
  