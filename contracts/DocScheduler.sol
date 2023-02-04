// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Ownable.sol';
import './Evaluations/Evaluation.sol';

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
  }

  struct OfficeDay {
    uint opening_time;
    uint closing_time;
    uint start_lunchbreak;
    uint stop_lunchbreak;
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
  function createDoctorsOffice(Doctor new_doctor) public  {
    doctors[new_doctor.wallet_address] = new_doctor;
  }

  //todo erstelle reconfigureOffice Methode
  //diese soll aus der Website aufgerufen werden und die Struktur übergeben bekommen
  //eintrag im Mapping soll mit der übergebenen Struktur überschrieben werden
  function reconfigureOffice(Doctor old_doctor) public {
    require(msg.sender == old_doctor.address, "Sorry, you have no permission to make changes");
    doctors[reconfigured_doctor.wallet_address] = reconfigured_doctor;
  }

  //todo erstelle createAppointment
  // checke ob praxis offen (require)
  // methode sollte payable sein, da Geld an Appointment durchgereicht werden muss
  // es soll ein neues Appointment(contract) erzeugt werden
   
  event Appointment(address _patient, address _doctor, uint from_time, uint to_time, uint _value);

  //check if ethers deposited
  modifier ifEthersDeposited(uint _amount){
    require(msg.value >= _amount, "Not enough Ether");
    _;
  }

  function _createAppointment(address _doctorsAddress, DateTime _fromDateTime, DateTime _toDateTime) payable private ifEthersDeposited(15 ether)  { 
    current_doc = doctors[_doctorsAddress];
    require(checkDoctorsTimeslot(current_doc.office_schedule, _fromDateTime, _toDateTime), "Sorry, timeslot is not awailable");
    
    // how to check if timeslot is already blocked with other appointment?!

    emit Appointment(msg.sender, _doctorsAddress, _fromTDateime, _toDateTime, msg.value);
  }

  function checkDoctorsTimeslot(OfficeDay [] officeSchedule, DateTime fromDateTime, DateTime toDateTime) private returns (bool){
    // pruefe ob geoeffnet
    
    weekday = weekDay(fromDateTime.day, fromDateTime.month, fromDateTime.year);

    // pruefe ob Timeslot noch verfuegbar

    // to be continued
    return (fromDateTime.hour > officeSchedule[weekday].opening_time &&  fromDateTime.hour < officeSchedule[weekday].closing_time);  // to be continued argh
  }

  function leapYear(uint year) private returns (bool):
    if (!((year%4) && (year%100)) || !(year%400))  return true;
    return false;
  }

  function weekDay(uint day, uint month, uint year) private returns (uint) {
    uint nums[12] = [1,4,4,0,2,5,0,3,6,1,4,6];
    uint num = (year % 100) / 4 + day + nums[month-1];
    if (leapYear(year) && month <= 2) num -= 1;
    return (num-1)%7 + 2; // gilt nur zwischen 2000 und 2099
  }
  